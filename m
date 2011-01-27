Return-path: <mchehab@pedra>
Received: from mailmxout5.mailmx.agnat.pl ([193.239.44.251]:43873 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751216Ab1A0Qaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 11:30:55 -0500
Message-ID: <0473CEA9D0594657A1DB0F7E25A208D2@laptop2>
From: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <g.daniluk@elproma.com.pl>, <linux-media@vger.kernel.org>
References: <1E539FC23CF84B8A91428720570395E0@laptop2> <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2> <Pine.LNX.4.64.1101262045550.3989@axis700.grange>
Subject: Re: SoC Camera driver and TV decoder
Date: Thu, 27 Jan 2011 17:21:30 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi again.

I patched tvp5150.c according to tw9910 driver (without real cropping 
support yet).
Unfortunately I got the messages:
camera 0-0: Probing 0-0
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
tvp5150 0-005d: chip found @ 0xba (i2c-sh_mobile)
tvp5150 0-005d: tvp5150am1 detected.
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 
0
camera: probe of 0-0 failed with error -515

I have also found 2 patches here http://www.sleepyrobot.com/?cat=3 but it 
does not support soc camera also.

kind regards
Janusz

my "copy-paste" patch:
--- tvp5150.c.orig      2011-01-27 08:56:34.454572019 +0100
+++ tvp5150.c   2011-01-27 17:04:38.786072092 +0100
@@ -2,6 +2,7 @@
  * tvp5150 - Texas Instruments TVP5150A/AM1 video decoder driver
  *
  * Copyright (c) 2005,2006 Mauro Carvalho Chehab (mchehab@infradead.org)
+ * Copyright (c) 2011 Janusz Uzycki (j.uzycki@elproma.com.pl) - SoC camera 
API
  * This code is placed under the terms of the GNU General Public License v2
  */

@@ -13,6 +14,7 @@
 #include <media/tvp5150.h>
 #include <media/v4l2-i2c-drv.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/soc_camera.h>

 #include "tvp5150_reg.h"

@@ -25,6 +27,135 @@
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");

+struct tvp5150_scale_ctrl {
+       char           *name;
+       unsigned short  width;
+       unsigned short  height;
+       u16             hscale;
+       u16             vscale;
+};
+
+static const struct tvp5150_scale_ctrl tvp5150_ntsc_scales[] = {
+       {
+               .name   = "NTSC SQ",
+               .width  = 640,
+               .height = 480,
+               .hscale = 0x0100,
+               .vscale = 0x0100,
+       },
+       {
+               .name   = "NTSC CCIR601",
+               .width  = 720,
+               .height = 480,
+               .hscale = 0x0100,
+               .vscale = 0x0100,
+       },
+       {
+               .name   = "NTSC SQ (CIF)",
+               .width  = 320,
+               .height = 240,
+               .hscale = 0x0200,
+               .vscale = 0x0200,
+       },
+       {
+               .name   = "NTSC CCIR601 (CIF)",
+               .width  = 360,
+               .height = 240,
+               .hscale = 0x0200,
+               .vscale = 0x0200,
+       },
+       {
+               .name   = "NTSC SQ (QCIF)",
+               .width  = 160,
+               .height = 120,
+               .hscale = 0x0400,
+               .vscale = 0x0400,
+       },
+       {
+               .name   = "NTSC CCIR601 (QCIF)",
+               .width  = 180,
+               .height = 120,
+               .hscale = 0x0400,
+               .vscale = 0x0400,
+       },
+};
+
+static const struct tvp5150_scale_ctrl tvp5150_pal_scales[] = {
+       {
+               .name   = "PAL SQ",
+               .width  = 768,
+               .height = 576,
+               .hscale = 0x0100,
+               .vscale = 0x0100,
+       },
+       {
+               .name   = "PAL CCIR601",
+               .width  = 720,
+               .height = 576,
+               .hscale = 0x0100,
+               .vscale = 0x0100,
+       },
+       {
+               .name   = "PAL SQ (CIF)",
+               .width  = 384,
+               .height = 288,
+               .hscale = 0x0200,
+               .vscale = 0x0200,
+       },
+       {
+               .name   = "PAL CCIR601 (CIF)",
+               .width  = 360,
+               .height = 288,
+               .hscale = 0x0200,
+               .vscale = 0x0200,
+       },
+       {
+               .name   = "PAL SQ (QCIF)",
+               .width  = 192,
+               .height = 144,
+               .hscale = 0x0400,
+               .vscale = 0x0400,
+       },
+       {
+               .name   = "PAL CCIR601 (QCIF)",
+               .width  = 180,
+               .height = 144,
+               .hscale = 0x0400,
+               .vscale = 0x0400,
+       },
+};
+
+static const struct tvp5150_scale_ctrl*
+tvp5150_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
+{
+       const struct tvp5150_scale_ctrl *scale;
+       const struct tvp5150_scale_ctrl *ret = NULL;
+       v4l2_std_id norm = icd->vdev->current_norm;
+       __u32 diff = 0xffffffff, tmp;
+       int size, i;
+
+       if (norm & V4L2_STD_NTSC) {
+               scale = tvp5150_ntsc_scales;
+               size = ARRAY_SIZE(tvp5150_ntsc_scales);
+       } else if (norm & V4L2_STD_PAL) {
+               scale = tvp5150_pal_scales;
+               size = ARRAY_SIZE(tvp5150_pal_scales);
+       } else {
+               return NULL;
+       }
+
+       for (i = 0; i < size; i++) {
+               tmp = abs(width - scale[i].width) +
+                       abs(height - scale[i].height);
+               if (tmp < diff) {
+                       diff = tmp;
+                       ret = scale + i;
+               }
+       }
+
+       return ret;
+}
+
 /* supported controls */
 static struct v4l2_queryctrl tvp5150_qctrl[] = {
        {
@@ -1016,6 +1147,194 @@

 /* -----------------------------------------------------------------------  
*/

+static int tvp5150_set_bus_param(struct soc_camera_device *icd,
+                               unsigned long flags)
+{
+/*     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+       struct i2c_client *client = sd->priv;*/
+/*     u8 val = VSSL_VVALID | HSSL_DVALID;*/
+
+       /*
+        * set OUTCTR1
+        *
+        * We use VVALID and DVALID signals to control VSYNC and HSYNC
+        * outputs, in this mode their polarity is inverted.
+        */
+/*     if (flags & SOCAM_HSYNC_ACTIVE_LOW)
+               val |= HSP_HI;
+
+       if (flags & SOCAM_VSYNC_ACTIVE_LOW)
+               val |= VSP_HI;
+
+       return i2c_smbus_write_byte_data(client, OUTCTR1, val);
+*/
+       return 0;
+}
+
+static unsigned long tvp5150_query_bus_param(struct soc_camera_device *icd)
+{
+/*     struct i2c_client *client = 
to_i2c_client(to_soc_camera_control(icd));*/
+/*     struct tw9910_priv *priv = to_tw9910(client);*/
+       struct soc_camera_link *icl = to_soc_camera_link(icd);
+       unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+               SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
+       /*      SOCAM_VSYNC_ACTIVE_LOW  | SOCAM_HSYNC_ACTIVE_LOW  |*/
+               SOCAM_DATA_ACTIVE_HIGH |
+               SOCAM_DATAWIDTH_8; /*priv->info->buswidth*/
+
+       return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+static int tvp5150_enum_input(struct soc_camera_device *icd,
+                            struct v4l2_input *inp)
+{
+       inp->type = V4L2_INPUT_TYPE_TUNER;
+       inp->std  = V4L2_STD_UNKNOWN;
+       strcpy(inp->name, "Video");
+
+       return 0;
+}
+
+static struct soc_camera_ops tvp5150_soc_ops = {
+       .set_bus_param          = tvp5150_set_bus_param,
+       .query_bus_param        = tvp5150_query_bus_param,
+       .enum_input             = tvp5150_enum_input,
+};
+
+/* -----------------------------------------------------------------------  
*/
+
+static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
+{
+/*     struct i2c_client *client = sd->priv;*/
+
+       if (enable) {
+               tvp5150_reset(sd, 0);
+       } else {
+               tvp5150_write(sd, TVP5150_MISC_CTL, tvp5150_read(sd, 
TVP5150_MISC_CTL) & 0 );   /* 0x03 register, turn off outputs */
+               tvp5150_write(sd, TVP5150_INT_CONF, tvp5150_read(sd, 
TVP5150_INT_CONF) & 3 );   /* 0xC2 register, turn off output */
+               tvp5150_write(sd, TVP5150_OP_MODE_CTL, tvp5150_read(sd, 
TVP5150_OP_MODE_CTL) | 1 );     /* 0x02 register, power down */
+       }
+       return 0;
+}
+
+static int tvp5150_g_fmt(struct v4l2_subdev *sd,
+                       struct v4l2_mbus_framefmt *mf)
+{
+       const struct tvp5150_scale_ctrl *pscale;
+       struct i2c_client *client = sd->priv;
+       struct soc_camera_device *icd = client->dev.platform_data;
+/*     struct tw9910_priv *priv = to_tw9910(client);
+
+       if (!priv->scale) {
+               int ret;
+               struct v4l2_crop crop = {
+                       .c = {
+                               .left   = 0,
+                               .top    = 0,
+                               .width  = 640,
+                               .height = 480,
+                       },
+               };
+               ret = tw9910_s_crop(sd, &crop);
+               if (ret < 0)
+                       return ret;
+       }*/
+       pscale = tvp5150_select_norm(icd, 640, 480);
+       if (!pscale) return -EINVAL;
+
+       mf->width       = pscale->width;
+       mf->height      = pscale->height;
+       mf->code        = V4L2_MBUS_FMT_YUYV8_2X8_BE;
+       mf->colorspace  = V4L2_COLORSPACE_JPEG;
+       mf->field       = V4L2_FIELD_INTERLACED_BT;
+
+       return 0;
+}
+
+static int tvp5150_s_fmt(struct v4l2_subdev *sd,
+                       struct v4l2_mbus_framefmt *mf)
+{
+       const struct tvp5150_scale_ctrl *pscale;
+       struct i2c_client *client = sd->priv;
+       struct soc_camera_device *icd = client->dev.platform_data;
+/*     struct tw9910_priv *priv = to_tw9910(client);*/
+       /* See tw9910_s_crop() - no proper cropping support */
+       struct v4l2_crop a = {
+               .c = {
+                       .left   = 0,
+                       .top    = 0,
+                       .width  = mf->width,
+                       .height = mf->height,
+               },
+       };
+       int ret = 0;
+
+       WARN_ON(mf->field != V4L2_FIELD_ANY &&
+               mf->field != V4L2_FIELD_INTERLACED_BT);
+
+       /*
+        * check color format
+        */
+       if (mf->code != V4L2_MBUS_FMT_YUYV8_2X8_BE)
+               return -EINVAL;
+
+       mf->colorspace = V4L2_COLORSPACE_JPEG;
+/*
+       ret = tw9910_s_crop(sd, &a);
+       if (!ret) {
+               mf->width       = priv->scale->width;
+               mf->height      = priv->scale->height;
+       }*/
+       pscale = tvp5150_select_norm(icd, a.c.width, a.c.height);
+       if (!pscale) {
+               mf->width       = pscale->width;
+               mf->height      = pscale->height;
+       }
+       return ret;
+}
+
+static int tvp5150_try_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_mbus_framefmt *mf)
+{
+       struct i2c_client *client = sd->priv;
+       struct soc_camera_device *icd = client->dev.platform_data;
+       const struct tvp5150_scale_ctrl *pscale;
+
+       if (V4L2_FIELD_ANY == mf->field) {
+               mf->field = V4L2_FIELD_INTERLACED_BT;
+       } else if (V4L2_FIELD_INTERLACED_BT != mf->field) {
+               dev_err(&client->dev, "Field type %d invalid.\n", 
mf->field);
+               return -EINVAL;
+       }
+
+       mf->code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
+       mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+       /*
+        * select suitable norm
+        */
+       pscale = tvp5150_select_norm(icd, mf->width, mf->height);
+       if (!pscale)
+               return -EINVAL;
+
+       mf->width       = pscale->width;
+       mf->height      = pscale->height;
+
+       return 0;
+}
+
+static int tvp5150_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+                          enum v4l2_mbus_pixelcode *code)
+{
+       if (index)
+               return -EINVAL;
+
+       *code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
+       return 0;
+}
+
+/* -----------------------------------------------------------------------  
*/
+
 static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
        .log_status = tvp5150_log_status,
        .g_ctrl = tvp5150_g_ctrl,
@@ -1036,6 +1355,16 @@

 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
        .s_routing = tvp5150_s_routing,
+
+       /* SoC camera: */
+       .s_stream       = tvp5150_s_stream,
+       .g_mbus_fmt     = tvp5150_g_fmt,
+       .s_mbus_fmt     = tvp5150_s_fmt,
+       .try_mbus_fmt   = tvp5150_try_fmt,
+       .enum_mbus_fmt  = tvp5150_enum_fmt,
+/*     .cropcap        = tw9910_cropcap,
+       .g_crop         = tw9910_g_crop,
+       .s_crop         = tw9910_s_crop,*/
 };

 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
@@ -1045,7 +1374,7 @@
        .s_raw_fmt = tvp5150_s_raw_fmt,
 };

-static const struct v4l2_subdev_ops tvp5150_ops = {
+static const struct v4l2_subdev_ops tvp5150_subdev_ops = {
        .core = &tvp5150_core_ops,
        .tuner = &tvp5150_tuner_ops,
        .video = &tvp5150_video_ops,
@@ -1056,12 +1385,68 @@
 /****************************************************************************                        I2C Client & Driver  ****************************************************************************/+static int tvp5150_video_probe(struct soc_camera_device *icd,+                             struct i2c_client *client,+                               struct v4l2_subdev *sd)+{+{+/*     struct tw9910_priv *priv = to_tw9910(client);*/+/*     s32 id;*/++       /*+        * We must have a parent by now. And it cannot be a wrong one.+        * So this entire test is completely redundant.+        */+       if (!icd->dev.parent ||+           to_soc_camera_host(icd->dev.parent)->nr != icd->iface)+               return -ENODEV;++       /*+        * tw9910 only use 8 or 16 bit bus width+        */+/*     if (SOCAM_DATAWIDTH_16 != priv->info->buswidth &&+           SOCAM_DATAWIDTH_8  != priv->info->buswidth) {+               dev_err(&client->dev, "bus width error\n");+               return -ENODEV;+       }*/++       /*+        * check and show Product ID+        * So far only revisions 0 and 1 have been seen+        */+       /*id = i2c_smbus_read_byte_data(client, ID);+       priv->revision = GET_REV(id);+       id = GET_ID(id);++       if (0x0B != id ||+           0x01 < priv->revision) {+               dev_err(&client->dev,+                       "Product ID error %x:%x\n",+                       id, priv->revision);+               return -ENODEV;+       }++       dev_info(&client->dev,+                "tw9910 Product ID %0x:%0x\n", id, priv->revision);+       */+       if (tvp5150_reset(sd, 0)) {     /*and/or tvp5150_g_chip_ident()*/+               dev_err(&client->dev,+                       "Reset error\n");+               return -ENODEV;+       }+       icd->vdev->tvnorms      = V4L2_STD_NTSC | V4L2_STD_PAL;+       icd->vdev->current_norm = V4L2_STD_NTSC;++       return 0;+} static int tvp5150_probe(struct i2c_client *c,                         const struct i2c_device_id *id) {        struct tvp5150 *core;        struct v4l2_subdev *sd;+       struct soc_camera_device       *icd = c->dev.platform_data;+       struct soc_camera_link         *icl;+       int                             ret;        /* Check if the adapter supports the needed features */        if (!i2c_check_functionality(c->adapter,@@ -1073,7 +1458,7 @@                return -ENOMEM;        }        sd = &core->sd;-       v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);+       v4l2_i2c_subdev_init(sd, c, &tvp5150_subdev_ops);        v4l_info(c, "chip found @ 0x%02x (%s)\n",                 c->addr << 1, c->adapter->name);@@ -1087,17 +1472,33 @@        if (debug > 1)                tvp5150_log_status(sd);++       if (icd) {                              /* attach SoC camera API */+               icl = to_soc_camera_link(icd);+               if (icl) {+                       /*icl->priv - platform data*/+                       icd->iface   = icl->bus_id;+                       icd->ops     = &tvp5150_soc_ops;+                       ret = tvp5150_video_probe(icd, c, sd);+                       if (ret) {+                               icd->ops = NULL;+                               return ret;+                       }+               }+       }        return 0; } static int tvp5150_remove(struct i2c_client *c) {        struct v4l2_subdev *sd = i2c_get_clientdata(c);+       struct soc_camera_device *icd = c->dev.platform_data;        v4l2_dbg(1, debug, sd,                "tvp5150.c: removing tvp5150 adapter on address 0x%x\n",                c->addr << 1);+       if (icd) icd->ops = NULL;               /* detach SoC camera API */        v4l2_device_unregister_subdev(sd);        kfree(to_tvp5150(sd));        return 0;----- Original Message -----From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>To: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>Cc: <g.daniluk@elproma.com.pl>Sent: Wednesday, January 26, 2011 8:47 PMSubject: Re: SoC Camera driver and TV decoder> On Wed, 26 Jan 2011, Janusz Uzycki wrote:>>> Thanks for the help. I found your post at>> http://www.spinics.net/lists/linux-media/msg16346.html and>>http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11493>> Do you remember some similar threads or guide? It will be better to read>> before to ask :)>> There have been a couple of threads with similar content, and no, there is> no guide.>> Regards> Guennadi>>>>> best regards>> Janusz Uzycki>> ELPROMA>>>> ----- Original Message ----- From: "Guennadi Liakhovetski">> <g.liakhovetski@gmx.de>>> To: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>>> Cc: <g.daniluk@elproma.com.pl>>> Sent: Monday, January 24, 2011 5:25 PM>> Subject: Re: SoC Camera driver and TV decoder>>>>>> > On Mon, 24 Jan 2011, Janusz Uzycki wrote:>> >>> > > Hello.>> > >>> > > We are developing a customized system based on Renesas SH7724 CPU. In>> > > dev.kit of that CPU video input (TV decoder) is powered by TW9910chip.>> > > Our customized board contains TVP5150 chip instead. Unfortunately>> > > SoC-camera driver supports SH-mobile host but not the our client.>> > > TVP5150 is supported in Linux kernel via default video decodersdriver>> > > but we weren't able to link SoC-camera and V4L2 driver of TVP5150 to>> > > work together. Both modules are loaded but /dev/video0 has notappeared.>> > > Could you point how to do it right? Does we need to rewrite TVP5150>> > > driver using TW9910 driver as template?>> >>> > Yes, you will have to adjust / extend the tvp5150.c driver to (also)work>> > with soc-camera. Unfortunately, the soc-camera framework is still not>> > completely compatible with the plain v4l2-subdev API. Yes, use any of>> > existing soc-camera sensor or tv-decoder drivers as an example. Theonly>> > soc-camera tv-decoder driver currently available, as you've correctly>> > recognised, is tw9910.>> >>> > With more detailed questions please CC the>> >>> > Linux Media Mailing List <linux-media@vger.kernel.org>>> >>> > mailing list.>> >>> > Thanks>> > Guennadi>> >>> > >>> > > Current our part for SoC in /arch/sh/boards/mach-ecovec24/setup.c is:>> > >>> > > static struct i2c_board_info i2c_camera[] = {>> > >         {>> > >                 I2C_BOARD_INFO("tvp5150", 0x5d),>> > >         },>> > > };>> > >>> > > static struct soc_camera_link tvp5150_link = {>> > >         .i2c_adapter_id = 0,>> > >         .bus_id         = 0,>> > >         .board_info     = &i2c_camera[0],>> > >          /*.priv           = &tw9910_info,*/            /* notsupported>> > > */>> > >          /*.power          = tw9910_power,*/        /* not supported*/>> > >         .module_name    = "tvp5150">> > > };>> > >>> > > static struct platform_device camera_devices[] = {>> > >         {>> > >                 .name   = "soc-camera-pdrv",>> > >                 .id     = 0,>> > >                 .dev    = {>> > >                         .platform_data = &tvp5150_link,>> > >                 },>> > >         },>> > > };>> > >>> > > kind regards>> > > Janusz Uzycki>> > > ELPROMA>> > >>> >>> > --->> > Guennadi Liakhovetski, Ph.D.>> > Freelance Open-Source Software Developer>> > http://www.open-technology.de/>> >>>>> ---> Guennadi Liakhovetski>
