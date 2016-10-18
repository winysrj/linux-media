Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51438 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755212AbcJRUqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH v2 55/58] platform: don't break long lines
Date: Tue, 18 Oct 2016 18:46:07 -0200
Message-Id: <04f307c4e4aabde34f02c010f3441983eeaf0096.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mx2_emmaprp.c | 10 +++++-----
 drivers/media/platform/pxa_camera.c  |  6 ++----
 drivers/media/platform/via-camera.c  |  7 ++-----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index e68d271b10af..03e47e0f778d 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -724,10 +724,10 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
-		dprintk(ctx->dev, "%s data will not fit into plane"
-				  "(%lu < %lu)\n", __func__,
-				  vb2_plane_size(vb, 0),
-				  (long)q_data->sizeimage);
+		dprintk(ctx->dev,
+			"%s data will not fit into plane(%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0),
+			(long)q_data->sizeimage);
 		return -EINVAL;
 	}
 
@@ -937,7 +937,7 @@ static int emmaprp_probe(struct platform_device *pdev)
 	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);
 	pcdev->vfd = vfd;
 	v4l2_info(&pcdev->v4l2_dev, EMMAPRP_MODULE_NAME
-			" Device registered as /dev/video%d\n", vfd->num);
+		  " Device registered as /dev/video%d\n", vfd->num);
 
 	platform_set_drvdata(pdev, pcdev);
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c12209c701d3..bcdac4932fb1 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2347,8 +2347,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		 * Platform hasn't set available data widths. This is bad.
 		 * Warn and use a default.
 		 */
-		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
-			 "data widths, using default 10 bit\n");
+		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available data widths, using default 10 bit\n");
 		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
 	}
 	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
@@ -2359,8 +2358,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->width_flags |= 1 << 9;
 	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
-			 "mclk == 0! Please, fix your platform data. "
-			 "Using default 20MHz\n");
+			 "mclk == 0! Please, fix your platform data. Using default 20MHz\n");
 		pcdev->mclk = 20000000;
 	}
 
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 7ca12deba89c..e16f70a5df1d 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -39,15 +39,12 @@ MODULE_LICENSE("GPL");
 static bool flip_image;
 module_param(flip_image, bool, 0444);
 MODULE_PARM_DESC(flip_image,
-		"If set, the sensor will be instructed to flip the image "
-		"vertically.");
+		"If set, the sensor will be instructed to flip the image vertically.");
 
 static bool override_serial;
 module_param(override_serial, bool, 0444);
 MODULE_PARM_DESC(override_serial,
-		"The camera driver will normally refuse to load if "
-		"the XO 1.5 serial port is enabled.  Set this option "
-		"to force-enable the camera.");
+		"The camera driver will normally refuse to load if the XO 1.5 serial port is enabled.  Set this option to force-enable the camera.");
 
 /*
  * The structure describing our camera.
-- 
2.7.4


