Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50215 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756614AbeDFOXe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 14/21] media: mmp-driver: add needed __iomem marks to power_regs
Date: Fri,  6 Apr 2018 10:23:15 -0400
Message-Id: <0cfc88c4b03be176e585f3693efcf92d8ba6ae9c.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solve those warnings:

    drivers/media/platform/marvell-ccic/mmp-driver.c:135:41: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:135:41:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:135:41:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:136:44: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:136:44:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:136:44:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:174:38: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:174:38:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:174:38:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:175:38: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:175:38:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:175:38:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:195:48: warning: incorrect type in argument 1 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:195:48:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:195:48:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:196:55: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:196:55:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:196:55:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:197:54: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:197:54:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:197:54:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:202:48: warning: incorrect type in argument 1 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:202:48:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:202:48:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:203:55: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:203:55:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:203:55:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:204:54: warning: incorrect type in argument 2 (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:204:54:    expected void [noderef] <asn:2>*<noident>
    drivers/media/platform/marvell-ccic/mmp-driver.c:204:54:    got void *
    drivers/media/platform/marvell-ccic/mmp-driver.c:389:25: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/marvell-ccic/mmp-driver.c:389:25:    expected void *power_regs
    drivers/media/platform/marvell-ccic/mmp-driver.c:389:25:    got void [noderef] <asn:2>*

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 17d79480e75c..3cf300072348 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -37,7 +37,7 @@ MODULE_LICENSE("GPL");
 static char *mcam_clks[] = {"CCICAXICLK", "CCICFUNCLK", "CCICPHYCLK"};
 
 struct mmp_camera {
-	void *power_regs;
+	void __iomem *power_regs;
 	struct platform_device *pdev;
 	struct mcam_camera mcam;
 	struct list_head devlist;
-- 
2.14.3
