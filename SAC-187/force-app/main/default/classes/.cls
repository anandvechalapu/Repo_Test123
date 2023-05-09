trigger InstituteTrigger on Institute__c (after update) {
    // Get a list of Student__c records related to the updated Institute__c records
    List<Student__c> studentsToInactivate = new List<Student__c>();
    for (Institute__c i : Trigger.new) {
        studentsToInactivate.addAll([SELECT Id, Status__c 
                                    FROM Student__c 
                                    WHERE Institute__c = :i.Id]);
    }

    // Check the Status__c of each related Student__c record
    List<Student__c> studentsToUpdate = new List<Student__c>();
    for (Student__c s : studentsToInactivate) {
        if (s.Status__c.CreatedDate > System.now().addDays(-30)) {
            s.Status__c = 'Inactive';
            studentsToUpdate.add(s);
        }
    }

    // Update the Student__c records
    if (!studentsToUpdate.isEmpty()) {
        update studentsToUpdate;
    }
}