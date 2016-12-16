Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54055 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761671AbcLPQ6K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 11:58:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 16 Dec 2016 18:58:48 +0200
Message-ID: <1788710.LLpCZ7KsYZ@avalon>
In-Reply-To: <bdfa08af-9c27-3f29-25af-312ee2805712@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan> <1604260.508DyjIRC9@avalon> <bdfa08af-9c27-3f29-25af-312ee2805712@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday 15 Dec 2016 07:56:55 Shuah Khan wrote:
> On 12/15/2016 03:39 AM, Laurent Pinchart wrote:
> > On Tuesday 13 Dec 2016 15:23:53 Shuah Khan wrote:

[snip]

> >> Please don't pursue this RFC series that makes mc-core changes until
> >> ompa3 driver problems are addressed. There is no need to change the
> >> core unless it is necessary.
> > 
> > It is necessary as has been explained countless times, and will become
> > more and more necessary as media_device instances get shared between
> > multiple drivers, which is currently attempted *without* reference
> > counting.
> 
> You are probably forgetting the Media Device Allocator API work I did
> to make media_device sharable across media and audio drivers.

I haven't. How could I forget it ? :-) Media device sharing is important, and 
will become even more so in the future.

> Sakari's patches don't address the sharable need.

That's correct.

> I have been asking Sakari to use Media Device Allocator API in his patch
> series for allocating media device.

That's where I disagree. The more we dig the more we realize that the current 
infrastructure is broken. Adding anything on top of a construction that is on 
the verge of collapsing isn't a good idea until the foundations have been 
fixed and consolidated.

> I discussed the conflicts between the work I am doing and Sakari's series
> to find a common ground. But it doesn't look like we are going to get there.

-- 
Regards,

Laurent Pinchart

