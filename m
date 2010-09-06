Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:60595 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0IFHnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 03:43:00 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 6 Sep 2010 13:12:55 +0530
Subject: RE: [PATCH 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build
 without VRFB
Message-ID: <19F8576C6E063C45BE387C64729E739404687B2342@dbde02.ent.ti.com>
References: <1283589705-6723-1-git-send-email-archit@ti.com>
 <19F8576C6E063C45BE387C64729E739404687B222E@dbde02.ent.ti.com>
 <FCCFB4CDC6E5564B9182F639FC35608703114DA270@dbde02.ent.ti.com>
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC35608703114DA270@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> -----Original Message-----
> From: Taneja, Archit
> Sent: Monday, September 06, 2010 9:31 AM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org
> Subject: RE: [PATCH 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build
> without VRFB
> 
> Hi,
> 
> Hiremath, Vaibhav wrote:
> >> -----Original Message-----
> >> From: Taneja, Archit
> >> Sent: Saturday, September 04, 2010 2:12 PM
> >> To: Hiremath, Vaibhav
> >> Cc: linux-omap@vger.kernel.org;
> > linux-media@vger.kernel.org; Taneja,
> >> Archit
> >> Subject: [PATCH 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build
> without
> >> VRFB
> >>
> >> This lets omap_vout driver build and run without VRFB. It works along
> >> the lines of the following patch series:
> >> OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
> >> https://patchwork.kernel.org/patch/105371/
> >>
> >> A variable rotation_type is introduced in omapvideo_info like the way
> >> in omapfb_info to make both vrfb and non vrfb rotation possible.
> >>
> > [Hiremath, Vaibhav] Archit,
> >
> > Currently omap_vout driver only supports VRFB based rotation,
> > it doesn't support SDMA based rotation (unlike OMAPFB) and neither you
> patch
> > adds it.
> 
> [Archit]The above description in the git commit is a mistake from my end.
> The main purpose
> of the patch is to get omap_vout running without VRFB.
> 
> I am not sure if we need to enable SDMA rotation for V4L2 though, we would
> always have
> vrfb and tiler on omap3 and omap4 respectively.
[Hiremath, Vaibhav] No, for me SDMA based rotation doesn't make sense, since SDMA rotation suffers from bandwidth issue. On OMAPFB it has been observed that, DSS throws FIFO underflow error very frequently in SDMA based rotation.


> 
> How do you think things should be handled in the non vrfb case? Should we
> try to get
> rotation running or should the driver return an error if userspace tries
> to enable
> rotation in a non-vrfb mode?
[Hiremath, Vaibhav] We can handle this in 2 ways,

- Driver can return -ERANGE error, in case of OMAP4 (or non-vrfb platform)

- Driver can choose/fall-down 0 degree rotation gracefully

As per V4L2 spec both options are acceptable.

Thanks,
Vaibhav

> 
> Thanks,
> 
> Archit
> 
> >> Since VRFB is tightly coupled with the omap_vout driver, a handful of
> >> vrfb-specific functions have been defined and placed in
> omap_vout_vrfb.c
> >>
> >> This series applies along with the previously submitted patch:
> >> https://patchwork.kernel.org/patch/146401/
> >>
> >> Archit Taneja (2):
> >>   V4L/DVB: OMAP_VOUT: Create a seperate vrfb functions library
> >>   V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb and
> sdram
> >> rotation
> >>
> >>  drivers/media/video/omap/Kconfig          |    1 -
> >>  drivers/media/video/omap/Makefile         |    1 +
> >>  drivers/media/video/omap/omap_vout.c      |  502 ++++++---------------
> ---
> >>  ----- drivers/media/video/omap/omap_vout_vrfb.c |  417
> >>  ++++++++++++++++++++++++ drivers/media/video/omap/omap_vout_vrfb.h |
> 40
> >>  +++ drivers/media/video/omap/omap_voutdef.h   |   26 ++
> >>  6 files changed, 582 insertions(+), 405 deletions(-)  create mode
> >> 100644 drivers/media/video/omap/omap_vout_vrfb.c
> >>  create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
