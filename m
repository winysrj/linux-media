Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3734 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3EaKDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 08/21] radio-tea5764: add device_caps support.
Date: Fri, 31 May 2013 12:02:28 +0200
Message-Id: <1369994561-25236-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 5a60990..077d906 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -294,7 +294,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->card, dev->name, sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info),
 		 "I2C:%s", dev_name(&dev->dev));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

