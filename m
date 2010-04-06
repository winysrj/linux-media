Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41135 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444Ab0DFByo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Apr 2010 21:54:44 -0400
Subject: Re: RFC: new V4L control framework
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004051125.20672.hverkuil@xs4all.nl>
References: <201004041741.51869.hverkuil@xs4all.nl>
	 <1270436282.12543.18.camel@palomino.walls.org>
	 <201004051125.20672.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 05 Apr 2010 21:55:01 -0400
Message-Id: <1270518901.11489.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-04-05 at 11:25 +0200, Hans Verkuil wrote:
> On Monday 05 April 2010 04:58:02 Andy Walls wrote:
> > On Sun, 2010-04-04 at 17:41 +0200, Hans Verkuil wrote:

> > 1. cx18 volume control: av_core subdev has a volume control (which the
> > bridge driver currently reports as it's volume control) and the cs5435
> > subdev has a volume control.
> > 
> > I'd really need them *both* to be controllable by the user.  I'd also
> > like them to appear as a single (bridge driver) volume control to the
> > user - as that is what a user would expect.
> 
> So the bridge driver implements the volume control, but the bridge's s_ctrl
> operation will in turn control the subdev's volume implementation, right?

Yes, I think we're saying the same thing.

The bridge only has one analog audio capture going on at a time and that
volume is what needs to be controlled with the bridge *driver's* s_ctrl.
The actual implementation of volume control for analog audio capture is
performed by different subdevs depending on the input source: av_core
subdev for tuner audio, or cs5345 subdev for line-in audio.


> That's no problem. I do need to add a few utility functions to make this
> easy, though. I realized that I need that anyway when I worked on converting
> bttv yesterday.

Good. :)

> Of course, once we can create device nodes for sub-devices, then the controls
> of the cs5435 will show up there as well so the user can have direct access
> to that volume control. But that's not really for applications, though.

That's convenient.  But yes you are correct.  It is not a control one
would expect an end user app to find and use.


> > 2. ivtv volume control for an AverTV M113 card.  The CX2584x chip is
> > normally the volume control.  However, due to some poor baseband audio
> > noise performance on this card, it is advantagous to adjust the volume
> > control on the WM8739 subdev that feeds I2S audio into the CX2584x chip.
> > Here, I would like a secondary volume control, not an override of the
> > primary.
> > 
> > (Here's my old hack:
> > 	http://linuxtv.org/hg/~awalls/ivtv-avertv-m113/rev/c8f2378a3119 )
> > 
> > 
> > Maybe there's a way to use the control clusters to handle some of this.
> > I'm a bit too tired to figure it all out at the moment.
> 
> Interesting use case. I have several ideas, but I need some time to think
> about it a bit more. Basically you want to be able to merge-and-remap
> controls. Or perhaps even allow some sort of control hierarchy.

Something.  Maybe worst case the user will just have to knwo about the
subdev device node specific volume control and fix it with a start-up
script or module post-install script.

The ideas is really just to crank up the baseband analog audio gain in
as early a stage as possible to improve the noise figure.
http://en.wikipedia.org/wiki/Friis_formulas_for_noise

The WM8739 and CX25841(!) are cascaded on this board, so both sliders
could be active at once.  However, I suspect the CX25841 volume should
be fixed at something less than 0 dB, and the primary volume control
remapped to the WM8739 when using line-in.

Regards,
Andy

