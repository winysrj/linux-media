Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36128 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbcIUNJr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 09:09:47 -0400
Received: by mail-pa0-f67.google.com with SMTP id my20so2289624pab.3
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 06:09:47 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] gs1662: drop kfree for memory allocated with devm_kzalloc
Date: Wed, 21 Sep 2016 13:09:39 +0000
Message-Id: <1474463379-1030-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

It's not necessary to free memory allocated with devm_kzalloc
and using kfree leads to a double free.

Fixes: 7aae6e2df127 ("[media] Add GS1662 driver, a video serializer")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/spi/gs1662.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/spi/gs1662.c b/drivers/media/spi/gs1662.c
index d76f362..5143a90 100644
--- a/drivers/media/spi/gs1662.c
+++ b/drivers/media/spi/gs1662.c
@@ -453,10 +453,9 @@ static int gs_probe(struct spi_device *spi)
 static int gs_remove(struct spi_device *spi)
 {
 	struct v4l2_subdev *sd = spi_get_drvdata(spi);
-	struct gs *gs = to_gs(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(gs);
+
 	return 0;
 }

