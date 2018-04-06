Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42298 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756732AbeDFOXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 07/21] media: davinci_vpfe: don't use kernel-doc markup for simple comments
Date: Fri,  6 Apr 2018 10:23:08 -0400
Message-Id: <c126556fb1b4c89bdee5aea1697247a3ea01d071.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those two warnings:
   drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c:90: warning: Function parameter or member 'interface' not described in 'MODULE_PARM_DESC'
   drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c:90: warning: Function parameter or member '(default' not described in 'MODULE_PARM_DESC'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 634d38c4bea1..e55c815b9b65 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -77,7 +77,7 @@ static bool interface;
 module_param(interface, bool, 0444);
 module_param(debug, bool, 0644);
 
-/**
+/*
  * VPFE capture can be used for capturing video such as from TVP5146 or TVP7002
  * and for capture raw bayer data from camera sensors such as mt9p031. At this
  * point there is problem in co-existence of mt9p031 and tvp5146 due to i2c
-- 
2.14.3
