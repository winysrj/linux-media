Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:44800 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeIJAC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 20:02:56 -0400
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
Subject: [PATCH v2 3/4] media: cedrus: Wrap PHYS_PFN_OFFSET with ifdef and add dedicated comment
Date: Sun,  9 Sep 2018 21:10:14 +0200
Message-Id: <20180909191015.20902-4-contact@paulk.fr>
In-Reply-To: <20180909191015.20902-1-contact@paulk.fr>
References: <20180909191015.20902-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since PHYS_PFN_OFFSET is not defined for all architectures, it is
requried to wrap it with ifdef so that it can be built on all
architectures.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
---
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
index f4307e8f7908..32adbcbe6175 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -199,8 +199,13 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
 	/*
 	 * The VPU is only able to handle bus addresses so we have to subtract
 	 * the RAM offset to the physcal addresses.
+	 *
+	 * This information will eventually be obtained from device-tree.
 	 */
+
+#ifdef PHYS_PFN_OFFSET
 	dev->dev->dma_pfn_offset = PHYS_PFN_OFFSET;
+#endif
 
 	ret = of_reserved_mem_device_init(dev->dev);
 	if (ret && ret != -ENODEV) {
-- 
2.18.0
