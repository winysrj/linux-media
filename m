Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48894 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752051AbdGDOVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Jul 2017 10:21:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: clear all cec_log_addrs fields
Message-ID: <d3e4392b-e76e-f3dc-1d08-a1db8ad33b36@xs4all.nl>
Date: Tue, 4 Jul 2017 16:21:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC version, vendor ID and OSD name were not cleared when clearing the
current set of logical addresses. This was unexpected and somewhat confusing,
so reset all these fields to their default values. Also document this since
the documentation wasn't quite clear either.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
--
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index fcf863ab6f43..91cecc4d69cb 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -48,7 +48,9 @@ can only be called by a file descriptor in initiator mode (see :ref:`CEC_S_MODE`
 the ``EBUSY`` error code will be returned.

 To clear existing logical addresses set ``num_log_addrs`` to 0. All other fields
-will be ignored in that case. The adapter will go to the unconfigured state.
+will be ignored in that case. The adapter will go to the unconfigured state and the
+``cec_version``, ``vendor_id`` and ``osd_name`` fields are all reset to their default
+values (CEC version 2.0, no vendor ID and an empty OSD name).

 If the physical address is valid (see :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`),
 then this ioctl will block until all requested logical
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..5a2363cbaeb1 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1471,8 +1471,13 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		return -ENODEV;

 	if (!log_addrs || log_addrs->num_log_addrs == 0) {
-		adap->log_addrs.num_log_addrs = 0;
 		cec_adap_unconfigure(adap);
+		adap->log_addrs.num_log_addrs = 0;
+		for (i = 0; i < CEC_MAX_LOG_ADDRS; i++)
+			adap->log_addrs.log_addr[i] = CEC_LOG_ADDR_INVALID;
+		adap->log_addrs.osd_name[0] = '\0';
+		adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
+		adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
 		return 0;
 	}
