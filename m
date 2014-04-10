Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46324 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaDJW2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:28:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 7/9] Print timestamp type and source for dequeued buffers
Date: Fri, 11 Apr 2014 00:28:23 +0200
Message-ID: <1981061.t1Onuu4osC@avalon>
In-Reply-To: <5346E9E1.2080702@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <5116965.JxiWPkm0Gp@avalon> <5346E9E1.2080702@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 April 2014 21:58:41 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > Hi Sakari,
> > 
> > Thank you for the patch.
> > 
> > Given that the timestamp type and source are not supposed to change during
> > streaming, do we really need to print them for every frame ?
> 
> When processing frames from memory to memory (COPY timestamp type), the
> it is entirely possible that the timestamp source changes as the flags
> are copied from the OUTPUT buffer to the CAPTURE buffer.

It's possible, but is it allowed by the V4L2 API ?

> These patches do not support it but it is allowed.
> 
> One option would be to print the source on every frame only when the
> type is COPY. For a program like yavta this might be overly
> sophisticated IMO. :-)

My concern is that this makes the lines output by yavta pretty long.

-- 
Regards,

Laurent Pinchart

