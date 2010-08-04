Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934810Ab0HDUzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 16:55:48 -0400
Message-ID: <4C59D3FD.9040601@infradead.org>
Date: Wed, 04 Aug 2010 17:56:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v3 0/7] V4L2 subdev userspace API
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008041446.24894.laurent.pinchart@ideasonboard.com> <4C59895C.5090709@infradead.org> <201008042229.32636.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008042229.32636.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2010 17:29, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Wednesday 04 August 2010 17:38:04 Mauro Carvalho Chehab wrote:
>> Em 04-08-2010 09:46, Laurent Pinchart escreveu:
>>> On Monday 12 July 2010 17:25:45 Laurent Pinchart wrote:
>>>> Hi everybody,
>>>>
>>>> Here's the third version of the V4L2 subdev userspace API patches.
>>>> Comments received on the first and second versions have been
>>>> incorporated, including the video_usercopy usage. The generic ioctls
>>>> support patch has been dropped and will be resubmitted later with a use
>>>> case.
>>>
>>> Mauro, is there a chance those patches could get in 2.6.36 ?
>>
>> Unfortunately, the changes are not high.
		      =======
			chances - unfortunately typo ;)
>>
>> I still have lots of patches ready to merge that I received before the
>> start of the merge window waiting for me to handle. As you know, we should
>> first send the patches to linux-next, and wait for a while, before sending
>> them upstream. I won't doubt that this time, we'll have only a 7-days
>> window before -rc1.
>>
>> There are also some other dead lines for this week, including the review of
>> LPC proposals.
>>
>> Finally, one requirement for merging API additions is to have a driver
>> using it. In the past, we had bad experiences of adding things at the
>> kernel API, but waiting for a very long time for a kernel driver using it,
>> as the ones that pushed hard for adding the new API's didn't submitted
>> their drivers timely (on some cased it ended by having a driver using the
>> new API's several kernel versions later). So, even considering that subdev
>> API is ready, we still need to wait for drivers needing it to be
>> submitted. So, the better is to analyse and apply it after the end of the
>> merge window, on a separate branch, merging it at the main branch after
>> receiving a driver needing the new API.
> 
> OK, understood.
> 
> I would still like to get your comments on the patches, if any. Hans has acked 
> them, and I'd like to make sure you're fine with them as well before pushing 
> them internally (the less I break the API/ABI, the better for our userspace 
> developers :-)). I will then keep the patches up-to-date with the mainline 
> kernel until the OMAP3 ISP driver (and the media controller) is ready for 
> submission.

Sure, I'll carefully review it and provide my comments. This is
on my TODO list.

Cheers,
Mauro
