Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51504 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZLWKQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 05:16:40 -0500
Message-ID: <4B31EDD1.9010701@maxwell.research.nokia.com>
Date: Wed, 23 Dec 2009 12:15:45 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, hverkuil@xs4all.nl, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 4/7] V4L: Events: Add backend
References: <4B30F713.8070004@maxwell.research.nokia.com>	 <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261530062.3161.29.camel@palomino.walls.org>
In-Reply-To: <1261530062.3161.29.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Andy Walls wrote:
>> +int v4l2_event_pending(struct v4l2_fh *fh)
>> +{
>> +	struct v4l2_events *events =&fh->events;
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	spin_lock_irqsave(&events->lock, flags);
>> +	ret = !list_empty(&events->available);
>> +	spin_unlock_irqrestore(&events->lock, flags);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_pending);
>
> Hi Sakari,
>
> Disabling and restoring local interrupts to check if any events are
> pending seems excessive.
>
> Since you added an atomic_t with the number of events available in patch
> 5/7, why don't you just check that atomic_t here?

Thanks for the comments!

I'll put the fix to patch 5.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
