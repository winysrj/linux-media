Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42280 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbbJ0Wu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 18:50:27 -0400
Subject: Re: PCIe capture driver
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
 <5625DDCA.2040203@xs4all.nl>
 <CAJ2oMhJvwZLypAXfYfrwdGLBvpFkVYkAm4POUVxfKEW+Qm7Cdw@mail.gmail.com>
 <562B5178.5040303@xs4all.nl>
 <CAJ2oMhJ1FhMqm_P0h+dzmTUJuvfK=DawPAO-R3duS6-XncsrMQ@mail.gmail.com>
 <562D5DE2.5020406@xs4all.nl>
 <CALzAhNUwq3p8OSG32VfffMbwSnpF_tGyUMmLgk+L-0XOTHZJjQ@mail.gmail.com>
 <CAJ2oMh++Ed43esZi3jnO7SZtc6ySmkmxaydEGPU=PY=UCxhGig@mail.gmail.com>
 <562EA780.7070706@xs4all.nl>
 <CAJ2oMhL+qBVics7596WcxdBD6Dz3YkuBA-PmZhFr-8yx4ioCCA@mail.gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <562FFF9D.3070502@xs4all.nl>
Date: Wed, 28 Oct 2015 07:50:05 +0900
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhL+qBVics7596WcxdBD6Dz3YkuBA-PmZhFr-8yx4ioCCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/27/2015 22:56, Ran Shalit wrote:
> On Tue, Oct 27, 2015 at 12:21 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>
>> On 10/27/2015 02:04, Ran Shalit wrote:
>>> On Mon, Oct 26, 2015 at 1:46 PM, Steven Toth <stoth@kernellabs.com> wrote:
>>>>> No, use V4L2. What you do with the frame after it has been captured
>>>>> into memory has no relevance to the API you use to capture into memory.
>>>>
>>>> Ran, I've built many open and closed source Linux drivers over the
>>>> last 10 years - so I can speak with authority on this.
>>>>
>>>> Hans is absolutely correct, don't make the mistake of going
>>>> proprietary with your API. Take advantage of the massive amount of
>>>> video related frameworks the kernel has to offer. It will get you to
>>>> market faster, assuming your goal is to build a driver that is open
>>>> source. If your licensing prohibits an open source driver solution,
>>>> you'll have no choice but to build your own proprietary API.
>>>>
>>>> --
>>>> Steven Toth - Kernel Labs
>>>> http://www.kernellabs.com
>>>
>>> Hi,
>>>
>>> Thank you very much for these valuable comments.
>>> If I may ask one more on this issue:
>>> Is there an example in linux tree, for a pci device which is used both
>>> as a capture and a display device ? (I've made a search but did not
>>> find any)
>>> The PCIe device we are using will be both a capture device and output
>>> video device (for display).
>>
>> The cobalt driver (drivers/media/pci/cobalt) does exactly that: multiple HDMI inputs and an optional HDMI output (through a daughterboard).
>>
>> Please note: using V4L2 for an output only makes sense if you will be outputting video, if the goal is to output a graphical desktop then the drm/kms API is much more suitable.
>>
>> Regards,
>>
>>         Hans
> 
> Hi Hans,
> 
> Thank you very much for the reference.
> I see that the cobalt card is not for sale ?  If it was it could help
> us in our development.

No, sorry. It's a Cisco-internal card only.
 
> In our case it is more custom design which is based on FPGA:
> 
> Cpu ---PCIe---- FPGA <<<-->>>     3xHD+3xSD inputs & 1xHD(or SD) output
> 
> As I understand there is no product chip which can do the above
> (3xHD+3xSD inputs & 1xHD(or SD) output), that's why the use of FPGA in
> the board design.

The ivtv driver (drivers/media/pci/ivtv) has SD input and output, so that can be a
useful reference for that as well. The Hauppauge PVR-350 board is no longer
sold, but you might be able to pick one up on ebay.

Regards,

	Hans
