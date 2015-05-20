Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbbETQ6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 12:58:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] [media] e4000: Fix rangehigh value
Date: Wed, 20 May 2015 13:58:35 -0300
Message-Id: <13b019bbd170d788b1461c2e00b4578a07541dc5.1432141113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:

drivers/media/tuners/e4000.c:287:32: warning: constant 2208000000 is so big it is long long
drivers/media/tuners/e4000.c:287:32: warning: decimal constant 2208000000 is between LONG_MAX and ULONG_MAX. For C99 that means long long, C90 compilers are very likely to produce unsigned long (and a warning) here
drivers/media/tuners/e4000.c:287:3: warning: this decimal constant is unsigned only in ISO C90
   .rangehigh  =  2208000000,
   ^

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 3b49a4550bd3..fdf07ce4177a 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -284,7 +284,7 @@ static const struct v4l2_frequency_band bands[] = {
 		.index = 1,
 		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
 		.rangelow   =  1249000000,
-		.rangehigh  =  2208000000,
+		.rangehigh  =  2208000000L,
 	},
 };
 
-- 
2.1.0

