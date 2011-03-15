Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57007 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1COE0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 00:26:13 -0400
Received: by qyk7 with SMTP id 7so2069858qyk.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 21:26:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: subash.rp@gmail.com
In-Reply-To: <AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
References: <4D7DEA68.2050604@samsung.com>
	<AANLkTimA070CdJxDR5A7Yq_e6cRG_0TUFG3Cf1VCBbCh@mail.gmail.com>
	<AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
Date: Tue, 15 Mar 2011 09:56:12 +0530
Message-ID: <AANLkTiknoX52jF_VGrkeCFYfLsQ0_RXNUDrLLxX8tUBZ@mail.gmail.com>
Subject: Re: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
From: Subash Patel <subashrp@gmail.com>
To: Pawel Osciak <pawel@osciak.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Also, there might still be situations where being able to STREAMON
> without buffers queued would be beneficial. For example, enabling the
> device might be a slow/expensive operation and we might prefer to keep
> it running even if we don't want any data at the moment. Even for
> faster devices, being able to keep them on and periodically take a
> snapshot would be faster without having to call STREAMON anyway...

If we are speaking of devices like camera for phone/tabs, then this
will have significant impact on the power consumption.

> Suppose we forced QBUF to be done before STREAMON. This would work,
> but what happens next? What should happen when we want to DQBUF the
> last buffer? If the device couldn't start without any buffers queued,
> can it continue streaming with all of them dequeued? I would guess
> not. So we'd either have to deny DQBUF of the last buffer (which for
> me personally is almost unacceptable) or have the last DQBUF
> automatically cause a STREAMOFF.

I think it depends on hardware's behavior on how it behaves without
any buffers queued. Some hardwares do notify the overflow state
(interrupting for each frame recieved) if there was no buffer queued.
This will ensure even the last frame is DQUEUEd.

Considering the scenario like preview/capture @ 30fps, if there is one
frame loss too, it is acceptable. But that doesnt hold good for
high-speed image capture.

Regards,
Subash

On Tue, Mar 15, 2011 at 8:51 AM, Pawel Osciak <pawel@osciak.com> wrote:
> Hi,
>
> On Mon, Mar 14, 2011 at 03:49, Subash Patel <subashrp@gmail.com> wrote:
>> VIDIOC_STREAMON expects buffers to be queued before hardware part of
>> image/video pipe is enabled. From my experience of V4L2 user space, I
>> have always QBUFfed before invoking the STREAMON. Below is the API
>> specification which also speaks something same:
>>
>
> Not exactly. It says that the API requires buffers to be queued for
> output devices. It does not require any buffers to be queued for input
> devices. Sylwester is right here.
>
> This feature of not having to queue input buffers before STREAMON
> introduces problems to driver implementations and I am personally not
> a big fan of it either. But I'm seeing some additional problems here.
> Suppose we forced QBUF to be done before STREAMON. This would work,
> but what happens next? What should happen when we want to DQBUF the
> last buffer? If the device couldn't start without any buffers queued,
> can it continue streaming with all of them dequeued? I would guess
> not. So we'd either have to deny DQBUF of the last buffer (which for
> me personally is almost unacceptable) or have the last DQBUF
> automatically cause a STREAMOFF. So, for the latter, should
> applications, after they get all the data they wanted, be made to
> always have one more buffer queued as a "throwaway" buffer? This is
> probably the only reasonable solution here, but the applications would
> have to keep count of their queued buffers and be aware of this.
> Also, there might still be situations where being able to STREAMON
> without buffers queued would be beneficial. For example, enabling the
> device might be a slow/expensive operation and we might prefer to keep
> it running even if we don't want any data at the moment. Even for
> faster devices, being able to keep them on and periodically take a
> snapshot would be faster without having to call STREAMON anyway...
>
> --
> Best regards,
> Pawel Osciak
>
