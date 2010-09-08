Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2664 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0IHFRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 01:17:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Wed, 8 Sep 2010 07:17:05 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <201009072321.45377.hverkuil@xs4all.nl> <alpine.LNX.2.00.1009071723430.16562@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1009071723430.16562@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009080717.05857.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wednesday, September 08, 2010 00:29:51 Theodore Kilgore wrote:
> 
> On Tue, 7 Sep 2010, Hans Verkuil wrote:
> 
> > On Tuesday, September 07, 2010 20:42:07 Hans Verkuil wrote:
> > > On Tuesday, September 07, 2010 19:57:18 Jean-Francois Moine wrote:
> > > > On Tue, 7 Sep 2010 17:30:33 +0200
> > > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > 
> > > > > enum v4l2_illuminator {
> > > > >         V4L2_ILLUMINATOR_OFF = 0,
> > > > >         V4L2_ILLUMINATOR_ON = 1,
> > > > > };
> > > > > #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> > > > > #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
> > > > > 
> > > > > enum v4l2_led {
> > > > >         V4L2_LED_AUTO = 0,
> > > > >         V4L2_LED_OFF = 1,
> > > > >         V4L2_LED_ON = 2,
> > > > > };
> > > > > #define V4L2_CID_LED_0              (V4L2_CID_BASE+39)
> > > > > 
> > > > > Simple and straightforward.
> > > > 
> > > > Hi,
> > > > 
> > > > Hans (de Goede), is this OK for you? I think that if we find more
> > > > illuminators or LEDs on some devices, we may add more V4L2_CID_xxx_n
> > > > controls.
> > > > 
> > > > Hans (Verkuil), may we have the same enum's for both light types?
> > > > Something like:
> > > > 
> > > > enum v4l2_light {
> > > > 	V4L2_LIGHT_OFF = 0,
> > > > 	V4L2_LIGHT_ON = 1,
> > > > 	V4L2_LIGHT_AUTO = 2,
> > > > 	V4L2_LIGHT_BLINK = 3,
> > > > };
> > > 
> > > I'm OK with that. Although 'blink' shouldn't be added yet unless we have a
> > > driver that will actually make use of it.
> > 
> > I realized something else: while for us programmers it is perfectly natural
> > to start counting at 0, for the rest of the world it is probably more
> > understandable to start counting at 1. I know it goes against our religion,
> > but sometimes you just have to conform. :-)
> > 
> > Regards,
> > 
> > 	Hans
> 
> Sorry about the long silence from here, but there has been illness in the 
> family. I do keep trying to watch whatever is going on.
> 
> Hans, I agree with your general characterization of the public's 
> perception of 0 versus 1. But on this particular occasion I suspect that 
> the general public would see that 0 corresponds more naturally to "off"
> than 1 does.

Ah, I see I was ambiguous in what I wrote. I referred to the '0' in
V4L2_CID_LED_0/V4L2_CID_ILLUMINATOR_0 (and their corresponding names as
reported to the user as "LED 0"/"Illuminator 0"), not to the 0 in the enum.

Regards,

	Hans

> 
> Hoping that all is well with you and others. 
> 
> Cheers, and this is just my two cents on a trivial issue.
> 
> Theodore Kilgore
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
