Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1266 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2HNLL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 07:11:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Tue, 14 Aug 2012 13:11:49 +0200
Cc: workshop-2011@linuxtv.org,
	"linux-media" <linux-media@vger.kernel.org>
References: <201208131427.56961.hverkuil@xs4all.nl> <201208141254.34095.hverkuil@xs4all.nl> <2777231.LqxP1P2FHv@avalon>
In-Reply-To: <2777231.LqxP1P2FHv@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208141311.49268.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 13:06:46 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 14 August 2012 12:54:34 Hans Verkuil wrote:
> > On Tue August 14 2012 01:54:16 Laurent Pinchart wrote:
> > > On Monday 13 August 2012 14:27:56 Hans Verkuil wrote:
> > > > Hi all!
> > > > 
> > > > As part of the 2012 Kernel Summit V4L2 workshop I will be discussing a
> > > > bunch of V4L2 ambiguities/improvements.
> > > > 
> > > > I've made a list of all the V4L2 issues and put them in two categories:
> > > > issues that I think are easy to resolve (within a few minutes at most),
> > > > and those that are harder.
> > > > 
> > > > If you think I put something in the easy category that you believe is
> > > > actually hard, then please let me know.
> > > > 
> > > > If you attend the workshop, then please read through this and think
> > > > about it a bit, particularly for the second category.
> > > > 
> > > > If something is unclear, or you think another topic should be added,
> > > > then let me know as well.
> > > 
> > > > Easy:
> > > [snip]
> > > 
> > > > 4) What should a driver return in TRY_FMT/S_FMT if the requested format
> > > > is not supported (possible behaviours include returning the currently
> > > > selected format or a default format).
> > > > 
> > > > The spec says this: "Drivers should not return an error code unless
> > > > the input is ambiguous", but it does not explain what constitutes an
> > > > ambiguous input. Frankly, I can't think of any and in my opinion
> > > > TRY/S_FMT should never return an error other than EINVAL (if the buffer
> > > > type is unsupported)or EBUSY (for S_FMT if streaming is in progress).
> > > > 
> > > > Returning an error for any other reason doesn't help the application
> > > > since the app will have no way of knowing what to do next.
> > > 
> > > That wasn't my point. Drivers should obviously not return an error. Let's
> > > consider the case of a driver supporting YUYV and MJPEG. If the user calls
> > > TRY_FMT or S_FMT with the pixel format set to RGB565, should the driver
> > > return a hardcoded default format (one of YUYV or MJPEG), or the
> > > currently selected format ? In other words, should the pixel format
> > > returned by TRY_FMT or S_FMT when the requested pixel format is not valid
> > > be a fixed default pixel format, or should it depend on the currently
> > > selected pixel format ?
> > 
> > Actually, in this case I would probably choose a YUYV format that is closest
> > to the requested size. If a driver supports both compressed and
> > uncompressed formats, then it should only select a compressed format if the
> > application explicitly asked for it. Handling compressed formats is more
> > complex than uncompressed formats, so that seems a sensible rule.
> 
> That wasn't my point either :-) YUYV/MJPEG was just an example. You can 
> replace MJPEG with UYVY or NV12 above. What I want to know is whether TRY_FMT 
> and S_FMT must, when given a non-supported format, return a fixed supported 
> format or return a supported format that can depend on the currently selected 
> format.
> 
> > The next heuristic I would apply is to choose a format that is closest to
> > the requested size.
> > 
> > So I guess my guidelines would be:
> > 
> > 1) If the pixelformat is not supported, then choose an uncompressed format
> > (if possible) instead.
> > 2) Next choose a format closest to, but smaller than (if possible) the
> > requested size.
> > 
> > But this would be a guideline only, and in the end it should be up to the
> > driver. Just as long TRY/S_FMT always returns a format.

Well, the currently selected format is irrelevant. The user is obviously
requesting something else and the driver should attempt to return something
that is at least somewhat close to what it requested. If that's impossible,
then falling back to some default format is a good choice.

Does that answer the question?

Regards,

	Hans
