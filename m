Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38885 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaHPG5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 02:57:36 -0400
Received: by mail-pd0-f175.google.com with SMTP id r10so4472588pdi.6
        for <linux-media@vger.kernel.org>; Fri, 15 Aug 2014 23:57:35 -0700 (PDT)
Message-ID: <1408172250.9865.3.camel@phoenix>
Subject: [PATCH] [media] tvp7002: Don't update device->streaming if write to
 register fails
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org
Date: Sat, 16 Aug 2014 14:57:30 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures device->streaming has correct status.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/tvp7002.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 11f2387..51bac76 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -775,25 +775,20 @@ static int tvp7002_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
 static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp7002 *device = to_tvp7002(sd);
-	int error = 0;
+	int error;
 
 	if (device->streaming == enable)
 		return 0;
 
-	if (enable) {
-		/* Set output state on (low impedance means stream on) */
-		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x00);
-		device->streaming = enable;
-	} else {
-		/* Set output state off (high impedance means stream off) */
-		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
-		if (error)
-			v4l2_dbg(1, debug, sd, "Unable to stop streaming\n");
-
-		device->streaming = enable;
+	/* low impedance: on, high impedance: off */
+	error = tvp7002_write(sd, TVP7002_MISC_CTL_2, enable ? 0x00 : 0x03);
+	if (error) {
+		v4l2_dbg(1, debug, sd, "Fail to set streaming\n");
+		return error;
 	}
 
-	return error;
+	device->streaming = enable;
+	return 0;
 }
 
 /*
-- 
1.9.1



