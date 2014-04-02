Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2228 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaDBGxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 02:53:11 -0400
Message-ID: <533BB3CA.1030000@xs4all.nl>
Date: Wed, 02 Apr 2014 08:52:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sriakhil Gogineni <sriakhil.gogineni@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Writing a HDMI-CEC device driver for the IT66121
References: <4E127074-D400-4334-874D-7A67CF2D42EB@gmail.com> <533A8708.6030302@xs4all.nl> <3F599A20-E00D-4C0A-B125-B1428774BCFE@gmail.com>
In-Reply-To: <3F599A20-E00D-4C0A-B125-B1428774BCFE@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/01/2014 08:55 PM, Sriakhil Gogineni wrote:
> Hi Hans,
> 
> Thanks for the detailed response. As, much as I would love to have a
> robust, fully functioning implementation for v1, I think it might be
> a a bit of 'over-optimization' to write the complete spec into the
> driver from the beginning.
> 
> The question I ask myself is, "how can we get it mainlined quickly?"
> I'm not sure of the answer but I would like implement and test basic
> features of HDMI-CEC and then add in the more advanced fun stuff ;)

To test CEC you typically need three ioctls: read, write and configure.
It's what we do for our drivers that support CEC. But this can't be
mainlined because the core CEC protocol really needs to be in the
kernel.

> So I'm trying to test out CEC on the hardware I have. Making clean
> interfaces would allow for adaptable between 4l2 devices, drm/kms
> devices and hardware. My question is how can I connect to / test on
> the hardware I have?> 

This might help:

http://www.spinics.net/lists/linux-media/msg29617.html

It's basically what we implemented in our V4L drivers. I have an
implementation of this for the adv7511 driver that I can mail you
off-list if you are interested. But forget about mainlining this as
it is not able to support the newer CEC features as I explained.

Regards,

	Hans

> Best,
> Sri
> 
> On Apr 1, 2014, at 2:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> Hi Sri,
>>
>> On 03/31/14 23:12, Sriakhil Gogineni wrote:
>>> Hi,
>>>
>>> I'm trying to write a HDMI-CEC driver for the Radxa Rock
>>> (Specification - Radxa). I am coming from a software background and
>>> have found libcec and am looking at other implementation.
>>>
>>> I'm wondering how to connect the hardware and software pieces under
>>> Linux / Android.
>>>
>>> I'm not sure if I need to find out what /dev/ its exposed under via
>>> the device tree or determine which register is used from the data
>>> sheet?
>>>
>>> Any advice / tips / pointers would be helpful.
>>
>> There is currently no kernel CEC support available. What makes cec
>> complex is 1) the CEC specification is horrible :-) and 2) a proper cec
>> implementation has to be able to take care of v4l2 devices, drm/kms devices
>> and usb dongles. In addition, at least some of the CEC handling has to
>> take place in the kernel in order to handle the audio return channel,
>> suspend commands, hotplug-over-CEC and such advanced features.
>>
>> I have been working on this, but it is a background project and I never
>> found the time to finish it.
>>
>> My latest code is available here:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cec
>>
>> but it needs more work to make this ready for prime time.
>>
>> It works, but it needs cleanup and cec_claim_log_addrs() needs improvement.
>> Particularly when called from a driver: this needs to be done in non-
>> blocking mode which isn't yet working (in blocking mode the driver would
>> block for an unacceptable amount of time).
>>
>> If you or someone else would be willing to take over, I would have no
>> objections. I have no idea when I might have time to continue work on
>> this.
>>
>> Regards,
>>
>> 	Hans
> 

