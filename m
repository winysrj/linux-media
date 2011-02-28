Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43818 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1B1LT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:19:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Mon, 28 Feb 2011 12:19:37 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <201102281207.34106.laurent.pinchart@ideasonboard.com> <201102281217.12538.hansverk@cisco.com>
In-Reply-To: <201102281217.12538.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281219.38266.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 28 February 2011 12:17:12 Hans Verkuil wrote:
> On Monday, February 28, 2011 12:07:33 Laurent Pinchart wrote:
> > On Monday 28 February 2011 12:02:41 Guennadi Liakhovetski wrote:
> > > On Mon, 28 Feb 2011, Hans Verkuil wrote:

[snip]

> > > > It was my understanding that the streaming would stop if no capture
> > > > buffers are available, requiring a VIDIOC_STREAMON to get it started
> > > > again. Of course, there is nothing wrong with stopping the hardware
> > > > and restarting it again when a new buffer becomes available if that
> > > > can be done efficiently enough. Just as long as userspace doesn't
> > > > notice.
> > > > 
> > > > Note that there are some problems with this anyway: often restarting
> > > > DMA requires resyncing to the video stream, which may lead to lost
> > > > frames. Also, the framecounter in struct v4l2_buffer will probably
> > > > have failed to count the lost frames.
> > > > 
> > > > In my opinion trying this might cause more problems than it solves.
> > > 
> > > So, do I understand it right, that currently there are drivers, that
> > > overwrite the last buffers while waiting for a new one, and ones, that
> > > stop capture for that time.
> 
> Does anyone know which drivers stop capture if there are no buffers
> available? I'm not aware of any.

Do you mean stop capture in a way that requires an explicit VIDIOC_STREAMON ? 
None that I'm aware of (and I think that would violate the spec). If you 
instead mean pause capture and restart it on the next VIDIOC_QBUF, uvcvideo 
(somehow) does that, and the OMAP3 ISP does as well.

> > > None of them violate the spec, but the former will not work with the
> > > "snapshot mode," and the latter will. Since we do not want / cannot
> > > enforce either way, we do need a way to tell the driver to enter the
> > > "snapshot mode" even if only to not overwrite the last buffer, right?

[snip]

> > > Right, but sensors do need it. It is not enough to just tell the sensor
> > > - a per-frame flash is used and let the driver figure out, that it has
> > > to switch to snapshot mode. The snapshot mode has other effects too,
> > > e.g., on some sensors it enables the external trigger pin, which some
> > > designs might want to use also without a flash. Maybe there are also
> > > some other side effects of such snapshot modes on some other sensors,
> > > that I'm not aware of.
> > 
> > This makes me wonder if we need a snapshot mode at all. Why should we tie
> > flash, capture trigger (and other such options that you're not aware of
> > yet :-)) together under a single high-level control (in the general sense,
> > not to be strictly taken as a V4L2 CID) ? Wouldn't it be better to expose
> > those features individually instead ? User might want to use the flash in
> > video capture mode for a stroboscopic effect for instance.
> 
> I think this is certainly a good initial approach.
> 
> Can someone make a list of things needed for flash/snapshot? So don't look
> yet at the implementation, but just start a list of functionalities that
> we need to support. I don't think I have seen that yet.

That's the right approach. I'll ping people internally to see if we have such 
a list already.

-- 
Regards,

Laurent Pinchart
