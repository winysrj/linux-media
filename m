Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:47940 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab1KYMA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 07:00:29 -0500
Message-ID: <4ECF8359.5080705@linuxtv.org>
Date: Fri, 25 Nov 2011 13:00:25 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com> <4ECE8839.8040606@redhat.com> <CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com> <4ECE913A.9090001@redhat.com>
In-Reply-To: <4ECE913A.9090001@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.11.2011 19:47, Mauro Carvalho Chehab wrote:
> Em 24-11-2011 16:13, Manu Abraham escreveu:
>> On Thu, Nov 24, 2011 at 11:38 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 24-11-2011 16:01, Manu Abraham escreveu:
>>>> On Thu, Nov 24, 2011 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>>>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>>>>> new API, but - pretty please - don't just blindly remove audio.h and
>>>>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>>>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>>>>> those out-of-tree drivers merged, but it isn't possible for many
>>>>>> reasons. And even if they were merged, you'd say "Port them and your
>>>>>> apps to V4L". No! That's not an option.
>>>>>
>>>>> I'm not breaking anything. All apps will still work.
>>>>>
>>>>> One option (and it depends on whether people like it or not) is to have
>>>>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>>>>> that these headers need to be replaced by the new av7110.h.
>>>>
>>>>
>>>> That won't work with other non av7110 hardware.
>>>
>>> There isn't any non-av7110 driver using it at the Kernel. Anyway, we can put
>>> a warning at the existing headers as-is, for now, putting them to be removed
>>> for a new kernel version, like 3.4.
>>
>>
>> No, that's not an option. The to-be merged saa716x driver depends on it.
> 
> If the driver is not merged yet, it can be changed.
> 
>> A DVB alone device need not depend V4L2 for it's operation.
> 
> Why not? DVB drivers with IR should implement the input/event/IR API. DVB drivers with net
> should implement the Linux Network API.

DVB doesn't specify IR. There's no such thing like a DVB IR device.

IP over DVB is implemented transparently. No driver needs to do anything
but register its device's MAC address, therefore no driver implements
the Linux Network API.

> There is nothing wrong on using the ALSA API for audio and the V4L2 API for video,
> as both API fits the needs for decoding audio and video streams, and new features
> could be added there when needed.

Yes. There's nothing wrong with it and I'm not complaining. I don't care
about the implementation of the API in ivtv either. Just don't remove
the API from dvb-core, period.

> Duplicated API's that become legacy are removed with time. Just to mention two
> notable cases, this happened with the old audio stack (OSS), with the old Wireless
> stack.

I can still use iwconfig and linux/wireless.h is still available on my
system.

ALSA still provides OSS emulation and the real OSS stack was marked
deprecated but still present for ages. In contrast, you want to remove a
stable API and introduce a new *completely untested* API between 3.3 and
3.4.

> Do you have any issues that needs to be addressed by the V4L2 API for it to fit
> on your needs?

I don't want to be forced to use the V4L2 API for no reason and no gain.

>> Also, it doesn't
>> make any sense to have device specific headers to be used by an application,
>> when drivers share more than one commonality.
> 
> The only in-kernel driver using audio/video/osd is av7110.

Once again: Manu is going to submit a new driver soon.

You're trying to remove an API that you've never used. The people who
use the API want it to stay.

Regards,
Andreas
