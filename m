Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41799 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbaCNJv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 05:51:59 -0400
Message-ID: <5322D117.9060008@ti.com>
Date: Fri, 14 Mar 2014 15:21:19 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 02/14] v4l: ti-vpe: register video device only when
 firmware is loaded
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-3-git-send-email-archit@ti.com> <000001cf3eb2$39817540$ac845fc0$%debski@samsung.com> <53219FE0.8010604@ti.com> <000901cf3ec8$aea34270$0be9c750$%debski@samsung.com>
In-Reply-To: <000901cf3ec8$aea34270$0be9c750$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 13 March 2014 07:59 PM, Kamil Debski wrote:
> Hi,
>
>> From: Archit Taneja [mailto:archit@ti.com]
>> Sent: Thursday, March 13, 2014 1:09 PM
>>
>> Hi Kamil,
>>
>> On Thursday 13 March 2014 05:18 PM, Kamil Debski wrote:
>>> Hi Archit,
>>>
>>>> From: Archit Taneja [mailto:archit@ti.com]
>>>> Sent: Tuesday, March 11, 2014 9:34 AM
>>>>
>>>> vpe fops(vpe_open in particular) should be called only when VPDMA
>>>> firmware is loaded. File operations on the video device are possible
>>>> the moment it is registered.
>>>>
>>>> Currently, we register the video device for VPE at driver probe,
>>>> after calling a vpdma helper to initialize VPDMA and load firmware.
>>>> This function is non-blocking(it calls request_firmware_nowait()),
>>>> and doesn't ensure that the firmware is actually loaded when it
>> returns.
>>>>
>>>> We remove the device registration from vpe probe, and move it to a
>>>> callback provided by the vpe driver to the vpdma library, through
>>>> vpdma_create().
>>>>
>>>> The ready field in vpdma_data is no longer needed since we always
>>>> have firmware loaded before the device is registered.
>>>>
>>>> A minor problem with this approach is that if the
>>>> video_register_device fails(which doesn't really happen), the vpe
>>>> platform device would be registered.
>>>> however, there won't be any v4l2 device corresponding to it.
>>>
>>> Could you explain to me one thing. request_firmware cannot be used in
>>> probe, thus you are using request_firmware_nowait. Why cannot the
>>> firmware be loaded on open with a regular request_firmware that is
>>> waiting?
>>
>> I totally agree with you here. Placing the firmware in open() would
>> probably make more sense.
>>
>> The reason I didn't place it in open() is because I didn't want to
>> release firmware in a corresponding close(), and be in a situation
>> where the firmware is loaded multiple times in the driver's lifetime.
>
> Would it be possible to load firmware in open and release it in remove?
> I know that this would disturb the symmetry between open-release and
> probe-remove. But this could work.

That might work.

Currently, the driver doesn't do any clock management, it just enables 
the clocks in probe, and disables them in remove. I need to check how 
the firmware is dependent on clocks. We could make a better decision 
about where to release the firmware with that information.

Archit

