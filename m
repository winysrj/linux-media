Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56910 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbEDRdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:33:51 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v6 04/11] HID: add HDMI CEC specific keycodes
Date: Mon, 04 May 2015 19:32:57 +0200
Message-id: <1430760785-1169-5-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add HDMI CEC specific keycodes to the keycodes definition.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 include/uapi/linux/input.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 731417c..7430a3f 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -752,6 +752,18 @@ struct input_keymap_entry {
 #define KEY_KBDINPUTASSIST_ACCEPT		0x264
 #define KEY_KBDINPUTASSIST_CANCEL		0x265
 
+#define KEY_RIGHT_UP			0x266
+#define KEY_RIGHT_DOWN			0x267
+#define KEY_LEFT_UP			0x268
+#define KEY_LEFT_DOWN			0x269
+
+#define KEY_NEXT_FAVORITE		0x270
+#define KEY_STOP_RECORD			0x271
+#define KEY_PAUSE_RECORD		0x272
+#define KEY_VOD				0x273
+#define KEY_UNMUTE			0x274
+#define KEY_DVB				0x275
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
-- 
1.7.9.5

