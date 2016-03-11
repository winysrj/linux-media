Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53131 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbcCKAQV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 19:16:21 -0500
Subject: Re: [PATCH] Revert "[media] au0828: use v4l2_mc_create_media_graph()"
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457493972-4063-1-git-send-email-shuahkh@osg.samsung.com>
 <56E19DDE.9080307@osg.samsung.com> <20160310145309.30c47210@recife.lan>
 <56E1B76E.5030205@osg.samsung.com>
Cc: hans.verkuil@cisco.com, nenggun.kim@samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E20E52.4040006@osg.samsung.com>
Date: Thu, 10 Mar 2016 17:16:18 -0700
MIME-Version: 1.0
In-Reply-To: <56E1B76E.5030205@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2016 11:05 AM, Shuah Khan wrote:
> On 03/10/2016 10:53 AM, Mauro Carvalho Chehab wrote:
>> Em Thu, 10 Mar 2016 09:16:30 -0700
>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>
>>> On 03/08/2016 08:26 PM, Shuah Khan wrote:
>>>> This reverts commit 9822f4173f84cb7c592edb5e1478b7903f69d018.
>>>> This commit breaks au0828_enable_handler() logic to find the tuner.
>>>> Audio, Video, and Digital applications are broken and fail to start
>>>> streaming with tuner busy error even when tuner is free.
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>> ---
>>>>  drivers/media/usb/au0828/au0828-video.c | 103 ++++++++++++++++++++++++++++++--
>>>>  drivers/media/v4l2-core/v4l2-mc.c       |  21 +------
>>>>  2 files changed, 99 insertions(+), 25 deletions(-)
>>>>   
>>>
>>> Hi Mauro,
>>>
>>> Please pull this revert in as soon as possible. Without
>>> the revert, auido, video, and digital applications won't
>>> start even. There is a bug in the common routine introduced
>>> in the commit 9822f4173f84cb7c592edb5e1478b7903f69d018 which
>>> causes the link between source and sink to be not found.
>>> I am testing on WIn-TV HVR 950Q
>>
>> No, this patch didn't seem to have broken anything. The problems
>> you're reporting seem to be related, instead, to this patch:
>>
>> 	https://patchwork.linuxtv.org/patch/33422/
>>
>> I rebased it on the top of the master tree (without reverting this
>> patch).
> 
> I don't think so. I sent https://patchwork.linuxtv.org/patch/33422/
> after I did the revert. I tested with linux_media branch with this
> top commit:
> 
> commit de08b5a8be0df1eb7c796b0fe6b30cf1d03d14a6
> Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Date:   Tue Mar 1 06:31:53 2016 -0300
> 
> when I found the problem and reverting the commit 
> 9822f4173f84cb7c592edb5e1478b7903f69d018 - solved the proble,
> 
> Could you please test with and without the revert.

ok now that we determined in our offline discussions that
the revert does solve the problem and that there is an issue
with the core routine, we can try to debug the core common
routine with the revert in place.

> 
>>
>> Please check if it solved for you.
>>
>> Yet, I'm seeing several troubles with au0828 after your patch series:
>>
>> 1) when both snd-usb-audio and au0828 are compiled as module and not
>> blacklisted, I'm getting some errors:
>> 	http://pastebin.com/nMzr3ueM

I am looking into this problem. I can't reproduce this
on my system. It would be good know the sequence that
led to this. 

I see in the above pastebin:

BUG: sleeping function called from invalid context at mm/slub.c:1289

Resulting from the kzalloc(sizeof(*link), GFP_KERNEL);

In this case media_add_link() is trying to allocate memory
within  spinlock context. media_device_register_entity()
holds mdev->lock.

I think we added this spinlock for a reason. How do we 
handle this case? Can we use GFP_ATOMIC here conditionally?

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
