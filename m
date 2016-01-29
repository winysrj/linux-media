Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbcA2RNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 12:13:09 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 3/3] [media] mt9v011: add media controller support
Date: Fri, 29 Jan 2016 15:12:00 -0200
Message-Id: <7d2b22781e9fcb6134160f475b8fd253cc83376b.1454087508.git.mchehab@osg.samsung.com>
In-Reply-To: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
References: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
In-Reply-To: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
References: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a source pad and set the media controller type to the sensor.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/mt9v011.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index b9fea11d6b0b..9ed1b26b6549 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -50,6 +50,9 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct mt9v011 {
 	struct v4l2_subdev sd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler ctrls;
 	unsigned width, height;
 	unsigned xtal;
@@ -493,6 +496,9 @@ static int mt9v011_probe(struct i2c_client *c,
 	u16 version;
 	struct mt9v011 *core;
 	struct v4l2_subdev *sd;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+#endif
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -506,6 +512,15 @@ static int mt9v011_probe(struct i2c_client *c,
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &mt9v011_ops);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
+
+	ret = media_entity_pads_init(&sd->entity, 1, &core->pad);
+	if (ret < 0)
+		return ret;
+#endif
+
 	/* Check if the sensor is really a MT9V011 */
 	version = mt9v011_read(sd, R00_MT9V011_CHIP_VERSION);
 	if ((version != MT9V011_VERSION) &&
-- 
2.5.0

