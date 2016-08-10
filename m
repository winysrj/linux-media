Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:18004 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbcHJSPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:15:43 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u7ACOjfX025170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Aug 2016 12:24:46 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag
Message-ID: <57AB1D0D.10801@cisco.com>
Date: Wed, 10 Aug 2016 14:24:45 +0200
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
index b2393bb..24d9a86 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1049,6 +1049,9 @@ static int cec_config_thread_func(void *arg)

 configured:
 	if (adap->log_addrs.log_addr_mask == 0) {
+		if (!(las->flags & CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK))
+			goto unconfigure;
+
 		/* Fall back to unregistered */
 		las->log_addr[0] = CEC_LOG_ADDR_UNREGISTERED;
 		las->log_addr_mask = 1 << las->log_addr[0];
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 7be7615..bfc5f74 100644
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
