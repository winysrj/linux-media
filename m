Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2371 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1E1PIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 11:08:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Date: Sat, 28 May 2011 17:08:30 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com> <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com> <20110528104845.GB4991@valkosipuli.localdomain>
In-Reply-To: <20110528104845.GB4991@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281708.30655.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, May 28, 2011 12:48:45 Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, May 25, 2011 at 03:33:51PM +0200, Hans Verkuil wrote:
> > @@ -1800,21 +1801,45 @@ struct v4l2_event_vsync {
> >  	__u8 field;
> >  } __attribute__ ((packed));
> >  
> > +/* Payload for V4L2_EVENT_CTRL */
> > +#define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
> > +#define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
> > +
> > +struct v4l2_event_ctrl {
> > +	__u32 changes;
> > +	__u32 type;
> > +	union {
> > +		__s32 value;
> > +		__s64 value64;
> > +	};
> > +	__u32 flags;
> > +	__s32 minimum;
> > +	__s32 maximum;
> > +	__s32 step;
> > +	__s32 default_value;
> > +} __attribute__ ((packed));
> > +
> 
> One more comment.
> 
> Do we really need type and default_value in the event? They are static, and
> on the other hand, the type should be already defined by the control so
> that's static, as I'd expect default_value would be.

We definitely want the type, since that's one of the first things that code
that handles the event will need (at least, in the case of a qv4l2-type app).
Not having to call queryctrl to get the type is actually quite handy.

If the range values of a control change, then the default_value will typically
also change. So I think it should be reported as well.

> It just looks like this attempts to reimplement what QUERYCTRL does. :-)

Up to a point, yes. I have thought about requiring apps to explicitly call
QUERYCTRL, but then you get race conditions between receiving the event and
calling QUERYCTRL/G_CTRL. To be honest, you still have that in the case of a
string control since you can't pass string values through the event API.

While you do have a few extra integer assignments, you also save unnecessary
ioctl calls in the applications, and those are a lot more expensive.

> Step, min and max values may change, so they are good.
> 
> More fields can be added later on. User space libraries / applications using
> this structure might have different views of its size, though, depending
> which definition they used at compile time. So in principle also this
> structure should have reserved fields, although not having such and still
> changing it might not have any adverse effects at all.
> 
> Btw. why __attribute__ ((packed))?

Prevents having to add code to compat32, particularly with the s64 in there.
It may not be needed, though, in this particular case. I'll have to test
alignment.

Regards,

	Hans

> 
> Regards,
> 
> 
