Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1139 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3CKLqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 23/42] go7007: remember boot firmware.
Date: Mon, 11 Mar 2013 12:46:01 +0100
Message-Id: <3d120b4623e4a73398d558b2b4247c3ee26741f8.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't load it everytime you stop encoding. Instead remember it.
Another reason for not loading it every time is that this could
be called from within the release() file operation, which turns
out to be deadly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   43 +++++++++++++-------------
 drivers/staging/media/go7007/go7007-priv.h   |    2 ++
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 09d0ef4..db9a4b3 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -95,34 +95,34 @@ static int go7007_load_encoder(struct go7007 *go)
 	int fw_len, rv = 0;
 	u16 intr_val, intr_data;
 
-	if (request_firmware(&fw_entry, fw_name, go->dev)) {
-		v4l2_err(go, "unable to load firmware from file "
-			"\"%s\"\n", fw_name);
-		return -1;
-	}
-	if (fw_entry->size < 16 || memcmp(fw_entry->data, "WISGO7007FW", 11)) {
-		v4l2_err(go, "file \"%s\" does not appear to be "
-				"go7007 firmware\n", fw_name);
-		release_firmware(fw_entry);
-		return -1;
-	}
-	fw_len = fw_entry->size - 16;
-	bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
-	if (bounce == NULL) {
-		v4l2_err(go, "unable to allocate %d bytes for "
-				"firmware transfer\n", fw_len);
+	if (go->boot_fw == NULL) {
+		if (request_firmware(&fw_entry, fw_name, go->dev)) {
+			v4l2_err(go, "unable to load firmware from file \"%s\"\n", fw_name);
+			return -1;
+		}
+		if (fw_entry->size < 16 || memcmp(fw_entry->data, "WISGO7007FW", 11)) {
+			v4l2_err(go, "file \"%s\" does not appear to be go7007 firmware\n", fw_name);
+			release_firmware(fw_entry);
+			return -1;
+		}
+		fw_len = fw_entry->size - 16;
+		bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
+		if (bounce == NULL) {
+			v4l2_err(go, "unable to allocate %d bytes for firmware transfer\n", fw_len);
+			release_firmware(fw_entry);
+			return -1;
+		}
 		release_firmware(fw_entry);
-		return -1;
+		go->boot_fw_len = fw_len;
+		go->boot_fw = bounce;
 	}
-	release_firmware(fw_entry);
 	if (go7007_interface_reset(go) < 0 ||
-			go7007_send_firmware(go, bounce, fw_len) < 0 ||
-			go7007_read_interrupt(go, &intr_val, &intr_data) < 0 ||
+	    go7007_send_firmware(go, go->boot_fw, go->boot_fw_len) < 0 ||
+	    go7007_read_interrupt(go, &intr_val, &intr_data) < 0 ||
 			(intr_val & ~0x1) != 0x5a5a) {
 		v4l2_err(go, "error transferring firmware\n");
 		rv = -1;
 	}
-	kfree(bounce);
 	return rv;
 }
 
@@ -675,6 +675,7 @@ void go7007_remove(struct go7007 *go)
 
 	if (go->audio_enabled)
 		go7007_snd_remove(go);
+	kfree(go->boot_fw);
 	go7007_v4l2_remove(go);
 }
 EXPORT_SYMBOL(go7007_remove);
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index daae6dd..d390120 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -178,6 +178,8 @@ struct go7007 {
 	int channel_number; /* for multi-channel boards like Adlink PCI-MPG24 */
 	char name[64];
 	struct video_device *video_dev;
+	void *boot_fw;
+	unsigned boot_fw_len;
 	struct v4l2_device v4l2_dev;
 	int ref_count;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
-- 
1.7.10.4

