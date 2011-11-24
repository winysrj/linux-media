Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1KXSr2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:47:28 -0500
Message-ID: <4ECE913A.9090001@redhat.com>
Date: Thu, 24 Nov 2011 16:47:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com> <4ECE8839.8040606@redhat.com> <CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com>
In-Reply-To: <CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 16:13, Manu Abraham escreveu:
> On Thu, Nov 24, 2011 at 11:38 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 24-11-2011 16:01, Manu Abraham escreveu:
>>> On Thu, Nov 24, 2011 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On Thursday, November 24, 2011 18:08:05 Andreas Oberritter wrote:
>>>>> Don't break existing Userspace APIs for no reason! It's OK to add the
>>>>> new API, but - pretty please - don't just blindly remove audio.h and
>>>>> video.h. They are in use since many years by av7110, out-of-tree drivers
>>>>> *and more importantly* by applications. Yes, I know, you'd like to see
>>>>> those out-of-tree drivers merged, but it isn't possible for many
>>>>> reasons. And even if they were merged, you'd say "Port them and your
>>>>> apps to V4L". No! That's not an option.
>>>>
>>>> I'm not breaking anything. All apps will still work.
>>>>
>>>> One option (and it depends on whether people like it or not) is to have
>>>> audio.h, video.h and osd.h just include av7110.h and add a #warning
>>>> that these headers need to be replaced by the new av7110.h.
>>>
>>>
>>> That won't work with other non av7110 hardware.
>>
>> There isn't any non-av7110 driver using it at the Kernel. Anyway, we can put
>> a warning at the existing headers as-is, for now, putting them to be removed
>> for a new kernel version, like 3.4.
> 
> 
> No, that's not an option. The to-be merged saa716x driver depends on it.

If the driver is not merged yet, it can be changed.

> A DVB alone device need not depend V4L2 for it's operation.

Why not? DVB drivers with IR should implement the input/event/IR API. DVB drivers with net
should implement the Linux Network API.

There is nothing wrong on using the ALSA API for audio and the V4L2 API for video,
as both API fits the needs for decoding audio and video streams, and new features
could be added there when needed.

Duplicated API's that become legacy are removed with time. Just to mention two
notable cases, this happened with the old audio stack (OSS), with the old Wireless
stack.

Do you have any issues that needs to be addressed by the V4L2 API for it to fit
on your needs?

> Also, it doesn't
> make any sense to have device specific headers to be used by an application,
> when drivers share more than one commonality.

The only in-kernel driver using audio/video/osd is av7110. There are some other
cases on driver-specific API's. The bttv and ivtv drivers used to have it. 
Their private API's were gradually replaced by other API's that are more flexible
and become standardized. In some cases, the same API that used to be private
were moved to the core API

Regards,
Mauro
