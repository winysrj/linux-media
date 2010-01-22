Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63858 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0AVRK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 12:10:58 -0500
Message-ID: <4B59DC19.1050400@maxwell.research.nokia.com>
Date: Fri, 22 Jan 2010 19:10:49 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 4/7] V4L: Events: Add backend
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <alpine.LNX.2.01.1001181333040.31857@alastor>
In-Reply-To: <alpine.LNX.2.01.1001181333040.31857@alastor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,

Hi, Hans!

> The code looks good, but I'm not so sure about the use of kmem_cache_*. It
> seems serious overkill to me.
> 
> Most of the time there will only be a handful of event messages pending. So
> setting up a kmem_cache for this seems unnecessary to me.
> 
> A much better way to ensure fast event reporting IMHO would be to keep a
> list
> of empty event messages rather than destroying an event after it is
> dequeued.
> 
> So you have two queues per filehandle: pending and empty; initially both
> are
> empty. When a new event has to be queued the code checks if there are
> events
> available for reuse in the empty queue, and if not a new event struct is
> allocated and added to the pending queue.

I actually had this kind of setup there for a while. Then I thought it'd
be too ugly and went for kmem_cache instead.

The other reason is that it's convenient to keep the memory allocated
even if there are no events subscribed or the device isn't open. For
1000 events that's 96 kiB. I guess an unused kmem_cache object consumes
extra memory very little. The cached slabs can be explicitly freed
anyway by the driver.

The size of the kmem_cache also adjusts based on the number of events in
the queue. Allocating kmem_cache objects is fast if they already exist,
too. There can be temporary delays from allocation, of course.

I can bring it back, sure, if you see a fixed allocation better.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
