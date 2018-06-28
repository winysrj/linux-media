Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34060 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966120AbeF1VpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 17:45:24 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>
Subject: [PATCH] tw686x: Fix oops on buffer alloc failure
Date: Thu, 28 Jun 2018 18:45:07 -0300
Message-Id: <20180628214507.6927-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Krzysztof Hałasa <khalasa@piap.pl>

The error path currently calls tw686x_video_free() which requires
vc->dev to be initialized, causing a NULL dereference on uninitizalized
channels.

Fix this by setting the vc->dev fields for all the channels first.

Fixes: f8afaa8dbc0d ("[media] tw686x: Introduce an interface to support multiple DMA modes")
Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
---
 drivers/media/pci/tw686x/tw686x-video.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 0ea8dd44026c..3a06c000f97b 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1190,6 +1190,14 @@ int tw686x_video_init(struct tw686x_dev *dev)
 			return err;
 	}
 
+	/* Initialize vc->dev and vc->ch for the error path */
+	for (ch = 0; ch < max_channels(dev); ch++) {
+		struct tw686x_video_channel *vc = &dev->video_channels[ch];
+
+		vc->dev = dev;
+		vc->ch = ch;
+	}
+
 	for (ch = 0; ch < max_channels(dev); ch++) {
 		struct tw686x_video_channel *vc = &dev->video_channels[ch];
 		struct video_device *vdev;
@@ -1198,9 +1206,6 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		spin_lock_init(&vc->qlock);
 		INIT_LIST_HEAD(&vc->vidq_queued);
 
-		vc->dev = dev;
-		vc->ch = ch;
-
 		/* default settings */
 		err = tw686x_set_standard(vc, V4L2_STD_NTSC);
 		if (err)
-- 
2.18.0.rc2
