Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42149 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KYQL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 11:11:59 -0500
Received: by vcbfk14 with SMTP id fk14so2172864vcb.19
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 08:11:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECFBC6F.3080607@redhat.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<4ECF8359.5080705@linuxtv.org>
	<4ECF9C92.2040607@redhat.com>
	<201111251622.52582.hverkuil@xs4all.nl>
	<CAHFNz9KkVzJ8719NOJLzcGJPf_LSaSUwNr1KgqSANCtkpX--tA@mail.gmail.com>
	<4ECFBC6F.3080607@redhat.com>
Date: Fri, 25 Nov 2011 21:41:58 +0530
Message-ID: <CAHFNz9+Eyov1NkKPYD=Vf+5KMyqtdciPrQv26EDh0kEsohvtsQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2011 at 9:33 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 25-11-2011 13:58, Manu Abraham escreveu:
>> On Fri, Nov 25, 2011 at 8:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On Friday, November 25, 2011 14:48:02 Mauro Carvalho Chehab wrote:
>>>> Em 25-11-2011 10:00, Andreas Oberritter escreveu:
>>>>> On 24.11.2011 19:47, Mauro Carvalho Chehab wrote:
>>>>>> Em 24-11-2011 16:13, Manu Abraham escreveu:
>>>>>>> On Thu, Nov 24, 2011 at 11:38 PM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em 24-11-2011 16:01, Manu Abraham escreveu:
>>>>>>>>> On Thu, Nov 24, 2011 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>>>>>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>>>>>>>>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>>>>>>>>>> new API, but - pretty please - don't just blindly remove audio.h and
>>>>>>>>>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>>>>>>>>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>>>>>>>>>> those out-of-tree drivers merged, but it isn't possible for many
>>>>>>>>>>> reasons. And even if they were merged, you'd say "Port them and your
>>>>>>>>>>> apps to V4L". No! That's not an option.
>>>>>>>>>>
>>>>>>>>>> I'm not breaking anything. All apps will still work.
>>>>>>>>>>
>>>>>>>>>> One option (and it depends on whether people like it or not) is to have
>>>>>>>>>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>>>>>>>>>> that these headers need to be replaced by the new av7110.h.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> That won't work with other non av7110 hardware.
>>>>>>>>
>>>>>>>> There isn't any non-av7110 driver using it at the Kernel. Anyway, we can put
>>>>>>>> a warning at the existing headers as-is, for now, putting them to be removed
>>>>>>>> for a new kernel version, like 3.4.
>>>>>>>
>>>>>>>
>>>>>>> No, that's not an option. The to-be merged saa716x driver depends on it.
>>>>>>
>>>>>> If the driver is not merged yet, it can be changed.
>>>>>>
>>>>>>> A DVB alone device need not depend V4L2 for it's operation.
>>>>>>
>>>>>> Why not? DVB drivers with IR should implement the input/event/IR API. DVB drivers with net
>>>>>> should implement the Linux Network API.
>>>>>
>>>>> DVB doesn't specify IR. There's no such thing like a DVB IR device.
>>>>>
>>>>> IP over DVB is implemented transparently. No driver needs to do anything
>>>>> but register its device's MAC address, therefore no driver implements
>>>>> the Linux Network API.
>>>>>
>>>>>> There is nothing wrong on using the ALSA API for audio and the V4L2 API for video,
>>>>>> as both API fits the needs for decoding audio and video streams, and new features
>>>>>> could be added there when needed.
>>>>>
>>>>> Yes. There's nothing wrong with it and I'm not complaining. I don't care
>>>>> about the implementation of the API in ivtv either. Just don't remove
>>>>> the API from dvb-core, period.
>>>>>
>>>>>> Duplicated API's that become legacy are removed with time. Just to mention two
>>>>>> notable cases, this happened with the old audio stack (OSS), with the old Wireless
>>>>>> stack.
>>>>>
>>>>> I can still use iwconfig and linux/wireless.h is still available on my
>>>>> system.
>>>>
>>>> Yes, but both iwconfig and the API changed.
>>>>
>>>>> ALSA still provides OSS emulation and the real OSS stack was marked
>>>>> deprecated but still present for ages.
>>>>
>>>> OSS driver submission stopped years ago. I remember it clearly as they denied cx88-oss
>>>> driver submission (2004 or 2005). The saa7134-oss and bttv-oss drivers were dropped in 2007[1]
>>>> in favor of the alsa drivers. The only hardware that are still there at OSS are the
>>>> legacy ones that probably no alsa developer has anymore.
>>>>
>>>> [1] http://kerneltrap.org/mailarchive/linux-kernel/2007/11/9/398438/thread
>>>>
>>>>> In contrast, you want to remove a
>>>>> stable API and introduce a new *completely untested* API between 3.3 and
>>>>> 3.4.
>>>>
>>>> Please read the patches again. The API for the devices are still there:
>>>> any binary compiled for older kernels will still work with av7110 and ivtv.
>>>> With the patches applied, the only difference is that the header file has
>>>> renamed, as they were moved to device-specific headers.
>>>>
>>>> It should be noticed that, while both av7110 and ivtv uses the same ioctl's, av7110
>>>> creates devices over /dev/dvb, while ivtv uses it over /dev/video?. So, in practice,
>>>> each driver has a different API.
>>>>
>>>> There are no plans to remove the API for av7110.
>>>>
>>>> As discussed on this thread, it seems that the agreed plans for the ivtv API is to put
>>>> it into the standard kernel procedure to get rid of legacy API. That means that the API
>>>> will be there for a few kernel versions.
>>>>
>>>> Hans proposal is to remove the ivtv API on 3.8, with seems reasonable. So, the first
>>>> API removal will happen in about 18 months from now (assuming about 2 months per kernel
>>>> version).
>>>>
>>>>>> Do you have any issues that needs to be addressed by the V4L2 API for it to fit
>>>>>> on your needs?
>>>>>
>>>>> I don't want to be forced to use the V4L2 API for no reason and no gain.
>>>>
>>>> As already explained on the other email, there are gains on using it, like the support
>>>> for other types of encoding, the pipeline setup, sub-device control, shared buffer interface
>>>> with GPU, proper support for SoC, etc.
>>>>
>>>> Also, currently, just one device uses it (av7110). I don't think that the chipset is
>>>> still manufactured. At least Google didn't help finding anything:
>>>>       http://www.google.com/search?q=av7110&tbm=shop&hl=en
>>>>
>>>> On the other hand, there are thousands of devices using V4L2 API.
>>>>
>>>> As both API's provide support for decoded video, one API has to be deprecated in favor
>>>> to the other. We should select for deprecation the one that is more restrictive
>>>> and that has just one driver using it.
>>>>
>>>>>
>>>>>>> Also, it doesn't
>>>>>>> make any sense to have device specific headers to be used by an application,
>>>>>>> when drivers share more than one commonality.
>>>>>>
>>>>>> The only in-kernel driver using audio/video/osd is av7110.
>>>>>
>>>>> Once again: Manu is going to submit a new driver soon.
>>>>
>>>> The API is there for several years (since 2002?), with just one driver supporting it.
>>>> It shouldn't be hard to convert Manu's work to the V4L2. I can help him on converting
>>>> his driver to use the V4L2 API if needed.
>>>>
>>>>> You're trying to remove an API that you've never used. The people who
>>>>> use the API want it to stay.
>>>>
>>>> As I said, it will stay there. Nobody will remove av7110 or remove the old API from it.
>>>>
>>>> The idea is that no new driver should use it, as it is a legacy one-driver-only API.
>>>>
>>>> If your complain is about the removal of audio.h, video.h and osd.h, then my proposal is
>>>> to keep it there, writing a text that they are part of a deprecated API, but keeping
>>>> the rest of the patches and not accepting anymore any submission using them, removing
>>>> the ioctl's that aren't used by av7110 from them.
>>>
>>> I have no problem with that. Something along those lines was my initial idea anyway,
>>> but I forgot about it.
>>>
>>> I've taken a quick look at Manu's driver: it uses very few ioctls from audio.h and
>>> video.h and it seems that that driver uses the video device as a classic video output
>>> device able to handle compressed video (I presume an elementary video stream).
>>
>>
>> How will you handle CI+ ? The CI+ descrambler is tightly married to
>> the DVB decoder.
>> So you will move the CA API also to V4L, eventually ?
>
> No. The idea is to integrate frontend, demux and ca at the Media Controller,


You don't understand any godamn thing, do you ? Please do your homework,
before you post crap to the ML.


> in order
> to allow complex devices to use it. This should solve the issues with:
>        drivers/staging/media/cxd2099/
>
> allowing to move it out of staging.


That was pure politics from your side. Many said the same before,
I am not the first one to state that.
