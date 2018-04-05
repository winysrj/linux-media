Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58452 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbeDEU3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:29:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 13/19] media: vpbe_venc: don't store return codes if they won't be used
Date: Thu,  5 Apr 2018 16:29:40 -0400
Message-Id: <cb991055539f885fb56edc6a97952bf49b8f5767.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those two warnings

drivers/media/platform/davinci/vpbe_venc.c: In function ‘venc_set_ntsc’:
drivers/media/platform/davinci/vpbe_venc.c:230:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]
  u32 val;
      ^~~
drivers/media/platform/davinci/vpbe_venc.c: In function ‘venc_sub_dev_init’:
drivers/media/platform/davinci/vpbe_venc.c:611:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]
  int err;
      ^~~
  AR      drivers/media/platform/davinci/built-in.a

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpbe_venc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index add72a39ef2d..5c255de3b3f8 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -227,7 +227,6 @@ venc_enable_vpss_clock(int venc_type,
  */
 static int venc_set_ntsc(struct v4l2_subdev *sd)
 {
-	u32 val;
 	struct venc_state *venc = to_state(sd);
 	struct venc_platform_data *pdata = venc->pdata;
 
@@ -244,7 +243,7 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 	if (venc->venc_type == VPBE_VERSION_3) {
 		venc_write(sd, VENC_CLKCTL, 0x01);
 		venc_write(sd, VENC_VIDCTL, 0);
-		val = vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
+		vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
 	} else if (venc->venc_type == VPBE_VERSION_2) {
 		venc_write(sd, VENC_CLKCTL, 0x01);
 		venc_write(sd, VENC_VIDCTL, 0);
@@ -608,9 +607,8 @@ struct v4l2_subdev *venc_sub_dev_init(struct v4l2_device *v4l2_dev,
 		const char *venc_name)
 {
 	struct venc_state *venc;
-	int err;
 
-	err = bus_for_each_dev(&platform_bus_type, NULL, &venc,
+	bus_for_each_dev(&platform_bus_type, NULL, &venc,
 			venc_device_get);
 	if (venc == NULL)
 		return NULL;
-- 
2.14.3
