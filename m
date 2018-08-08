Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbeHHRNA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 13:13:00 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5/6] media: isp: fix a warning about a wrong struct initializer
Date: Wed,  8 Aug 2018 10:52:55 -0400
Message-Id: <cf5719a1cb77e6322d8dd4c679529aec4c07ee27.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As sparse complains:
	drivers/media/platform/omap3isp/isp.c:303:39: warning: Using plain integer as NULL pointer

when a struct is initialized with { 0 }, actually the first
element of the struct is initialized with zeros, initializing the
other elements recursively. That can even generate gcc warnings
on nested structs.

So, instead, use the gcc-specific syntax for that (with is used
broadly inside the Kernel), initializing it with {};

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 03354d513311..842e2235047d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
 static int isp_xclk_init(struct isp_device *isp)
 {
 	struct device_node *np = isp->dev->of_node;
-	struct clk_init_data init = { 0 };
+	struct clk_init_data init = {};
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
-- 
2.17.1
