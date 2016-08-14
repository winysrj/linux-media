Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39257 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbcHNKjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 06:39:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 519FC180AA9
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2016 12:38:58 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 for v4.8] cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK
 flag
Message-ID: <30a78325-c08b-f036-e610-0a2788f1c98f@xs4all.nl>
Date: Sun, 14 Aug 2016 12:38:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently if none of the requested logical addresses can be claimed, the
framework will fall back to the Unregistered logical address.

Add a flag to enable this explicitly. By default it will just go back to
the unconfigured state.

Usually Unregistered is not something you want since the functionality is
very limited. Unless the application has support for this, it will fail
to work correctly. So require that the application explicitly requests
this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Change since v2: the flag test should be done before the configure label,
otherwise it would also be performed when explicitly requesting the unregistered
'LA'.
---
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst     | 21 ++++++++++++++++++++-
 drivers/staging/media/cec/cec-adap.c                |  4 ++++
 drivers/staging/media/cec/cec-api.c                 |  2 +-
 include/linux/cec.h                                 |  5 ++++-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 04ee900..201d483 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -144,7 +144,7 @@ logical address types are already defined will return with error ``EBUSY``.

        -  ``flags``

-       -  Flags. No flags are defined yet, so set this to 0.
+       -  Flags. See :ref:`cec-log-addrs-flags` for a list of available flags.

     -  .. row 7

@@ -201,6 +201,25 @@ logical address types are already defined will return with error ``EBUSY``.
           give the CEC framework more information about the device type, even
           though the framework won't use it directly in the CEC message.

+.. _cec-log-addrs-flags:
+
+.. flat-table:: Flags for struct cec_log_addrs
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. _`CEC-LOG-ADDRS-FL-ALLOW-UNREG-FALLBACK`:
+
+       -  ``CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK``
+
+       -  1
+
+       -  By default if no logical address of the requested type can be claimed, then
+	  it will go back to the unconfigured state. If this flag is set, then it will
+	  fallback to the Unregistered logical address. Note that if the Unregistered
+	  logical address was explicitly requested, then this flag has no effect.
+
 .. _cec-versions:

 .. flat-table:: CEC Versions
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 9dcb784..2458a6c 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1047,6 +1047,10 @@ static int cec_config_thread_func(void *arg)
 			dprintk(1, "could not claim LA %d\n", i);
 	}

+	if (adap->log_addrs.log_addr_mask == 0 &&
+	    !(las->flags & CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK))
+		goto unconfigure;
+
 configured:
 	if (adap->log_addrs.log_addr_mask == 0) {
 		/* Fall back to unregistered */
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 4e2696a..6f58ee8 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -162,7 +162,7 @@ static long cec_adap_s_log_addrs(struct cec_adapter *adap, struct cec_fh *fh,
 		return -ENOTTY;
 	if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
 		return -EFAULT;
-	log_addrs.flags = 0;
+	log_addrs.flags &= CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK;
 	mutex_lock(&adap->lock);
 	if (!adap->is_configuring &&
 	    (!log_addrs.num_log_addrs || !adap->is_configured) &&
diff --git a/include/linux/cec.h b/include/linux/cec.h
index b3e2289..851968e 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -364,7 +364,7 @@ struct cec_caps {
  * @num_log_addrs: how many logical addresses should be claimed. Set by the
  *	caller.
  * @vendor_id: the vendor ID of the device. Set by the caller.
- * @flags: set to 0.
+ * @flags: flags.
  * @osd_name: the OSD name of the device. Set by the caller.
  * @primary_device_type: the primary device type for each logical address.
  *	Set by the caller.
@@ -389,6 +389,9 @@ struct cec_log_addrs {
 	__u8 features[CEC_MAX_LOG_ADDRS][12];
 };

+/* Allow a fallback to unregistered */
+#define CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK	(1 << 0)
+
 /* Events */

 /* Event that occurs when the adapter state changes */
-- 
2.8.1

