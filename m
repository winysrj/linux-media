Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbLKNef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:35 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Harry Wei <harryxiyou@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bryan Wu <cooloney@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Shraddha Barke <shraddha.6596@gmail.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Junsu Shin <jjunes0@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Nicholas Mc Guire <der.herr@hofr.at>,
	Inki Dae <inki.dae@samsung.com>, linux-doc@vger.kernel.org,
	linux-kernel@zh-kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: [PATCH 03/10] media framework: rename pads init function to media_entity_pads_init()
Date: Fri, 11 Dec 2015 11:34:08 -0200
Message-Id: <063476f381aebf981106b7d134348a0a9acc67cc.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the MC next gen rework, what's left for media_entity_init()
is to just initialize the PADs. However, certain devices, like
a FLASH led/light doesn't have any input or output PAD.

So, there's no reason why calling media_entity_init() would be
mandatory. Also, despite its name, what this function actually
does is to initialize the PADs data. So, rename it to
media_entity_pads_init() in order to reflect that.

The media entity actual init happens during entity register,
at media_device_register_entity(). We should move init of
num_links and num_backlinks to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/media-framework.txt                  | 18 +++++++++++-------
 Documentation/video4linux/v4l2-framework.txt       |  8 ++++----
 Documentation/zh_CN/video4linux/v4l2-framework.txt |  8 ++++----
 drivers/media/dvb-core/dvbdev.c                    |  4 ++--
 drivers/media/dvb-frontends/au8522_decoder.c       |  2 +-
 drivers/media/i2c/ad9389b.c                        |  2 +-
 drivers/media/i2c/adp1653.c                        |  2 +-
 drivers/media/i2c/adv7180.c                        |  2 +-
 drivers/media/i2c/adv7511.c                        |  2 +-
 drivers/media/i2c/adv7604.c                        |  2 +-
 drivers/media/i2c/adv7842.c                        |  2 +-
 drivers/media/i2c/as3645a.c                        |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |  2 +-
 drivers/media/i2c/lm3560.c                         |  2 +-
 drivers/media/i2c/lm3646.c                         |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |  2 +-
 drivers/media/i2c/mt9m032.c                        |  2 +-
 drivers/media/i2c/mt9p031.c                        |  2 +-
 drivers/media/i2c/mt9t001.c                        |  2 +-
 drivers/media/i2c/mt9v032.c                        |  2 +-
 drivers/media/i2c/noon010pc30.c                    |  2 +-
 drivers/media/i2c/ov2659.c                         |  2 +-
 drivers/media/i2c/ov9650.c                         |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  4 ++--
 drivers/media/i2c/s5k4ecgx.c                       |  2 +-
 drivers/media/i2c/s5k5baf.c                        |  4 ++--
 drivers/media/i2c/s5k6a3.c                         |  2 +-
 drivers/media/i2c/s5k6aa.c                         |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  6 +++---
 drivers/media/i2c/tc358743.c                       |  2 +-
 drivers/media/i2c/tvp514x.c                        |  2 +-
 drivers/media/i2c/tvp7002.c                        |  2 +-
 drivers/media/media-device.c                       |  2 ++
 drivers/media/media-entity.c                       | 11 ++++-------
 drivers/media/platform/exynos4-is/fimc-capture.c   |  4 ++--
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  4 ++--
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  2 +-
 drivers/media/platform/omap3isp/ispccdc.c          |  2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  2 +-
 drivers/media/platform/omap3isp/isppreview.c       |  2 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  2 +-
 drivers/media/platform/omap3isp/ispstat.c          |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  4 ++--
 drivers/media/platform/vsp1/vsp1_entity.c          |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |  2 +-
 drivers/media/usb/au0828/au0828-video.c            |  6 +++---
 drivers/media/usb/cx231xx/cx231xx-video.c          |  4 ++--
 drivers/media/usb/uvc/uvc_entity.c                 |  4 ++--
 drivers/media/v4l2-core/tuner-core.c               |  2 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 +++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  2 +-
 include/media/media-entity.h                       |  2 +-
 68 files changed, 102 insertions(+), 99 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index b424de6c3bb3..7fbfe4bd1f47 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -101,14 +101,18 @@ include/media/media-entity.h. The structure is usually embedded into a
 higher-level structure, such as a v4l2_subdev or video_device instance,
 although drivers can allocate entities directly.
 
-Drivers initialize entities by calling
+Drivers initialize entity pads by calling
 
-	media_entity_init(struct media_entity *entity, u16 num_pads,
+	media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 			  struct media_pad *pads);
 
-The media_entity name, type, flags, revision and group_id fields can be
-initialized before or after calling media_entity_init. Entities embedded in
-higher-level standard structures can have some of those fields set by the
+If no pads are needed, drivers could directly fill entity->num_pads
+with 0 and entity->pads with NULL or to call the above function that
+will do the same.
+
+The media_entity name, type, flags, revision and group_id fields should be
+initialized before calling media_device_register_entity(). Entities embedded
+in higher-level standard structures can have some of those fields set by the
 higher-level framework.
 
 As the number of pads is known in advance, the pads array is not allocated
@@ -116,10 +120,10 @@ dynamically but is managed by the entity driver. Most drivers will embed the
 pads array in a driver-specific structure, avoiding dynamic allocation.
 
 Drivers must set the direction of every pad in the pads array before calling
-media_entity_init. The function will initialize the other pads fields.
+media_entity_pads_init. The function will initialize the other pads fields.
 
 Unlike the number of pads, the total number of links isn't always known in
-advance by the entity driver. As an initial estimate, media_entity_init
+advance by the entity driver. As an initial estimate, media_entity_pads_init
 pre-allocates a number of links equal to the number of pads. The links array
 will be reallocated if it grows beyond the initial estimate.
 
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 2e0fc28fa12f..fa41608ab2b4 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -295,12 +295,12 @@ module owner. This is done for you if you use the i2c helper functions.
 
 If integration with the media framework is needed, you must initialize the
 media_entity struct embedded in the v4l2_subdev struct (entity field) by
-calling media_entity_init():
+calling media_entity_pads_init(), if the entity has pads:
 
 	struct media_pad *pads = &my_sd->pads;
 	int err;
 
-	err = media_entity_init(&sd->entity, npads, pads);
+	err = media_entity_pads_init(&sd->entity, npads, pads);
 
 The pads array must have been previously initialized. There is no need to
 manually set the struct media_entity function and name fields, but the
@@ -695,12 +695,12 @@ difference is that the inode argument is omitted since it is never used.
 
 If integration with the media framework is needed, you must initialize the
 media_entity struct embedded in the video_device struct (entity field) by
-calling media_entity_init():
+calling media_entity_pads_init():
 
 	struct media_pad *pad = &my_vdev->pad;
 	int err;
 
-	err = media_entity_init(&vdev->entity, 1, pad);
+	err = media_entity_pads_init(&vdev->entity, 1, pad);
 
 The pads array must have been previously initialized. There is no need to
 manually set the struct media_entity type and name fields.
diff --git a/Documentation/zh_CN/video4linux/v4l2-framework.txt b/Documentation/zh_CN/video4linux/v4l2-framework.txt
index ff815cb92031..698660b7f21f 100644
--- a/Documentation/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/zh_CN/video4linux/v4l2-framework.txt
@@ -289,13 +289,13 @@ struct v4l2_subdev_ops {
 然后，你必须用一个唯一的名字初始化 subdev->name，并初始化模块的
 owner 域。若使用 i2c 辅助函数，这些都会帮你处理好。
 
-若需同媒体框架整合，你必须调用 media_entity_init() 初始化 v4l2_subdev
+若需同媒体框架整合，你必须调用 media_entity_pads_init() 初始化 v4l2_subdev
 结构体中的 media_entity 结构体（entity 域）：
 
 	struct media_pad *pads = &my_sd->pads;
 	int err;
 
-	err = media_entity_init(&sd->entity, npads, pads);
+	err = media_entity_pads_init(&sd->entity, npads, pads);
 
 pads 数组必须预先初始化。无须手动设置 media_entity 的 type 和
 name 域，但如有必要，revision 域必须初始化。
@@ -596,13 +596,13 @@ void v4l2_disable_ioctl(struct video_device *vdev, unsigned int cmd);
 v4l2_file_operations 结构体是 file_operations 的一个子集。其主要
 区别在于：因 inode 参数从未被使用，它将被忽略。
 
-如果需要与媒体框架整合，你必须通过调用 media_entity_init() 初始化
+如果需要与媒体框架整合，你必须通过调用 media_entity_pads_init() 初始化
 嵌入在 video_device 结构体中的 media_entity（entity 域）结构体：
 
 	struct media_pad *pad = &my_vdev->pad;
 	int err;
 
-	err = media_entity_init(&vdev->entity, 1, pad);
+	err = media_entity_pads_init(&vdev->entity, 1, pad);
 
 pads 数组必须预先初始化。没有必要手动设置 media_entity 的 type 和
 name 域。
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 1d4e35693d09..b56e00817d3f 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -245,7 +245,7 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 		entity->function = MEDIA_ENT_F_IO_DTV;
 		pads->flags = MEDIA_PAD_FL_SINK;
 
-		ret = media_entity_init(entity, 1, pads);
+		ret = media_entity_pads_init(entity, 1, pads);
 		if (ret < 0)
 			return ret;
 
@@ -340,7 +340,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 	}
 
 	if (npads) {
-		ret = media_entity_init(dvbdev->entity, npads, dvbdev->pads);
+		ret = media_entity_pads_init(dvbdev->entity, npads, dvbdev->pads);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 39fab1ab921c..9674cefcf232 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -777,7 +777,7 @@ static int au8522_probe(struct i2c_client *client,
 	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
-	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
+	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
 				state->pads);
 	if (ret < 0) {
 		v4l_info(client, "failed to initialize media entity!\n");
diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index a02dc4925707..788967dadd29 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1158,7 +1158,7 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->rgb_quantization_range_ctrl->is_private = true;
 
 	state->pad.flags = MEDIA_PAD_FL_SINK;
-	err = media_entity_init(&sd->entity, 1, &state->pad);
+	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
 
diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index 7150f35d5935..7e9cbf757e95 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -512,7 +512,7 @@ static int adp1653_probe(struct i2c_client *client,
 	if (ret)
 		goto free_and_quit;
 
-	ret = media_entity_init(&flash->subdev.entity, 0, NULL);
+	ret = media_entity_pads_init(&flash->subdev.entity, 0, NULL);
 	if (ret < 0)
 		goto free_and_quit;
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 2ebe9efdfc1b..ff57c1dcb8af 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1214,7 +1214,7 @@ static int adv7180_probe(struct i2c_client *client,
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.flags |= MEDIA_ENT_F_ATV_DECODER;
-	ret = media_entity_init(&sd->entity, 1, &state->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (ret)
 		goto err_free_ctrl;
 
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index cbcf81b1d29e..471fd23b5c5c 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1482,7 +1482,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->rgb_quantization_range_ctrl->is_private = true;
 
 	state->pad.flags = MEDIA_PAD_FL_SINK;
-	err = media_entity_init(&sd->entity, 1, &state->pad);
+	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_hdl;
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c2df7e8053f3..f8dd7505b529 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3208,7 +3208,7 @@ static int adv76xx_probe(struct i2c_client *client,
 		state->pads[i].flags = MEDIA_PAD_FL_SINK;
 	state->pads[state->source_pad].flags = MEDIA_PAD_FL_SOURCE;
 
-	err = media_entity_init(&sd->entity, state->source_pad + 1,
+	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
 		goto err_work_queues;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index b5013a937254..5fbb788e7b59 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3309,7 +3309,7 @@ static int adv7842_probe(struct i2c_client *client,
 			adv7842_delayed_work_enable_hotplug);
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
-	err = media_entity_init(&sd->entity, 1, &state->pad);
+	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
 		goto err_work_queues;
 
diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index b1bc4d0f76f2..2e90e4094b79 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -827,7 +827,7 @@ static int as3645a_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto done;
 
-	ret = media_entity_init(&flash->subdev.entity, 0, NULL);
+	ret = media_entity_pads_init(&flash->subdev.entity, 0, NULL);
 	if (ret < 0)
 		goto done;
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index f2f0992c7e54..f4ac54027f15 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5210,7 +5210,7 @@ static int cx25840_probe(struct i2c_client *client,
 	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
-	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
+	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
 				state->pads);
 	if (ret < 0) {
 		v4l_info(client, "failed to initialize media entity!\n");
diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 98266f707ea0..251a2aaf98c3 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -365,7 +365,7 @@ static int lm3560_subdev_init(struct lm3560_flash *flash,
 	rval = lm3560_init_controls(flash, led_no);
 	if (rval)
 		goto err_out;
-	rval = media_entity_init(&flash->subdev_led[led_no].entity, 0, NULL);
+	rval = media_entity_pads_init(&flash->subdev_led[led_no].entity, 0, NULL);
 	if (rval < 0)
 		goto err_out;
 	flash->subdev_led[led_no].entity.function = MEDIA_ENT_F_FLASH;
diff --git a/drivers/media/i2c/lm3646.c b/drivers/media/i2c/lm3646.c
index ba5ee0d7a78e..7e9967af36ec 100644
--- a/drivers/media/i2c/lm3646.c
+++ b/drivers/media/i2c/lm3646.c
@@ -282,7 +282,7 @@ static int lm3646_subdev_init(struct lm3646_flash *flash)
 	rval = lm3646_init_controls(flash);
 	if (rval)
 		goto err_out;
-	rval = media_entity_init(&flash->subdev_led.entity, 0, NULL);
+	rval = media_entity_pads_init(&flash->subdev_led.entity, 0, NULL);
 	if (rval < 0)
 		goto err_out;
 	flash->subdev_led.entity.function = MEDIA_ENT_F_FLASH;
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index bec5cea23b65..acb804bceccb 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -975,7 +975,7 @@ static int m5mols_probe(struct i2c_client *client,
 
 	sd->internal_ops = &m5mols_subdev_internal_ops;
 	info->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, 1, &info->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &info->pad);
 	if (ret < 0)
 		return ret;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index a2a450839ca1..da076796999e 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -799,7 +799,7 @@ static int mt9m032_probe(struct i2c_client *client,
 
 	sensor->subdev.ctrl_handler = &sensor->ctrls;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sensor->subdev.entity, 1, &sensor->pad);
+	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
 	if (ret < 0)
 		goto error_ctrl;
 
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 165f29cddca6..237737fec09c 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -1112,7 +1112,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
 
 	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad);
+	ret = media_entity_pads_init(&mt9p031->subdev.entity, 1, &mt9p031->pad);
 	if (ret < 0)
 		goto done;
 
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 7d3df84651d8..702d562f8e39 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -933,7 +933,7 @@ static int mt9t001_probe(struct i2c_client *client,
 	mt9t001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	mt9t001->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&mt9t001->subdev.entity, 1, &mt9t001->pad);
+	ret = media_entity_pads_init(&mt9t001->subdev.entity, 1, &mt9t001->pad);
 
 done:
 	if (ret < 0) {
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index b4f0f042c6c3..2e1d116a64e7 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1046,7 +1046,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad);
+	ret = media_entity_pads_init(&mt9v032->subdev.entity, 1, &mt9v032->pad);
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 47ea3f79eacc..30cb90b88d75 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -780,7 +780,7 @@ static int noon010_probe(struct i2c_client *client,
 
 	info->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, 1, &info->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &info->pad);
 	if (ret < 0)
 		goto np_err;
 
diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index cf8e71610248..02b9a3440557 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1446,7 +1446,7 @@ static int ov2659_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, 1, &ov2659->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &ov2659->pad);
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&ov2659->ctrls);
 		return ret;
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index adb4aab45c10..a0b3c9bde53d 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1501,7 +1501,7 @@ static int ov965x_probe(struct i2c_client *client,
 
 	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, 1, &ov965x->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 3d578f2ce7b2..57b3d27993a4 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1690,7 +1690,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 
-	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
+	ret = media_entity_pads_init(&sd->entity, S5C73M3_NUM_PADS,
 							state->sensor_pads);
 	if (ret < 0)
 		return ret;
@@ -1706,7 +1706,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
 	oif_sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 
-	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
+	ret = media_entity_pads_init(&oif_sd->entity, OIF_NUM_PADS,
 							state->oif_pads);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index bacec84e773f..8a0f22da590f 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -962,7 +962,7 @@ static int s5k4ecgx_probe(struct i2c_client *client,
 
 	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, 1, &priv->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &priv->pad);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 564938ab2abd..fc3a5a8e6c9c 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1905,7 +1905,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 
 	state->cis_pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, NUM_CIS_PADS, &state->cis_pad);
+	ret = media_entity_pads_init(&sd->entity, NUM_CIS_PADS, &state->cis_pad);
 	if (ret < 0)
 		goto err;
 
@@ -1920,7 +1920,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
 	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
-	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
+	ret = media_entity_pads_init(&sd->entity, NUM_ISP_PADS, state->pads);
 
 	if (!ret)
 		return 0;
diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 2434a7944781..b9e43ffa5085 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -333,7 +333,7 @@ static int s5k6a3_probe(struct i2c_client *client,
 	sensor->format.height = S5K6A3_DEFAULT_HEIGHT;
 
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, 1, &sensor->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index d71d104441bd..faee11383cb7 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1578,7 +1578,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	s5k6aa->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
-	ret = media_entity_init(&sd->entity, 1, &s5k6aa->pad);
+	ret = media_entity_pads_init(&sd->entity, 1, &s5k6aa->pad);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3eaa69ee341b..a215efe7a8ba 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2487,11 +2487,11 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 		if (!last)
 			continue;
 
-		rval = media_entity_init(&this->sd.entity,
+		rval = media_entity_pads_init(&this->sd.entity,
 					 this->npads, this->pads);
 		if (rval) {
 			dev_err(&client->dev,
-				"media_entity_init failed\n");
+				"media_entity_pads_init failed\n");
 			return rval;
 		}
 
@@ -3077,7 +3077,7 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-	rval = media_entity_init(&sensor->src->sd.entity, 2,
+	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
 	if (rval < 0)
 		return rval;
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 78e5b644d400..3397eb99c67b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1889,7 +1889,7 @@ static int tc358743_probe(struct i2c_client *client,
 	}
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
-	err = media_entity_init(&sd->entity, 1, &state->pad);
+	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err < 0)
 		goto err_hdl;
 
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 455dd4e6a1da..7fa5f1e4fe37 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1097,7 +1097,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	decoder->sd.entity.flags |= MEDIA_ENT_F_ATV_DECODER;
 
-	ret = media_entity_init(&decoder->sd.entity, 1, &decoder->pad);
+	ret = media_entity_pads_init(&decoder->sd.entity, 1, &decoder->pad);
 	if (ret < 0) {
 		v4l2_err(sd, "%s decoder driver failed to register !!\n",
 			 sd->name);
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 216a07956fe9..83c79fa5f61d 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -1014,7 +1014,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	device->sd.entity.flags |= MEDIA_ENT_F_ATV_DECODER;
 
-	error = media_entity_init(&device->sd.entity, 1, &device->pad);
+	error = media_entity_pads_init(&device->sd.entity, 1, &device->pad);
 	if (error < 0)
 		return error;
 #endif
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 14bd568e2f41..b8cd7733a31c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -623,6 +623,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	WARN_ON(entity->graph_obj.mdev != NULL);
 	entity->graph_obj.mdev = mdev;
 	INIT_LIST_HEAD(&entity->links);
+	entity->num_links = 0;
+	entity->num_backlinks = 0;
 
 	spin_lock(&mdev->lock);
 	/* Initialize media_gobj embedded at the entity */
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 07f2dc6c2df6..ef2102ac0c66 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -197,7 +197,7 @@ void media_gobj_remove(struct media_gobj *gobj)
 }
 
 /**
- * media_entity_init - Initialize a media entity
+ * media_entity_pads_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
  * @pads: Array of 'num_pads' pads.
@@ -216,18 +216,15 @@ void media_gobj_remove(struct media_gobj *gobj)
  * number of allocated elements.
  *
  * The pads array is managed by the entity driver and passed to
- * media_entity_init() where its pointer will be stored in the entity structure.
+ * media_entity_pads_init() where its pointer will be stored in the entity structure.
  */
 int
-media_entity_init(struct media_entity *entity, u16 num_pads,
+media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 		  struct media_pad *pads)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int i;
 
-	entity->group_id = 0;
-	entity->num_links = 0;
-	entity->num_backlinks = 0;
 	entity->num_pads = num_pads;
 	entity->pads = pads;
 
@@ -247,7 +244,7 @@ media_entity_init(struct media_entity *entity, u16 num_pads,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(media_entity_init);
+EXPORT_SYMBOL_GPL(media_entity_pads_init);
 
 void
 media_entity_cleanup(struct media_entity *entity)
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 45745fd16271..7518c36f9ff7 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1800,7 +1800,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vid_cap->wb_fmt.code = fmt->mbus_code;
 
 	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad);
+	ret = media_entity_pads_init(&vfd->entity, 1, &vid_cap->vd_pad);
 	if (ret)
 		goto err_free_ctx;
 
@@ -1892,7 +1892,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_CAM].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK_FIFO].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+	ret = media_entity_pads_init(&sd->entity, FIMC_SD_PADS_NUM,
 				fimc->vid_cap.sd_pads);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 17e9d66cdaf6..be150e7c2241 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -619,7 +619,7 @@ int fimc_isp_video_device_register(struct fimc_isp *isp,
 	vdev->lock = &isp->video_lock;
 
 	iv->pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vdev->entity, 1, &iv->pad);
+	ret = media_entity_pads_init(&vdev->entity, 1, &iv->pad);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index f52eebf765c1..293b807020c4 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -708,7 +708,7 @@ int fimc_isp_subdev_create(struct fimc_isp *isp)
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
 	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FIMC_ISP_SD_PADS_NUM,
+	ret = media_entity_pads_init(&sd->entity, FIMC_ISP_SD_PADS_NUM,
 				isp->subdev_pads);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 2e043cb3776e..2a00a12963ec 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1317,7 +1317,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 		return ret;
 
 	fimc->vd_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vfd->entity, 1, &fimc->vd_pad);
+	ret = media_entity_pads_init(&vfd->entity, 1, &fimc->vd_pad);
 	if (ret < 0)
 		return ret;
 
@@ -1431,7 +1431,7 @@ static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
 	fimc->subdev_pads[FLITE_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	fimc->subdev_pads[FLITE_SD_PAD_SOURCE_DMA].flags = MEDIA_PAD_FL_SOURCE;
 	fimc->subdev_pads[FLITE_SD_PAD_SOURCE_ISP].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&sd->entity, FLITE_SD_PADS_NUM,
+	ret = media_entity_pads_init(&sd->entity, FLITE_SD_PADS_NUM,
 				fimc->subdev_pads);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 777b510991b6..af4372a4bb71 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -739,7 +739,7 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 		return PTR_ERR(fimc->m2m.m2m_dev);
 	}
 
-	ret = media_entity_init(&vfd->entity, 0, NULL);
+	ret = media_entity_pads_init(&vfd->entity, 0, NULL);
 	if (ret)
 		goto err_me;
 
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 8847797b0d0b..ac5e50e595be 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -866,7 +866,7 @@ static int s5pcsis_probe(struct platform_device *pdev)
 
 	state->pads[CSIS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	state->pads[CSIS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
-	ret = media_entity_init(&state->sd.entity,
+	ret = media_entity_pads_init(&state->sd.entity,
 				CSIS_PADS_NUM, state->pads);
 	if (ret < 0)
 		goto e_clkdis;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index f0e530c98188..dae674cd3f74 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2655,7 +2655,7 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 	pads[CCDC_PAD_SOURCE_OF].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &ccdc_media_ops;
-	ret = media_entity_init(me, CCDC_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, CCDC_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ae3038e643cc..0c790b25f6f9 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1076,7 +1076,7 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 	pads[CCP2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &ccp2_media_ops;
-	ret = media_entity_init(me, CCP2_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, CCP2_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index b1617f7efdee..f50f6b305204 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1250,7 +1250,7 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
 				    | MEDIA_PAD_FL_MUST_CONNECT;
 
 	me->ops = &csi2_media_ops;
-	ret = media_entity_init(me, CSI2_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, CSI2_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index cfb2debb02bf..c300cb7219e9 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2287,7 +2287,7 @@ static int preview_init_entities(struct isp_prev_device *prev)
 	pads[PREV_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &preview_media_ops;
-	ret = media_entity_init(me, PREV_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, PREV_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index e3ecf1787fc4..cd0a9f6e1fed 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1733,7 +1733,7 @@ static int resizer_init_entities(struct isp_res_device *res)
 	pads[RESZ_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &resizer_media_ops;
-	ret = media_entity_init(me, RESZ_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, RESZ_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index f7a5eee9f11d..1b9217d3b1b6 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1028,7 +1028,7 @@ static int isp_stat_init_entities(struct ispstat *stat, const char *name,
 	stat->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
 	me->ops = NULL;
 
-	return media_entity_init(me, 1, &stat->pad);
+	return media_entity_pads_init(me, 1, &stat->pad);
 }
 
 int omap3isp_stat_init(struct ispstat *stat, const char *name,
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 0d6bc70eba44..a631228c2750 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1369,7 +1369,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	if (IS_ERR(video->alloc_ctx))
 		return PTR_ERR(video->alloc_ctx);
 
-	ret = media_entity_init(&video->video.entity, 1, &video->pad);
+	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
 	if (ret < 0) {
 		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 		return ret;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index c12ff728cb05..78de2c466a4e 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1155,7 +1155,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 		goto err_vd_rel;
 
 	vp->pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&vfd->entity, 1, &vp->pad);
+	ret = media_entity_pads_init(&vfd->entity, 1, &vp->pad);
 	if (ret)
 		goto err_vd_rel;
 
@@ -1570,7 +1570,7 @@ int s3c_camif_create_subdev(struct camif_dev *camif)
 	camif->pads[CAMIF_SD_PAD_SOURCE_C].flags = MEDIA_PAD_FL_SOURCE;
 	camif->pads[CAMIF_SD_PAD_SOURCE_P].flags = MEDIA_PAD_FL_SOURCE;
 
-	ret = media_entity_init(&sd->entity, CAMIF_SD_PADS_NUM,
+	ret = media_entity_pads_init(&sd->entity, CAMIF_SD_PADS_NUM,
 				camif->pads);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 619942ff2058..d7308530952f 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -219,7 +219,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
 
 	/* Initialize the media entity. */
-	return media_entity_init(&entity->subdev.entity, num_pads,
+	return media_entity_pads_init(&entity->subdev.entity, num_pads,
 				 entity->pads);
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 8131e65517d7..43f98eeaebce 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1223,7 +1223,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
 	video->pipe.state = VSP1_PIPELINE_STOPPED;
 
 	/* Initialize the media entity... */
-	ret = media_entity_init(&video->video.entity, 1, &video->pad);
+	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 06eb74344507..33d2fe5fd45e 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -677,7 +677,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
 		       ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
-	ret = media_entity_init(&dma->video.entity, 1, &dma->pad);
+	ret = media_entity_pads_init(&dma->video.entity, 1, &dma->pad);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c b/drivers/media/platform/xilinx/xilinx-tpg.c
index c09ca513a9dc..2ec1f6c4b274 100644
--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -838,7 +838,7 @@ static int xtpg_probe(struct platform_device *pdev)
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	subdev->entity.ops = &xtpg_media_ops;
 
-	ret = media_entity_init(&subdev->entity, xtpg->npads, xtpg->pads);
+	ret = media_entity_pads_init(&subdev->entity, xtpg->npads, xtpg->pads);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 150824fe382a..3ea9d4f13797 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1814,12 +1814,12 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
 
 	/* Initialize Video and VBI pads */
 	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad);
+	ret = media_entity_pads_init(&dev->vdev.entity, 1, &dev->video_pad);
 	if (ret < 0)
 		pr_err("failed to initialize video media entity!\n");
 
 	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
+	ret = media_entity_pads_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
 	if (ret < 0)
 		pr_err("failed to initialize vbi media entity!\n");
 
@@ -1851,7 +1851,7 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
 			break;
 		}
 
-		ret = media_entity_init(ent, 1, &dev->input_pad[i]);
+		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
 		if (ret < 0)
 			pr_err("failed to initialize input pad[%d]!\n", i);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 86c9cbd02016..9ea5a9e60a70 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2174,7 +2174,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	cx231xx_vdev_init(dev, &dev->vdev, &cx231xx_video_template, "video");
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vdev.entity, 1, &dev->video_pad);
+	ret = media_entity_pads_init(&dev->vdev.entity, 1, &dev->video_pad);
 	if (ret < 0)
 		dev_err(dev->dev, "failed to initialize video media entity!\n");
 #endif
@@ -2201,7 +2201,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
-	ret = media_entity_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
+	ret = media_entity_pads_init(&dev->vbi_dev.entity, 1, &dev->vbi_pad);
 	if (ret < 0)
 		dev_err(dev->dev, "failed to initialize vbi media entity!\n");
 #endif
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 7f82b65b238e..38e893a1408b 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -94,10 +94,10 @@ static int uvc_mc_init_entity(struct uvc_entity *entity)
 		strlcpy(entity->subdev.name, entity->name,
 			sizeof(entity->subdev.name));
 
-		ret = media_entity_init(&entity->subdev.entity,
+		ret = media_entity_pads_init(&entity->subdev.entity,
 					entity->num_pads, entity->pads);
 	} else if (entity->vdev != NULL) {
-		ret = media_entity_init(&entity->vdev->entity,
+		ret = media_entity_pads_init(&entity->vdev->entity,
 					entity->num_pads, entity->pads);
 		if (entity->flags & UVC_ENTITY_FLAG_DEFAULT)
 			entity->vdev->entity.flags |= MEDIA_ENT_FL_DEFAULT;
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 05fc4df61b85..76496fd282aa 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -701,7 +701,7 @@ register_client:
 	t->sd.entity.function = MEDIA_ENT_F_TUNER;
 	t->sd.entity.name = t->name;
 
-	ret = media_entity_init(&t->sd.entity, TUNER_NUM_PADS, &t->pad[0]);
+	ret = media_entity_pads_init(&t->sd.entity, TUNER_NUM_PADS, &t->pad[0]);
 	if (ret < 0) {
 		tuner_err("failed to initialize media entity!\n");
 		kfree(t);
diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 5c686a24712b..13d5a36bc5d8 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -651,7 +651,7 @@ struct v4l2_flash *v4l2_flash_init(
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	strlcpy(sd->name, config->dev_name, sizeof(sd->name));
 
-	ret = media_entity_init(&sd->entity, 0, NULL);
+	ret = media_entity_pads_init(&sd->entity, 0, NULL);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 77837afab0ce..ac78ed2f8bcc 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1843,7 +1843,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	v4l2_ctrl_handler_setup(&ipipe->ctrls);
 	sd->ctrl_handler = &ipipe->ctrls;
 
-	return media_entity_init(me, IPIPE_PADS_NUM, pads);
+	return media_entity_pads_init(me, IPIPE_PADS_NUM, pads);
 }
 
 /*
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index b66584ecb693..a54c60fce3d5 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -1031,7 +1031,7 @@ int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
 	ipipeif->output = IPIPEIF_OUTPUT_NONE;
 	me->ops = &ipipeif_media_ops;
 
-	ret = media_entity_init(me, IPIPEIF_NUM_PADS, pads);
+	ret = media_entity_pads_init(me, IPIPEIF_NUM_PADS, pads);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 8ca0c1297ec8..b35667afb73f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -2057,7 +2057,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 	isif->input = ISIF_INPUT_NONE;
 	isif->output = ISIF_OUTPUT_NONE;
 	me->ops = &isif_media_ops;
-	status = media_entity_init(me, ISIF_PADS_NUM, pads);
+	status = media_entity_pads_init(me, ISIF_PADS_NUM, pads);
 	if (status)
 		goto isif_fail;
 	isif->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index ba887efd226a..669ae3f9791f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1915,7 +1915,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	vpfe_rsz->crop_resizer.output2 = RESIZER_CROP_OUTPUT_NONE;
 	vpfe_rsz->crop_resizer.rsz_device = vpfe_rsz;
 	me->ops = &resizer_media_ops;
-	ret = media_entity_init(me, RESIZER_CROP_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, RESIZER_CROP_PADS_NUM, pads);
 	if (ret)
 		return ret;
 
@@ -1937,7 +1937,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	vpfe_rsz->resizer_a.output = RESIZER_OUTPUT_NONE;
 	vpfe_rsz->resizer_a.rsz_device = vpfe_rsz;
 	me->ops = &resizer_media_ops;
-	ret = media_entity_init(me, RESIZER_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, RESIZER_PADS_NUM, pads);
 	if (ret)
 		return ret;
 
@@ -1959,7 +1959,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	vpfe_rsz->resizer_b.output = RESIZER_OUTPUT_NONE;
 	vpfe_rsz->resizer_b.rsz_device = vpfe_rsz;
 	me->ops = &resizer_media_ops;
-	ret = media_entity_init(me, RESIZER_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, RESIZER_PADS_NUM, pads);
 	if (ret)
 		return ret;
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index a1fafddd671e..25ba878f06ad 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1599,7 +1599,7 @@ int vpfe_video_init(struct vpfe_video_device *video, const char *name)
 	spin_lock_init(&video->irqlock);
 	spin_lock_init(&video->dma_queue_lock);
 	mutex_init(&video->lock);
-	ret = media_entity_init(&video->video_dev.entity,
+	ret = media_entity_pads_init(&video->video_dev.entity,
 				1, &video->pad);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 2b9a36cd8fa8..226366a03661 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1276,7 +1276,7 @@ static int csi2_init_entities(struct iss_csi2_device *csi2, const char *subname)
 	pads[CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 
 	me->ops = &csi2_media_ops;
-	ret = media_entity_init(me, CSI2_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, CSI2_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index dd9d7d54e6f8..d38782e8e84c 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -516,7 +516,7 @@ static int ipipe_init_entities(struct iss_ipipe_device *ipipe)
 	pads[IPIPE_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &ipipe_media_ops;
-	ret = media_entity_init(me, IPIPE_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, IPIPE_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 8cbb9840a989..c2b5638a0898 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -748,7 +748,7 @@ static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
 	pads[IPIPEIF_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &ipipeif_media_ops;
-	ret = media_entity_init(me, IPIPEIF_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, IPIPEIF_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index a3925ecd0ed7..fea13ab4041f 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -790,7 +790,7 @@ static int resizer_init_entities(struct iss_resizer_device *resizer)
 	pads[RESIZER_PAD_SOURCE_MEM].flags = MEDIA_PAD_FL_SOURCE;
 
 	me->ops = &resizer_media_ops;
-	ret = media_entity_init(me, RESIZER_PADS_NUM, pads);
+	ret = media_entity_pads_init(me, RESIZER_PADS_NUM, pads);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 0eb6eac8debf..ac73065ae56f 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1102,7 +1102,7 @@ int omap4iss_video_init(struct iss_video *video, const char *name)
 		return -EINVAL;
 	}
 
-	ret = media_entity_init(&video->video.entity, 1, &video->pad);
+	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cd3f3a77df2d..32fef503d950 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -347,7 +347,7 @@ void media_gobj_init(struct media_device *mdev,
 		    struct media_gobj *gobj);
 void media_gobj_remove(struct media_gobj *gobj);
 
-int media_entity_init(struct media_entity *entity, u16 num_pads,
+int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 		      struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
 
-- 
2.5.0


