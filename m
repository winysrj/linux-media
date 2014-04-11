Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaDKNL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 09:11:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 7/9] Print timestamp type and source for dequeued buffers
Date: Fri, 11 Apr 2014 15:11:55 +0200
Message-ID: <77625335.6btl6flutB@avalon>
In-Reply-To: <53471CD3.3060306@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1981061.t1Onuu4osC@avalon> <53471CD3.3060306@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 11 April 2014 01:36:03 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Thursday 10 April 2014 21:58:41 Sakari Ailus wrote:
> >> Laurent Pinchart wrote:
> >>> Hi Sakari,
> >>> 
> >>> Thank you for the patch.
> >>> 
> >>> Given that the timestamp type and source are not supposed to change
> >>> during streaming, do we really need to print them for every frame ?
> >> 
> >> When processing frames from memory to memory (COPY timestamp type), the
> >> it is entirely possible that the timestamp source changes as the flags
> >> are copied from the OUTPUT buffer to the CAPTURE buffer.
> > 
> > It's possible, but is it allowed by the V4L2 API ?
> 
> The spec states that:
> 
> "The V4L2_BUF_FLAG_TIMESTAMP_COPY timestamp type which is used by e.g. on
> mem-to-mem devices is an exception to the rule: the timestamp source flags
> are copied from the OUTPUT video buffer to the CAPTURE video buffer."
> 
> >> These patches do not support it but it is allowed.
> >> 
> >> One option would be to print the source on every frame only when the
> >> type is COPY. For a program like yavta this might be overly
> >> sophisticated IMO. :-)
> > 
> > My concern is that this makes the lines output by yavta pretty long.
> 
> True as well. I could remove "type/src " from the timestamp source
> information. That's mostly redundant anyway. Then we shouldn't exceed 80
> characters per line that easily anymore.

I think that would be better.
 
> Could this be the time to add a "verbose" option? :-)

Possibly, but then we'll need to discuss what information should be printed in 
verbose mode only :-)

-- 
Regards,

Laurent Pinchart

