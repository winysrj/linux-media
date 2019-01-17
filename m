Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E93C43614
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7052E20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfAQQSJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:18:09 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50250 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbfAQQSI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:18:08 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kAMkgeAhPNR5ykAMngTv1R; Thu, 17 Jan 2019 17:18:05 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 8/8] soc_camera_platform: remove obsolete soc_camera test driver
Date:   Thu, 17 Jan 2019 17:18:02 +0100
Message-Id: <20190117161802.5740-9-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNXVrFOTWLJKQxd/CmlGj4OfRj1lc0E0SZWeAKQVbsOP5Be0+ePytfdnAu94IDQqeF2rm5ofTyfB53f7u0nnqFiSPZcf1qK1DH7C2W2mlVbwoek6SAcy
 HeLx4ckB8FZP/w0OMW3/pS7oIqhdHjoS8FsgbEY5b3pqytVq9jucFtM82tXxQ5YaK26w9IXkNBuy69ApCieWIqjVjAcdGSAlzkL2QqGfr9DhEOf4IyZLqTlX
 5/Alh2c7N/4Xp0p4cZ2nf999H0CQgW3ZW1fzRQQtwlgcKEalOQxmTksyfjjvefltSPSYLCtPxcgdLNy0GYchPLOwwZ/iLRkhG2Ycmt0NXlVSZdeNiH21qiLY
 DEIhc2rbLbdmgyPPUQy9GsDumMipYQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This is a test stub driver for soc_camera. Since soc_camera is
being deprecated (and in fact, nobody is using it anymore)
there's no sense in keeping this test driver.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/soc_camera/Kconfig     |   6 -
 drivers/media/platform/soc_camera/Makefile    |   4 -
 .../platform/soc_camera/soc_camera_platform.c | 188 ------------------
 .../platform_data/media/soc_camera_platform.h |  83 --------
 4 files changed, 281 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/soc_camera_platform.c
 delete mode 100644 include/linux/platform_data/media/soc_camera_platform.h

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index d471d34b884c..8f9b3bac5450 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -6,9 +6,3 @@ config SOC_CAMERA
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
 	  directly to the data bus of an SoC.
-
-config SOC_CAMERA_PLATFORM
-	tristate "platform camera support"
-	depends on SOC_CAMERA
-	help
-	  This is a generic SoC camera platform driver, useful for testing
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 2cb7022e073b..85d5e74f3b2b 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -1,5 +1 @@
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
-
-# a platform subdevice driver stub, allowing to support cameras by adding a
-# couple of callback functions to the board code
-obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
deleted file mode 100644
index 79fbe1fea95f..000000000000
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ /dev/null
@@ -1,188 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Generic Platform Camera Driver
- *
- * Copyright (C) 2008 Magnus Damm
- * Based on mt9m001 driver,
- * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/platform_device.h>
-#include <linux/videodev2.h>
-#include <media/v4l2-subdev.h>
-#include <media/soc_camera.h>
-#include <linux/platform_data/media/soc_camera_platform.h>
-
-struct soc_camera_platform_priv {
-	struct v4l2_subdev subdev;
-};
-
-static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
-{
-	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
-	return container_of(subdev, struct soc_camera_platform_priv, subdev);
-}
-
-static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-	return p->set_capture(p, enable);
-}
-
-static int soc_camera_platform_fill_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-	struct v4l2_mbus_framefmt *mf = &format->format;
-
-	mf->width	= p->format.width;
-	mf->height	= p->format.height;
-	mf->code	= p->format.code;
-	mf->colorspace	= p->format.colorspace;
-	mf->field	= p->format.field;
-
-	return 0;
-}
-
-static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-
-	return soc_camera_set_power(p->icd->control, &p->icd->sdesc->subdev_desc, NULL, on);
-}
-
-static const struct v4l2_subdev_core_ops platform_subdev_core_ops = {
-	.s_power = soc_camera_platform_s_power,
-};
-
-static int soc_camera_platform_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-
-	if (code->pad || code->index)
-		return -EINVAL;
-
-	code->code = p->format.code;
-	return 0;
-}
-
-static int soc_camera_platform_get_selection(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_selection *sel)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-
-	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-		return -EINVAL;
-
-	switch (sel->target) {
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_CROP:
-		sel->r.left = 0;
-		sel->r.top = 0;
-		sel->r.width = p->format.width;
-		sel->r.height = p->format.height;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
-static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
-					     struct v4l2_mbus_config *cfg)
-{
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
-
-	cfg->flags = p->mbus_param;
-	cfg->type = p->mbus_type;
-
-	return 0;
-}
-
-static const struct v4l2_subdev_video_ops platform_subdev_video_ops = {
-	.s_stream	= soc_camera_platform_s_stream,
-	.g_mbus_config	= soc_camera_platform_g_mbus_config,
-};
-
-static const struct v4l2_subdev_pad_ops platform_subdev_pad_ops = {
-	.enum_mbus_code = soc_camera_platform_enum_mbus_code,
-	.get_selection	= soc_camera_platform_get_selection,
-	.get_fmt	= soc_camera_platform_fill_fmt,
-	.set_fmt	= soc_camera_platform_fill_fmt,
-};
-
-static const struct v4l2_subdev_ops platform_subdev_ops = {
-	.core	= &platform_subdev_core_ops,
-	.video	= &platform_subdev_video_ops,
-	.pad	= &platform_subdev_pad_ops,
-};
-
-static int soc_camera_platform_probe(struct platform_device *pdev)
-{
-	struct soc_camera_host *ici;
-	struct soc_camera_platform_priv *priv;
-	struct soc_camera_platform_info *p = pdev->dev.platform_data;
-	struct soc_camera_device *icd;
-
-	if (!p)
-		return -EINVAL;
-
-	if (!p->icd) {
-		dev_err(&pdev->dev,
-			"Platform has not set soc_camera_device pointer!\n");
-		return -EINVAL;
-	}
-
-	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	icd = p->icd;
-
-	/* soc-camera convention: control's drvdata points to the subdev */
-	platform_set_drvdata(pdev, &priv->subdev);
-	/* Set the control device reference */
-	icd->control = &pdev->dev;
-
-	ici = to_soc_camera_host(icd->parent);
-
-	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
-	v4l2_set_subdevdata(&priv->subdev, p);
-	strscpy(priv->subdev.name, dev_name(&pdev->dev),
-		sizeof(priv->subdev.name));
-
-	return v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
-}
-
-static int soc_camera_platform_remove(struct platform_device *pdev)
-{
-	struct soc_camera_platform_priv *priv = get_priv(pdev);
-	struct soc_camera_platform_info *p = v4l2_get_subdevdata(&priv->subdev);
-
-	p->icd->control = NULL;
-	v4l2_device_unregister_subdev(&priv->subdev);
-	return 0;
-}
-
-static struct platform_driver soc_camera_platform_driver = {
-	.driver		= {
-		.name	= "soc_camera_platform",
-	},
-	.probe		= soc_camera_platform_probe,
-	.remove		= soc_camera_platform_remove,
-};
-
-module_platform_driver(soc_camera_platform_driver);
-
-MODULE_DESCRIPTION("SoC Camera Platform driver");
-MODULE_AUTHOR("Magnus Damm");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:soc_camera_platform");
diff --git a/include/linux/platform_data/media/soc_camera_platform.h b/include/linux/platform_data/media/soc_camera_platform.h
deleted file mode 100644
index 1e5065dab430..000000000000
--- a/include/linux/platform_data/media/soc_camera_platform.h
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Generic Platform Camera Driver Header
- *
- * Copyright (C) 2008 Magnus Damm
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __SOC_CAMERA_H__
-#define __SOC_CAMERA_H__
-
-#include <linux/videodev2.h>
-#include <media/soc_camera.h>
-#include <media/v4l2-mediabus.h>
-
-struct device;
-
-struct soc_camera_platform_info {
-	const char *format_name;
-	unsigned long format_depth;
-	struct v4l2_mbus_framefmt format;
-	unsigned long mbus_param;
-	enum v4l2_mbus_type mbus_type;
-	struct soc_camera_device *icd;
-	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
-};
-
-static inline void soc_camera_platform_release(struct platform_device **pdev)
-{
-	*pdev = NULL;
-}
-
-static inline int soc_camera_platform_add(struct soc_camera_device *icd,
-					  struct platform_device **pdev,
-					  struct soc_camera_link *plink,
-					  void (*release)(struct device *dev),
-					  int id)
-{
-	struct soc_camera_subdev_desc *ssdd =
-		(struct soc_camera_subdev_desc *)plink;
-	struct soc_camera_platform_info *info = ssdd->drv_priv;
-	int ret;
-
-	if (&icd->sdesc->subdev_desc != ssdd)
-		return -ENODEV;
-
-	if (*pdev)
-		return -EBUSY;
-
-	*pdev = platform_device_alloc("soc_camera_platform", id);
-	if (!*pdev)
-		return -ENOMEM;
-
-	info->icd = icd;
-
-	(*pdev)->dev.platform_data = info;
-	(*pdev)->dev.release = release;
-
-	ret = platform_device_add(*pdev);
-	if (ret < 0) {
-		platform_device_put(*pdev);
-		*pdev = NULL;
-		info->icd = NULL;
-	}
-
-	return ret;
-}
-
-static inline void soc_camera_platform_del(const struct soc_camera_device *icd,
-					   struct platform_device *pdev,
-					   const struct soc_camera_link *plink)
-{
-	const struct soc_camera_subdev_desc *ssdd =
-		(const struct soc_camera_subdev_desc *)plink;
-	if (&icd->sdesc->subdev_desc != ssdd || !pdev)
-		return;
-
-	platform_device_unregister(pdev);
-}
-
-#endif /* __SOC_CAMERA_H__ */
-- 
2.20.1

