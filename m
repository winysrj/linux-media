Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46279 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0BUU0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 15:26:04 -0500
Message-ID: <4B8196C6.80209@maxwell.research.nokia.com>
Date: Sun, 21 Feb 2010 22:25:42 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"iivanov@mm-sol.com" <iivanov@mm-sol.com>,
	"gururaj.nagendra@intel.com" <gururaj.nagendra@intel.com>,
	"david.cohen@nokia.com" <david.cohen@nokia.com>
Subject: Re: [PATCH v5 4/6] V4L: Events: Add backend
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <1266607320-9974-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE8944536915B9@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944536915B9@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> Heippa!

Hi, Sergio!

Your lines seem to be over 80 characters long. :I

...
>> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_kevent *kev;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +
>> +	if (list_empty(&events->available)) {
>> +		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +		return -ENOENT;
>> +	}
>> +
>> +	WARN_ON(events->navailable == 0);
> 
> I don't think the above warning will ever happen. Looks a bit over protective to me.

If it does it's a bug somewhere.

> Whenever you update your "events->available" list, you're holding the fh_lock spinlock, so there's no chance that the list of events would contan a different number of elents to what the navailable var is holding. Is it?
> 
> Please correct me if I'm missing something...

At the moment that is true as far as I see it. But if it's changed in
future chances are something goes wrong. It's a simple check but might
save some headaches.

> Or if you insist in checking, you could just have done this instead:
> 
> 	if (list_empty(&events->available) || (events->navailable == 0)) {
> 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 		return -ENOENT;
> 	}
> 
> As it doesn't make sense to proceed if navailable is zero, I believe...

It'd be a bug in the code so it must be WARN_ON().

I think the question is whether the check should be left there or removed.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
