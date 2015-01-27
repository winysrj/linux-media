Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43723 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA0CkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 21:40:08 -0500
Received: by mail-we0-f170.google.com with SMTP id w55so6988651wes.1
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 18:40:07 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 27 Jan 2015 10:40:07 +0800
Message-ID: <CAKwPUoyk=rsKGQNFoqxDHskRCm92nUTKSa90OFdqE-LuLHeejw@mail.gmail.com>
Subject: [PATCH] [media] V4L: soc-camera: add SPI device support
From: Kassey <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Li <kasseyl@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for spi interface sub device for soc_camera.

Signed-off-by: Kassey Li <kasseyl@nvidia.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |   51 ++++++++++++++++++++++++
 include/media/soc_camera.h                     |   11 +++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c
b/drivers/media/platform/soc_camera/soc_camera.c
index b3db51c..6db2d89 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1599,6 +1599,49 @@ static void scan_async_host(struct soc_camera_host *ici)
 #define soc_camera_i2c_free(icd)       do {} while (0)
 #define scan_async_host(ici)           do {} while (0)
 #endif
+static int soc_camera_init_spi(struct soc_camera_device *icd,
+               struct soc_camera_desc *sdesc)
+{
+       struct spi_device   *spi;
+       struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+       struct soc_camera_host_desc *shd = &sdesc->host_desc;
+       struct spi_master *spi_master =
+                       spi_busnum_to_master(shd->spi_bus_id);
+       struct v4l2_subdev *subdev;
+
+       if (!spi_master) {
+               dev_err(icd->pdev, "Cannot get spi master #%d. No driver?\n",
+                               shd->spi_bus_id);
+               goto espind;
+       }
+
+       shd->board_info_spi->platform_data = &sdesc->subdev_desc;
+
+       subdev = v4l2_spi_new_subdev(&ici->v4l2_dev, spi_master,
+                       shd->board_info_spi);
+       if (!subdev)
+               goto espind;
+
+       spi = v4l2_get_subdevdata(subdev);
+
+       /* Use to_i2c_client(dev) to recover the i2c client */
+       icd->control = &spi->dev;
+
+       return 0;
+espind:
+       return -ENODEV;
+}
+
+static void soc_camera_free_spi(struct soc_camera_device *icd) {
+       struct spi_device   *spi;
+       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+       spi = v4l2_get_subdevdata(sd);
+       icd->control = NULL;
+       v4l2_device_unregister_subdev(sd);
+       spi_unregister_device(spi);
+}

 #ifdef CONFIG_OF

@@ -1762,6 +1805,10 @@ static int soc_camera_probe(struct soc_camera_host *ici,
                ret = soc_camera_i2c_init(icd, sdesc);
                if (ret < 0 && ret != -EPROBE_DEFER)
                        goto eadd;
+       } else if (shd->board_info_spi) {
+               ret = soc_camera_init_spi(icd, sdesc);
+               if (ret < 0)
+                       goto eadd;
        } else if (!shd->add_device || !shd->del_device) {
                ret = -EINVAL;
                goto eadd;
@@ -1803,6 +1850,8 @@ static int soc_camera_probe(struct soc_camera_host *ici,
 efinish:
        if (shd->board_info) {
                soc_camera_i2c_free(icd);
+       } else if (shd->board_info_spi) {
+               soc_camera_free_spi(icd);
        } else {
                shd->del_device(icd);
                module_put(control->driver->owner);
@@ -1843,6 +1892,8 @@ static int soc_camera_remove(struct
soc_camera_device *icd)

        if (sdesc->host_desc.board_info) {
                soc_camera_i2c_free(icd);
+       } else if (sdesc->host_desc.board_info_spi) {
+               soc_camera_free_spi(icd);
        } else {
                struct device *dev = to_soc_camera_control(icd);
                struct device_driver *drv = dev ? dev->driver : NULL;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..6d495f8 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -180,6 +180,12 @@ struct soc_camera_host_desc {
        const char *module_name;

        /*
+        * Add SPI device support.
+        */
+       struct spi_board_info *board_info_spi;
+       int spi_bus_id;
+
+       /*
         * For non-I2C devices platform has to provide methods to add a device
         * to the system and to remove it
         */
@@ -243,6 +249,11 @@ struct soc_camera_link {
        int i2c_adapter_id;
        struct i2c_board_info *board_info;
        const char *module_name;
+       /*
+        * Add SPI device support.
+        */
+       struct spi_board_info *board_info_spi;
+       int spi_bus_id;

        /*
         * For non-I2C devices platform has to provide methods to add a device
--
1.7.9.5

-- 
Best regards
Kassey
