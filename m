Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55425 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2HKSjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 14:39:55 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	oselas@community.pengutronix.de,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/1] S3C244X/S3C64XX SoC camera host interface driver
Date: Sat, 11 Aug 2012 20:39:42 +0200
Message-ID: <9609498.7r78ladCdh@flatron>
In-Reply-To: <50269F15.4030504@gmail.com>
References: <50269F15.4030504@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Saturday 11 of August 2012 20:06:13 Sylwester Nawrocki wrote:
> Hi all,
> 
> This patch adds a driver for Samsung S3C244X/S3C64XX SoC series camera
> host interface. My intention was to create a V4L2 driver that would work
> with standard applications like Gstreamer or mplayer, and yet exposing
> possibly all features available in the hardware.
> 
> It took me several weeks to do this work in my (limited) spare time.
> Finally I've got something that is functional and I think might be useful
> for others, so I'm publishing this initial version. It hopefully doesn't
> need much tweaking or corrections, at least as far as S3C244X is
> concerned. It has not been tested on S3C64XX SoCs, as I don't have the
> hardware. However, the driver has been designed with covering S3C64XX as
> well in mind, and I've already taken care of some differences between
> S3C2444X and S3C64XX. Mem-to-mem features are not yet supported, but
> these are quite separate issue and could be easily added as a next step.

I will try to test it on S3C6410 in some reasonably near future and report 
any needed corrections.

Currently I am using a modified s5p-fimc driver in my project, but it 
supports only the codec path of S3C64xx and any needed stream duplication 
and rescaling is done in later processing, so it might be wise to migrate 
to yours.

Best regards,
Tomasz Figa
 
> The patch to follow only adds the CAMIF driver, the other two required
> for the camera on Mini2440 board to work (OV9650 sensor driver and the
> board file patch) can be found in branch s3c-camif-v3.5 in git
> repository:
> 
> git://github.com/snawrocki/linux.git
> 
> Gitweb: https://github.com/snawrocki/linux/commits/s3c-camif-v3.5
> 
> These patches are based off of stable v3.5 kernel.
> 
> The S3C-CAMIF driver exposes one v4l2 subdev and two capture video nodes
> - for the "codec" and "preview" data paths. For minimum functionality
> there is no need to touch the subdev device node in user space. However
> it is recommended for best results.
> 
> For my tests I used nice Mini2440 BSP from Pengutronix, which already
> contains various applications, like Gstreamer, v4l2-ctl or even
> media-ctl. It's available at
> http://www.pengutronix.de/oselas/bsp/pengutronix/index_en.html.
> 
> I've tested the driver with mplayer and Gstreamer, also simultaneous
> capture from the "preview" and "codec" video nodes. The codec path
> camera preview at framebuffer can be started, for example, with
> following command:
> 
> # gst-launch v4l2src device=/dev/video0 !
> video/x-raw-yuv,width=320,height= 240 ! ffmpegcolorspace ! fbdevsink
> 
> In order to select the preview video node (which supports only RGB pixel
> formats) /dev/video0 need to be replaced with /dev/video1, e.g.
> 
> # gst-launch v4l2src device=/dev/video1 !
> video/x-raw-rgb,bpp=32,endianness= 4321,depth=32,width=320,height=240 !
> ffmpegcolorspace ! fbdevsink
> 
> In this case I'm getting slightly incorrect color representation, still
> need to figure out why this happens.
> 
> The supported pixel formats are listed in the attached
> supported_pixel_formats.txt file.
> 
> The camera test pattern is exposed through a private control at the
> subdev node, all supported controls are listed in attached
> supported_controls.txt file. The test pattern can be enabled e.g. with
> command:
> 
> # v4l2-ctl -d /dev/v4l-subdev1 --set-ctrl=test_pattern=1
> 
> 
> A note about the driver's internals
> 
> The S3C-CAMIF driver sets at the camera input ("catchcam") (default)
> pixel format as retrieved from the sensor subdev. This happens during
> driver's initialization, so there is no need to touch the subdev in user
>  space to capture video from the camera. If pixel resolution selected at
> /dev/video? differs from the one set at camera input (S3C-CAMIF subdev
> pad 0), the image frames will be resized accordingly, taking into
> account the resizer's capabilities.
> 
> To change pixel format at the sensor subdev and the camif input, so those
> better match our target capture resolution, following commands can be
> used:
> 
> media-ctl --set-v4l2 '"OV9650":0 [fmt: YUYV2X8/640x640]'
> media-ctl --set-v4l2 '"S3C-CAMIF":0 [fmt: YUYV2X8/640x640]'
> 
> The only requirement is that these formats are same, otherwise it won't
> be possible to start streaming and VIDIOC_STREAMON will fail wit -EPIPE
> errno.
> 
> The video node numbering might be different, if there are other V4L2
> drivers in the system. It can be easily checked with media-ctl utility
> (media-ctl -p), my configuration was as in attached camif_media_info.txt
> log.
> 
> I've run v4l2-compliance on both video nodes, the results can be found in
> file v4l2_compliance_log.txt.
> 
> A graph depicting device topology can be generated from attached
> camif_graph.dot file (which was created with 'media-ctl --print-dot'),
> with following command:
> 
> # cat camif_graph.dot | dot -Tpdf > camif_graph.pdf
> # evince camif_graph.pdf
> 
> There is still some more work needed to make the OV9650 sensor driver
> ready for the mainline, I'm planning to take care of it in near future.
> As for the CAMIF driver, I might try to push it upstream if it doesn't
> take too much of my time and there is enough interest from the users
> side.
> 
> Feature requests or bug reports are welcome.
> 
> Regards,
> Sylwester
> 
> ---
> 
> 
> Sylwester Nawrocki (1):
>   V4L: Add driver for S3C244X/S3C64XX SoC series camera interface
> 
>  drivers/media/video/Kconfig                   |   12 +
>  drivers/media/video/Makefile                  |    1 +
>  drivers/media/video/s3c-camif/Makefile        |    5 +
>  drivers/media/video/s3c-camif/camif-capture.c | 1602
> +++++++++++++++++++++ drivers/media/video/s3c-camif/camif-core.c    | 
> 625 ++++++++
>  drivers/media/video/s3c-camif/camif-core.h    |  375 ++++
>  drivers/media/video/s3c-camif/camif-regs.c    |  497 ++++++
>  drivers/media/video/s3c-camif/camif-regs.h    |  262 ++
>  include/media/s3c_camif.h                     |   36 +
>  9 files changed, 3415 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/s3c-camif/Makefile
>  create mode 100644 drivers/media/video/s3c-camif/camif-capture.c
>  create mode 100644 drivers/media/video/s3c-camif/camif-core.c
>  create mode 100644 drivers/media/video/s3c-camif/camif-core.h
>  create mode 100644 drivers/media/video/s3c-camif/camif-regs.c
>  create mode 100644 drivers/media/video/s3c-camif/camif-regs.h
>  create mode 100644 include/media/s3c_camif.h
