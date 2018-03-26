Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34660 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeCZVK7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 11/18] media: staging: atomisp: don't access a NULL var
Date: Mon, 26 Mar 2018 17:10:44 -0400
Message-Id: <42655bfbf1e40e716e5fa5368bd24737f4e073f2.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of those warnings:
	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:446 gmin_v1p2_ctrl() error: we previously assumed 'gs' could be null (see line 444)
	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:480 gmin_v1p8_ctrl() error: we previously assumed 'gs' could be null (see line 478)
	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:516 gmin_v2p8_ctrl() error: we previously assumed 'gs' could be null (see line 514)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c        | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index d8b7183db252..be0c5e11e86b 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -441,7 +441,7 @@ static int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 
-	if (gs && gs->v1p2_on == on)
+	if (!gs || gs->v1p2_on == on)
 		return 0;
 	gs->v1p2_on = on;
 
@@ -475,7 +475,7 @@ static int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 		}
 	}
 
-	if (gs && gs->v1p8_on == on)
+	if (!gs || gs->v1p8_on == on)
 		return 0;
 	gs->v1p8_on = on;
 
@@ -511,7 +511,7 @@ static int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 		}
 	}
 
-	if (gs && gs->v2p8_on == on)
+	if (!gs || gs->v2p8_on == on)
 		return 0;
 	gs->v2p8_on = on;
 
-- 
2.14.3
