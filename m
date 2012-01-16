Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1467 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2APM3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:29:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] hid-core: ignore the Keene FM transmitter.
Date: Mon, 16 Jan 2012 13:29:20 +0100
Message-Id: <5023b3e0c2020dd6ac6250d43413e51f206486fa.1326716517.git.hans.verkuil@cisco.com>
In-Reply-To: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <4f4e18b94612a34be98e2304a4d9b0cef74acd39.1326716517.git.hans.verkuil@cisco.com>
References: <4f4e18b94612a34be98e2304a4d9b0cef74acd39.1326716517.git.hans.verkuil@cisco.com>
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
index af35384..f02d197 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1973,6 +1973,16 @@ static bool hid_ignore(struct hid_device *hdev)
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
index 4a441a6..2f6dc92 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -440,6 +440,7 @@
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
+#define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
 #define USB_DEVICE_ID_LOGITECH_HARMONY_LAST 0xc14f
-- 
1.7.7.3

