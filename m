Return-path: <linux-media-owner@vger.kernel.org>
Received: from f5out.microchip.com ([198.175.253.81]:28786 "EHLO
        DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751857AbdJ0DaB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 23:30:01 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v5 4/5] media: atmel-isc: Remove unnecessary member
Date: Fri, 27 Oct 2017 11:21:31 +0800
Message-ID: <20171027032132.16418-5-wenyou.yang@microchip.com>
In-Reply-To: <20171027032132.16418-1-wenyou.yang@microchip.com>
References: <20171027032132.16418-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the memeber *config from the isc_subdev_entity struct,
the member is useless afterward.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/media/platform/atmel/atmel-isc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 4431c27dfb09..a99796f7eb03 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -83,7 +83,6 @@ struct isc_subdev_entity {
 	struct v4l2_subdev		*sd;
 	struct v4l2_async_subdev	*asd;
 	struct v4l2_async_notifier      notifier;
-	struct v4l2_subdev_pad_config	*config;
 
 	u32 pfe_cfg0;
 
@@ -1000,6 +999,7 @@ static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
 {
 	struct isc_format *isc_fmt;
 	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
@@ -1030,7 +1030,7 @@ static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
 
 	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
 	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
-			       isc->current_subdev->config, &format);
+			       &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
@@ -1495,8 +1495,6 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
 					      struct isc_device, v4l2_dev);
 	cancel_work_sync(&isc->awb_work);
 	video_unregister_device(&isc->video_dev);
-	if (isc->current_subdev->config)
-		v4l2_subdev_free_pad_config(isc->current_subdev->config);
 	v4l2_ctrl_handler_free(&isc->ctrls.handler);
 }
 
@@ -1648,10 +1646,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	INIT_LIST_HEAD(&isc->dma_queue);
 	spin_lock_init(&isc->dma_queue_lock);
 
-	sd_entity->config = v4l2_subdev_alloc_pad_config(sd_entity->sd);
-	if (!sd_entity->config)
-		return -ENOMEM;
-
 	ret = isc_formats_init(isc);
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev,
-- 
2.13.0
