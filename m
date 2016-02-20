Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38757 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1948978AbcBTIs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 03:48:28 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tc358743: use - instead of non-ascii wide-dash character
Message-ID: <56C82857.5080106@xs4all.nl>
Date: Sat, 20 Feb 2016 09:48:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch complains about non-ascii characters. It turns out that a wide-dash character
was used instead of the more common '-' character.

Replace those dashes with -.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index da7469b..972e0d4 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1198,21 +1198,21 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static void tc358743_print_register_map(struct v4l2_subdev *sd)
 {
-	v4l2_info(sd, "0x0000–0x00FF: Global Control Register\n");
-	v4l2_info(sd, "0x0100–0x01FF: CSI2-TX PHY Register\n");
-	v4l2_info(sd, "0x0200–0x03FF: CSI2-TX PPI Register\n");
-	v4l2_info(sd, "0x0400–0x05FF: Reserved\n");
-	v4l2_info(sd, "0x0600–0x06FF: CEC Register\n");
-	v4l2_info(sd, "0x0700–0x84FF: Reserved\n");
-	v4l2_info(sd, "0x8500–0x85FF: HDMIRX System Control Register\n");
-	v4l2_info(sd, "0x8600–0x86FF: HDMIRX Audio Control Register\n");
-	v4l2_info(sd, "0x8700–0x87FF: HDMIRX InfoFrame packet data Register\n");
-	v4l2_info(sd, "0x8800–0x88FF: HDMIRX HDCP Port Register\n");
-	v4l2_info(sd, "0x8900–0x89FF: HDMIRX Video Output Port & 3D Register\n");
-	v4l2_info(sd, "0x8A00–0x8BFF: Reserved\n");
-	v4l2_info(sd, "0x8C00–0x8FFF: HDMIRX EDID-RAM (1024bytes)\n");
-	v4l2_info(sd, "0x9000–0x90FF: HDMIRX GBD Extraction Control\n");
-	v4l2_info(sd, "0x9100–0x92FF: HDMIRX GBD RAM read\n");
+	v4l2_info(sd, "0x0000-0x00FF: Global Control Register\n");
+	v4l2_info(sd, "0x0100-0x01FF: CSI2-TX PHY Register\n");
+	v4l2_info(sd, "0x0200-0x03FF: CSI2-TX PPI Register\n");
+	v4l2_info(sd, "0x0400-0x05FF: Reserved\n");
+	v4l2_info(sd, "0x0600-0x06FF: CEC Register\n");
+	v4l2_info(sd, "0x0700-0x84FF: Reserved\n");
+	v4l2_info(sd, "0x8500-0x85FF: HDMIRX System Control Register\n");
+	v4l2_info(sd, "0x8600-0x86FF: HDMIRX Audio Control Register\n");
+	v4l2_info(sd, "0x8700-0x87FF: HDMIRX InfoFrame packet data Register\n");
+	v4l2_info(sd, "0x8800-0x88FF: HDMIRX HDCP Port Register\n");
+	v4l2_info(sd, "0x8900-0x89FF: HDMIRX Video Output Port & 3D Register\n");
+	v4l2_info(sd, "0x8A00-0x8BFF: Reserved\n");
+	v4l2_info(sd, "0x8C00-0x8FFF: HDMIRX EDID-RAM (1024bytes)\n");
+	v4l2_info(sd, "0x9000-0x90FF: HDMIRX GBD Extraction Control\n");
+	v4l2_info(sd, "0x9100-0x92FF: HDMIRX GBD RAM read\n");
 	v4l2_info(sd, "0x9300-      : Reserved\n");
 }

