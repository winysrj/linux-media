Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53759 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756742AbeDFOXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 18/21] media: isppreview: fix __user annotations
Date: Fri,  6 Apr 2018 10:23:19 -0400
Message-Id: <de3b0b55d826e597f2be27f79e6e8177c0022e6a.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That prevent those warnings:
   drivers/media/platform/omap3isp/isppreview.c:893:45: warning: incorrect type in initializer (different address spaces)
   drivers/media/platform/omap3isp/isppreview.c:893:45:    expected void [noderef] <asn:1>*from
   drivers/media/platform/omap3isp/isppreview.c:893:45:    got void *[noderef] <asn:1><noident>
   drivers/media/platform/omap3isp/isppreview.c:893:47: warning: dereference of noderef expression

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap3isp/isppreview.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f83780..c2ef5870b231 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -890,7 +890,7 @@ static int preview_config(struct isp_prev_device *prev,
 		params = &prev->params.params[!!(active & bit)];
 
 		if (cfg->flag & bit) {
-			void __user *from = *(void * __user *)
+			void __user *from = *(void __user **)
 				((void *)cfg + attr->config_offset);
 			void *to = (void *)params + attr->param_offset;
 			size_t size = attr->param_size;
-- 
2.14.3
