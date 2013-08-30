Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43581 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753886Ab3H3QJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 12:09:22 -0400
Date: Fri, 30 Aug 2013 19:08:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Message-ID: <20130830160847.GI2835@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl>
 <2952851.Yc6rv3OV6R@avalon>
 <20130829113339.GH2835@valkosipuli.retiisi.org.uk>
 <8949750.QPjOLDxmxg@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8949750.QPjOLDxmxg@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Aug 30, 2013 at 01:31:44PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 29 August 2013 14:33:39 Sakari Ailus wrote:
> > On Thu, Aug 29, 2013 at 01:25:05AM +0200, Laurent Pinchart wrote:
> > > On Wednesday 28 August 2013 19:39:19 Sakari Ailus wrote:
> > > > On Wed, Aug 28, 2013 at 06:14:44PM +0200, Laurent Pinchart wrote:
> > > > ...
> > > > 
> > > > > > > UVC devices timestamp frames when the frame is captured, not when
> > > > > > > the first pixel is transmitted.
> > > > > > 
> > > > > > I.e. we shouldn't set the SOF flag? "When the frame is captured"
> > > > > > doesn't say much, or almost anything in terms of *when*. The frames
> > > > > > have exposure time and rolling shutter makes a difference, too.
> > > > > 
> > > > > The UVC 1.1 specification defines the timestamp as
> > > > > 
> > > > > "The source clock time in native deviceclock units when the raw frame
> > > > > capture begins."
> > > > > 
> > > > > What devices do in practice may differ :-)
> > > > 
> > > > I think that this should mean start-of-frame - exposure time. I'd really
> > > > wonder if any practical implementation does that however.
> > > 
> > > It's start-of-frame - exposure time - internal delays (UVC webcams are
> > > supposed to report their internal delay value as well).
> > 
> > Do they report it? How about the exposure time?
> 
> It's supposed to be configurable.

Is the exposure reported with the frame so it could be used to construct the
per-frame SOF timestamp?

> > If you know them all you can calculate the SOF timestamp. The fewer
> > timestamps are available for user programs the better.
> > 
> > It's another matter then if there are webcams that report these values
> > wrong.
> 
> There most probably are :-)
> 
> > Then you could get timestamps that are complete garbage. But I guess you
> > could compare them to the current monotonic timestamp and detect such cases.
> > 
> > > > What's your suggestion; should we use the SOF flag for this or do you
> > > > prefer the end-of-frame timestamp instead? I think it'd be quite nice
> > > > for drivers to know which one is which without having to guess, and
> > > > based on the above start-of-frame comes as close to that definition as
> > > > is meaningful.
> > > 
> > > SOF is better than EOF. Do we need a start-of-capture flag, or could we
> > > document SOF as meaning start-of-capture or start-of-reception depending
> > > on what the device can do ?
> > 
> > One possibility is to dedicate a few flags for this; by using three bits
> > we'd get eight different timestamps already. But I have to say that fewer is
> > better. :-)
> 
> Does it really need to be a per-buffer flag ? This seems to be a driver-wide 
> (or at least device-wide) behaviour to me.

Same goes for timestamp clock sources. It was concluded to use buffer flags
for those as well.

Using a control for the purpose would however require quite non-zero amount
of initialisation code from each driver so that would probably need to be
sorted out first.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
