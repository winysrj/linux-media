Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41185 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbeDPQhS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 12:37:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 6/9] media: atomisp: ov2680: don't declare unused vars
Date: Mon, 16 Apr 2018 12:37:09 -0400
Message-Id: <f0f1de54f94a059e1ebe863a5c9e830b658905ab.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/atomisp/i2c/atomisp-ov2680.c: In function ‘__ov2680_set_exposure’:
drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:400:10: warning: variable ‘hts’ set but not used [-Wunused-but-set-variable]
  u16 vts,hts;
          ^~~
drivers/staging/media/atomisp/i2c/atomisp-ov2680.c: In function ‘ov2680_detect’:
drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:1164:5: warning: variable ‘revision’ set but not used [-Wunused-but-set-variable]
  u8 revision;
     ^~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index c0849299d592..bba3d1745908 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -397,14 +397,13 @@ static long __ov2680_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
-	u16 vts,hts;
+	u16 vts;
 	int ret,exp_val;
 
 	dev_dbg(&client->dev,
 		"+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",
 		coarse_itg, gain, digitgain);
 
-	hts = ov2680_res[dev->fmt_idx].pixels_per_line;
 	vts = ov2680_res[dev->fmt_idx].lines_per_frame;
 
 	/* group hold */
@@ -1185,7 +1184,8 @@ static int ov2680_detect(struct i2c_client *client)
 					OV2680_SC_CMMN_SUB_ID, &high);
 	revision = (u8) high & 0x0f;
 
-	dev_info(&client->dev, "sensor_revision id = 0x%x\n", id);
+	dev_info(&client->dev, "sensor_revision id = 0x%x, rev= %d\n",
+		 id, revision);
 
 	return 0;
 }
-- 
2.14.3
