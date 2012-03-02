Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60611 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab2CBRyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 12:54:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 09/33] v4l: Add subdev selections documentation
Date: Fri, 02 Mar 2012 18:54:48 +0100
Message-ID: <1742252.0cUhcqmAIQ@avalon>
In-Reply-To: <20120302122439.GC14920@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1714254.ToCjbJ901j@avalon> <20120302122439.GC14920@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 02 March 2012 14:24:40 Sakari Ailus wrote:
> On Tue, Feb 28, 2012 at 12:42:26PM +0100, Laurent Pinchart wrote:
> > On Sunday 26 February 2012 23:42:19 Sakari Ailus wrote:
> > > Laurent Pinchart wrote:
> > > > On Monday 20 February 2012 03:56:48 Sakari Ailus wrote:

> > > >> +      </section>
> > > >> 
> > > >> -      <para>Cropping behaviour on output pads is not defined.</para>
> > > >> +    </section>
> > > >> +
> > > >> +    <section>
> > > >> +      <title>Order of configuration and format propagation</title>
> > > >> +
> > > >> +      <para>Inside subdevs, the order of image processing steps will
> > > >> +      always be from the sink pad towards the source pad. This is
> > > >> also
> > > >> +      reflected in the order in which the configuration must be
> > > >> +      performed by the user: the changes made will be propagated to
> > > >> +      any subsequent stages. If this behaviour is not desired, the
> > > >> +      user must set
> > > >> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag.
> > > > 
> > > > Could you explain what happens when V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG
> > > > is
> > > > set ? Just stating that it doesn't follow the propagation behaviour
> > > > previously described could be understood in many different ways.
> > > 
> > > Good point. How about this:
> > > 
> > > "This flag causes that no propagation of the changes are allowed in any
> > > circumstances. This may also lead the accessed rectangle not being
> > > changed at all,
> > 
> > "The accessed rectangle will likely be adjusted by the driver,"
> 
> Why "likely"? I think it should say "may" instead, but this of course
> depends on what the user asks.

I'm fine with "The accessed rectangle may be adjusted by the driver" (or 
s/may/can/, as adjusting the rectangle is part of the negotiation mechanism 
and is thus more likely than not).

> > > depending on the properties of the underlying hardware.
> > > Some drivers may not support this flag."
> > 
> > What should happen then ? Should the flag be ignored, or should the driver
> > return an error ?
> 
> Only the SMIA++ driver supports this flag so far (as goes for the subdev
> selection interface).
> 
> I think it should be ignored. Consider a situation that we add a new flag
> which most of the drivers are unaware of.
> 
> As we're adding the flag right at the time the interface is introduced, we
> could also require that all drivers must support it. How about that? In that
> case I'd remove the last sentence of that paragraph.

I think I'd like that better. Otherwise applications would be forced to check 
the returned rectangle to find out if the flag was taken into account.

-- 
Regards,

Laurent Pinchart

