Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:57168 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0BCTlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 14:41:49 -0500
Message-ID: <4B69D2F5.2050100@gmail.com>
Date: Wed, 03 Feb 2010 20:48:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	tobias.lorenz@gmx.net, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The -EINVAL was overwritten by the si470x_disconnect_check().

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this needed?

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 4da0f15..65b4a92 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -748,12 +748,13 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = -EINVAL;
+	int retval;
 
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
 		goto done;
+	retval = -EINVAL;
 
 	if (tuner->index != 0)
 		goto done;
