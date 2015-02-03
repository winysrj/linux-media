Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58586 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbbBCObN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 09:31:13 -0500
Message-ID: <54D0DBAA.7040607@users.sourceforge.net>
Date: Tue, 03 Feb 2015 15:31:06 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] [media] V4L2: Delete an unnecessary check before the function
 call "media_entity_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 3 Feb 2015 15:27:38 +0100

The media_entity_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 543631c..b9ff7fd 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -93,8 +93,7 @@ static int subdev_open(struct file *file)
 
 err:
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	if (entity)
-		media_entity_put(entity);
+	media_entity_put(entity);
 #endif
 	v4l2_fh_del(&subdev_fh->vfh);
 	v4l2_fh_exit(&subdev_fh->vfh);
-- 
2.2.2

