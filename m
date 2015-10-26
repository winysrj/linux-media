Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35222 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbbJZRLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 13:11:03 -0400
Received: by obctp1 with SMTP id tp1so120947044obc.2
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2015 10:11:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
 <5625DDCA.2040203@xs4all.nl> <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
 <562B5178.5040303@xs4all.nl> <CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
 <562D5DE2.5020406@xs4all.nl> <CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
 <CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Mon, 26 Oct 2015 18:10:43 +0100
Message-ID: <CAH-u=82pNpsWVEBaAazRgwHGuUDVd0HQ11JLKU=_KcnMcuKcJg@mail.gmail.com>
Subject: Re: PCIe capture driver
To: Ran Shalit <ranshalit@gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ran,

2015-10-26 18:04 GMT+01:00 Ran Shalit <ranshalit@gmail.com>:
> On Mon, Oct 26, 2015 at 1:46 PM, Steven Toth <stoth@kernellabs.com> wrote:
>>> No, use V4L2. What you do with the frame after it has been captured
>>> into memory has no relevance to the API you use to capture into memory.
>>
>> Ran, I've built many open and closed source Linux drivers over the
>> last 10 years - so I can speak with authority on this.
>>
>> Hans is absolutely correct, don't make the mistake of going
>> proprietary with your API. Take advantage of the massive amount of
>> video related frameworks the kernel has to offer. It will get you to
>> market faster, assuming your goal is to build a driver that is open
>> source. If your licensing prohibits an open source driver solution,
>> you'll have no choice but to build your own proprietary API.
>>
>> --
>> Steven Toth - Kernel Labs
>> http://www.kernellabs.com
>
> Hi,
>
> Thank you very much for these valuable comments.
> If I may ask one more on this issue:
> Is there an example in linux tree, for a pci device which is used both
> as a capture and a display device ? (I've made a search but did not
> find any)
> The PCIe device we are using will be both a capture device and output
> video device (for display).

Is is a custom card ? If not, which one is it ?
And if it is a custom board, then maybe can you at least describe the
inputs and outputs exactly (ideally, the chips used) ?
This would help understand what you problem really is :).

JM
