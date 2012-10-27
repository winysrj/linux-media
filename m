Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab2J0Um4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 65/68] [media] soc_camera: ret is never used. get rid of it
Date: Sat, 27 Oct 2012 18:41:23 -0200
Message-Id: <1351370486-29040-66-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/soc_camera/soc_camera.c:1051:8: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d3f0b84..6f76ada 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1048,10 +1048,8 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
-			int ret;
-
 			icd->parent = ici->v4l2_dev.dev;
-			ret = soc_camera_probe(icd);
+			soc_camera_probe(icd);
 		}
 	}
 
-- 
1.7.11.7

