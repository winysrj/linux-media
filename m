Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52878 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752321AbdK2TIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:52 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 02/22] media: pxa_camera: get rid of kernel_doc warnings
Date: Wed, 29 Nov 2017 14:08:20 -0500
Message-Id: <05ea85d38bcc2087aa61ea2787ca33f5131546f0.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of the following warnings:
    drivers/media/platform/pxa_camera.c:247: warning: No description found for parameter 'layout'
    drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'buf'
    drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'sg'
    drivers/media/platform/pxa_camera.c:867: warning: No description found for parameter 'sglen'
    drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'vb' description in 'pxa_init_dma_channel'
    drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'dma' description in 'pxa_init_dma_channel'
    drivers/media/platform/pxa_camera.c:867: warning: Excess function parameter 'cibr' description in 'pxa_init_dma_channel'
    drivers/media/platform/pxa_camera.c:1029: warning: No description found for parameter 'last_submitted'
    drivers/media/platform/pxa_camera.c:1029: warning: No description found for parameter 'last_issued'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/pxa_camera.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 9d3f0cb1d95a..295f34ad1080 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -235,6 +235,7 @@ enum pxa_mbus_layout {
  *			stored in memory in the following way:
  * @packing:		Type of sample-packing, that has to be used
  * @order:		Sample order when storing in memory
+ * @layout:		Planes layout in memory
  * @bits_per_sample:	How many bits the bridge has to sample
  */
 struct pxa_mbus_pixelfmt {
@@ -852,10 +853,10 @@ static void pxa_camera_dma_irq_v(void *data)
 /**
  * pxa_init_dma_channel - init dma descriptors
  * @pcdev: pxa camera device
- * @vb: videobuffer2 buffer
- * @dma: dma video buffer
+ * @buf: pxa camera buffer
  * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
- * @cibr: camera Receive Buffer Register
+ * @sg: dma scatter list
+ * @sglen: dma scatter list length
  *
  * Prepares the pxa dma descriptors to transfer one camera channel.
  *
@@ -1010,6 +1011,8 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 /**
  * pxa_camera_check_link_miss - check missed DMA linking
  * @pcdev: camera device
+ * @last_submitted: an opaque DMA cookie for last submitted
+ * @last_issued: an opaque DMA cookie for last issued
  *
  * The DMA chaining is done with DMA running. This means a tiny temporal window
  * remains, where a buffer is queued on the chain, while the chain is already
-- 
2.14.3
