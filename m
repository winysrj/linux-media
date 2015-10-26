Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35804 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbJZREY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 13:04:24 -0400
Received: by igbkq10 with SMTP id kq10so63393454igb.0
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 10:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
	<5625DDCA.2040203@xs4all.nl>
	<CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
	<562B5178.5040303@xs4all.nl>
	<CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
	<562D5DE2.5020406@xs4all.nl>
	<CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
Date: Mon, 26 Oct 2015 19:04:23 +0200
Message-ID: <CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
Subject: Re: PCIe capture driver
From: Ran Shalit <ranshalit@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 26, 2015 at 1:46 PM, Steven Toth <stoth@kernellabs.com> wrote:
>> No, use V4L2. What you do with the frame after it has been captured
>> into memory has no relevance to the API you use to capture into memory.
>
> Ran, I've built many open and closed source Linux drivers over the
> last 10 years - so I can speak with authority on this.
>
> Hans is absolutely correct, don't make the mistake of going
> proprietary with your API. Take advantage of the massive amount of
> video related frameworks the kernel has to offer. It will get you to
> market faster, assuming your goal is to build a driver that is open
> source. If your licensing prohibits an open source driver solution,
> you'll have no choice but to build your own proprietary API.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

Hi,

Thank you very much for these valuable comments.
If I may ask one more on this issue:
Is there an example in linux tree, for a pci device which is used both
as a capture and a display device ? (I've made a search but did not
find any)
The PCIe device we are using will be both a capture device and output
video device (for display).

Many Thanks,
Ran
