Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2EGTUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/23] gspca_zc3xx: Fix setting of jpeg quality while streaming
Date: Mon,  7 May 2012 21:01:20 +0200
Message-Id: <1336417294-4566-10-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the user changes the JPEG quality while the camera is streaming, the
driver should not only change the JPEG headers send to userspace, but also
actually tell the camera to use a different quantization table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/zc3xx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 7d9a4f1..c7c9d11 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -5923,6 +5923,8 @@ static void setquality(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	s8 reg07;
 
+	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
+
 	reg07 = 0;
 	switch (sd->sensor) {
 	case SENSOR_OV7620:
@@ -6885,7 +6887,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 	setquality(gspca_dev);
-	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
 	setlightfreq(gspca_dev);
 
 	switch (sd->sensor) {
@@ -7041,7 +7042,7 @@ static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 	sd->reg08 = i;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
 	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
+		setquality(gspca_dev);
 	return gspca_dev->usb_err;
 }
 
-- 
1.7.10

