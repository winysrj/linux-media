Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1ETVud (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 17:50:33 -0400
Message-ID: <4DD6E221.5080004@redhat.com>
Date: Fri, 20 May 2011 18:50:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105202147.22435.laurent.pinchart@ideasonboard.com> <4DD6D69E.2050701@redhat.com> <201105202329.38977.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105202329.38977.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-05-2011 18:29, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Friday 20 May 2011 23:01:18 Mauro Carvalho Chehab wrote:
>> Em 20-05-2011 16:47, Laurent Pinchart escreveu:
>>> On Friday 20 May 2011 21:16:49 Mauro Carvalho Chehab wrote:
>>>> Em 20-05-2011 12:49, Laurent Pinchart escreveu:
>>>>> On Friday 20 May 2011 17:32:45 Mauro Carvalho Chehab wrote:
>>>>>> Em 15-05-2011 04:48, Laurent Pinchart escreveu:
>>>>>>> Hi Mauro,
>>>>>>>
>>>>>>> The following changes since commit
>>>>>
>>>>> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
>>>>>>>   [media] DVB: return meaningful error codes in dvb_frontend
>>>>>>>   (2011-05-09 05:47:20 +0200)
>>>>>>>
>>>>>>> are available in the git repository at:
>>>>>>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
>>>>>>>
>>>>>>> They replace the git pull request I've sent on Thursday with the same
>>>>>>> subject.
>>>>>>>
>>>>>>> Bob Liu (2):
>>>>>>>       Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
>>>>>>>       uvcvideo: Add support for NOMMU arch
>>>>>>
>>>>>> IMO, such fixes should happen inside the arch bits, and not on each
>>>>>> driver. If this fix is needed for uvc video, the same fix should
>>>>>> probably needed to all other USB drivers, in order to work on NOMMU
>>>>>> arch.
>>>>>>
>>>>>> For now, I'm accepting this as a workaround, but please work on a
>>>>>> generic solution for it.
>>>>>
>>>>> A fix at the arch/ level isn't possible, as drivers need to implement
>>>>> the get_unmapped_area file operation in order to support NOMMU
>>>>> architectures. The proper fix is of course to port uvcvideo to
>>>>> videobuf2, and implement support for NOMMU in videobuf2. Modifications
>>>>> to individual drivers will still be needed to fill the
>>>>> get_unmapped_area operation pointer with a videobuf2 handler though.
>>>>
>>>> This doesn't sound nice, as most people test their drivers only on an
>>>> specific architecture. If the driver can work on more then one
>>>> architecture (e. g. if it is not part of the IP block of some SoC chip,
>>>> but, instead, uses some generic bus like USB or PCI), the driver itself
>>>> shouldn't contain any arch-specific bits. IMO, the proper fix should be
>>>> either at the DMA stuff or somewhere inside the bus driver
>>>> implementation.
>>>
>>> It might not sound nice, but that's how NOMMU works. It needs
>>> get_unmapped_area. If you can get rid of that requirement I'll be happy
>>> to remove NOMMU-specific support from the driver :-)
>>
>> As I said, the patches were added, but we need to work on a better solution
>> than polluting every driver with
>>
>> #if CONFIG_NOMMU
>>
>> just because arm arch is crappy.
> 
> There might be some misunderstanding here (not that ARM doesn't bring its 
> share of issues, we both agree on that :-)). NOMMU has nothing to do with ARM, 
> it's for architectures that have no system MMU. Everything lives in the same 
> address space, so some support is needed from drivers when "mapping" memory to 
> "userspace".

I see. Well, having this inside videobuf2 will hide it from the drivers 
that use it so, it is better than having the same code duplicated into 
all drivers. Yet, we have several streaming stuff spread. Just naming the
most used non-legacy drivers, we have: gspca, videobuf1, videobuf2 and uvcvideo.
There are the other drivers that are currently unmaintained with their own
streaming implementations. If UVC is broken if no MMU, all the other drivers
are also broken.

Maybe we should just make all other drivers, for now, dependent of !NOMMU, 
to avoid showing them to the architectures were they won't work. Or, if the
solution given for UVC is generic enough, to just apply it to the other drivers.

Yet, the better is to have a NOMMU-dependent code inside the arch-specific bits 
(or at least having a default handler that would take care of it for NOMMU, 
that would work for most drivers), to avoid code duplication or having generic
drivers dependent of !NOMMU.

> 
> I'll answer the MC part over the weekend, I need to sleep now :-)

OK.

Mauro.

