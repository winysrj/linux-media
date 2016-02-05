Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58072 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbcBENwi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 08:52:38 -0500
From: weiyj_lk@163.com
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] [media] media: davinci_vpfe: fix missing unlock on error in vpfe_prepare_pipeline()
Date: Fri,  5 Feb 2016 21:52:00 +0800
Message-Id: <1454680320-18307-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function
vpfe_prepare_pipeline() in the error handling case.

video->lock is lock/unlock in function vpfe_open(),
and no need to unlock it here, so remove unlock
video->lock.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 3ec7e65..db49af9 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -147,7 +147,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 	mutex_lock(&mdev->graph_mutex);
 	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
 	if (ret) {
-		mutex_unlock(&video->lock);
+		mutex_unlock(&mdev->graph_mutex);
 		return -ENOMEM;
 	}
 	media_entity_graph_walk_start(&graph, entity);

