Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42571 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933164AbdKAVGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Leon Luo <leonl@leopardimaging.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 20/26] media: imx274: don't randomly return if range_count is zero
Date: Wed,  1 Nov 2017 17:05:57 -0400
Message-Id: <13dbb41e9cd36e5d974e144c7c34bd6b0079537c.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As smatch reported:
	drivers/media/i2c/imx274.c:659 imx274_regmap_util_write_table_8() error: uninitialized symbol 'err'.

There is a bug at imx274_regmap_util_write_table_8() with causes
it to randomly return a random error if range_count is zero.

Worse than that, the logic there starts with range_count
equal to zero, and periodically resets it to zero again.

As it is a way more likely that err assumes a non-zero value,
I suspect that the chance of this code to run is very small,
so, it would be worth to review the entire function.

Anyway, clearly it shouldn't be returning error if range_count
is zero. So, let's fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/imx274.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index ab6a5f31da74..0d8314bfd3cb 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -655,6 +655,8 @@ static int imx274_regmap_util_write_table_8(struct regmap *regmap,
 				err = regmap_bulk_write(regmap, range_start,
 							&range_vals[0],
 							range_count);
+			else
+				err = 0;
 
 			if (err)
 				return err;
-- 
2.13.6
