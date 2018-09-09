Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:44832 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeIJADW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 20:03:22 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <contact@paulk.fr>
Subject: [PATCH v2 4/4] media: cedrus: Select the sunxi SRAM driver in Kconfig
Date: Sun,  9 Sep 2018 21:10:15 +0200
Message-Id: <20180909191015.20902-5-contact@paulk.fr>
In-Reply-To: <20180909191015.20902-1-contact@paulk.fr>
References: <20180909191015.20902-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the sunxi SRAM driver is required to build the Cedrus driver,
select it in Kconfig.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
---
 drivers/staging/media/sunxi/cedrus/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
index afd7d7ee0388..3b06283e4bf3 100644
--- a/drivers/staging/media/sunxi/cedrus/Kconfig
+++ b/drivers/staging/media/sunxi/cedrus/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_SUNXI_CEDRUS
 	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on HAS_DMA
 	depends on OF
+	select SUNXI_SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select MEDIA_REQUEST_API
 	select V4L2_MEM2MEM_DEV
-- 
2.18.0
