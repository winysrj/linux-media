Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38622 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeFIIjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2018 04:39:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so7649544wmf.3
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2018 01:39:17 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: omap3isp: zero-initialize the isp cam_xclk{a,b} initial data
Date: Sat,  9 Jun 2018 10:39:12 +0200
Message-Id: <20180609083912.27807-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct clk_init_data defined in isp_xclk_init() is a variable in the
stack but it's not explicitly zero-initialized. Because of that, in some
cases the data structure contains values that confuses the clk framework.

For example if the flags member has the CLK_IS_CRITICAL bit set, the clk
framework will wrongly prepare the clock on registration. This leads to
the isp_xclk_prepare() callback to be called which in turn calls to the
omap3isp_get() function that increments the isp device reference counter.

Since this omap3isp_get() call is unexpected, this leads to an unbalanced
omap3isp_get() call that prevents the requested IRQ to be later enabled,
due the refcount not being 0 when the correct omap3isp_get() call happens.

Fixes: 9b28ee3c9122 ("[media] omap3isp: Use the common clock framework")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f22cf351e3e..ae0ef8b241a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
 static int isp_xclk_init(struct isp_device *isp)
 {
 	struct device_node *np = isp->dev->of_node;
-	struct clk_init_data init;
+	struct clk_init_data init = { 0 };
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
-- 
2.17.1
