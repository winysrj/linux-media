Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11483 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKRl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 12:41:27 -0500
Date: Wed, 12 Feb 2014 02:41:19 +0900
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Rob Herring <robherring2@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
Message-id: <20140212024119.7fc96f30.m.chehab@samsung.com>
In-reply-to: <52FA5C5A.1090008@samsung.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
 <20140211145248.GI26684@n2100.arm.linux.org.uk> <8648675.AIXYyYlgXy@avalon>
 <1392136617.6943.33.camel@pizza.hi.pengutronix.de>
 <52FA5C5A.1090008@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Feb 2014 18:22:34 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> (adding Guennadi to Cc)
> 
> On 11/02/14 17:36, Philipp Zabel wrote:
> > Am Dienstag, den 11.02.2014, 16:23 +0100 schrieb Laurent Pinchart:
> >> Hi Russell,
> >>
> >> On Tuesday 11 February 2014 14:52:48 Russell King - ARM Linux wrote:
> >>> On Tue, Feb 11, 2014 at 07:56:33AM -0600, Rob Herring wrote:
> >>>> On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel wrote:
> >>>>> This allows to reuse the same parser code from outside the V4L2
> >>>>> framework, most importantly from display drivers. There have been
> >>>>> patches that duplicate the code (and I am going to send one of my own),
> >>>>> such as
> >>>>> http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> >>>>> and others that parse the same binding in a different way:
> >>>>> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> >>>>>
> >>>>> I think that all common video interface parsing helpers should be moved
> >>>>> to a single place, outside of the specific subsystems, so that it can
> >>>>> be reused by all drivers.
> >>>>
> >>>> Perhaps that should be done rather than moving to drivers/of now and
> >>>> then again to somewhere else.
> >>>
> >>> Do you have a better suggestion where it should move to?
> >>>
> >>> drivers/gpu/drm - no, because v4l2 wants to use it
> >>> drivers/media/video - no, because DRM drivers want to use it
> >>> drivers/video - no, because v4l2 and drm drivers want to use it
> >>
> >> Just pointing out a missing location (which might be rejected due to similar 
> >> concerns), there's also drivers/media, which isn't V4L-specific.
> > 
> > Since drivers/Makefile has media/ in obj-y, moving the graph helpers to
> > drivers/media should technically work.
> > 
> >>> Maybe drivers/of-graph/ ?  Or maybe it's just as good a place to move it
> >>> into drivers/of ?
> > 
> > include/media/of_graph.h,
> > drivers/media/of_graph.c?
> 
> drivers/media sounds like a good alternative to me.

>From my side, I'm ok with putting them at drivers/media. You may add my acked-by
for such change:

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> I would just remove also v4l2_of_{parse/get}* and update the users
> to call of_graph_* directly, there should not be many of them.
> 
> --
> Thanks,
> Sylwester
> 


-- 

Cheers,
Mauro
