Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35400 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1761482AbdLSJWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:22:49 -0500
Date: Tue, 19 Dec 2017 11:22:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
Message-ID: <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171211013146.2497-3-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 09:31:46AM +0800, Wenyou Yang wrote:
> The ov7740 (color) image sensor is a high performance VGA CMOS
> image snesor, which supports for output formats: RAW RGB and YUV
> and image sizes: VGA, and QVGA, CIF and any size smaller.
> 
> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>

Applied with this diff:

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 0308ba437bbb..041a77039d70 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1,5 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (c) 2017 Microchip Corporation.
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2017 Microchip Corporation.
+ */
 
 #include <linux/clk.h>
 #include <linux/delay.h>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
