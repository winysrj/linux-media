Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60574 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752300AbZFLMPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 08:15:11 -0400
Date: Fri, 12 Jun 2009 14:15:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <200906102351.34219.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906121403300.4843@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <200906102251.57644.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906102311410.4817@axis700.grange>
 <200906102351.34219.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> On Wednesday 10 June 2009 23:30:55 Guennadi Liakhovetski wrote:
> > On Wed, 10 Jun 2009, Hans Verkuil wrote:
> > > My view of this would be that the board specification specifies the
> > > sensor (and possibly other chips) that are on the board. And to me it
> > > makes sense that that also supplies the bus settings. I agree that it
> > > is not complex code, but I think it is also unnecessary code. Why
> > > negotiate if you can just set it?
> >
> > Why force all platforms to set it if the driver is perfectly capable do
> > this itself? As I said - this is not a platform-specific feature, it's
> > chip-specific. What good would it make to have all platforms using
> > mt9t031 to specify, that yes, the chip can use both falling and rising
> > pclk edge, but only active high vsync and hsync?
> 
> ???
> 
> You will just tell the chip what to use. So you set 'use falling edge' and 
> either set 'active high vsync/hsync' or just leave that out since you know 
> the mt9t031 has that fixed. You don't specify in the platform data what the 
> chip can support, that's not relevant. You know what the host expects and 
> you pass that information on to the chip.
> 
> A board designer knows what the host supports, knows what the sensor 
> supports, and knows if he added any inverters on the board, and based on 
> all that information he can just setup these parameters for the sensor 
> chip. Settings that are fixed on the sensor chip he can just ignore, he 
> only need to specify those settings that the sensor really needs.

I'd like to have this resolved somehow (preferably my way of ourse:-)), 
here once again (plus some new) my main arguments:

1. it is very unusual that the board designer has to mandate what signal 
polarity has to be used - only when there's additional logic between the 
capture device and the host. So, we shouldn't overload all boards with 
this information. Board-code authors will be grateful to us!

2. what if you do have an inverter between the two? You'd have to tell the 
sensor to use active high, and the host to use active low, i.e., you need 
two sets of flags.

3. all soc-camera boards rely on this autonegotiation. Do we really want 
(and have) to add this useless information back to them? Back - because, 
yes, we've been there we've done that before, but then we switched to the 
current autonegotiation, which we are perfectly happy with so far (anyone 
dares to object?:-)).

4. the autonegiation code is simple and small, so, I really don't see a 
reason to hardcode something, that we can perfectly autoconfigure.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
