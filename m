Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60856 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbeLAGiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Dec 2018 01:38:07 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB))
Subject: [PATCH RFC 08/15] media: replace **** with a hug
Date: Fri, 30 Nov 2018 11:27:17 -0800
Message-Id: <20181130192737.15053-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to comply with the CoC, replace **** with a hug. In
addition, fix a coding style issue (lines with over 80 chars).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/media/i2c/bt819.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 472e37637c8d..c0f198b764f0 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -165,9 +165,11 @@ static int bt819_init(struct v4l2_subdev *sd)
 		0x0f, 0x00,	/* 0x0f Hue control */
 		0x12, 0x04,	/* 0x12 Output Format */
 		0x13, 0x20,	/* 0x13 Vertial Scaling msb 0x00
-					   chroma comb OFF, line drop scaling, interlace scaling
-					   BUG? Why does turning the chroma comb on fuck up color?
-					   Bug in the bt819 stepping on my board?
+					   chroma comb OFF, line drop scaling,
+					   interlace scaling BUG? Why does
+					   turning the chroma comb on hug up
+					   color?  Bug in the bt819 stepping on
+					   my board?
 					*/
 		0x14, 0x00,	/* 0x14 Vertial Scaling lsb */
 		0x16, 0x07,	/* 0x16 Video Timing Polarity
-- 
2.19.1
