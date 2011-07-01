Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:43673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab1GAXeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 19:34:08 -0400
Message-ID: <4E0E5968.7030509@infradead.org>
Date: Fri, 01 Jul 2011 20:34:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] first soc-camera pull for 3.1
References: <Pine.LNX.4.64.1106291511280.12577@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106291511280.12577@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-06-2011 10:15, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> I expect at least one more soc-camera pull request for 3.1, so far a bunch 
> of patches, that have been lying around since a while already.
> 
> The following changes since commit 7023c7dbc3944f42aa1d6910a6098c5f9e23d3f1:
> 
>   [media] DVB: dvb-net, make the kconfig text helpful (2011-06-21 15:55:15 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.1
> 
> Andrew Chew (6):
>       V4L: ov9740: Cleanup hex casing inconsistencies
>       V4L: ov9740: Correct print in ov9740_reg_rmw()
>       V4L: ov9740: Fixed some settings
>       V4L: ov9740: Remove hardcoded resolution regs
>       V4L: ov9740: Reorder video and core ops
>       V4L: ov9740: Add suspend/resume
> 
> Guennadi Liakhovetski (11):
>       V4L: mx3_camera: remove redundant calculations
>       V4L: pxa_camera: remove redundant calculations
>       V4L: pxa-camera: try to force progressive video format
>       V4L: pxa-camera: switch to using subdev .s_power() core operation
>       V4L: mx2_camera: .try_fmt shouldn't fail
>       V4L: sh_mobile_ceu_camera: remove redundant calculations
>       V4L: tw9910: remove bogus ENUMINPUT implementation

Guennadi,

While it is the right thing to remove the bogus implementation for ENUMINPUT on
tw9910, the reasons pointed there are not ok. Demodulators generally need an
implementation for ENUMINPUT/G_INPUT/S_INPUT, as, on most cases, they have a
video multiplexer. On a quick look at tm9910 marketing "datasheet", this device
has 4 analog inputs.

Probably, those macros (currently unused) are linked to the input selection:

#define YSEL_M0     0x00 /*  00 : Mux0 selected */
#define YSEL_M1     0x04 /*  01 : Mux1 selected */
#define YSEL_M2     0x08 /*  10 : Mux2 selected */
#define YSEL_M3     0x10 /*  11 : Mux3 selected */

So, the right thing to do is to implement the s_routing callback at tw9910, 
implementing the mux code, in order to allow the bridge driver to select 
between the several inputs. 

At soc_camera, a proper implementation for ENUMINPUT/G_INPUT/S_INPUT is required, 
in order to allow to select what's connected to each vmux input (with is board-specific),
and to return the selected video standard.

See, for example, saa7115 s_routing implementation and em28xx-video
for the *input callbacks.

I'll apply this patch for now as-is. Please fix the implementation on a latter patch.

>       V4L: soc-camera: MIPI flags are not sensor flags
>       V4L: mt9m111: propagate higher level abstraction down in functions
>       V4L: mt9m111: switch to v4l2-subdev .s_power() method
>       V4L: soc-camera: remove several now unused soc-camera client operations
> 
> Josh Wu (1):
>       V4L: at91: add Atmel Image Sensor Interface (ISI) support
> 
>  drivers/media/video/Kconfig                |    8 +
>  drivers/media/video/Makefile               |    1 +
>  drivers/media/video/atmel-isi.c            | 1048 ++++++++++++++++++++++++++++
>  drivers/media/video/mt9m111.c              |  218 ++++---
>  drivers/media/video/mx2_camera.c           |   15 +-
>  drivers/media/video/mx3_camera.c           |   12 -
>  drivers/media/video/ov9740.c               |  543 ++++++++-------
>  drivers/media/video/pxa_camera.c           |   25 +-
>  drivers/media/video/sh_mobile_ceu_camera.c |    5 -
>  drivers/media/video/soc_camera.c           |   17 +-
>  drivers/media/video/tw9910.c               |   11 -
>  include/media/atmel-isi.h                  |  119 ++++
>  include/media/soc_camera.h                 |   15 +-
>  13 files changed, 1631 insertions(+), 406 deletions(-)
>  create mode 100644 drivers/media/video/atmel-isi.c
>  create mode 100644 include/media/atmel-isi.h
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

