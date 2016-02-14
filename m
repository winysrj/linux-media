Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbcBNTvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 14:51:44 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Stas Sergeev <stsp@list.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] saa7134: Fix bytesperline not being set correctly for planar formats
Date: Sun, 14 Feb 2016 20:51:37 +0100
Message-Id: <1455479497-6324-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bytesperline should be the bytesperline for the first plane for planar
formats, not that of all planes combined.

This fixes a crash in xawtv caused by the wrong bpl.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1305389
Reported-and-tested-by: Stas Sergeev <stsp@list.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index a63c136..1293563b 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1219,10 +1219,13 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height       = dev->height;
 	f->fmt.pix.field        = dev->field;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
-	f->fmt.pix.bytesperline =
-		(f->fmt.pix.width * dev->fmt->depth) >> 3;
+	if (dev->fmt->planar)
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+	else
+		f->fmt.pix.bytesperline =
+			(f->fmt.pix.width * dev->fmt->depth) / 8;
 	f->fmt.pix.sizeimage =
-		f->fmt.pix.height * f->fmt.pix.bytesperline;
+		(f->fmt.pix.height * f->fmt.pix.width * dev->fmt->depth) / 8;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	return 0;
 }
@@ -1298,10 +1301,13 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 	if (f->fmt.pix.height > maxh)
 		f->fmt.pix.height = maxh;
 	f->fmt.pix.width &= ~0x03;
-	f->fmt.pix.bytesperline =
-		(f->fmt.pix.width * fmt->depth) >> 3;
+	if (fmt->planar)
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+	else
+		f->fmt.pix.bytesperline =
+			(f->fmt.pix.width * fmt->depth) / 8;
 	f->fmt.pix.sizeimage =
-		f->fmt.pix.height * f->fmt.pix.bytesperline;
+		(f->fmt.pix.height * f->fmt.pix.width * fmt->depth) / 8;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
-- 
2.7.1

