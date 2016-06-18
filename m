Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57753 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbcFRPDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:03:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 09/15] cec/TODO: add TODO file so we know why this is still in staging
Date: Sat, 18 Jun 2016 17:02:42 +0200
Message-Id: <1466262168-12805-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
References: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explain why cec.c is still in staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/TODO | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 drivers/staging/media/cec/TODO

diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
new file mode 100644
index 0000000..e3c384a
--- /dev/null
+++ b/drivers/staging/media/cec/TODO
@@ -0,0 +1,23 @@
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
+
+Hans Verkuil <hans.verkuil@cisco.com>
-- 
2.8.1

