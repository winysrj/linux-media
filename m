Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36754 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753021AbcKBMqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/11] cec: add flag to cec_log_addrs to enable RC passthrough
Date: Wed,  2 Nov 2016 13:46:27 +0100
Message-Id: <20161102124635.11989-4-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

By default the CEC_MSG_USER_CONTROL_PRESSED/RELEASED messages
are passed on to the follower(s) only. If the new
CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU flag is set in the
flags field of struct cec_log_addrs then these messages are also
passed on to the remote control input subsystem and they will appear
as keystrokes.

This used to be the default behavior, but now you have to explicitly
enable it. This is done to force the caller to think about possible
security issues (e.g. if these messages are used to enter passwords).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 10 ++++++++++
 drivers/staging/media/cec/TODO                            |  2 --
 drivers/staging/media/cec/cec-adap.c                      |  6 ++++--
 drivers/staging/media/cec/cec-api.c                       |  3 ++-
 include/linux/cec.h                                       |  2 ++
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index af35f71..571ae57 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -166,6 +166,16 @@ logical address types are already defined will return with error ``EBUSY``.
 	it will go back to the unconfigured state. If this flag is set, then it will
 	fallback to the Unregistered logical address. Note that if the Unregistered
 	logical address was explicitly requested, then this flag has no effect.
+    * .. _`CEC-LOG-ADDRS-FL-ALLOW-RC-PASSTHRU`:
+
+      - ``CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU``
+      - 2
+      - By default the ``CEC_MSG_USER_CONTROL_PRESSED`` and ``CEC_MSG_USER_CONTROL_RELEASED``
+        messages are only passed on to the follower(s), if any. If this flag is set,
+	then these messages are also passed on to the remote control input subsystem
+	and will appear as keystrokes. This features needs to be enabled explicitly.
+	If CEC is used to enter e.g. passwords, then you may not want to enable this
+	to avoid trivial snooping of the keystrokes.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index 1322469..0841206 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -13,8 +13,6 @@ Hopefully this will happen later in 2016.
 Other TODOs:
 
 - There are two possible replies to CEC_MSG_INITIATE_ARC. How to handle that?
-- Add a flag to inhibit passing CEC RC messages to the rc subsystem.
-  Applications should be able to choose this when calling S_LOG_ADDRS.
 - If the reply field of cec_msg is set then when the reply arrives it
   is only sent to the filehandle that transmitted the original message
   and not to any followers. Should this behavior change or perhaps
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 611e07b..589e457 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1478,7 +1478,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 
 	case CEC_MSG_USER_CONTROL_PRESSED:
-		if (!(adap->capabilities & CEC_CAP_RC))
+		if (!(adap->capabilities & CEC_CAP_RC) ||
+		    !(adap->log_addrs.flags & CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU))
 			break;
 
 #if IS_REACHABLE(CONFIG_RC_CORE)
@@ -1515,7 +1516,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		break;
 
 	case CEC_MSG_USER_CONTROL_RELEASED:
-		if (!(adap->capabilities & CEC_CAP_RC))
+		if (!(adap->capabilities & CEC_CAP_RC) ||
+		    !(adap->log_addrs.flags & CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU))
 			break;
 #if IS_REACHABLE(CONFIG_RC_CORE)
 		rc_keyup(adap->rc);
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index e274e2f..040ca7d 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -162,7 +162,8 @@ static long cec_adap_s_log_addrs(struct cec_adapter *adap, struct cec_fh *fh,
 		return -ENOTTY;
 	if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
 		return -EFAULT;
-	log_addrs.flags &= CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK;
+	log_addrs.flags &= CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK |
+			   CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU;
 	mutex_lock(&adap->lock);
 	if (!adap->is_configuring &&
 	    (!log_addrs.num_log_addrs || !adap->is_configured) &&
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 851968e..825455f 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -391,6 +391,8 @@ struct cec_log_addrs {
 
 /* Allow a fallback to unregistered */
 #define CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK	(1 << 0)
+/* Passthrough RC messages to the input subsystem */
+#define CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU	(1 << 1)
 
 /* Events */
 
-- 
2.10.1

