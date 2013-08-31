Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42551 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3HaVlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 17:41:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Date: Sat, 31 Aug 2013 23:43:18 +0200
Message-ID: <2062971.KPW0FZTQyQ@avalon>
In-Reply-To: <20130830160847.GI2835@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl> <8949750.QPjOLDxmxg@avalon> <20130830160847.GI2835@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 30 August 2013 19:08:48 Sakari Ailus wrote:
> On Fri, Aug 30, 2013 at 01:31:44PM +0200, Laurent Pinchart wrote:
> > On Thursday 29 August 2013 14:33:39 Sakari Ailus wrote:
> > > On Thu, Aug 29, 2013 at 01:25:05AM +0200, Laurent Pinchart wrote:
> > > > On Wednesday 28 August 2013 19:39:19 Sakari Ailus wrote:
> > > > > On Wed, Aug 28, 2013 at 06:14:44PM +0200, Laurent Pinchart wrote:
> > > > > ...
> > > > > 
> > > > > > > > UVC devices timestamp frames when the frame is captured, not
> > > > > > > > when the first pixel is transmitted.
> > > > > > > 
> > > > > > > I.e. we shouldn't set the SOF flag? "When the frame is captured"
> > > > > > > doesn't say much, or almost anything in terms of *when*. The
> > > > > > > frames have exposure time and rolling shutter makes a
> > > > > > > difference, too.
> > > > > > 
> > > > > > The UVC 1.1 specification defines the timestamp as
> > > > > > 
> > > > > > "The source clock time in native deviceclock units when the raw
> > > > > > frame capture begins."
> > > > > > 
> > > > > > What devices do in practice may differ :-)
> > > > > 
> > > > > I think that this should mean start-of-frame - exposure time. I'd
> > > > > really wonder if any practical implementation does that however.
> > > > 
> > > > It's start-of-frame - exposure time - internal delays (UVC webcams are
> > > > supposed to report their internal delay value as well).
> > > 
> > > Do they report it? How about the exposure time?
> > 
> > It's supposed to be configurable.
> 
> Is the exposure reported with the frame so it could be used to construct the
> per-frame SOF timestamp?

Not when auto-exposure is turned on I'm afraid :-S

I believe that the capture timestamp makes more sense than the SOF timestamp 
for applications. SOF/EOF are more of a poor man's timestamp in case nothing 
else is available, but when you want to synchronize multiple audio and/or 
video streams the capture timestamp is what you're interested in. I don't 
think converting a capture timestamp to an SOF would be a good idea.

> > > If you know them all you can calculate the SOF timestamp. The fewer
> > > timestamps are available for user programs the better.
> > > 
> > > It's another matter then if there are webcams that report these values
> > > wrong.
> > 
> > There most probably are :-)
> > 
> > > Then you could get timestamps that are complete garbage. But I guess you
> > > could compare them to the current monotonic timestamp and detect such
> > > cases.
> > >
> > > > > What's your suggestion; should we use the SOF flag for this or do
> > > > > you prefer the end-of-frame timestamp instead? I think it'd be quite
> > > > > nice for drivers to know which one is which without having to guess,
> > > > > and based on the above start-of-frame comes as close to that
> > > > > definition as is meaningful.
> > > > 
> > > > SOF is better than EOF. Do we need a start-of-capture flag, or could
> > > > we document SOF as meaning start-of-capture or start-of-reception
> > > > depending on what the device can do ?
> > > 
> > > One possibility is to dedicate a few flags for this; by using three bits
> > > we'd get eight different timestamps already. But I have to say that
> > > fewer is better. :-)
> > 
> > Does it really need to be a per-buffer flag ? This seems to be a
> > driver-wide (or at least device-wide) behaviour to me.
> 
> Same goes for timestamp clock sources. It was concluded to use buffer flags
> for those as well.

Yes, and I don't think I was convinced, so I'm not convinced here either :-)

> Using a control for the purpose would however require quite non-zero amount
> of initialisation code from each driver so that would probably need to be
> sorted out first.

We could also use a capabilities flag.

-- 
Regards,

Laurent Pinchart

