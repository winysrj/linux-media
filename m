Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40457 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2EGKoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 06:44:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 2/3] New, more flexible syntax for media-ctl
Date: Mon, 07 May 2012 12:44:45 +0200
Message-ID: <24750495.xAecYja1VB@avalon>
In-Reply-To: <4FA6BF6A.4030902@iki.fi>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi> <2542901.vLyHxKHSqR@avalon> <4FA6BF6A.4030902@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 06 May 2012 21:14:02 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Saturday 05 May 2012 16:09:33 Sakari Ailus wrote:
> ...
> 
> >> The pixel format and the image size at the pad are clearly format
> >> (VIDIOC_SUBDEV_S_FMT) but the other things are related to pads but not
> >> format.
> >> 
> >> I see them different kinds of properties of pads. That suggests we might
> >> be better renaming the option (-f) to something else as well.
> > 
> > You like breaking interfaces, don't you ? :-D
> 
> I thought you said we have no stable release yet. :-D
> 
> The selection interface on subdevs is currently used to change format
> related things (cropping and scaling, for example) but it was one of
> Sylwester's patches ("V4L: Add auto focus targets to the selections
> API") that adds a focus window target to the V4L2 selection interface. I
> don't see why it couldn't be present on subdevs, too. That's got nothing
> to do with the image format.
> 
> I've been pondering a bit using another option to configure things
> related to selections. Conveniently "-s" is free. We could leave the
> crop things to -f but remove the documentation related to them.

It would then become much more complex to setup a complete pipeline in a 
single command line, unless we completely modify the way the command line is 
parsed.

What would you think about renaming -f to -V (long option --video or --v4l2) ? 
media-ctl will hopefully be used for non-V4L2 devices in the future, so 
subsystem-specific options will likely be needed.

> I'm fine with keeping the things as they are for now, too, but in that
> case we should recognise that -f will not be for formats only. Or we
> split handling selections into separate options, but I don't like that
> idea either.
> 
> >>> I find the '/' a bit confusing compared to the ' ' (but I think you find
> >>> the space confusing compared to '/' :-)). I also wonder whether we
> >>> shouldn't just drop 'fmt:', as there can be a single format only.
> >> 
> >> You can set it multiple times, or you may not set it at all. That's why I
> >> think we should explicitly say it's the format.
> > 
> > Not at all makes sense, but why would you set it multiple times ?
> 
> I guess that's not a very practical use case, albeit there may be
> dependencies between the two: Guennadi had a piece of hardware where the
> hardware cropping or scaling capabilities depended on the format.

We don't have a way to handle that cleanly in the V4L2 API, do we ?

> But not setting it at all definitely is a valid use case.

-- 
Regards,

Laurent Pinchart

