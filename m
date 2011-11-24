Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62567 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KXTFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 14:05:07 -0500
Received: by wwp14 with SMTP id 14so2219298wwp.1
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 11:05:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECE913A.9090001@redhat.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
	<dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com>
	<4ECE79F5.9000402@linuxtv.org>
	<201111241844.23292.hverkuil@xs4all.nl>
	<CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com>
	<4ECE8839.8040606@redhat.com>
	<CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com>
	<4ECE913A.9090001@redhat.com>
Date: Fri, 25 Nov 2011 00:35:06 +0530
Message-ID: <CAHFNz9Lb-1X2NCzGP5qfYcanOHsGm3L03dBSH3JKX7zgVZcfPQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2011 at 12:17 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
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


A DVB alone device shouldn't use V4L, while an existing interface exists.
I have no plans of porting the driver to use DVB and V4L, for DVB
alone operations.
