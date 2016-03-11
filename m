Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:28254 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbcCKPkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 10:40:21 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: pxa_camera: convert to vb2
References: <1457543851-17823-1-git-send-email-robert.jarzmik@free.fr>
	<56E2BD79.9080405@xs4all.nl> <8760wtdtda.fsf@belgarion.home>
	<56E2CF64.9040809@xs4all.nl>
Date: Fri, 11 Mar 2016 16:40:15 +0100
In-Reply-To: <56E2CF64.9040809@xs4all.nl> (Hans Verkuil's message of "Fri, 11
	Mar 2016 15:00:04 +0100")
Message-ID: <87oaal81ls.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 03/11/2016 02:41 PM, Robert Jarzmik wrote:
>> Hans Verkuil <hverkuil@xs4all.nl> writes:
> One area where I would like to see some helper functions is with respect to
> format/media bus processing. I played with this a little bit but it is surprisingly
> hard to do. A lot of devices have all sorts of weird and wonderful exceptions
> that make this quite problematic.

I'm also worried about the initial probing, where the subdevice, be that an I2C
sensor or something else has to be available, ie. the v4l2_async_notifier and
its implications.

>> Ah, that's a special case we need to discuss.
>> I've written in the commit message a chapter about a "special port of this
>> code". This is it.
>> 
>> This usecase is when a user does the following :
>>  - set format to 1280x1024, RGB565
>>  - REQBUF for MMAP buffers
>>  - QBUF, capture, DQBUF
>> 
>>  - then set format to 640x480, RGB565
>>    => here the new format fits in the previously allocated video buffer
>>  - QBUF
>>    => the test in pxa_vb2_prepare() detects this, and calls pxa_buffer_init()
>>    again
>> 
>> Now if this usecase is impossible, then I'll do as you say to simplify the code
>> : use icd->sizeimage, remove the code in pxa_vb2_prepare(), etc ...
>
> Does this actually work with soc-camera? As far as I can see soc-camera returns
> -EBUSY in soc_camera_s_fmt_vid_cap() if you attempt to change the format while
> streaming.

It's not "while streaming" in the described usecase, it's after streaming is
finished actually. I should have added in the third dash VIDIOC_STREAMON before
"capture" and VIDIOC_STREAMOFF after DQBUF. I think it's working, even if I had
not tried recently. I certainly don't care that much about the usecase, and I
won't feel sad dropping it :)

> We theorized about this use-case, but nobody actually implemented it.
> As far as I can see this use-case isn't supported today, so I would certainly not
> implement it for this vb2 conversion.
Fair enough, simpler is better, I'll remove it for v2.

>>> If the latter, then just remove it. If you don't have the memory to allocate
>>> the buffers, then reqbufs will just return ENOMEM. I never saw a reason for
>>> such checks.
>> Okay, that was to be consistent with former driver behavior. This was from the
>> beginning in this driver. If Guennadi doesn't care, then I'll remove that, as he
>> is the original author of this limitation.
>
> I've removed it from other drivers in the past, nobody complained :-)
Good, let's do that here then.

Cheers.

-- 
Robert
