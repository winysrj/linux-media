Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43413 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133AbcGJNLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:11:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] pulse8-cec: add TODO file
Date: Sun, 10 Jul 2016 15:11:21 +0200
Message-Id: <1468156281-25731-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explain what needs to be done to move this driver out of staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/pulse8-cec/TODO | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 drivers/staging/media/pulse8-cec/TODO

diff --git a/drivers/staging/media/pulse8-cec/TODO b/drivers/staging/media/pulse8-cec/TODO
new file mode 100644
index 0000000..6860a33
--- /dev/null
+++ b/drivers/staging/media/pulse8-cec/TODO
@@ -0,0 +1,35 @@
+This driver needs to mature a bit more and another round of
+code cleanups.
+
+Otherwise it looks to be in good shape. And of course the fact
+that the CEC framework is in staging at the moment also prevents
+this driver from being mainlined.
+
+To use this driver you also need to patch the inputattach utility,
+this patch will be submitted once this driver is moved out of staging.
+
+diff -urN linuxconsoletools-1.4.9/utils/inputattach.c linuxconsoletools-1.4.9.new/utils/inputattach.c
+--- linuxconsoletools-1.4.9/utils/inputattach.c	2016-01-09 16:27:02.000000000 +0100
++++ linuxconsoletools-1.4.9.new/utils/inputattach.c	2016-03-20 11:35:31.707788967 +0100
+@@ -861,6 +861,9 @@
+ { "--wacom_iv",		"-wacom_iv",	"Wacom protocol IV tablet",
+ 	B9600, CS8 | CRTSCTS,
+ 	SERIO_WACOM_IV,		0x00,	0x00,	0,	wacom_iv_init },
++{ "--pulse8-cec",		"-pulse8-cec",	"Pulse Eight HDMI CEC dongle",
++	B9600, CS8,
++	SERIO_PULSE8_CEC,		0x00,	0x00,	0,	NULL },
+ { NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL }
+ };
+ 
+diff -urN linuxconsoletools-1.4.9/utils/serio-ids.h linuxconsoletools-1.4.9.new/utils/serio-ids.h
+--- linuxconsoletools-1.4.9/utils/serio-ids.h	2015-04-26 18:29:42.000000000 +0200
++++ linuxconsoletools-1.4.9.new/utils/serio-ids.h	2016-03-20 11:41:00.153558539 +0100
+@@ -131,5 +131,8 @@
+ #ifndef SERIO_EASYPEN
+ # define SERIO_EASYPEN		0x3f
+ #endif
++#ifndef SERIO_PULSE8_CEC
++# define SERIO_PULSE8_CEC	0x40
++#endif
+ 
+ #endif
-- 
2.8.1

