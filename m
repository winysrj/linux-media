Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59593 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbcFOMJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 08:09:45 -0400
Subject: Re: [PATCH] [media] v4l2-ioctl.c: fix warning due wrong check in
 v4l_cropcap()
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <1465935497-30002-1-git-send-email-javier@osg.samsung.com>
 <5760F114.6010809@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <84124307-c08c-56b9-308e-9ac0fb83696c@osg.samsung.com>
Date: Wed, 15 Jun 2016 08:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <5760F114.6010809@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 06/15/2016 02:09 AM, Hans Verkuil wrote:
> On 06/14/2016 10:18 PM, Javier Martinez Canillas wrote:
>> Commit 95dd7b7e30f3 ("[media] v4l2-ioctl.c: improve cropcap compatibility
>> code") tried to check if both .vidioc_cropcap and .vidioc_g_selection are
>> NULL ops and warn if that was the case, but unfortunately the logic isn't
>> correct and instead checks for .vidioc_cropcap == NULL twice.
>>
>> So the v4l2 core will print the following warning if a driver has the ops
>> .vidioc_g_selection set but no .vidioc_cropcap callback:
> 
> This fix is already queued up for 4.7.
>

Thanks, and sorry for missing that you already had a fix queued for this.
 
> Regards,
> 
> 	Hans
> 
>>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
