Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33319 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbeDPQhU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 9/9] media: atomisp-mt9m114: comment out unused stuff
Date: Mon, 16 Apr 2018 12:37:12 -0400
Message-Id: <19ed5c24c1efe1dfb3867a9ed91f02b27c97317f.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of data structs defined there but aren't used
anywhere.

Comment them out. Gets rid of those warnings:

drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:1808:45: warning: 'mt9m114_entity_ops' defined but not used [-Wunused-const-variable=]
 static const struct media_entity_operations mt9m114_entity_ops = {
                                             ^~~~~~~~~~~~~~~~~~
In file included from drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:35:0:
drivers/staging/media/atomisp/i2c/mt9m114.h:805:34: warning: 'mt9m114_iq' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_iq[] = {
                                  ^~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:797:34: warning: 'mt9m114_antiflicker_60hz' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_antiflicker_60hz[] = {
                                  ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:789:34: warning: 'mt9m114_antiflicker_50hz' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_antiflicker_50hz[] = {
                                  ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:682:34: warning: 'mt9m114_720_480P_init' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_720_480P_init[] = {
                                  ^~~~~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:533:34: warning: 'mt9m114_960P_init' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_960P_init[] = {
                                  ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:518:34: warning: 'mt9m114_wakeup_reg' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_wakeup_reg[] = {
                                  ^~~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:504:34: warning: 'mt9m114_streaming' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_streaming[] = {
                                  ^~~~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:497:34: warning: 'mt9m114_suspend' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_suspend[] = {
                                  ^~~~~~~~~~~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.h:393:34: warning: 'mt9m114_exitstandby' defined but not used [-Wunused-const-variable=]
 static struct misensor_reg const mt9m114_exitstandby[] = {
                                  ^~~~~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c |  4 ----
 drivers/staging/media/atomisp/i2c/mt9m114.h         | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index 454a5c31a206..8e180f903335 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -1805,10 +1805,6 @@ static const struct v4l2_subdev_ops mt9m114_ops = {
 	.sensor = &mt9m114_sensor_ops,
 };
 
-static const struct media_entity_operations mt9m114_entity_ops = {
-	.link_setup = NULL,
-};
-
 static int mt9m114_remove(struct i2c_client *client)
 {
 	struct mt9m114_device *dev;
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.h b/drivers/staging/media/atomisp/i2c/mt9m114.h
index 0af79d77a404..de39cc141308 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.h
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.h
@@ -390,6 +390,7 @@ static struct mt9m114_res_struct mt9m114_res[] = {
 };
 #define N_RES (ARRAY_SIZE(mt9m114_res))
 
+#if 0 /* Currently unused */
 static struct misensor_reg const mt9m114_exitstandby[] = {
 	{MISENSOR_16BIT,  0x098E, 0xDC00},
 	/* exit-standby */
@@ -397,6 +398,7 @@ static struct misensor_reg const mt9m114_exitstandby[] = {
 	{MISENSOR_16BIT,  0x0080, 0x8002},
 	{MISENSOR_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct misensor_reg const mt9m114_exp_win[5][5] = {
 	{
@@ -494,6 +496,7 @@ static struct misensor_reg const mt9m114_exp_center[] = {
 	{MISENSOR_TOK_TERM, 0, 0}
 };
 
+#if 0 /* Currently unused */
 static struct misensor_reg const mt9m114_suspend[] = {
 	 {MISENSOR_16BIT,  0x098E, 0xDC00},
 	 {MISENSOR_8BIT,  0xDC00, 0x40},
@@ -507,6 +510,7 @@ static struct misensor_reg const mt9m114_streaming[] = {
 	 {MISENSOR_16BIT,  0x0080, 0x8002},
 	 {MISENSOR_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct misensor_reg const mt9m114_standby_reg[] = {
 	 {MISENSOR_16BIT,  0x098E, 0xDC00},
@@ -515,12 +519,14 @@ static struct misensor_reg const mt9m114_standby_reg[] = {
 	 {MISENSOR_TOK_TERM, 0, 0}
 };
 
+#if 0 /* Currently unused */
 static struct misensor_reg const mt9m114_wakeup_reg[] = {
 	 {MISENSOR_16BIT,  0x098E, 0xDC00},
 	 {MISENSOR_8BIT,  0xDC00, 0x54},
 	 {MISENSOR_16BIT,  0x0080, 0x8002},
 	 {MISENSOR_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct misensor_reg const mt9m114_chgstat_reg[] = {
 	{MISENSOR_16BIT,  0x098E, 0xDC00},
@@ -530,6 +536,7 @@ static struct misensor_reg const mt9m114_chgstat_reg[] = {
 };
 
 /* [1296x976_30fps] - Intel */
+#if 0
 static struct misensor_reg const mt9m114_960P_init[] = {
 	{MISENSOR_16BIT, 0x098E, 0x1000},
 	{MISENSOR_8BIT, 0xC97E, 0x01},	  /* cam_sysctl_pll_enable = 1 */
@@ -565,6 +572,7 @@ static struct misensor_reg const mt9m114_960P_init[] = {
 	{MISENSOR_16BIT, 0xC86A, 0x03C8}, /* cam_output_height = 960 */
 	{MISENSOR_TOK_TERM, 0, 0},
 };
+#endif
 
 /* [1296x976_30fps_768Mbps] */
 static struct misensor_reg const mt9m114_976P_init[] = {
@@ -679,6 +687,7 @@ static struct misensor_reg const mt9m114_736P_init[] = {
 };
 
 /* [736x496_30fps_768Mbps] */
+#if 0 /* Currently unused */
 static struct misensor_reg const mt9m114_720_480P_init[] = {
 	{MISENSOR_16BIT, 0x98E, 0x1000},
 	{MISENSOR_8BIT, 0xC97E, 0x01},	  /* cam_sysctl_pll_enable = 1 */
@@ -714,6 +723,7 @@ static struct misensor_reg const mt9m114_720_480P_init[] = {
 	{MISENSOR_8BIT, 0xC878, 0x00}, /* 0x0E //cam_aet_aemode = 0 */
 	{MISENSOR_TOK_TERM, 0, 0}
 };
+#endif
 
 static struct misensor_reg const mt9m114_common[] = {
 	/* reset */
@@ -785,7 +795,7 @@ static struct misensor_reg const mt9m114_common[] = {
 	{MISENSOR_TOK_TERM, 0, 0},
 
 };
-
+#if 0 /* Currently unused */
 static struct misensor_reg const mt9m114_antiflicker_50hz[] = {
 	 {MISENSOR_16BIT,  0x098E, 0xC88B},
 	 {MISENSOR_8BIT,  0xC88B, 0x32},
@@ -1775,3 +1785,4 @@ static struct misensor_reg const mt9m114_iq[] = {
 };
 
 #endif
+#endif
-- 
2.14.3
