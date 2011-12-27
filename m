Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1L0Tn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 14:43:57 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so11868452eek.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:43:56 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 3/4] gspca: sonixj: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Date: Tue, 27 Dec 2011 20:43:30 +0100
Message-Id: <1325015011-11904-4-git-send-email-snjw23@gmail.com>
In-Reply-To: <1325015011-11904-1-git-send-email-snjw23@gmail.com>
References: <4EBECD11.8090709@gmail.com>
 <1325015011-11904-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The JPEG compression quality value can currently be read using the
VIDIOC_G_JPEGCOMP ioctl. As the quality field of struct v4l2_jpgecomp
is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY
control, so after the deprecation period VIDIOC_G_JPEGCOMP ioctl
handler can be removed, leaving the control the only user interface
for retrieving the compression quality.

For completeness the V4L2_CID_JPEG_ACTIVE_MARKER control should be also
added.

Cc: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/media/video/gspca/sonixj.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index c55d667..c148081 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -45,6 +45,7 @@ enum e_ctrl {
 	SHARPNESS,
 	ILLUM,
 	FREQ,
+	QUALITY,
 	NCTRLS		/* number of controls */
 };
 
@@ -126,6 +127,7 @@ static void qual_upd(struct work_struct *work);
 #define DEF_EN		0x80	/* defect pixel by 0: soft, 1: hard */
 
 /* V4L2 controls supported by the driver */
+static int getjpegqual(struct gspca_dev *gspca_dev, s32 *val);
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
 static void setcolors(struct gspca_dev *gspca_dev);
@@ -286,6 +288,19 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 	    },
 	    .set_control = setfreq
 	},
+[QUALITY] = {
+	    {
+		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Compression Quality",
+		.minimum = QUALITY_MIN,
+		.maximum = QUALITY_MAX,
+		.step    = 1,
+		.default_value = QUALITY_DEF,
+		.flags	 = V4L2_CTRL_FLAG_READ_ONLY,
+	    },
+	    .get = getjpegqual
+	},
 };
 
 /* table of the disabled controls */
@@ -2960,6 +2975,14 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int getjpegqual(struct gspca_dev *gspca_dev, s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->quality;
+	return 0;
+}
+
 static int sd_querymenu(struct gspca_dev *gspca_dev,
 			struct v4l2_querymenu *menu)
 {
-- 
1.7.4.1

