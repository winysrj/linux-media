Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3HUGsm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 02:48:42 -0400
Message-ID: <5214627E.30503@ti.com>
Date: Wed, 21 Aug 2013 12:17:26 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1436822.NCo0PqzB8p@avalon> <52136C36.1090605@ti.com> <2009747.pxcYsmMib4@avalon>
In-Reply-To: <2009747.pxcYsmMib4@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 20 August 2013 07:26 PM, Laurent Pinchart wrote:
> Hi Archit,
>
> On Tuesday 20 August 2013 18:46:38 Archit Taneja wrote:
>> On Tuesday 20 August 2013 05:09 PM, Laurent Pinchart wrote:
>>
>> <snip>
>>
>>>>>> +static int vpdma_load_firmware(struct vpdma_data *vpdma)
>>>>>> +{
>>>>>> +	int r;
>>>>>> +	struct device *dev = &vpdma->pdev->dev;
>>>>>> +
>>>>>> +	r = request_firmware_nowait(THIS_MODULE, 1,
>>>>>> +		(const char *) VPDMA_FIRMWARE, dev, GFP_KERNEL, vpdma,
>>>>>> +		vpdma_firmware_cb);
>>>>>
>>>>> Is there a reason not to use the synchronous interface ? That would
>>>>> simplify both this code and the callers, as they won't have to check
>>>>> whether the firmware has been correctly loaded.
>>>>
>>>> I'm not clear what you mean by that, the firmware would be stored in the
>>>> filesystem. If the driver is built-in, then the synchronous interface
>>>> wouldn't work unless the firmware is appended to the kernel image. Am I
>>>> missing something here? I'm not very aware of the firmware api.
>>>
>>> request_firmware() would just sleep (with a 30 seconds timeout if I'm not
>>> mistaken) until userspace provides the firmware. As devices are probed
>>> asynchronously (in kernel threads) the system will just boot normally, and
>>> the request_firmware() call will return when the firmware is available.
>>
>> Sorry, I sent the previous mail bit too early.
>>
>> With request_firmware() and the driver built-in, I see that the kernel
>> stalls for 10 seconds at the driver's probe, and the firware loading fails
>> since we didn't enter userspace where the file is.
>>
>> The probing of devices asynchronously with kernel threads makes sense, so
>> it's possible that I'm doing something wrong here. I'll give it a try again
>
> I might have spoken too fast. It looks like module initcalls are not run in
> threads. I've most probably mistaken that with asynchronous probing of hot-
> pluggable devices.
>
> If your driver is built-in then it looks like the correct solution is to build
> the firmware in the kernel image as well, or use the asynchronous API as you
> did.

Okay, thanks for clarifying that.

We could use the request_firmware synchronous version if we call it in 
the open v4l2 file op.

Maybe I could load the firmware when the device is opened the first 
time(one instance).

I'll have to see whether it slows things down, and if I'd need to load 
firmware more often. But I'd probably leave this experiment for later.

Archit



