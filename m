Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57094 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab2JYMnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 08:43:00 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCG0024E8OJOKA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 13:43:31 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MCG0024S8NMR710@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 13:42:58 +0100 (BST)
Message-id: <508933D1.80308@samsung.com>
Date: Thu, 25 Oct 2012 14:42:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] s5p-fimc: Fix platform entities registration
References: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
 <6007649.66KylGAjOu@avalon>
In-reply-to: <6007649.66KylGAjOu@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/25/2012 01:35 PM, Laurent Pinchart wrote:
> On Thursday 25 October 2012 11:06:56 Sylwester Nawrocki wrote:
>> Make sure there is no v4l2_device_unregister_subdev() call
>> on a subdev which wasn't registered.
> 
> I'm not implying that this fix is bad, but doesn't the V4L2 core already 
> handle this ? v4l2_device_unregister_subdev() returns immediately without 
> doing anything if the subdev hasn't been registered.

Indeed, the patch summary might be a bit misleading and incomplete.
I of course wanted to make sure the platform subdevs are not treated
as registered when any part of v4l2_device_register_subdev() fails.


Looking at function v4l2_device_register_subdev(), I'm wondering whether
line
 159         sd->v4l2_dev = v4l2_dev;

shouldn't be moved right before

 190         spin_lock(&v4l2_dev->lock);

so sd->v4l2_dev is set only if we return 0 in this function ?

Since in function v4l2_device_unregister_subdev() there is a check like

 259         /* return if it isn't registered */
 260         if (sd == NULL || sd->v4l2_dev == NULL)
 261                 return;

i.e. if subdev is not really registered, e.g. internal .registered
op fails, it should be NULL.

In my case sd wasn't null since this structure was embedded in
other one.

--

Thanks,
Sylwester

