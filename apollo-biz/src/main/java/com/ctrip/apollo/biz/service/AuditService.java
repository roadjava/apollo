package com.ctrip.apollo.biz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ctrip.apollo.biz.entity.Audit;
import com.ctrip.apollo.biz.repository.AuditRepository;

@Service
public class AuditService {

  @Autowired
  private AuditRepository auditRepository;

  List<Audit> findByOwner(String owner) {
    return auditRepository.findByOwner(owner);
  }

  List<Audit> find(String owner, String entity, String op) {
    return auditRepository.findAudits(owner, entity, op);
  }

  @Transactional
  void audit(String entityName, Long entityId, Audit.OP op, String owner) {
    Audit audit = new Audit();
    audit.setEntityName(entityName);
    audit.setEntityId(entityId);
    audit.setOpName(op.name());
    audit.setDataChangeCreatedBy(owner);
    auditRepository.save(audit);
  }
  
  @Transactional
  void audit(Audit audit){
    auditRepository.save(audit);
  }
}