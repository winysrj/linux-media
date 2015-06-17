Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:23789 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753064AbbFQKfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 06:35:36 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] media: atmel-isi: move configure_geometry() to start_streaming()
Date: Wed, 17 Jun 2015 18:39:39 +0800
Message-ID: <1434537579-23417-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
References: <1434537579-23417-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As in set_fmt() function we only need to know which format is been set,
we don't need to access the ISI hardware in this moment.

So move the configure_geometry(), which access the ISI hardware, to
start_streaming() will make code more consistent and simpler.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 8bc40ca..b01086d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -390,6 +390,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
+	ret = configure_geometry(isi, icd->user_width, icd->user_height,
+				icd->current_fmt->code);
+	if (ret < 0)
+		return ret;
+
 	spin_lock_irq(&isi->lock);
 	/* Clear any pending interrupt */
 	isi_readl(isi, ISI_STATUS);
@@ -477,8 +482,6 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 static int isi_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
@@ -511,16 +514,6 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	if (mf->code != xlate->code)
 		return -EINVAL;
 
-	/* Enable PM and peripheral clock before operate isi registers */
-	pm_runtime_get_sync(ici->v4l2_dev.dev);
-
-	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
-
-	pm_runtime_put(ici->v4l2_dev.dev);
-
-	if (ret < 0)
-		return ret;
-
 	pix->width		= mf->width;
 	pix->height		= mf->height;
 	pix->field		= mf->field;
-- 
1.9.1

