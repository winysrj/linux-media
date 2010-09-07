Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:38137 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0IGWOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 18:14:51 -0400
Date: Tue, 7 Sep 2010 17:29:51 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
In-Reply-To: <201009072321.45377.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.1009071723430.16562@banach.math.auburn.edu>
References: <20100906201105.4029d7e7@tele> <20100907195718.066b2986@tele> <201009072042.07487.hverkuil@xs4all.nl> <201009072321.45377.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>



On Tue, 7 Sep 2010, Hans Verkuil wrote:

> On Tuesday, September 07, 2010 20:42:07 Hans Verkuil wrote:
> > On Tuesday, September 07, 2010 19:57:18 Jean-Francois Moine wrote:
> > > On Tue, 7 Sep 2010 17:30:33 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > 
> > > > enum v4l2_illuminator {
> > > >         V4L2_ILLUMINATOR_OFF = 0,
> > > >         V4L2_ILLUMINATOR_ON = 1,
> > > > };
> > > > #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> > > > #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
> > > > 
> > > > enum v4l2_led {
> > > >         V4L2_LED_AUTO = 0,
> > > >         V4L2_LED_OFF = 1,
> > > >         V4L2_LED_ON = 2,
> > > > };
> > > > #define V4L2_CID_LED_0              (V4L2_CID_BASE+39)
> > > > 
> > > > Simple and straightforward.
> > > 
> > > Hi,
> > > 
> > > Hans (de Goede), is this OK for you? I think that if we find more
> > > illuminators or LEDs on some devices, we may add more V4L2_CID_xxx_n
> > > controls.
> > > 
> > > Hans (Verkuil), may we have the same enum's for both light types?
> > > Something like:
> > > 
> > > enum v4l2_light {
> > > 	V4L2_LIGHT_OFF = 0,
> > > 	V4L2_LIGHT_ON = 1,
> > > 	V4L2_LIGHT_AUTO = 2,
> > > 	V4L2_LIGHT_BLINK = 3,
> > > };
> > 
> > I'm OK with that. Although 'blink' shouldn't be added yet unless we have a
> > driver that will actually make use of it.
> 
> I realized something else: while for us programmers it is perfectly natural
> to start counting at 0, for the rest of the world it is probably more
> understandable to start counting at 1. I know it goes against our religion,
> but sometimes you just have to conform. :-)
> 
> Regards,
> 
> 	Hans

Sorry about the long silence from here, but there has been illness in the 
family. I do keep trying to watch whatever is going on.

Hans, I agree with your general characterization of the public's 
perception of 0 versus 1. But on this particular occasion I suspect that 
the general public would see that 0 corresponds more naturally to "off"
than 1 does.

Hoping that all is well with you and others. 

Cheers, and this is just my two cents on a trivial issue.

Theodore Kilgore
