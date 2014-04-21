Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39433 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaDUOiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 10:38:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: subdev: Move [gs]_std operation to video ops
Date: Mon, 21 Apr 2014 16:38:20 +0200
Message-ID: <1946703.iYRICFVott@avalon>
In-Reply-To: <1394532878-3943-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394532878-3943-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Guennadi,

Could you please review this patch ? I'd like to get it in v3.16.

On Tuesday 11 March 2014 11:14:38 Laurent Pinchart wrote:
> The g_std and s_std operations are video-related, move them to the video
> ops where they belong.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/adv7180.c                     |  6 +-----
>  drivers/media/i2c/adv7183.c                     |  4 ++--
>  drivers/media/i2c/adv7842.c                     |  4 ++--
>  drivers/media/i2c/bt819.c                       |  2 +-
>  drivers/media/i2c/cx25840/cx25840-core.c        |  4 ++--
>  drivers/media/i2c/ks0127.c                      |  6 +-----
>  drivers/media/i2c/ml86v7667.c                   |  2 +-
>  drivers/media/i2c/msp3400-driver.c              |  2 +-
>  drivers/media/i2c/saa6752hs.c                   |  2 +-
>  drivers/media/i2c/saa7110.c                     |  2 +-
>  drivers/media/i2c/saa7115.c                     |  2 +-
>  drivers/media/i2c/saa717x.c                     |  2 +-
>  drivers/media/i2c/saa7191.c                     |  2 +-
>  drivers/media/i2c/soc_camera/tw9910.c           |  4 ++--
>  drivers/media/i2c/sony-btf-mpx.c                | 10 +++++-----
>  drivers/media/i2c/tvaudio.c                     |  6 +++++-
>  drivers/media/i2c/tvp514x.c                     |  2 +-
>  drivers/media/i2c/tvp5150.c                     |  2 +-
>  drivers/media/i2c/tw2804.c                      |  2 +-
>  drivers/media/i2c/tw9903.c                      |  2 +-
>  drivers/media/i2c/tw9906.c                      |  2 +-
>  drivers/media/i2c/vp27smpx.c                    |  6 +++++-
>  drivers/media/i2c/vpx3220.c                     |  2 +-
>  drivers/media/pci/bt8xx/bttv-driver.c           |  2 +-
>  drivers/media/pci/cx18/cx18-av-core.c           |  2 +-
>  drivers/media/pci/cx18/cx18-fileops.c           |  2 +-
>  drivers/media/pci/cx18/cx18-gpio.c              |  6 +++++-
>  drivers/media/pci/cx18/cx18-ioctl.c             |  2 +-
>  drivers/media/pci/cx23885/cx23885-video.c       |  4 ++--
>  drivers/media/pci/cx88/cx88-core.c              |  2 +-
>  drivers/media/pci/ivtv/ivtv-fileops.c           |  2 +-
>  drivers/media/pci/ivtv/ivtv-ioctl.c             |  2 +-
>  drivers/media/pci/saa7134/saa7134-video.c       |  4 ++--
>  drivers/media/pci/saa7146/mxb.c                 | 14 +++++++-------
>  drivers/media/pci/sta2x11/sta2x11_vip.c         |  4 ++--
>  drivers/media/pci/zoran/zoran_device.c          |  2 +-
>  drivers/media/pci/zoran/zoran_driver.c          |  2 +-
>  drivers/media/platform/blackfin/bfin_capture.c  |  4 ++--
>  drivers/media/platform/davinci/vpfe_capture.c   |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c   |  2 +-
>  drivers/media/platform/davinci/vpif_display.c   |  2 +-
>  drivers/media/platform/fsl-viu.c                |  2 +-
>  drivers/media/platform/soc_camera/soc_camera.c  |  4 ++--
>  drivers/media/platform/timblogiw.c              |  2 +-
>  drivers/media/platform/vino.c                   |  6 +++---
>  drivers/media/usb/au0828/au0828-video.c         |  4 ++--
>  drivers/media/usb/cx231xx/cx231xx-417.c         |  2 +-
>  drivers/media/usb/cx231xx/cx231xx-video.c       |  6 +++---
>  drivers/media/usb/em28xx/em28xx-video.c         |  4 ++--
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |  2 +-
>  drivers/media/usb/stk1160/stk1160-v4l.c         |  4 ++--
>  drivers/media/usb/tm6000/tm6000-cards.c         |  2 +-
>  drivers/media/usb/tm6000/tm6000-video.c         |  2 +-
>  drivers/media/usb/usbvision/usbvision-video.c   |  2 +-
>  drivers/media/v4l2-core/tuner-core.c            |  6 +++++-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
>  drivers/staging/media/go7007/go7007-v4l2.c      |  2 +-
>  drivers/staging/media/go7007/s2250-board.c      |  2 +-
>  drivers/staging/media/go7007/saa7134-go7007.c   |  4 ++++
>  include/media/v4l2-subdev.h                     |  6 +++---
>  60 files changed, 107 insertions(+), 95 deletions(-)

[snip]

-- 
Regards,

Laurent Pinchart

