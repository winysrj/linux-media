Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:32860 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0JNXH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 19:07:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Eino-Ville Talvala" <talvala@stanford.edu>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Fri, 15 Oct 2010 01:08:01 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sung Hee Park <shpark7@stanford.edu>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <201010140058.47236.laurent.pinchart@ideasonboard.com> <4CB69289.6080409@stanford.edu>
In-Reply-To: <4CB69289.6080409@stanford.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010150108.02426.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Eino-Ville,

On Thursday 14 October 2010 07:18:01 Eino-Ville Talvala wrote:
> On 10/13/2010 3:58 PM, Laurent Pinchart wrote:
> > On Thursday 14 October 2010 00:03:33 Eino-Ville Talvala wrote:
> >>   Hi Laurent, linux-media,
> >> 
> >> We've been working on porting our OMAP3 ISP/mt9p031 Frankencamera
> >> framework forward to the current kernel versions (currently, we're
> >> using the N900 ISP driver codebase, which is rather old by now). We'd
> >> been following Sakari's omap3camera tree, but as is clear from this
> >> discussion, that's a bad idea now.
> >> 
> >> (I'd love to just send out our mt9p031 driver code, but we still haven't
> >> sorted out whether we're free to do so - since we're rewriting it a
> >> great deal anyway, it hasn't been a priority to sort out.)
> >> 
> >> I've been handing off dev work on this to the next set of students on
> >> the project, so I haven't been paying much attention to the mailing
> >> lists recently, and I apologize if these questions have had clear
> >> answers already.
> >> 
> >> Assuming one has a driver that works fine on the old v4l2_int_framework
> >> back in .28-n900 kernel version - what is the best way forward to move
> >> it to the 'current best option' framework, whatever that's currently
> >> considered to be for the OMAP3 ISP?  And for whatever option that is,
> >> is there a document somewhere describing what needs to hooked up to
> >> what to make that go, or is the best way to just look at the *-rx51 /
> >> et8ek8 code in the right git repository?
> > 
> > First of all, you need to get the latest OMAP3 ISP driver sources.
> > 
> > The most recent OMAP3 ISP driver for the N900 can be found in the
> > omap3isp- rx51 git tree on gitorious.org (devel branch from
> > http://meego.gitorious.org/maemo-multimedia/omap3isp-rx51). This is the
> > tree used by MeeGo for the OMAP3 ISP camera driver. The driver has been
> > ported to the media controller framework, but the latest changes to the
> > framework are not present in that tree as they break the driver ABI and
> > API. This should be fixed in the future, but I can't give you any time
> > estimate at the moment.
> > 
> > The most recent OMAP3 ISP driver and media controller framework can be
> > found in the pinchartl/media git tree on linuxtv.org
> > (media-0004-omap3isp branch from
> > http://git.linuxtv.org/pinchartl/media.git). This is the tree used for
> > upstream submission of the media controller and OMAP3 ISP driver. The
> > OMAP3 ISP driver implements the latest media controller API, but the
> > tree doesn't contain RX51 camera support.
> > 
> > As I assume you need RX51 camera support (arch/arm/mach-omap2/board-rx51-
> > camera.c, drivers/media/video/et8ek8.c, ...), the easiest solution is to
> > go for the gitorious.org tree. You will need to modify your code later
> > when the OMAP3 ISP driver will hit upstream, but the modifications will
> > be very small (mostly a matter of renaming constants or structure
> > fields).
> > 
> > If you want to play with the latest media controller API, you could go
> > for the linuxtv.org tree and port the RX51 camera support from the
> > gitorious.org tree. That shouldn't be difficult, but time is
> > unfortunately a scarce resource.
> > 
> > For userspace API documentation, run "make htmldocs" on the linuxtv.org
> > tree to generate HTML documentation, and navigate to
> > Documentation/DocBook/media/media_controller.html and
> > Documentation/DocBook/media/subdev.html.
> > 
> > Regarding the v4l2_int framework, your kernel drivers will need to be
> > ported to the V4L2 subdev framework and use pad-level operations. The
> > et8ek8 driver should be a good example. You can also have a look at the
> > mt9t001 driver in the media-mt9t001 branch from the linuxtv.org tree.
> > The subdev pad-level userspace API documentation will also help you
> > understand the in-kernel API.
> > 
> > I hope this information will help you. Feel free to contact me if you
> > have further questions.
> 
> Thanks for the reply!

You're welcome.

> We're not terribly set on requiring rx51 support right - at least, I'm
> assuming we couldn't just use the latest codebase for the ISP/et8ek8
> drivers and get those to compile with the N900's release kernel, and we
> don't want to ask end users to reflash their phone kernels to use our
> programs and API.

The V4L core and media controller frameworks could be ported to the N900's 
release kernel, but I'm not sure it would be worth it. You can use the latest 
OMAP3 ISP driver on the N900 with MeeGo though.

> Mostly, I just want to make sure that we try to ensure the fewest number
> of substantial driver changes in the future, once we've gotten ourselves
> up to the present. So if one of the two options you listed is the way
> things will end up, I'd rather go with that and have a bit more work to
> do if we need to support some other device that looks more like the rx51
> in the future.
> 
> I gather the linux-tv branch is more like how things should end up
> looking like, once the dust settles for a bit.  So we port our driver
> over to that, using the mt9t001 driver as an example of how everything
> should be coded up, that should put us on a track of reasonable stability?

That's correct.

> Also, is there a board file that has the needed sensor device
> registration/power management/etc bits in that tree?

There's the RX51 board code in the gitorious tree. It shouldn't be difficult 
to adapt it to a parallel sensor.

-- 
Regards,

Laurent Pinchart
