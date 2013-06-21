Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423122Ab3FUR1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 13:27:17 -0400
Date: Fri, 21 Jun 2013 19:27:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL] V4L2: clock and async probing APIs, soc-camera example
 implementation
In-Reply-To: <Pine.LNX.4.64.1306211851540.27277@axis700.grange>
Message-ID: <Pine.LNX.4.64.1306211925030.27277@axis700.grange>
References: <Pine.LNX.4.64.1306211851540.27277@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 21 Jun 2013, Guennadi Liakhovetski wrote:

> Hi Mauro

Sorry, I did forget a couple more acks: for patch "V4L2: add a device 
pointer to struct v4l2_subdev"

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

and for patch "V4L2: support asynchronous subdevice registration"

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Mauro, maybe it would be possible for you to modify only these two 
patches.

Thanks
Guennadi

> With acks from Hans and Laurent I'd like to ask you to pull my V4L2 clock 
> and asynchronous probing APIs together with respective soc-camera changes. 
> I included an ack from Laurent, even though he requested me to include the 
> documentation update into this pull request, which I haven't done yet. But 
> we agreed privately, that it's also ok, if I submit a v2 of the patch 
> first to the list next Monday and then send an additional pull request for 
> it some time next week. The last patch from the patch series, as I posted 
> it to the list last time is also omitted, because (1) it's for arch/arm, 
> (2) the board, which I used as an example to develop and test these 
> patches will be removed from the kernel, so, I'll need to pick up a 
> different platform for testing, also a different camera host driver, 
> perhaps.
> 
> The following changes since commit 4ef72e347112a834fbd6944565b1f63d4af19c8a:
> 
>   [media] V4L2: soc-camera: remove unneeded include path (2013-06-21 13:11:59 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.11-2
> 
> Guennadi Liakhovetski (20):
>       soc-camera: move common code to soc_camera.c
>       soc-camera: add host clock callbacks to start and stop the master clock
>       pxa-camera: move interface activation and deactivation to clock callbacks
>       omap1-camera: move interface activation and deactivation to clock callbacks
>       atmel-isi: move interface activation and deactivation to clock callbacks
>       mx3-camera: move interface activation and deactivation to clock callbacks
>       mx2-camera: move interface activation and deactivation to clock callbacks
>       mx1-camera: move interface activation and deactivation to clock callbacks
>       sh-mobile-ceu-camera: move interface activation and deactivation to clock callbacks
>       soc-camera: make .clock_{start,stop} compulsory, .add / .remove optional
>       soc-camera: don't attach the client to the host during probing
>       sh-mobile-ceu-camera: add primitive OF support
>       sh-mobile-ceu-driver: support max width and height in DT
>       V4L2: add temporary clock helpers
>       V4L2: add a device pointer to struct v4l2_subdev
>       V4L2: support asynchronous subdevice registration
>       soc-camera: switch I2C subdevice drivers to use v4l2-clk
>       soc-camera: add V4L2-async support
>       sh_mobile_ceu_camera: add asynchronous subdevice probing support
>       imx074: support asynchronous probing
> 
>  .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
>  drivers/media/i2c/soc_camera/imx074.c              |   32 +-
>  drivers/media/i2c/soc_camera/mt9m001.c             |   17 +-
>  drivers/media/i2c/soc_camera/mt9m111.c             |   20 +-
>  drivers/media/i2c/soc_camera/mt9t031.c             |   19 +-
>  drivers/media/i2c/soc_camera/mt9t112.c             |   25 +-
>  drivers/media/i2c/soc_camera/mt9v022.c             |   17 +-
>  drivers/media/i2c/soc_camera/ov2640.c              |   19 +-
>  drivers/media/i2c/soc_camera/ov5642.c              |   20 +-
>  drivers/media/i2c/soc_camera/ov6650.c              |   17 +-
>  drivers/media/i2c/soc_camera/ov772x.c              |   15 +-
>  drivers/media/i2c/soc_camera/ov9640.c              |   17 +-
>  drivers/media/i2c/soc_camera/ov9640.h              |    1 +
>  drivers/media/i2c/soc_camera/ov9740.c              |   18 +-
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 +-
>  drivers/media/i2c/soc_camera/tw9910.c              |   24 +-
>  drivers/media/platform/soc_camera/atmel-isi.c      |   38 +-
>  drivers/media/platform/soc_camera/mx1_camera.c     |   48 +-
>  drivers/media/platform/soc_camera/mx2_camera.c     |   41 +-
>  drivers/media/platform/soc_camera/mx3_camera.c     |   44 +-
>  drivers/media/platform/soc_camera/omap1_camera.c   |   41 +-
>  drivers/media/platform/soc_camera/pxa_camera.c     |   46 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  243 +++++--
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c |  153 +++--
>  drivers/media/platform/soc_camera/soc_camera.c     |  707 +++++++++++++++++---
>  .../platform/soc_camera/soc_camera_platform.c      |    2 +-
>  drivers/media/v4l2-core/Makefile                   |    3 +-
>  drivers/media/v4l2-core/v4l2-async.c               |  280 ++++++++
>  drivers/media/v4l2-core/v4l2-clk.c                 |  242 +++++++
>  drivers/media/v4l2-core/v4l2-common.c              |    2 +
>  include/media/sh_mobile_ceu.h                      |    2 +
>  include/media/sh_mobile_csi2.h                     |    2 +-
>  include/media/soc_camera.h                         |   39 +-
>  include/media/v4l2-async.h                         |  105 +++
>  include/media/v4l2-clk.h                           |   54 ++
>  include/media/v4l2-subdev.h                        |   10 +
>  36 files changed, 1973 insertions(+), 425 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
>  create mode 100644 drivers/media/v4l2-core/v4l2-async.c
>  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
>  create mode 100644 include/media/v4l2-async.h
>  create mode 100644 include/media/v4l2-clk.h

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
