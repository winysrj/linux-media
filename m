Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3077 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2AWHxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 02:53:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Oliver Neukum <oneukum@suse.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/2] hid-core: ignore the Keene FM transmitter.
Date: Mon, 23 Jan 2012 08:53:20 +0100
Message-Id: <6a631f8625a923609e598226be5c588d50a2e325.1327305074.git.hans.verkuil@cisco.com>
In-Reply-To: <1327305200-3012-1-git-send-email-hverkuil@xs4all.nl>
References: <1327305200-3012-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <cc03ba62a0c7373b83212036e152c76c1ef07047.1327305074.git.hans.verkuil@cisco.com>
References: <cc03ba62a0c7373b83212036e152c76c1ef07047.1327305074.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The Keene FM transmitter USB device has the same USB ID as
the Logitech AudioHub Speaker, but it should ignore the hid.
Check if the name is that of the Keene device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/hid/hid-core.c |   10 ++++++++++
 drivers/hid/hid-ids.h  |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af08ce7..dd1bab4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1993,6 +1993,16 @@ static bool hid_ignore(struct hid_device *hdev)
 		if (hdev->product >= USB_DEVICE_ID_LOGITECH_HARMONY_FIRST &&
 				hdev->product <= USB_DEVICE_ID_LOGITECH_HARMONY_LAST)
 			return true;
+		/*
+		 * The Keene FM transmitter USB device has the same USB ID as
+		 * the Logitech AudioHub Speaker, but it should ignore the hid.
+		 * Check if the name is that of the Keene device.
+		 * For reference: the name of the AudioHub is
+		 * "HOLTEK  AudioHub Speaker".
+		 */
+		if (hdev->product == USB_DEVICE_ID_LOGITECH_AUDIOHUB &&
+			!strcmp(hdev->name, "HOLTEK  B-LINK USB Audio  "))
+				return true;
 		break;
 	case USB_VENDOR_ID_SOUNDGRAPH:
 		if (hdev->product >= USB_DEVICE_ID_SOUNDGRAPH_IMON_FIRST &&
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b8574cd..e1c4535 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -451,6 +451,7 @@
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
+#define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
 #define USB_DEVICE_ID_LOGITECH_HARMONY_LAST 0xc14f
-- 
1.7.7.3

