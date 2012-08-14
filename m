Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2408 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HNLcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 07:32:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Tue, 14 Aug 2012 13:32:43 +0200
Cc: workshop-2011@linuxtv.org,
	"linux-media" <linux-media@vger.kernel.org>
References: <201208131427.56961.hverkuil@xs4all.nl> <201208141311.49268.hverkuil@xs4all.nl> <1961858.59LqqANPqn@avalon>
In-Reply-To: <1961858.59LqqANPqn@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208141332.43254.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 13:15:21 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 14 August 2012 13:11:49 Hans Verkuil wrote:
> > On Tue August 14 2012 13:06:46 Laurent Pinchart wrote:
> > > On Tuesday 14 August 2012 12:54:34 Hans Verkuil wrote:
> > > > On Tue August 14 2012 01:54:16 Laurent Pinchart wrote:
> > > > > On Monday 13 August 2012 14:27:56 Hans Verkuil wrote:
> > > > > [snip]
> > > > > 
> > > > > > 4) What should a driver return in TRY_FMT/S_FMT if the requested
> > > > > > format is not supported (possible behaviours include returning the
> > > > > > currently selected format or a default format).
> > > > > > 
> > > > > > The spec says this: "Drivers should not return an error code unless
> > > > > > the input is ambiguous", but it does not explain what constitutes an
> > > > > > ambiguous input. Frankly, I can't think of any and in my opinion
> > > > > > TRY/S_FMT should never return an error other than EINVAL (if the
> > > > > > buffer type is unsupported)or EBUSY (for S_FMT if streaming is in
> > > > > > progress).
> > > > > > 
> > > > > > Returning an error for any other reason doesn't help the application
> > > > > > since the app will have no way of knowing what to do next.
> > > > > 
> > > > > That wasn't my point. Drivers should obviously not return an error.
> > > > > Let's consider the case of a driver supporting YUYV and MJPEG. If the
> > > > > user calls TRY_FMT or S_FMT with the pixel format set to RGB565,
> > > > > should the driver return a hardcoded default format (one of YUYV or
> > > > > MJPEG), or the currently selected format ? In other words, should the
> > > > > pixel format returned by TRY_FMT or S_FMT when the requested pixel
> > > > > format is not valid be a fixed default pixel format, or should it
> > > > > depend on the currently selected pixel format ?
> > > > 
> > > > Actually, in this case I would probably choose a YUYV format that is
> > > > closest to the requested size. If a driver supports both compressed and
> > > > uncompressed formats, then it should only select a compressed format if
> > > > the application explicitly asked for it. Handling compressed formats is
> > > > more complex than uncompressed formats, so that seems a sensible rule.
> > > 
> > > That wasn't my point either :-) YUYV/MJPEG was just an example. You can
> > > replace MJPEG with UYVY or NV12 above. What I want to know is whether
> > > TRY_FMT and S_FMT must, when given a non-supported format, return a fixed
> > > supported format or return a supported format that can depend on the
> > > currently selected format.
> > > 
> > > > The next heuristic I would apply is to choose a format that is closest
> > > > to the requested size.
> > > > 
> > > > So I guess my guidelines would be:
> > > > 
> > > > 1) If the pixelformat is not supported, then choose an uncompressed
> > > > format (if possible) instead.
> > > > 2) Next choose a format closest to, but smaller than (if possible) the
> > > > requested size.
> > > > 
> > > > But this would be a guideline only, and in the end it should be up to
> > > > the driver. Just as long TRY/S_FMT always returns a format.
> > 
> > Well, the currently selected format is irrelevant. The user is obviously
> > requesting something else and the driver should attempt to return something
> > that is at least somewhat close to what it requested. If that's impossible,
> > then falling back to some default format is a good choice.
> > 
> > Does that answer the question?
> 
> Yes it does, and I agree with that. Some drivers return the currently selected 
> format when a non-supported format is requested. I think the spec should be 
> clarified to make it mandatory to return a fixed default format independent of 
> the currently selected format, and non-compliant drivers should be fixed.

I don't know whether it should be mandated. In the end it doesn't matter to the
application: that just wants to get some format that is valid.

It's a good recommendation for drivers, but I do not think that there is anything
wrong as such with drivers that return the current format.

Am I missing something here? Is there any particular advantage of returning a
default fallback format from the point of view of an application?

Regards,

	Hans
