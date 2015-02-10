Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37459 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbbBJTg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 14:36:56 -0500
Date: Tue, 10 Feb 2015 13:36:21 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Grant Likely <grant.likely@linaro.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: i2c: add support for omnivision's ov2659 sensor
Message-ID: <20150210193620.GA4937@ti.com>
References: <1421365163-29394-1-git-send-email-prabhakar.csengg@gmail.com>
 <3110055.vYzQi51GtK@avalon>
 <CA+V-a8vhRLC2EsKJRjuf1ZyABnSyeLBg+OTOKetzA62Eybqv3w@mail.gmail.com>
 <3367184.gDmyGXufvA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3367184.gDmyGXufvA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote on Thu [2015-Feb-05 16:52:22 +0200]:
> Hi Prabhakar,
> 
> (CC'ing Benoit Parrot)
> 
> On Thursday 05 February 2015 11:55:28 Lad, Prabhakar wrote:
> > On Thu, Feb 5, 2015 at 11:53 AM, Laurent Pinchart wrote:
> > > On Wednesday 04 February 2015 20:55:02 Lad, Prabhakar wrote:
> > >> On Wed, Feb 4, 2015 at 5:03 PM, Laurent Pinchart wrote:
> > >> > On Thursday 15 January 2015 23:39:23 Lad, Prabhakar wrote:
> > >> >> From: Benoit Parrot <bparrot@ti.com>
> > >> >> 
> > >> >> this patch adds support for omnivision's ov2659
> > >> >> sensor.
> > >> >> 
> > >> >> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > >> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > >> >> ---
> > >> >> 
> > >> >>  .../devicetree/bindings/media/i2c/ov2659.txt       |   33 +
> > >> >>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
> > >> >>  MAINTAINERS                                        |   10 +
> > >> >>  drivers/media/i2c/Kconfig                          |   11 +
> > >> >>  drivers/media/i2c/Makefile                         |    1 +
> > >> >>  drivers/media/i2c/ov2659.c                         | 1623 +++++++++++
> > >> >>  include/media/ov2659.h                             |   33 +
> > >> >>  7 files changed, 1712 insertions(+)
> > >> >>  create mode 100644
> > >> >>  Documentation/devicetree/bindings/media/i2c/ov2659.txt
> > >> >>  create mode 100644 drivers/media/i2c/ov2659.c
> > >> >>  create mode 100644 include/media/ov2659.h
> > > 
> > > [snip]
> > > 
> > >> >> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> > >> >> new file mode 100644
> > >> >> index 0000000..ce8ec8d
> > >> >> --- /dev/null
> > >> >> +++ b/drivers/media/i2c/ov2659.c
> > >> >> @@ -0,0 +1,1623 @@
> > > 
> > > [snip]
> > > 
> > >> >> +static const struct ov2659_framesize ov2659_framesizes[] = {
> > >> >> +     { /* QVGA */
> > >> >> +             .width          = 320,
> > >> >> +             .height         = 240,
> > >> >> +             .regs           = ov2659_qvga,
> > >> >> +             .max_exp_lines  = 248,
> > >> >> +     }, { /* VGA */
> > >> >> +             .width          = 640,
> > >> >> +             .height         = 480,
> > >> >> +             .regs           = ov2659_vga,
> > >> >> +             .max_exp_lines  = 498,
> > >> >> +     }, { /* SVGA */
> > >> >> +             .width          = 800,
> > >> >> +             .height         = 600,
> > >> >> +             .regs           = ov2659_svga,
> > >> >> +             .max_exp_lines  = 498,
> > >> >> +     }, { /* XGA */
> > >> >> +             .width          = 1024,
> > >> >> +             .height         = 768,
> > >> >> +             .regs           = ov2659_xga,
> > >> >> +             .max_exp_lines  = 498,
> > >> >> +     }, { /* 720P */
> > >> >> +             .width          = 1280,
> > >> >> +             .height         = 720,
> > >> >> +             .regs           = ov2659_720p,
> > >> >> +             .max_exp_lines  = 498,
> > >> >> +     }, { /* SXGA */
> > >> >> +             .width          = 1280,
> > >> >> +             .height         = 1024,
> > >> >> +             .regs           = ov2659_sxga,
> > >> >> +             .max_exp_lines  = 1048,
> > >> >> +     }, { /* UXGA */
> > >> >> +             .width          = 1600,
> > >> >> +             .height         = 1200,
> > >> >> +             .regs           = ov2659_uxga,
> > >> >> +             .max_exp_lines  = 498,
> > >> >> +     },
> > >> >> +};
> > >> > 
> > >> > That's what bothers me the most about drivers for Omnivision sensors.
> > >> > For some reason (I'd bet on lack of proper documentation) they list a
> > >> > couple of supported resolutions with corresponding register values,
> > >> > instead of computing the register values from the format configured by
> > >> > userspace. That's not the way we want to go. Prabhakar, do you have
> > >> > enough documentation to fix that ?
> > >> 
> > >> I am afraid I have limited documentation here.
> > > 
> > > How limited ? :-) I assume someone has documentation, given that the patch
> > > contains a larger number of #define's with register names.
> > 
> > Yea I don’t have NDA signed with TI/Omnivision :( because I which I
> > lack the documentation.
> 
> And a quick online search doesn't show any leaked datasheet. Wikileaks isn't 
> doing a good job ;-)
> 
> Benoit, do you think this is something that can be fixed ?

Laurent,

I did spend several days (many moons ago) to try and derive a generic
way to set the output resolution dynamically. However even though
the data sheet is somewhat useful, the various working example config
from the vendor make use of several un-documented registers which
make this pretty much unfeasible.

I am afraid we are stuck with this method for the time being.

Regards,
Benoit Parrot

> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
