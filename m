Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53674 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbcFYNG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:06:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv19 08/14] cec/TODO: add TODO file so we know why this is still in staging
Date: Sat, 25 Jun 2016 15:06:32 +0200
Message-Id: <1466859998-17640-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explain why cec.c is still in staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/TODO | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 drivers/staging/media/cec/TODO

diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
new file mode 100644
index 0000000..a8f4b7d
--- /dev/null
+++ b/drivers/staging/media/cec/TODO
@@ -0,0 +1,27 @@
+The reason why cec.c is still in staging is that I would like
+to have a bit more confidence in the uABI. The kABI is fine,
+no problem there, but I would like to let the public API mature
+a bit.
+
+Once I'm confident that I didn't miss anything then the cec.c source
+can move to drivers/media and the linux/cec.h and linux/cec-funcs.h
+headers can move to uapi/linux and added to uapi/linux/Kbuild to make
+them public.
+
+Hopefully this will happen later in 2016.
+
+Other TODOs:
+
+- Add a flag to inhibit passing CEC RC messages to the rc subsystem.
+  Applications should be able to choose this when calling S_LOG_ADDRS.
+- Convert cec.txt to sphinx.
+- If the reply field of cec_msg is set then when the reply arrives it
+  is only sent to the filehandle that transmitted the original message
+  and not to any followers. Should this behavior change or perhaps
+  controlled through a cec_msg flag?
+- Should CEC_LOG_ADDR_TYPE_SPECIFIC be replaced by TYPE_2ND_TV and TYPE_PROCESSOR?
+  And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
+  This should give the framework more information about the device type
+  since SPECIFIC and UNREGISTERED give no useful information.
+
+Hans Verkuil <hans.verkuil@cisco.com>
-- 
2.8.1

