Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44554 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbbFPGKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 02:10:13 -0400
Message-ID: <557FBDB3.3030004@xs4all.nl>
Date: Tue, 16 Jun 2015 08:09:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/19] New ioct VIDIOC_G_DEF_EXT_CTRLS
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

This patch series looks good to me. I'll wait a bit to see if anyone else has
comments. If not, then I'll merge for 4.3.

Regards,

	Hans

On 06/12/2015 06:46 PM, Ricardo Ribalda Delgado wrote:
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
> https://github.com/ribalda/linux/tree/g_def_ext-rfc3
> 
> It has been tested with a hacked version of yavta (for normal controls) and a
> custom program for the array control.
> 
> Changelog v3:
> -Comments by Hans Verkuil:
> -Remove the control ops from the following drivers
> saa7706
> ivtv-gpio
> wm8739
> tvp7002
> tvp514x
> tvl320aic23b
> tda7432
> sr030pc30
> saa717x
> cs5345
> adv7393
> adv7343
> 
> Changelog v2:
> -Add documentation
> -Split in multiple patches
> -Comments by Hans Verkuil:
> -Rename ioctl to G_DEF_EXT_CTRL
> -Much! better implementation of def_to_user
> 
> 
> THANKS!
> 
> 
> Ricardo Ribalda Delgado (19):
>   media/v4l2-core: Add argument def_value to g_ext_ctrl
>   media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
>   videodev2.h: Fix typo in comment
>   media/usb/uvc: Implement vivioc_g_def_ext_ctrls
>   media/pci/saa7164-encoder: Implement vivioc_g_def_ext_ctrls
>   media/pci/saa7164-vbi: Implement vivioc_g_def_ext_ctrls
>   media/usb/prusb2: Implement vivioc_g_def_ext_ctrls
>   v4l2-subdev: Add g_def_ext_ctrls to core_ops
>   media/i2c/bt819: Implement g_def_ext_ctrls core_op
>   media/i2c/cs53l32a: Implement g_def_ext_ctrls core_op
>   media/i2c/cx25840/cx25840-core: Implement g_def_ext_ctrls core_op
>   media/i2c/msp3400-driver: Implement g_def_ext_ctrls core_op
>   media/i2c/saa7110: Implement g_def_ext_ctrls core_op
>   media/i2c/saa7115: Implement g_def_ext_ctrls core_op
>   media/i2c/tlv320aic23b: Implement g_def_ext_ctrls core_op
>   media/i2c/vpx3220: Implement g_def_ext_ctrls core_op
>   media/i2c/wm8775: Implement g_def_ext_ctrls core_op
>   Docbook: media: new ioctl VIDIOC_G_DEF_EXT_CTRLS
>   Documentation: media: Fix code sample
> 
>  Documentation/DocBook/media/v4l/v4l2.xml           |  8 ++++++
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 13 ++++++---
>  Documentation/video4linux/v4l2-controls.txt        |  4 ++-
>  Documentation/video4linux/v4l2-framework.txt       |  1 +
>  Documentation/zh_CN/video4linux/v4l2-framework.txt |  1 +
>  drivers/media/i2c/bt819.c                          |  1 +
>  drivers/media/i2c/cs53l32a.c                       |  1 +
>  drivers/media/i2c/cx25840/cx25840-core.c           |  1 +
>  drivers/media/i2c/msp3400-driver.c                 |  1 +
>  drivers/media/i2c/saa7110.c                        |  1 +
>  drivers/media/i2c/saa7115.c                        |  1 +
>  drivers/media/i2c/tlv320aic23b.c                   |  1 +
>  drivers/media/i2c/vpx3220.c                        |  1 +
>  drivers/media/i2c/wm8775.c                         |  1 +
>  drivers/media/pci/saa7164/saa7164-encoder.c        | 28 +++++++++++++++++++
>  drivers/media/pci/saa7164/saa7164-vbi.c            | 28 +++++++++++++++++++
>  drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 28 +++++++++++++++++++
>  drivers/media/usb/uvc/uvc_v4l2.c                   | 30 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  4 +++
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 32 ++++++++++++++++++----
>  drivers/media/v4l2-core/v4l2-ioctl.c               | 25 +++++++++++++++--
>  drivers/media/v4l2-core/v4l2-subdev.c              |  5 +++-
>  include/media/v4l2-ctrls.h                         |  5 +++-
>  include/media/v4l2-ioctl.h                         |  2 ++
>  include/media/v4l2-subdev.h                        |  2 ++
>  include/uapi/linux/videodev2.h                     |  3 +-
>  27 files changed, 214 insertions(+), 16 deletions(-)
> 

