Return-Path: <hverkuil@xs4all.nl>
Message-id: <557AE172.7070408@xs4all.nl>
Date: Fri, 12 Jun 2015 15:41:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [RFC v2 00/27]  New ioct VIDIOC_G_DEF_EXT_CTRLS
References: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

On 06/12/2015 03:11 PM, Ricardo Ribalda Delgado wrote:
> Integer controls provide a way to get their default/initial value, but
> any other control (p_u32, p_u8.....) provide no other way to get the
> initial value than unloading the module and loading it back.
> 
> *What is the actual problem?
> I have a custom control with WIDTH integer values. Every value
> represents the calibrated FPN (fixed pattern noise) correction value for that
> column
> -Application A changes the FPN correction value
> -Application B wants to restore the calibrated value but it cant :(
> 
> *What is the proposed solution?
> -Add a new ioctl VIDIOC_G_DEF_EXT_CTRLS, with the same API as
> G_EXT_CTRLS, but that returns the initial value of a given control.
> 
> 
> I have posted a copy of my working tree to
> 
> https://github.com/ribalda/linux/tree/g_def_ext
> 
> It has been tested with a hacked version of yavta (for normal controls) and a
> custom program for the array control.
> 
> Changelog v2:
> -Add documentation
> -Split in multiple patches
> -Comments by Hans:
>   -Rename ioctl to G_DEF_EXT_CTRL
>   -Much! better implementation of def_to_user
> 
> 
> THANKS!
> 
> Ricardo Ribalda Delgado (27):
>   media/v4l2-core: Add argument def_value to g_ext_ctrl
>   media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
>   videodev2.h: Fix typo in comment
>   v4l2-subdev: Add g_def_ext_ctrls to core_ops
>   media/i2c/adv7343: Implement g_def_ext_ctrls core_op
>   media/i2c/adv7393: Implement g_def_ext_ctrls core_op
>   media/i2c/bt819: Implement g_def_ext_ctrls core_op
>   media/i2c/cs5345: Implement g_def_ext_ctrls core_op
>   media/i2c/cs53l32a: Implement g_def_ext_ctrls core_op
>   media/i2c/cx25840/cx25840-core: Implement g_def_ext_ctrls core_op
>   media/i2c/msp3400-driver: Implement g_def_ext_ctrls core_op
>   media/i2c/saa7110: Implement g_def_ext_ctrls core_op
>   media/i2c/saa7115: Implement g_def_ext_ctrls core_op
>   media/i2c/saa717x: Implement g_def_ext_ctrls core_op
>   media/i2c/sr030pc30: Implement g_def_ext_ctrls core_op
>   media/i2c/tda7432: Implement g_def_ext_ctrls core_op
>   media/i2c/tlv320aic23b: Implement g_def_ext_ctrls core_op
>   media/i2c/tvaudio: Implement g_def_ext_ctrls core_op
>   media/i2c/tvp514x: Implement g_def_ext_ctrls core_op
>   media/i2c/tvp7002: Implement g_def_ext_ctrls core_op
>   media/i2c/vpx3220: Implement g_def_ext_ctrls core_op
>   media/i2c/wm8739: Implement g_def_ext_ctrls core_op
>   media/i2c/wm8775: Implement g_def_ext_ctrls core_op
>   media/pci/ivtv/ivtv-gpio: Implement g_def_ext_ctrls core_op
>   media/radio/saa7706h: Implement g_def_ext_ctrls core_op

I did a quick analysis and for the following i2c modules you can just remove the
compat control ops altogether since they are no longer used in old non-control-framework
bridge drivers:

saa7706
ivtv-gpio
wm8739
tvp7002
tvp514x
tvl320aic23b
tda7432
sr030pc30
saa717x
cs5345
adv7393
adv7343

Also note that the uvc driver needs to be adapted manually since it can't use
the control framework. The ioctls are implemented in the driver itself.

Regards,

	Hans

>   Docbook: media: new ioctl VIDIOC_G_DEF_EXT_CTRLS
>   Documentation: media: Fix code sample
> 
>  Documentation/DocBook/media/v4l/v4l2.xml           |  8 ++++++
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 13 ++++++---
>  Documentation/video4linux/v4l2-controls.txt        |  4 ++-
>  Documentation/video4linux/v4l2-framework.txt       |  1 +
>  Documentation/zh_CN/video4linux/v4l2-framework.txt |  1 +
>  drivers/media/i2c/adv7343.c                        |  1 +
>  drivers/media/i2c/adv7393.c                        |  1 +
>  drivers/media/i2c/bt819.c                          |  1 +
>  drivers/media/i2c/cs5345.c                         |  1 +
>  drivers/media/i2c/cs53l32a.c                       |  1 +
>  drivers/media/i2c/cx25840/cx25840-core.c           |  1 +
>  drivers/media/i2c/msp3400-driver.c                 |  1 +
>  drivers/media/i2c/saa7110.c                        |  1 +
>  drivers/media/i2c/saa7115.c                        |  1 +
>  drivers/media/i2c/saa717x.c                        |  1 +
>  drivers/media/i2c/sr030pc30.c                      |  1 +
>  drivers/media/i2c/tda7432.c                        |  1 +
>  drivers/media/i2c/tlv320aic23b.c                   |  1 +
>  drivers/media/i2c/tvaudio.c                        |  1 +
>  drivers/media/i2c/tvp514x.c                        |  1 +
>  drivers/media/i2c/tvp7002.c                        |  1 +
>  drivers/media/i2c/vpx3220.c                        |  1 +
>  drivers/media/i2c/wm8739.c                         |  1 +
>  drivers/media/i2c/wm8775.c                         |  1 +
>  drivers/media/pci/ivtv/ivtv-gpio.c                 |  1 +
>  drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
>  drivers/media/radio/saa7706h.c                     |  1 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  4 +++
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 32 ++++++++++++++++++----
>  drivers/media/v4l2-core/v4l2-ioctl.c               | 25 +++++++++++++++--
>  drivers/media/v4l2-core/v4l2-subdev.c              |  5 +++-
>  include/media/v4l2-ctrls.h                         |  5 +++-
>  include/media/v4l2-ioctl.h                         |  2 ++
>  include/media/v4l2-subdev.h                        |  2 ++
>  include/uapi/linux/videodev2.h                     |  3 +-
>  35 files changed, 112 insertions(+), 16 deletions(-)
> 
