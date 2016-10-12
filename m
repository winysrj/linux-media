Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:58627 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933642AbcJLOzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:55:24 -0400
Subject: [PATCH 11/34] [media] DaVinci-VPBE: Rename a jump label in
 vpbe_set_output()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <0fb1a9a0-cf02-51a1-6fe7-6d7be501e0d9@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:48:38 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:10:19 +0200

Adjust jump labels according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 6e7b0df..e68a792 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -253,20 +253,20 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
 		sd_index = vpbe_find_encoder_sd_index(cfg, index);
 		if (sd_index < 0) {
 			ret = -EINVAL;
-			goto out;
+			goto unlock;
 		}
 
 		ret = venc_device->setup_if_config(cfg
 						   ->outputs[index].if_params);
 		if (ret)
-			goto out;
+			goto unlock;
 	}
 
 	/* Set output at the encoder */
 	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
 				       s_routing, 0, enc_out_index, 0);
 	if (ret)
-		goto out;
+		goto unlock;
 
 	/*
 	 * It is assumed that venc or extenal encoder will set a default
@@ -288,7 +288,7 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
 		vpbe_dev->current_sd_index = sd_index;
 		vpbe_dev->current_out_index = index;
 	}
-out:
+unlock:
 	mutex_unlock(&vpbe_dev->lock);
 	return ret;
 }
-- 
2.10.1

