Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46573 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbeDEU34 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 03/19] media: omap3isp/isp: remove an unused static var
Date: Thu,  5 Apr 2018 16:29:30 -0400
Message-Id: <66cc140f94014b062ab2720564405e1a24f0cd1e.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isp_xclk_init_data const data isn't used anywere.

drivers/media/platform/omap3isp/isp.c:294:35: warning: ‘isp_xclk_init_data’ defined but not used [-Wunused-const-variable=]
 static const struct clk_init_data isp_xclk_init_data = {
                                   ^~~~~~~~~~~~~~~~~~

Fixes: 9b28ee3c9122 ("[media] omap3isp: Use the common clock framework")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap3isp/isp.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 2a11a709aa4f..9e4b5fb8a8b5 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -291,13 +291,6 @@ static const struct clk_ops isp_xclk_ops = {
 
 static const char *isp_xclk_parent_name = "cam_mclk";
 
-static const struct clk_init_data isp_xclk_init_data = {
-	.name = "cam_xclk",
-	.ops = &isp_xclk_ops,
-	.parent_names = &isp_xclk_parent_name,
-	.num_parents = 1,
-};
-
 static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
 {
 	unsigned int idx = clkspec->args[0];
-- 
2.14.3
