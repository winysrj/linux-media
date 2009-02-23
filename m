Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755356AbZBWPkS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 10:40:18 -0500
Date: Mon, 23 Feb 2009 16:40:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] sh-mobile-ceu-camera: set field to the value, configured at
 open()
In-Reply-To: <uiqn2gdnx.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902231633040.5100@axis700.grange>
References: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
 <Pine.LNX.4.64.0902191616340.5156@axis700.grange> <u3ae9zzd9.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902201737000.5004@axis700.grange> <uiqn2gdnx.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the case, that we have to capture with a default format, i.e., when the
user doesn't call S_FMT, we have to use the field value according to the
default, configured at open() time.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

On Mon, 23 Feb 2009, morimoto.kuninori@renesas.com wrote:

> ov772x_try_fmt is called when soc_camera_open is called.
> but sh_mobile_ceu_init_videobuf that set filed to ANY
> is called after soc_camera_open.
> And ov772x_try_fmt should be called after sh_mobile_ceu_init_videobuf.

Ok, you're right again. But that's not the problem with my previous patch 
this time, it's that one more patch was missing - this one. And this time 
I even actually tested it - at least with the capture-example. I would 
need an mplayer or gstreamer for migor... Testing video blindly is better 
than no testing at all, but worse than visually:-)

 drivers/media/video/sh_mobile_ceu_camera.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3f71cb8..55a5eae 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -94,7 +94,7 @@ struct sh_mobile_ceu_dev {
 	spinlock_t lock;
 	struct list_head capture;
 	struct videobuf_buffer *active;
-	int is_interlace;
+	int is_interlaced;
 
 	struct sh_mobile_ceu_info *pdata;
 
@@ -205,7 +205,7 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
 	ceu_write(pcdev, CDAYR, phys_addr_top);
-	if (pcdev->is_interlace) {
+	if (pcdev->is_interlaced) {
 		phys_addr_bottom = phys_addr_top + icd->width;
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
 	}
@@ -217,7 +217,7 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	case V4L2_PIX_FMT_NV61:
 		phys_addr_top += icd->width * icd->height;
 		ceu_write(pcdev, CDACR, phys_addr_top);
-		if (pcdev->is_interlace) {
+		if (pcdev->is_interlaced) {
 			phys_addr_bottom = phys_addr_top + icd->width;
 			ceu_write(pcdev, CDBCR, phys_addr_bottom);
 		}
@@ -481,7 +481,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	ceu_write(pcdev, CAMCR, value);
 
 	ceu_write(pcdev, CAPCR, 0x00300000);
-	ceu_write(pcdev, CAIFR, (pcdev->is_interlace) ? 0x101 : 0);
+	ceu_write(pcdev, CAIFR, pcdev->is_interlaced ? 0x101 : 0);
 
 	mdelay(1);
 
@@ -497,7 +497,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	}
 
 	height = icd->height;
-	if (pcdev->is_interlace) {
+	if (pcdev->is_interlaced) {
 		height /= 2;
 		cdwdr_width *= 2;
 	}
@@ -711,13 +711,13 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	switch (f->fmt.pix.field) {
 	case V4L2_FIELD_INTERLACED:
-		pcdev->is_interlace = 1;
+		pcdev->is_interlaced = 1;
 		break;
 	case V4L2_FIELD_ANY:
 		f->fmt.pix.field = V4L2_FIELD_NONE;
 		/* fall-through */
 	case V4L2_FIELD_NONE:
-		pcdev->is_interlace = 0;
+		pcdev->is_interlaced = 0;
 		break;
 	default:
 		ret = -EINVAL;
@@ -783,7 +783,8 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       &sh_mobile_ceu_videobuf_ops,
 				       &ici->dev, &pcdev->lock,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				       V4L2_FIELD_ANY,
+				       pcdev->is_interlaced ?
+				       V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE,
 				       sizeof(struct sh_mobile_ceu_buffer),
 				       icd);
 }
-- 
1.5.4

