Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:44630 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2EGEze (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 00:55:34 -0400
Message-ID: <4FA6BF6A.4030902@iki.fi>
Date: Sun, 06 May 2012 21:14:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 2/3] New, more flexible syntax for media-ctl
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi> <14849350.mp0nWfDsvJ@avalon> <20120505130933.GI852@valkosipuli.localdomain> <2542901.vLyHxKHSqR@avalon>
In-Reply-To: <2542901.vLyHxKHSqR@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Saturday 05 May 2012 16:09:33 Sakari Ailus wrote:
...
>> The pixel format and the image size at the pad are clearly format
>> (VIDIOC_SUBDEV_S_FMT) but the other things are related to pads but not
>> format.
>>
>> I see them different kinds of properties of pads. That suggests we might be
>> better renaming the option (-f) to something else as well.
> 
> You like breaking interfaces, don't you ? :-D

I thought you said we have no stable release yet. :-D

The selection interface on subdevs is currently used to change format
related things (cropping and scaling, for example) but it was one of
Sylwester's patches ("V4L: Add auto focus targets to the selections
API") that adds a focus window target to the V4L2 selection interface. I
don't see why it couldn't be present on subdevs, too. That's got nothing
to do with the image format.

I've been pondering a bit using another option to configure things
related to selections. Conveniently "-s" is free. We could leave the
crop things to -f but remove the documentation related to them.

I'm fine with keeping the things as they are for now, too, but in that
case we should recognise that -f will not be for formats only. Or we
split handling selections into separate options, but I don't like that
idea either.

>>> I find the '/' a bit confusing compared to the ' ' (but I think you find
>>> the space confusing compared to '/' :-)). I also wonder whether we
>>> shouldn't just drop 'fmt:', as there can be a single format only.
>>
>> You can set it multiple times, or you may not set it at all. That's why I
>> think we should explicitly say it's the format.
> 
> Not at all makes sense, but why would you set it multiple times ?

I guess that's not a very practical use case, albeit there may be
dependencies between the two: Guennadi had a piece of hardware where the
hardware cropping or scaling capabilities depended on the format. But
not setting it at all definitely is a valid use case.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
