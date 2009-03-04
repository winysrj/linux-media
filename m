Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44695 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZCDWmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 17:42:10 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Curran, Dominic" <dcurran@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Wed, 4 Mar 2009 16:41:54 -0600
Subject: RE: [PATCH 5/5] LDP: Add support for built-in camera
Message-ID: <A24693684029E5489D1D202277BE89442E296EE0@dlee02.ent.ti.com>
In-Reply-To: <96DA7A230D3B2F42BA3EF203A7A1B3B5012EA393AA@dlee07.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



From: Curran, Dominic
> > -----Original Message-----
> > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
> > Sent: Tuesday, March 03, 2009 2:44 PM
> > To: linux-media@vger.kernel.org; linux-omap@vger.kernel.org
> > Cc: Sakari Ailus; Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel)
> Kim;
> > MiaoStanley; Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon,
> Nishanth
> > Subject: [PATCH 5/5] LDP: Add support for built-in camera
> >
> > This patch adds support for the LDP builtin camera sensor:
> >  - Primary sensor (/dev/video4): OV3640 (CSI2).
> >
> > It introduces also a new file for storing all camera sensors board
> > specific related functions, like other platforms do (N800 for example).
> >
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  arch/arm/mach-omap2/Makefile                |    3 +-
> >  arch/arm/mach-omap2/board-ldp-camera.c      |  203
> > +++++++++++++++++++++++++++
> >  arch/arm/mach-omap2/board-ldp.c             |   17 +++
> >  arch/arm/plat-omap/include/mach/board-ldp.h |    1 +
> >  4 files changed, 223 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/mach-omap2/board-ldp-camera.c
> >
> > diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> > index 8888ee6..097bc58 100644
> > --- a/arch/arm/mach-omap2/Makefile
> > +++ b/arch/arm/mach-omap2/Makefile
> > @@ -63,7 +63,8 @@ obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-
> > omap3beagle.o \
> >  					   mmc-twl4030.o \
> >  					   twl4030-generic-scripts.o
> >  obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o \
> > -					   mmc-twl4030.o
> > +					   mmc-twl4030.o \
> > +					   board-ldp-camera.o
> >  obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o \
> >  					   board-apollon-mmc.o	\
> >  					   board-apollon-keys.o
> > diff --git a/arch/arm/mach-omap2/board-ldp-camera.c b/arch/arm/mach-
> > omap2/board-ldp-camera.c
> > new file mode 100644
> > index 0000000..0db085c
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/board-ldp-camera.c
> > @@ -0,0 +1,203 @@
> > +/*
> > + * linux/arch/arm/mach-omap2/board-ldp0-camera.c
> 
> Minor typo, should be:
>  linux/arch/arm/mach-omap2/board-ldp-camera.c

Oops, fixed.

<snip>

> > +
> > +static struct omap34xxcam_sensor_config ov3640_hwc = {
> > +	.sensor_isp = 0,
> > +	.xclk = OMAP34XXCAM_XCLK_B,
> > +	.capture_mem = 2592 * 1944 * 2 * 2,
> 
> Should this be  2048 * 1536 * 2 * 2  ?

Yep, You're right. Fixed.

I'll repost after I fix Felipe Balbi's comments on MT sensor.

Thanks for your time!

Regards,
Sergio
