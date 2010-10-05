Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:44949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754461Ab0JEQk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Oct 2010 12:40:58 -0400
Date: Tue, 5 Oct 2010 18:41:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: Re: [PATCH 00/16] Use modaliases to load I2C modules - please review
In-Reply-To: <Pine.LNX.4.64.1009242057570.18077@axis700.grange>
Message-ID: <Pine.LNX.4.64.1010051833100.31708@axis700.grange>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1009242057570.18077@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Sep 2010, Guennadi Liakhovetski wrote:

> Hi Laurent
> 
> On Fri, 24 Sep 2010, Laurent Pinchart wrote:
> 
> > Hi everybody,
> > 
> > Here's a bunch of patches (on top of staging/v2.6.37) that remove the
> > module_name argument to the v4l2_i2c_new_subdev* functions.
> 
> Something seems to be wrong with them. On arch/arm/mach-mx3/mach-pcm037.c 
> without your patches both mt9mt031 and mt9v022 drivers attempt to load 
> (only one sensor attached, so, the second one fails probing, but stays 
> loaded, of course), with your patches only one driver loads. As I told 
> you, I'm leaving early tomorrow, so, unfortunately I cannot investigate 
> this further now, please, see if you find the problem, I'll be back on 
> Monday 04.10.

Hm, maybe testing patches between packing and completing a thousand of 
other things was not a very good idea... In any case, I think, it has been 
something in my rootfs. Can it be, that modules, loaded per modalias and 
per explicit module names interact differently with module blacklists? 
That would explain the different behaviour, that I've been observing.

In any case, it seems to work fine with soc-camera. I didn't test sh_vou, 
but I think, it should work too - it looks good at least. If you feel it 
shall be tested, I can do so, maybe, tomorrow, otherwise you can add my

Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

for the "soc-camera: allow only one video queue per device" patch and

Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

for "sh_vou: Don't use module names to load I2C modules"

Thanks
Guennadi

> > 
> > The module name is used by those functions to load the module corresponding
> > to the I2C sub-device being instanciated. As the I2C modules now support
> > modalias (and have been for quite some time), the module name isn't necessary
> > anymore.
> > 
> > The first patch adds the ability to load I2C modules based on modaliases when
> > the module name passed to the v4l_i2c_new_subdev* functions is NULL. This is
> > never the case with the in-tree drivers, so there shouldn't be any regression.
> > 
> > The 14 next patches modify all drivers that call those functions to pass a NULL
> > module name. Patch 2/16 touches all the drivers that hardcode the module name
> > directly when calling the function, and the remaining 13 patches do the same
> > for driver that fetch the module name from platform data or from other sources
> > (such as static tables). I've checked all I2C modules used by the drivers
> > modified in those patches to make sure they have a proper module devices table.
> > 
> > The last patch finally removes the module_name argument, as all callers now
> > pass a NULL value.
> > 
> > The code has obviously not been tested, as I lack the necessary hardware. I've
> > tested the V4L2 core changes with the OMAP3 ISP driver. All x86 drivers have
> > been compile-tested.
> > 
> > Laurent Pinchart (16):
> >   v4l: Load I2C modules based on modalias
> >   v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
> >   go7007: Add MODULE_DEVICE_TABLE to the go7007 I2C modules
> >   go7007: Fix the TW2804 I2C type name
> >   go7007: Don't use module names to load I2C modules
> >   zoran: Don't use module names to load I2C modules
> >   pvrusb2: Don't use module names to load I2C modules
> >   sh_vou: Don't use module names to load I2C modules
> >   radio-si4713: Don't use module names to load I2C modules
> >   soc_camera: Don't use module names to load I2C modules
> >   vpfe_capture: Don't use module names to load I2C modules
> >   vpif_display: Don't use module names to load I2C modules
> >   vpif_capture: Don't use module names to load I2C modules
> >   ivtv: Don't use module names to load I2C modules
> >   cx18: Don't use module names to load I2C modules
> >   v4l: Remove module_name argument to the v4l2_i2c_new_subdev*
> >     functions
> > 
> >  arch/arm/mach-mx3/mach-pcm037.c               |    2 -
> >  arch/arm/mach-mx3/mx31moboard-marxbot.c       |    1 -
> >  arch/arm/mach-mx3/mx31moboard-smartbot.c      |    1 -
> >  arch/arm/mach-pxa/em-x270.c                   |    1 -
> >  arch/arm/mach-pxa/ezx.c                       |    2 -
> >  arch/arm/mach-pxa/mioa701.c                   |    1 -
> >  arch/arm/mach-pxa/pcm990-baseboard.c          |    2 -
> >  arch/sh/boards/mach-ap325rxa/setup.c          |    1 -
> >  arch/sh/boards/mach-ecovec24/setup.c          |    4 --
> >  arch/sh/boards/mach-kfr2r09/setup.c           |    1 -
> >  arch/sh/boards/mach-migor/setup.c             |    2 -
> >  arch/sh/boards/mach-se/7724/setup.c           |    1 -
> >  drivers/media/radio/radio-si4713.c            |    2 +-
> >  drivers/media/video/au0828/au0828-cards.c     |    4 +-
> >  drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++-----
> >  drivers/media/video/cafe_ccic.c               |    2 +-
> >  drivers/media/video/cx18/cx18-i2c.c           |   22 ++---------
> >  drivers/media/video/cx231xx/cx231xx-cards.c   |    4 +-
> >  drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
> >  drivers/media/video/cx23885/cx23885-video.c   |    4 +-
> >  drivers/media/video/cx88/cx88-cards.c         |    9 ++--
> >  drivers/media/video/cx88/cx88-video.c         |    7 +--
> >  drivers/media/video/davinci/vpfe_capture.c    |    1 -
> >  drivers/media/video/davinci/vpif_capture.c    |    1 -
> >  drivers/media/video/davinci/vpif_display.c    |    2 +-
> >  drivers/media/video/em28xx/em28xx-cards.c     |   18 ++++----
> >  drivers/media/video/fsl-viu.c                 |    2 +-
> >  drivers/media/video/ivtv/ivtv-i2c.c           |   50 +++++--------------------
> >  drivers/media/video/mxb.c                     |   12 +++---
> >  drivers/media/video/pvrusb2/pvrusb2-hdw.c     |   13 +-----
> >  drivers/media/video/saa7134/saa7134-cards.c   |    8 ++--
> >  drivers/media/video/saa7134/saa7134-core.c    |    4 +-
> >  drivers/media/video/sh_vou.c                  |    2 +-
> >  drivers/media/video/soc_camera.c              |    2 +-
> >  drivers/media/video/usbvision/usbvision-i2c.c |    6 +-
> >  drivers/media/video/v4l2-common.c             |   13 ++----
> >  drivers/media/video/vino.c                    |    4 +-
> >  drivers/media/video/zoran/zoran.h             |    2 -
> >  drivers/media/video/zoran/zoran_card.c        |   24 +----------
> >  drivers/staging/go7007/go7007-driver.c        |   43 +--------------------
> >  drivers/staging/go7007/go7007-usb.c           |    2 +-
> >  drivers/staging/go7007/wis-ov7640.c           |    1 +
> >  drivers/staging/go7007/wis-saa7113.c          |    1 +
> >  drivers/staging/go7007/wis-saa7115.c          |    1 +
> >  drivers/staging/go7007/wis-sony-tuner.c       |    1 +
> >  drivers/staging/go7007/wis-tw2804.c           |    1 +
> >  drivers/staging/go7007/wis-tw9903.c           |    1 +
> >  drivers/staging/go7007/wis-uda1342.c          |    1 +
> >  drivers/staging/tm6000/tm6000-cards.c         |    4 +-
> >  include/media/sh_vou.h                        |    1 -
> >  include/media/v4l2-common.h                   |   16 +++-----
> >  51 files changed, 100 insertions(+), 234 deletions(-)
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski
