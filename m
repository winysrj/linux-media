Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1LSLnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 06:43:35 -0500
Date: Mon, 19 Dec 2011 12:43:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1112191237300.23694@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <201112191105.25855.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191113230.23694@axis700.grange>
 <201112191120.40084.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191139560.23694@axis700.grange>
 <CACKLOr0Z4BnB3bHCs8BjhwpwcHBHsZA1rDNrxzDW+z3+-qSRgQ@mail.gmail.com>
 <Pine.LNX.4.64.1112191155340.23694@axis700.grange>
 <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Dec 2011, javier Martin wrote:

> On 19 December 2011 11:58, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Mon, 19 Dec 2011, javier Martin wrote:
> >
> >> On 19 December 2011 11:41, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
> >> >
> >> >> Hi Guennadi,
> >> >>
> >> >> On Monday 19 December 2011 11:13:58 Guennadi Liakhovetski wrote:
> >> >> > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
> >> >> > > On Monday 19 December 2011 09:09:34 Guennadi Liakhovetski wrote:
> >> >> > > > On Mon, 19 Dec 2011, Laurent Pinchart wrote:
> >> >> > > > > On Friday 16 December 2011 10:50:21 Guennadi Liakhovetski wrote:
> >> >> > > > > > On Fri, 16 Dec 2011, Scott Jiang wrote:
> >> >> > > > > > > >> How about this implementation? I know it's not for soc, but I
> >> >> > > > > > > >> post it to give my idea.
> >> >> > > > > > > >> Bridge knows the layout, so it doesn't need to query the
> >> >> > > > > > > >> subdevice.
> >> >> > > > > > > >
> >> >> > > > > > > > Where from? AFAIU, we are talking here about subdevice inputs,
> >> >> > > > > > > > right? In this case about various inputs of the TV decoder. How
> >> >> > > > > > > > shall the bridge driver know about that?
> >> >> > > > > > >
> >> >> > > > > > > I have asked this question before. Laurent reply me:
> >> >> > > > > > > > >> ENUMINPUT as defined by V4L2 enumerates input connectors
> >> >> > > > > > > > >> available on the board. Which inputs the board designer
> >> >> > > > > > > > >> hooked up is something that only the top-level V4L driver
> >> >> > > > > > > > >> will know. Subdevices do not have that information, so
> >> >> > > > > > > > >> enuminputs is not applicable there.
> >> >> > > > > > > > >>
> >> >> > > > > > > > >> Of course, subdevices do have input pins and output pins,
> >> >> > > > > > > > >> but these are assumed to be fixed. With the s_routing ops
> >> >> > > > > > > > >> the top level driver selects which input and output pins
> >> >> > > > > > > > >> are active. Enumeration of those inputs and outputs
> >> >> > > > > > > > >> wouldn't gain you anything as far as I can tell since the
> >> >> > > > > > > > >> subdevice simply does not know which inputs/outputs are
> >> >> > > > > > > > >> actually hooked up. It's the top level driver that has that
> >> >> > > > > > > > >> information (usually passed in through board/card info
> >> >> > > > > > > > >> structures).
> >> >> > > > > >
> >> >> > > > > > Laurent, right, I now remember reading this discussion before. But
> >> >> > > > > > I'm not sure I completely agree:-) Yes, you're right - the board
> >> >> > > > > > decides which pins are routed to which connectors. And it has to
> >> >> > > > > > provide this information to the driver in its platform data. But -
> >> >> > > > > > I think, this information should be provided not to the bridge
> >> >> > > > > > driver, but to respective subdevice drivers, because only they
> >> >> > > > > > know what exactly those interfaces are good for and how to report
> >> >> > > > > > them to the bridge or the user, if we decide to also export this
> >> >> > > > > > information over the subdevice user-space API.
> >> >> > > > > >
> >> >> > > > > > So, I would say, the board has to tell the subdevice driver: yes,
> >> >> > > > > > your inputs 0 and 1 are routed to external connectors. On input 1
> >> >> > > > > > I've put a pullup, it is connected to connector of type X over a
> >> >> > > > > > circuit Y, clocked from your output Z, if the driver needs to know
> >> >> > > > > > all that. And the subdev driver will just tell the bridge only
> >> >> > > > > > what that one needs to know - number of inputs and their
> >> >> > > > > > capabilities.
> >> >> > > > >
> >> >> > > > > That sounds reasonable.
> >> >> > > >
> >> >> > > > Good, this would mean, we need additional subdevice operations along
> >> >> > > > the lines of enum_input and enum_output, and maybe also g_input and
> >> >> > > > g_output?
> >> >> > >
> >> >> > > What about implementing pad support in the subdevice ? Input enumeration
> >> >> > > could then be performed without a subdev operation.
> >> >> >
> >> >> > soc-camera doesn't support pad operations yet.
> >> >>
> >> >> soc-camera doesn't support enum_input yet either, so you need to implement
> >> >> something anyway ;-)
> >> >>
> >> >> You wouldn't need to call a pad operation here, you would just need to iterate
> >> >> through the pads provided by the subdev.
> >> >
> >> > tvp5150 doesn't implement it either yet. So, I would say, it is a better
> >> > solution ATM to fix this functionality independent of the pad-level API.
> >>
> >> I agree,
> >> I cannot contribute to implement pad-level API stuff since I can't
> >> test it with tvp5150.
> >>
> >> Would you accept a patch implementing only S_INPUT?
> >
> > Sorry, maybe I'm missing something, but how would it work? I mean, how can
> > we accept from the user any S_INPUT request with index != 0, if we always
> > return only 0 in reply to ENUM_INPUT? Ok, G_INPUT we could implement
> > internally in soc-camera: return 0 by default, then remember last set
> > input number per soc-camera device / subdev. But ENUM_INPUT?...
> 
> It clearly is not a complete solution but at least it allows setting
> input 0 in broken drivers such as tvp5150 which have input 1 enabled
> by default, while soc-camera assumes input 0 is enabled.

I would really prefer an addition of an .enum_input() video subdev 
operation. Please, try to propose such a patch. If it absolutely gets 
rejected, maybe we can add a hack to soc-camera, returning -ENOSYS or 
-ENOIOCTLCMD in reply to ENUM_INPUT with index > 0, like saying "we have 
no idea, whether this device has any more inputs, than #0, try at your own 
risk." But this would be a user-visible change in behaviour, so, actually 
a bad thing (TM).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
