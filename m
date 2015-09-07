Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:39474 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbIGNpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2015 09:45:11 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv9 05/15] HID: add HDMI CEC specific keycodes
Date: Mon,  7 Sep 2015 15:44:34 +0200
Message-Id: <43c01f85d2ab18f39584bf68d779fa10bfa20674.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

Add HDMI CEC specific keycodes to the keycodes definition.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/input.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index a32bff1..5e7019a 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -752,6 +752,34 @@ struct input_keymap_entry {
 #define KEY_KBDINPUTASSIST_ACCEPT		0x264
 #define KEY_KBDINPUTASSIST_CANCEL		0x265
 
+#define KEY_RIGHT_UP			0x266
+#define KEY_RIGHT_DOWN			0x267
+#define KEY_LEFT_UP			0x268
+#define KEY_LEFT_DOWN			0x269
+#define KEY_ROOT_MENU			0x26a /* Show Device's Root Menu */
+#define KEY_MEDIA_TOP_MENU		0x26b /* Show Top Menu of the Media (e.g. DVD) */
+#define KEY_NUMERIC_11			0x26c
+#define KEY_NUMERIC_12			0x26d
+/*
+ * Toggle Audio Description: refers to an audio service that helps blind and
+ * visually impaired consumers understand the action in a program. Note: in
+ * some countries this is referred to as "Video Description".
+ */
+#define KEY_AUDIO_DESC			0x26e
+#define KEY_3D_MODE			0x26f
+#define KEY_NEXT_FAVORITE		0x270
+#define KEY_STOP_RECORD			0x271
+#define KEY_PAUSE_RECORD		0x272
+#define KEY_VOD				0x273 /* Video on Demand */
+#define KEY_UNMUTE			0x274
+#define KEY_FASTREVERSE			0x275
+#define KEY_SLOWREVERSE			0x276
+/*
+ * Control a data application associated with the currently viewed channel,
+ * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
+ */
+#define KEY_DATA			0x275
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
-- 
2.1.4

