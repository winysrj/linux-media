Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51689 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1FAHQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 03:16:02 -0400
Date: Wed, 1 Jun 2011 10:15:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Message-ID: <20110601071557.GD4991@valkosipuli.localdomain>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
 <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com>
 <20110528104845.GB4991@valkosipuli.localdomain>
 <201105281708.30655.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105281708.30655.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, May 28, 2011 at 05:08:30PM +0200, Hans Verkuil wrote:
> On Saturday, May 28, 2011 12:48:45 Sakari Ailus wrote:
[clip]
> > Do we really need type and default_value in the event? They are static, and
> > on the other hand, the type should be already defined by the control so
> > that's static, as I'd expect default_value would be.
> 
> We definitely want the type, since that's one of the first things that code
> that handles the event will need (at least, in the case of a qv4l2-type app).
> Not having to call queryctrl to get the type is actually quite handy.
> 
> If the range values of a control change, then the default_value will typically
> also change. So I think it should be reported as well.
> 
> > It just looks like this attempts to reimplement what QUERYCTRL does. :-)
> 
> Up to a point, yes. I have thought about requiring apps to explicitly call
> QUERYCTRL, but then you get race conditions between receiving the event and
> calling QUERYCTRL/G_CTRL. To be honest, you still have that in the case of a
> string control since you can't pass string values through the event API.
> 
> While you do have a few extra integer assignments, you also save unnecessary
> ioctl calls in the applications, and those are a lot more expensive.

Sound good to me.

> > Step, min and max values may change, so they are good.
> > 
> > More fields can be added later on. User space libraries / applications using
> > this structure might have different views of its size, though, depending
> > which definition they used at compile time. So in principle also this
> > structure should have reserved fields, although not having such and still
> > changing it might not have any adverse effects at all.
> > 
> > Btw. why __attribute__ ((packed))?
> 
> Prevents having to add code to compat32, particularly with the s64 in there.
> It may not be needed, though, in this particular case. I'll have to test
> alignment.

We don't have this in a number of user space API structures. I don't have
good access to the code right now but I think struct v4l2_event, for
example, doesn't use it. It would define the memory layout exactly so
perhaps it should be always used?

Cheers,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
