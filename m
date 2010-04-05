Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3261 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab0DEJZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 05:25:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: new V4L control framework
Date: Mon, 5 Apr 2010 11:25:20 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201004041741.51869.hverkuil@xs4all.nl> <1270436282.12543.18.camel@palomino.walls.org>
In-Reply-To: <1270436282.12543.18.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004051125.20672.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 April 2010 04:58:02 Andy Walls wrote:
> On Sun, 2010-04-04 at 17:41 +0200, Hans Verkuil wrote:
> > Hi all,
> > 
> > The support in drivers for the V4L2 control API is currently very chaotic.
> > Few if any drivers support the API correctly. Especially the support for the
> > new extended controls is very much hit and miss.
> > 
> > Combine that with the requirements for the upcoming embedded devices that
> > will want to use controls much more actively and you end up with a big mess.
> > 
> > I've wanted to fix this for a long time and last week I finally had the time.
> > 
> > The new framework works like a charm and massively reduces the complexity in
> > drivers when it comes to control handling. And just as importantly, any driver
> > that uses it is fully compliant to the V4L spec. Something that application
> > writers will appreciate.
> > 
> > I have converted the cx2341x.c module and tested it with ivtv since that is
> > by far the most complex example of control handling. The new code is much,
> > much cleaner.
> > 
> > The documentation is available here:
> > 
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/raw-file/9b6708e8293c/linux/Documentation/video4linux/v4l2-controls.txt
> 
> >From reading the Documentation.  Things look very much improved.
> 
> However:
> 
> "When a subdevice is registered with a bridge driver and the ctrl_handler
> fields of both v4l2_subdev and v4l2_device are set, then the controls of the
> subdev will become automatically available in the bridge driver as well. If
> the subdev driver contains controls that already exist in the bridge driver,
> then those will be skipped (so a bridge driver can always override a subdev
> control)."
> 
> I think I have 2 cases where that is undesriable:
> 
> 1. cx18 volume control: av_core subdev has a volume control (which the
> bridge driver currently reports as it's volume control) and the cs5435
> subdev has a volume control.
> 
> I'd really need them *both* to be controllable by the user.  I'd also
> like them to appear as a single (bridge driver) volume control to the
> user - as that is what a user would expect.

So the bridge driver implements the volume control, but the bridge's s_ctrl
operation will in turn control the subdev's volume implementation, right?
That's no problem. I do need to add a few utility functions to make this
easy, though. I realized that I need that anyway when I worked on converting
bttv yesterday.

Of course, once we can create device nodes for sub-devices, then the controls
of the cs5435 will show up there as well so the user can have direct access
to that volume control. But that's not really for applications, though.

> 2. ivtv volume control for an AverTV M113 card.  The CX2584x chip is
> normally the volume control.  However, due to some poor baseband audio
> noise performance on this card, it is advantagous to adjust the volume
> control on the WM8739 subdev that feeds I2S audio into the CX2584x chip.
> Here, I would like a secondary volume control, not an override of the
> primary.
> 
> (Here's my old hack:
> 	http://linuxtv.org/hg/~awalls/ivtv-avertv-m113/rev/c8f2378a3119 )
> 
> 
> Maybe there's a way to use the control clusters to handle some of this.
> I'm a bit too tired to figure it all out at the moment.

Interesting use case. I have several ideas, but I need some time to think
about it a bit more. Basically you want to be able to merge-and-remap
controls. Or perhaps even allow some sort of control hierarchy.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
