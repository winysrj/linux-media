Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 25/35] [media] mx2_camera: get rid of a warning
Date: Tue, 26 Aug 2014 18:55:01 -0300
Message-Id: <1409090111-8290-26-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/soc_camera/mx2_camera.c: In function 'mx27_camera_emma_prp_reset':
drivers/media/platform/soc_camera/mx2_camera.c:812:6: warning: variable 'cntl' set but not used [-Wunused-but-set-variable]
  u32 cntl;
      ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index b40bc2e5ba47..2d57c1d272b8 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -809,10 +809,9 @@ static int mx2_camera_init_videobuf(struct vb2_queue *q,
 
 static int mx27_camera_emma_prp_reset(struct mx2_camera_dev *pcdev)
 {
-	u32 cntl;
 	int count = 0;
 
-	cntl = readl(pcdev->base_emma + PRP_CNTL);
+	readl(pcdev->base_emma + PRP_CNTL);
 	writel(PRP_CNTL_SWRST, pcdev->base_emma + PRP_CNTL);
 	while (count++ < 100) {
 		if (!(readl(pcdev->base_emma + PRP_CNTL) & PRP_CNTL_SWRST))
-- 
1.9.3

