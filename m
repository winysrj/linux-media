Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65448 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756619AbeDFOX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 02/21] media: dm365_ipipe: remove an unused var
Date: Fri,  6 Apr 2018 10:23:03 -0400
Message-Id: <8d5562a96cfc82d5256325ec44b12a45aa70cc8f.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/davinci_vpfe/dm365_ipipe.c:74:17: warning: variable 'dev' set but not used [-Wunused-but-set-variable]
  struct device *dev;
                 ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 31b9e3011415..dd0cfc79f50c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -71,14 +71,12 @@ static int ipipe_set_lutdpc_params(struct vpfe_ipipe_device *ipipe, void *param)
 {
 	struct vpfe_ipipe_lutdpc *lutdpc = &ipipe->config.lutdpc;
 	struct vpfe_ipipe_lutdpc *dpc_param;
-	struct device *dev;
 
 	if (!param) {
 		memset((void *)lutdpc, 0, sizeof(struct vpfe_ipipe_lutdpc));
 		goto success;
 	}
 
-	dev = ipipe->subdev.v4l2_dev->dev;
 	dpc_param = param;
 	lutdpc->en = dpc_param->en;
 	lutdpc->repl_white = dpc_param->repl_white;
-- 
2.14.3
