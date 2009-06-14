Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:53774 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbZFNL2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 07:28:08 -0400
Date: Sun, 14 Jun 2009 14:22:25 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv7 6/9] FMTx: si4713: Add files to add radio interface
	for si4713
Message-ID: <20090614112225.GA6931@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-6-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-7-git-send-email-eduardo.valentin@nokia.com> <200906141314.07217.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906141314.07217.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 14, 2009 at 01:14:06PM +0200, ext Hans Verkuil wrote:
> On Friday 12 June 2009 19:30:37 Eduardo Valentin wrote:
> > This patch adds files which creates the radio interface
> > for si4713 FM transmitter (modulator) devices.
> >
> > In order to do the real access to device registers, this
> > driver uses the v4l2 subdev interface exported by si4713 i2c driver.
> >
> > Signed-off-by: "Eduardo Valentin <eduardo.valentin@nokia.com>"
> > ---
> >  linux/drivers/media/radio/radio-si4713.c |  325 ++++++++++++++++++++++++++++++
> >  linux/include/media/si4713.h             |   40 ++++
> >  2 files changed, 365 insertions(+), 0 deletions(-)
> >  create mode 100644 linux/drivers/media/radio/radio-si4713.c
> >  create mode 100644 linux/include/media/si4713.h
> >
> > diff --git a/linux/drivers/media/radio/radio-si4713.c b/linux/drivers/media/radio/radio-si4713.c
> > new file mode 100644
> > index 0000000..4c23120
> > --- /dev/null
> > +++ b/linux/drivers/media/radio/radio-si4713.c
> > @@ -0,0 +1,325 @@
> > +/*
> > + * drivers/media/radio/radio-si4713.c
> > + *
> > + * Platform Driver for Silicon Labs Si4713 FM Radio Transmitter:
> > + *
> > + * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
> > + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/version.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/i2c.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-common.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/si4713.h>
> > +
> > +/* Driver state struct */
> > +struct radio_si4713_device {
> > +     struct v4l2_device              v4l2_dev;
> > +     struct video_device             *radio_dev;
> > +};
> > +
> > +/* module parameters */
> > +static int radio_nr = -1;    /* radio device minor (-1 ==> auto assign) */
> > +
> > +/* radio_si4713_fops - file operations interface */
> > +static const struct v4l2_file_operations radio_si4713_fops = {
> > +     .owner          = THIS_MODULE,
> > +     .ioctl          = video_ioctl2,
> > +};
> > +
> > +/* Video4Linux Interface */
> > +static int radio_si4713_fill_audout(struct v4l2_audioout *vao)
> > +{
> > +     /* TODO: check presence of audio output */
> > +     memset(vao, 0, sizeof(*vao));
> 
> No need for memset, the v4l2 core has done that for you already.

Right. 

> 
> > +     strlcpy(vao->name, "FM Modulator Audio Out", 32);
> > +
> > +     return 0;
> > +}
> > +
> > +static int radio_si4713_enumaudout(struct file *file, void *priv,
> > +                                             struct v4l2_audioout *vao)
> > +{
> > +     return radio_si4713_fill_audout(vao);
> > +}
> > +
> > +static int radio_si4713_g_audout(struct file *file, void *priv,
> > +                                     struct v4l2_audioout *vao)
> > +{
> > +     int rval = radio_si4713_fill_audout(vao);
> > +
> > +     vao->index = 0;
> > +
> > +     return rval;
> > +}
> > +
> > +static int radio_si4713_s_audout(struct file *file, void *priv,
> > +                                     struct v4l2_audioout *vao)
> > +{
> > +     if (vao->index != 0)
> > +             return -EINVAL;
> > +
> > +     return radio_si4713_fill_audout(vao);
> 
> It is a write only ioctl, so you can just do this:
> 
>         return vao->index ? -EINVAL : 0;

Ok.

> 
> > +}
> > +
> > +/* radio_si4713_querycap - query device capabilities */
> > +static int radio_si4713_querycap(struct file *file, void *priv,
> > +                                     struct v4l2_capability *capability)
> > +{
> > +     struct radio_si4713_device *rsdev;
> > +
> > +     rsdev = video_get_drvdata(video_devdata(file));
> > +
> > +     strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
> > +     strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
> > +                             sizeof(capability->card));
> > +     capability->capabilities = V4L2_CAP_MODULATOR;
> > +
> > +     return 0;
> > +}
> > +
> > +/* radio_si4713_queryctrl - enumerate control items */
> > +static int radio_si4713_queryctrl(struct file *file, void *priv,
> > +                                             struct v4l2_queryctrl *qc)
> > +{
> > +
> 
> Unnecessary empty line.

Yes.

> 
> > +     /* Must be sorted from low to high control ID! */
> > +     static const u32 user_ctrls[] = {
> > +             V4L2_CID_USER_CLASS,
> > +             V4L2_CID_AUDIO_MUTE,
> > +             0
> > +     };
> > +
> > +     /* Must be sorted from low to high control ID! */
> > +     static const u32 fmtx_ctrls[] = {
> > +             V4L2_CID_FM_TX_CLASS,
> > +             V4L2_CID_RDS_ENABLED,
> > +             V4L2_CID_RDS_PI,
> > +             V4L2_CID_RDS_PTY,
> > +             V4L2_CID_RDS_PS_NAME,
> > +             V4L2_CID_RDS_RADIO_TEXT,
> > +             V4L2_CID_AUDIO_LIMITER_ENABLED,
> > +             V4L2_CID_AUDIO_LIMITER_RELEASE_TIME,
> > +             V4L2_CID_AUDIO_LIMITER_DEVIATION,
> > +             V4L2_CID_AUDIO_COMPRESSION_ENABLED,
> > +             V4L2_CID_AUDIO_COMPRESSION_GAIN,
> > +             V4L2_CID_AUDIO_COMPRESSION_THRESHOLD,
> > +             V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME,
> > +             V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME,
> > +             V4L2_CID_PILOT_TONE_ENABLED,
> > +             V4L2_CID_PILOT_TONE_DEVIATION,
> > +             V4L2_CID_PILOT_TONE_FREQUENCY,
> > +             V4L2_CID_PREEMPHASIS,
> > +             V4L2_CID_TUNE_POWER_LEVEL,
> > +             V4L2_CID_TUNE_ANTENNA_CAPACITOR,
> > +             0
> > +     };
> > +     static const u32 *ctrl_classes[] = {
> > +             user_ctrls,
> > +             fmtx_ctrls,
> > +             NULL
> > +     };
> > +     struct radio_si4713_device *rsdev;
> > +
> > +     rsdev = video_get_drvdata(video_devdata(file));
> > +
> > +     qc->id = v4l2_ctrl_next(ctrl_classes, qc->id);
> > +     if (qc->id == 0)
> > +             return -EINVAL;
> > +
> > +     if (qc->id == V4L2_CID_USER_CLASS || qc->id == V4L2_CID_FM_TX_CLASS)
> > +             return v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
> > +
> > +     return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, core,
> > +                                             queryctrl, qc);
> > +}
> > +
> > +/*
> > + * radio_si4713_template - Produce a v4l2 call back.
> > + * Can be used because we are just a wrapper for v4l2_sub_devs.
> > + */
> > +#define radio_si4713_template(type, callback, arg_type)                      \
> > +static int radio_si4713_##callback(struct file *file, void *p,               \
> > +                                                     arg_type a)     \
> > +{                                                                    \
> > +     struct radio_si4713_device *rsdev;                              \
> > +                                                                     \
> > +     rsdev = video_get_drvdata(video_devdata(file));                 \
> > +                                                                     \
> > +     return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, type,    \
> > +                                                     callback, a);   \
> > +}
> > +
> > +radio_si4713_template(core, g_ext_ctrls, struct v4l2_ext_controls *)
> > +radio_si4713_template(core, s_ext_ctrls, struct v4l2_ext_controls *)
> > +radio_si4713_template(core, g_ctrl, struct v4l2_control *)
> > +radio_si4713_template(core, s_ctrl, struct v4l2_control *)
> > +radio_si4713_template(tuner, g_modulator, struct v4l2_modulator *)
> > +radio_si4713_template(tuner, s_modulator, struct v4l2_modulator *)
> > +radio_si4713_template(tuner, g_frequency, struct v4l2_frequency *)
> > +radio_si4713_template(tuner, s_frequency, struct v4l2_frequency *)
> 
> I still don't like this macro, especially since there is really no need for it.

Ok. I'm going to remove it.

> 
> > +
> > +static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
> > +     .vidioc_enumaudout      = radio_si4713_enumaudout,
> > +     .vidioc_g_audout        = radio_si4713_g_audout,
> > +     .vidioc_s_audout        = radio_si4713_s_audout,
> > +     .vidioc_querycap        = radio_si4713_querycap,
> > +     .vidioc_queryctrl       = radio_si4713_queryctrl,
> > +     .vidioc_g_ext_ctrls     = radio_si4713_g_ext_ctrls,
> > +     .vidioc_s_ext_ctrls     = radio_si4713_s_ext_ctrls,
> > +     .vidioc_g_ctrl          = radio_si4713_g_ctrl,
> > +     .vidioc_s_ctrl          = radio_si4713_s_ctrl,
> > +     .vidioc_g_modulator     = radio_si4713_g_modulator,
> > +     .vidioc_s_modulator     = radio_si4713_s_modulator,
> > +     .vidioc_g_frequency     = radio_si4713_g_frequency,
> > +     .vidioc_s_frequency     = radio_si4713_s_frequency,
> > +};
> > +
> > +/* radio_si4713_vdev_template - video device interface */
> > +static struct video_device radio_si4713_vdev_template = {
> > +     .fops                   = &radio_si4713_fops,
> > +     .name                   = "radio-si4713",
> > +     .release                = video_device_release,
> > +     .ioctl_ops              = &radio_si4713_ioctl_ops,
> > +};
> > +
> > +/* Platform driver interface */
> > +/* radio_si4713_pdriver_probe - probe for the device */
> > +static int radio_si4713_pdriver_probe(struct platform_device *pdev)
> > +{
> > +     struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
> > +     struct radio_si4713_device *rsdev;
> > +     struct i2c_adapter *adapter;
> > +     struct v4l2_subdev *sd;
> > +     int rval = 0;
> > +
> > +     if (!pdata) {
> > +             dev_err(&pdev->dev, "Cannot proceed without platform data.\n");
> > +             rval = -EINVAL;
> > +             goto exit;
> > +     }
> > +
> > +     rsdev = kzalloc(sizeof *rsdev, GFP_KERNEL);
> > +     if (!rsdev) {
> > +             dev_err(&pdev->dev, "Failed to alloc video device.\n");
> > +             rval = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
> > +     if (rval) {
> > +             dev_err(&pdev->dev, "Failed to register v4l2 device.\n");
> > +             goto free_rsdev;
> > +     }
> > +
> > +     adapter = i2c_get_adapter(pdata->i2c_bus);
> > +     if (!adapter) {
> > +             dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
> > +                                                     pdata->i2c_bus);
> > +             rval = -ENODEV;
> > +             goto unregister_v4l2_dev;
> > +     }
> > +
> > +     sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, "si4713_i2c",
> > +                                     pdata->subdev_board_info, NULL);
> > +     if (!sd) {
> > +             dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
> > +             rval = -ENODEV;
> > +             goto unregister_v4l2_dev;
> > +     }
> > +
> > +     rsdev->radio_dev = video_device_alloc();
> > +     if (!rsdev->radio_dev) {
> > +             dev_err(&pdev->dev, "Failed to alloc video device.\n");
> > +             rval = -ENOMEM;
> > +             goto unregister_v4l2_dev;
> > +     }
> > +
> > +     memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
> > +                     sizeof(radio_si4713_vdev_template));
> > +     video_set_drvdata(rsdev->radio_dev, rsdev);
> > +     if (video_register_device(rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
> > +             dev_err(&pdev->dev, "Could not register video device.\n");
> > +             rval = -EIO;
> > +             goto free_vdev;
> > +     }
> > +     dev_info(&pdev->dev, "New device successfully probed\n");
> > +
> > +     goto exit;
> > +
> > +free_vdev:
> > +     video_device_release(rsdev->radio_dev);
> > +unregister_v4l2_dev:
> > +     v4l2_device_unregister(&rsdev->v4l2_dev);
> > +free_rsdev:
> > +     kfree(rsdev);
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/* radio_si4713_pdriver_remove - remove the device */
> > +static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
> > +{
> > +     struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> > +     struct radio_si4713_device *rsdev = container_of(v4l2_dev,
> > +                                             struct radio_si4713_device,
> > +                                             v4l2_dev);
> > +
> > +     video_unregister_device(rsdev->radio_dev);
> > +     v4l2_device_unregister(&rsdev->v4l2_dev);
> > +     kfree(rsdev);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct platform_driver radio_si4713_pdriver = {
> > +     .driver         = {
> > +             .name   = "radio-si4713",
> > +     },
> > +     .probe          = radio_si4713_pdriver_probe,
> > +     .remove         = __exit_p(radio_si4713_pdriver_remove),
> > +};
> > +
> > +/* Module Interface */
> > +static int __init radio_si4713_module_init(void)
> > +{
> > +     return platform_driver_register(&radio_si4713_pdriver);
> > +}
> > +
> > +static void __exit radio_si4713_module_exit(void)
> > +{
> > +     platform_driver_unregister(&radio_si4713_pdriver);
> > +}
> > +
> > +module_init(radio_si4713_module_init);
> > +module_exit(radio_si4713_module_exit);
> > +
> > +module_param(radio_nr, int, 0);
> > +MODULE_PARM_DESC(radio_nr,
> > +              "Minor number for radio device (-1 ==> auto assign)");
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
> > +MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
> > +MODULE_VERSION("0.0.1");
> > diff --git a/linux/include/media/si4713.h b/linux/include/media/si4713.h
> > new file mode 100644
> > index 0000000..de43f83
> > --- /dev/null
> > +++ b/linux/include/media/si4713.h
> > @@ -0,0 +1,40 @@
> > +/*
> > + * include/media/si4713.h
> > + *
> > + * Board related data definitions for Si4713 radio transmitter chip.
> > + *
> > + * Copyright (c) 2009 Nokia Corporation
> > + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > + *
> > + * This file is licensed under the terms of the GNU General Public License
> > + * version 2. This program is licensed "as is" without any warranty of any
> > + * kind, whether express or implied.
> > + *
> > + */
> > +
> > +#ifndef SI4713_H
> > +#define SI4713_H
> > +
> > +#include <linux/i2c.h>
> > +#include <media/v4l2-device.h>
> > +
> > +#define SI4713_NAME "radio-si4713"
> > +
> > +/* The SI4713 I2C sensor chip has a fixed slave address of 0xc6. */
> > +#define SI4713_I2C_ADDR_BUSEN_HIGH   0x63
> > +#define SI4713_I2C_ADDR_BUSEN_LOW    0x11
> 
> I think the comment should be: 'has a fixed slave address of either 0xc6 or
> 0x22'. Right?

yes

> 
> > +
> > +/*
> > + * Platform dependent definition
> > + */
> > +struct si4713_platform_data {
> > +     /* Set power state, zero is off, non-zero is on. */
> > +     int (*set_power)(int power);
> > +};
> > +
> > +struct radio_si4713_platform_data {
> > +     int i2c_bus;
> > +     struct i2c_board_info *subdev_board_info;
> > +};
> > +
> > +#endif /* ifndef SI4713_H*/
> 
> No, this is not right. You need two headers here: one for the i2c driver and
> one for the v4l2 driver. The radio_si4713_platform_data struct is specific to
> the v4l2 driver and another future v4l2 driver that uses the si4713 i2c device
> might have different platform data.
> 
> So media/si4713.h should contain only the bits that are relevant to the i2c
> driver. For the v4l2 driver you should make a media/radio-si4713.h header
> instead.

Right. I first thought in putting them in separated files. Will resend them separated.

> 
> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
