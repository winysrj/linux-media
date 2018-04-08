Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39090 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbeDHVVH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:07 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 6/6] usbtv: Use the constant for supported standards
Date: Sun,  8 Apr 2018 23:12:01 +0200
Message-Id: <20180408211201.27452-7-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the USBTV_TV_STD define instead of repeating ourselves.

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index d0bf5eb217b1..eda51dbf063b 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -670,8 +670,7 @@ static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	int ret = -EINVAL;
 	struct usbtv *usbtv = video_drvdata(file);
 
-	if ((norm & V4L2_STD_525_60) || (norm & V4L2_STD_PAL) ||
-			(norm & V4L2_STD_SECAM))
+	if (norm & USBTV_TV_STD)
 		ret = usbtv_select_norm(usbtv, norm);
 
 	return ret;
-- 
2.17.0
