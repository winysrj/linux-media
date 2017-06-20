Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48875
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750993AbdFTLVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] [media] ov13858: remove duplicated const declaration
Date: Tue, 20 Jun 2017 08:21:14 -0300
Message-Id: <6584a77b6ad17a46dba2d39024a148b206f07b8b.1497957671.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by gcc:

drivers/media/i2c/ov13858.c:953:20: warning: duplicate const
drivers/media/i2c/ov13858.c:953:14: warning: duplicate 'const' declaration specifier [-Wduplicate-decl-specifier]
 static const const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
              ^~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov13858.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 7ebcf6763866..86550d8ddfee 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -950,7 +950,7 @@ static const char * const ov13858_test_pattern_menu[] = {
 #define OV13858_LINK_FREQ_INDEX_1	1
 
 /* Menu items for LINK_FREQ V4L2 control */
-static const s64 const link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
+static const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
 	OV13858_LINK_FREQ_1080MBPS,
 	OV13858_LINK_FREQ_540MBPS
 };
-- 
2.9.4
