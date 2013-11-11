Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13336 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab3KKR2O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 12:28:14 -0500
Message-ID: <5281139D.1050801@linux.intel.com>
Date: Mon, 11 Nov 2013 19:27:57 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, vinod.govindapillai@intel.com
Subject: Re: [PATCH 1/1] v4l: Add frame end event
References: <1383311443-7863-1-git-send-email-sakari.ailus@linux.intel.com> <5280CA88.8030207@xs4all.nl>
In-Reply-To: <5280CA88.8030207@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comments.

Hans Verkuil wrote:
...
> I have no objections to this patch. You do need to adapt drivers/media/platform/omap3isp/ispccdc.c
> a bit since it is using the FRAME_SYNC event and so it should check the id field.

Good point.

> But will you also be upstreaming a driver that uses the SYNC_END?
>
> I don't really want to merge this if nobody is using it.

I agree --- I can't say right now when there could be an upstreamable 
driver using that event. Let's keep it out of the tree for now.

Especially that after giving some thought to the multi stream use cases 
--- now arguing against my own proposal ;-) --- the "id" field would be 
better used to make a difference between different streams, especially 
for the frame start event. We're not exactly running out of possible 
values for the type field.

So I'd now prefer an entirely separate event to tell about the frame 
end, and perhaps add an alias for the frame sync event (FRAME_START). 
(This again is a proof of why things that are not going to get used 
pretty much immediately should almost never be merged.) I can send a 
patch on that as well, and, should someone else need it, that one can be 
merged, naturally after a review.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
