Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59302 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1LSAvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 19:51:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
Date: Mon, 19 Dec 2011 01:51:39 +0100
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com> <CAHG8p1BLVgO1_vN+Wsk1R6awG+uAht1Z9w542naOO53XqVThOQ@mail.gmail.com> <Pine.LNX.4.64.1112161043280.6572@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1112161043280.6572@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112190151.40165.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 16 December 2011 10:50:21 Guennadi Liakhovetski wrote:
> On Fri, 16 Dec 2011, Scott Jiang wrote:
> > >> How about this implementation? I know it's not for soc, but I post it
> > >> to give my idea.
> > >> Bridge knows the layout, so it doesn't need to query the subdevice.
> > > 
> > > Where from? AFAIU, we are talking here about subdevice inputs, right?
> > > In this case about various inputs of the TV decoder. How shall the
> > > bridge driver know about that?
> > 
> > I have asked this question before. Laurent reply me:
> > > >> ENUMINPUT as defined by V4L2 enumerates input connectors available
> > > >> on the board. Which inputs the board designer hooked up is
> > > >> something that only the top-level V4L driver will know. Subdevices
> > > >> do not have that information, so enuminputs is not applicable
> > > >> there.
> > > >> 
> > > >> Of course, subdevices do have input pins and output pins, but these
> > > >> are assumed to be fixed. With the s_routing ops the top level
> > > >> driver selects which input and output pins are active. Enumeration
> > > >> of those inputs and outputs wouldn't gain you anything as far as I
> > > >> can tell since the subdevice simply does not know which
> > > >> inputs/outputs are actually hooked up. It's the top level driver
> > > >> that has that information (usually passed in through board/card
> > > >> info structures).
> 
> Laurent, right, I now remember reading this discussion before. But I'm not
> sure I completely agree:-) Yes, you're right - the board decides which
> pins are routed to which connectors. And it has to provide this
> information to the driver in its platform data. But - I think, this
> information should be provided not to the bridge driver, but to respective
> subdevice drivers, because only they know what exactly those interfaces
> are good for and how to report them to the bridge or the user, if we
> decide to also export this information over the subdevice user-space API.
> 
> So, I would say, the board has to tell the subdevice driver: yes, your
> inputs 0 and 1 are routed to external connectors. On input 1 I've put a
> pullup, it is connected to connector of type X over a circuit Y, clocked
> from your output Z, if the driver needs to know all that. And the subdev
> driver will just tell the bridge only what that one needs to know - number
> of inputs and their capabilities.

That sounds reasonable.

-- 
Regards,

Laurent Pinchart
