Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1CODV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 23:21:26 -0400
Received: by vxi39 with SMTP id 39so205687vxi.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 20:21:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimA070CdJxDR5A7Yq_e6cRG_0TUFG3Cf1VCBbCh@mail.gmail.com>
References: <4D7DEA68.2050604@samsung.com> <AANLkTimA070CdJxDR5A7Yq_e6cRG_0TUFG3Cf1VCBbCh@mail.gmail.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 14 Mar 2011 20:21:05 -0700
Message-ID: <AANLkTinE_Z3QDWDB1+w1ih0bQ2dC15ynkprqB-nFPeqd@mail.gmail.com>
Subject: Re: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
To: subash.rp@gmail.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Subash Patel <subashrp@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Mar 14, 2011 at 03:49, Subash Patel <subashrp@gmail.com> wrote:
> VIDIOC_STREAMON expects buffers to be queued before hardware part of
> image/video pipe is enabled. From my experience of V4L2 user space, I
> have always QBUFfed before invoking the STREAMON. Below is the API
> specification which also speaks something same:
>

Not exactly. It says that the API requires buffers to be queued for
output devices. It does not require any buffers to be queued for input
devices. Sylwester is right here.

This feature of not having to queue input buffers before STREAMON
introduces problems to driver implementations and I am personally not
a big fan of it either. But I'm seeing some additional problems here.
Suppose we forced QBUF to be done before STREAMON. This would work,
but what happens next? What should happen when we want to DQBUF the
last buffer? If the device couldn't start without any buffers queued,
can it continue streaming with all of them dequeued? I would guess
not. So we'd either have to deny DQBUF of the last buffer (which for
me personally is almost unacceptable) or have the last DQBUF
automatically cause a STREAMOFF. So, for the latter, should
applications, after they get all the data they wanted, be made to
always have one more buffer queued as a "throwaway" buffer? This is
probably the only reasonable solution here, but the applications would
have to keep count of their queued buffers and be aware of this.
Also, there might still be situations where being able to STREAMON
without buffers queued would be beneficial. For example, enabling the
device might be a slow/expensive operation and we might prefer to keep
it running even if we don't want any data at the moment. Even for
faster devices, being able to keep them on and periodically take a
snapshot would be faster without having to call STREAMON anyway...

-- 
Best regards,
Pawel Osciak
