Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55984 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbbEVOAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 04/11] e4000: fix compiler warning
Date: Fri, 22 May 2015 15:59:37 +0200
Message-Id: <1432303184-8594-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/tuners/e4000.c:287:3: warning: this decimal constant is unsigned only in ISO C90
   .rangehigh  =  2208000000L,
   ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/tuners/e4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index fdf07ce..03538f8 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -284,7 +284,7 @@ static const struct v4l2_frequency_band bands[] = {
 		.index = 1,
 		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
 		.rangelow   =  1249000000,
-		.rangehigh  =  2208000000L,
+		.rangehigh  =  2208000000UL,
 	},
 };
 
-- 
2.1.4

