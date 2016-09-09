Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbcIIOBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 10:01:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] [media] pxa_camera: remove an unused structure pointer
Date: Fri,  9 Sep 2016 11:00:40 -0300
Message-Id: <ade50f4ff8029a182c16c6418995e6ec569ea9fc.1473429632.git.mchehab@s-opensource.com>
In-Reply-To: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
References: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
In-Reply-To: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
References: <8f05b34a8be23d483661de181aa77c07d8a1bd58.1473429632.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:

drivers/media/platform/pxa_camera.c: In function 'pxa_dma_start_channels':
drivers/media/platform/pxa_camera.c:457:21: warning: variable 'active' set but not used [-Wunused-but-set-variable]
  struct pxa_buffer *active;
                     ^~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/pxa_camera.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 733677f06cb4..11478364c6d6 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -455,9 +455,6 @@ static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
 static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
 {
 	int i;
-	struct pxa_buffer *active;
-
-	active = pcdev->active;
 
 	for (i = 0; i < pcdev->channels; i++) {
 		dev_dbg(pcdev_to_dev(pcdev),
-- 
2.7.4

