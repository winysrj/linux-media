Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:46397 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaAXOC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 09:02:59 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] [media] adv7842: log-status for Audio Video Info frames (AVI)
Date: Fri, 24 Jan 2014 14:50:05 +0100
Message-Id: <1390571406-11215-4-git-send-email-marbugge@cisco.com>
In-Reply-To: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
References: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clear any pending AVI checksum-errors.
To be able to display last received AVI.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 3aa1a7c..209b175 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2191,7 +2191,8 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 {
 	int i;
 	uint8_t buf[14];
-	uint8_t avi_inf_len;
+	u8 avi_len;
+	u8 avi_ver;
 	struct avi_info_frame avi;
 
 	if (!(hdmi_read(sd, 0x05) & 0x80)) {
@@ -2204,18 +2205,20 @@ static void print_avi_infoframe(struct v4l2_subdev *sd)
 	}
 
 	if (io_read(sd, 0x88) & 0x10) {
-		/* Note: the ADV7842 calculated incorrect checksums for InfoFrames
-		   with a length of 14 or 15. See the ADV7842 Register Settings
-		   Recommendations document for more details. */
-		v4l2_info(sd, "AVI infoframe checksum error\n");
-		return;
+		v4l2_info(sd, "AVI infoframe checksum error has occurred earlier\n");
+		io_write(sd, 0x8a, 0x10); /* clear AVI_INF_CKS_ERR_RAW */
+		if (io_read(sd, 0x88) & 0x10) {
+			v4l2_info(sd, "AVI infoframe checksum error still present\n");
+			io_write(sd, 0x8a, 0x10); /* clear AVI_INF_CKS_ERR_RAW */
+		}
 	}
 
-	avi_inf_len = infoframe_read(sd, 0xe2);
+	avi_len = infoframe_read(sd, 0xe2);
+	avi_ver = infoframe_read(sd, 0xe1);
 	v4l2_info(sd, "AVI infoframe version %d (%d byte)\n",
-		  infoframe_read(sd, 0xe1), avi_inf_len);
+		  avi_ver, avi_len);
 
-	if (infoframe_read(sd, 0xe1) != 0x02)
+	if (avi_ver != 0x02)
 		return;
 
 	for (i = 0; i < 14; i++)
-- 
1.8.1.4

