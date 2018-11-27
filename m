Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45512 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbeK1IOf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 03:14:35 -0500
Date: Tue, 27 Nov 2018 23:15:15 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH v3 6/6] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181127211512.2zqvrqa37vdsk35b@kekkonen.localdomain>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
 <20181127100253.30845-7-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127100253.30845-7-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 11:02:53AM +0100, Marco Felsch wrote:
> From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> 
> The chip can be configured to output data transitions on the
> rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> falling edge.
> 
> Parsing the fw-node is made in a subfunction to bundle all (future)
> dt-parsing / fw-parsing stuff.
> 
> Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> per default. Set bit to 0 (enable mask bit without value) to enable
> falling edge sampling.)
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> (m.felsch@pengutronix.de: use fwnode helpers)
> (m.felsch@pengutronix.de: mv fw parsing into own function)
> (m.felsch@pengutronix.de: adapt commit msg)
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

This one as well:

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 005fc2bd0d05..902c3cabf44c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -859,6 +859,7 @@ config VIDEO_MT9M032
 config VIDEO_MT9M111
 	tristate "mt9m111, mt9m112 and mt9m131 support"
 	depends on I2C && VIDEO_V4L2
+	select V4L2_FWNODE
 	help
 	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
 	  Micron/Aptina

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
