Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37726 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbeDERy1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 13:54:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 10/16] media: mmp-driver: make two functions static
Date: Thu,  5 Apr 2018 13:54:10 -0400
Message-Id: <aaac5957ee592ef9fcb91100f4556b2df12eec59.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions are used only internally:

  CC      drivers/media/platform/marvell-ccic/mmp-driver.o
drivers/media/platform/marvell-ccic/mmp-driver.c:186:6: warning: no previous prototype for ‘mcam_ctlr_reset’ [-Wmissing-prototypes]
 void mcam_ctlr_reset(struct mcam_camera *mcam)
      ^~~~~~~~~~~~~~~
drivers/media/platform/marvell-ccic/mmp-driver.c:217:6: warning: no previous prototype for ‘mmpcam_calc_dphy’ [-Wmissing-prototypes]
 void mmpcam_calc_dphy(struct mcam_camera *mcam)
      ^~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 816f4b6a7b8e..17d79480e75c 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -183,7 +183,7 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	mcam_clk_disable(mcam);
 }
 
-void mcam_ctlr_reset(struct mcam_camera *mcam)
+static void mcam_ctlr_reset(struct mcam_camera *mcam)
 {
 	unsigned long val;
 	struct mmp_camera *cam = mcam_to_cam(mcam);
@@ -214,7 +214,7 @@ void mcam_ctlr_reset(struct mcam_camera *mcam)
  * CSI2_DPHY3 and CSI2_DPHY6 can be set with a default value
  * or be calculated dynamically
  */
-void mmpcam_calc_dphy(struct mcam_camera *mcam)
+static void mmpcam_calc_dphy(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
 	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
-- 
2.14.3
