Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58697 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab2J0UoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:44:24 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1244051eaa.19
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 13:44:22 -0700 (PDT)
Message-ID: <508C47A4.1090607@gmail.com>
Date: Sat, 27 Oct 2012 22:44:20 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] s5p-fimc: Fix platform entities registration
References: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com> <6007649.66KylGAjOu@avalon> <508933D1.80308@samsung.com>
In-Reply-To: <508933D1.80308@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/25/2012 02:42 PM, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 10/25/2012 01:35 PM, Laurent Pinchart wrote:
>> On Thursday 25 October 2012 11:06:56 Sylwester Nawrocki wrote:
>>> Make sure there is no v4l2_device_unregister_subdev() call
>>> on a subdev which wasn't registered.
>>
>> I'm not implying that this fix is bad, but doesn't the V4L2 core already
>> handle this ? v4l2_device_unregister_subdev() returns immediately without
>> doing anything if the subdev hasn't been registered.
> 
> Indeed, the patch summary might be a bit misleading and incomplete.
> I of course wanted to make sure the platform subdevs are not treated
> as registered when any part of v4l2_device_register_subdev() fails.
> 
> 
> Looking at function v4l2_device_register_subdev(), I'm wondering whether
> line
>   159         sd->v4l2_dev = v4l2_dev;
> 
> shouldn't be moved right before
> 
>   190         spin_lock(&v4l2_dev->lock);
> 
> so sd->v4l2_dev is set only if we return 0 in this function ?

Hmm, no, that would be wrong. Since sd->v4l2_dev needs to be initialized
for sd->internal_ops->registered() and sd->internal_ops->registered() ops.

Still, it is possible that a subdev has the v4l2_dev field initialized and 
is not added to the v4l2_device list of subdevs (v4l2_dev->subdevs). Then 
function v4l2_device_unregister_subdev() checks for valid sd->v4l2_dev and
attempts to remove (not yet added) subdev from v4l2_dev->subdevs.

This subdev (un)registration code seems buggy, unless I'm missing something...

> Since in function v4l2_device_unregister_subdev() there is a check like
> 
>   259         /* return if it isn't registered */
>   260         if (sd == NULL || sd->v4l2_dev == NULL)
>   261                 return;
> 
> i.e. if subdev is not really registered, e.g. internal .registered
> op fails, it should be NULL.
> 
> In my case sd wasn't null since this structure was embedded in
> other one.

--
Regards,
Sylwester

