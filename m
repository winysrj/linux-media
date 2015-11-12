Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53696 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbbKLDZz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 22:25:55 -0500
Subject: Re: Slow path and cpu lock warnings - MC Next Gen
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <5640C0F2.9070000@osg.samsung.com>
 <5640C1DA.7040100@osg.samsung.com> <20151111103053.448ac440@recife.lan>
 <56434F37.9070007@osg.samsung.com> <20151111133610.0d2f0923@recife.lan>
 <5643637C.3010205@osg.samsung.com> <5643DC88.10300@osg.samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <564406BB.8020308@osg.samsung.com>
Date: Wed, 11 Nov 2015 20:25:47 -0700
MIME-Version: 1.0
In-Reply-To: <5643DC88.10300@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2015 05:25 PM, Shuah Khan wrote:
> On 11/11/2015 08:49 AM, Shuah Khan wrote:
>> On 11/11/2015 08:36 AM, Mauro Carvalho Chehab wrote:
>>> Em Wed, 11 Nov 2015 07:22:47 -0700
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>
>>>> On 11/11/2015 05:30 AM, Mauro Carvalho Chehab wrote:
>>>>> Em Mon, 09 Nov 2015 08:55:06 -0700
>>>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>>>
>>>>>> On 11/09/2015 08:51 AM, Shuah Khan wrote:
>>>>>>> As I mentioned on the IRC, here is the log for the problems I am seeing.
>>>>>>> I have to do eject HVR 950Q TV stick to see the problem.
>>>>>>>
>>>>>>> mc_next_gen.v8.4 branch with no changes.
>>>>>>>
>>>>>>> I can test and debug this week.
>>>>>>>
>>>>>>> thanks,
>>>>>>> -- Shuah
>>>>>>>   
>>>>>>
>>>>>> Forgot to cc linux-media, just in case others are interested
>>>>>> and have ideas on debugging.
>>>>>>
> 
> snip
> 
>>>>>
>>>>> Sorry, but I fail to see how this is related to the V4L2 subsystem.
>>>>>
>>>>> At least on my eyes, it seems that the bug is somewhere at the Radeon
>>>>> driver.
>>>>>
>>>>
>>>> Mauro,
>>>>
>>>> I think you didn't look down the dmesg far enough. The following is the
>>>> problem I am talking about and you will see media_device_unregister()
>>>> on the stack. This occurs as soon as the device is removed.
>>>
>>> Shuah,
>>>
>>> I saw that, but it is clear, from the above log, that the Radeon
>>> driver is broken and it has some bad lock dependencies with the
>>> driver_attach locks. Any other bad lock report related to the
>>> Radeon driver or driver binding/unbiding code are very likely
>>> related to the above bug.
>>>
>>> You should either fix the bad lock at the Radeon driver or not
>>> load it at all, in order to be able to get any reliable results
>>> about possible locking troubles with the MC drivers with the Kernel
>>> lock tests.
>>>
>>
>> Yeah Radeon driver bug could be making things worse. Did you see
>> any problems with device removal during your testing?
>>
>> ok found the following commit that fixes the problem:
>> 7231ed1a813e0a9d249bbbe58e66ca058aee83e1
>>
>> This went into 4.2-rc4 or rc5. I will test applying just this
>> one patch to mc_next_gen.v8.4 branch and see if device removal
>> problem also goes away.
>>
> 
> Applied the acpi backlight fix and now kernel hangs solid when
> device is removed. I managed to get stack trace enabling sysrq
> and that showed media_device_unregister_entity() attempt to hold
> spin_lock() -> raw_spin_lock() on the stack trace. It is same as
> the one seen in the dmesg I sent.
> 
> I think we have several calls to media_device_unregister_entity()
> from various media core drivers (dvb, v4l2, bridge driver) during
> device removal from their unregister paths. This adds lot of
> contention on the mdev->lock.
> 
> media_device_unregister() calls media_device_unregister_entity()
> as well on all the mdev entities.
> 
> I am not testing with my ALSA patches at the moment. When that
> gets added, media_devnode_is_registered() check to ensure only
> one of them (bridge driver or snd-usb-audio) runs
> media_device_unregister() won't work as the MEDIA_FLAG_REGISTERED
> flag gets cleared towards the end of media_device_unregister().
> media_device_unregister() needs to be safe to be run by these two
> drivers and still do the work only once. media_device_unregister()
> does a lot (removes interface links, interfaces, and then then
> unregister entities before it removes the media device devnode
> file and call media_devnode_unregister() to clear the
> MEDIA_FLAG_REGISTERED bit.
> 
> I see two problems to solve:
> 
> - ensure media_device_unregister() is safe to be called by one
>   or more drivers during device removal (usb disconnect in this
>   case)
> - Reduce contention on mdev->lock during device removal
> 
> I have some ideas on how to do this. I can work on them and send
> patches. Sounds like a plan?
> 

Found a two line fix to the problem. Will send patch tomorrow.
I was able to do device inserts and removals in a row with the
change. It hangs every time device removed without the change.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
