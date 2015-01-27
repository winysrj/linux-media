Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50636 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbbA0PnM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 10:43:12 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIU009HCEIUF780@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Jan 2015 15:47:18 +0000 (GMT)
Message-id: <54C7B20D.4000103@samsung.com>
Date: Tue, 27 Jan 2015 16:43:09 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: setting volatile v4l2-control
References: <54C79385.2050702@samsung.com> <54C79D47.9090609@xs4all.nl>
In-reply-to: <54C79D47.9090609@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/2015 03:14 PM, Hans Verkuil wrote:
> On 01/27/15 14:32, Jacek Anaszewski wrote:
>> While testing the LED / flash API integration patches
>> I noticed that the v4l2-controls marked as volatile with
>> V4L2_CTRL_FLAG_VOLATILE flag behave differently than I would
>> expect.
>>
>> Let's consider following use case:
>>
>> There is a volatile V4L2_CID_FLASH_INTENSITY v4l2 control with
>> following constraints:
>>
>> min: 1
>> max: 100
>> step: 1
>> def: 1
>>
>> 1. Set the V4L2_CID_FLASH_INTENSITY control to 100.
>>      - as a result s_ctrl op is called
>> 2. Set flash_brightness LED sysfs attribute to 10.
>> 3. Set the V4L2_CID_FLASH_INTENSITY control to 100.
>>      - s_ctrl op isn't called
>>
>> This way we are unable to write a new value to the device, despite
>> that the related setting was changed from the LED subsystem level.
>>
>> I would expect that if a control is marked volatile, then
>> the v4l2-control framework should by default call g_volatile_ctrl
>> op before set and not try to use the cached value.
>>
>> Is there some vital reason for not doing this?
>
> It's rather strange to have a writable volatile control. The semantics
> of this are ambiguous and I don't believe we have ever used such controls
> before.
>
> Actually, the commit log of this patch (never merged) gives some
> background information about this:
>
> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/commit/?h=volatilefix
>
> It's never been merged because I have never been certain how to handle
> such controls. Why do you have such controls in the first place? What
> is it supposed to do?

In case of integrated LED subsystem and V4L2 Flash API [1] a driver
can be accessed from the level of either LED subsystem sysfs interface
or v4l2-flash sub-device. Once the v4l2 sub-device is opened the LED
subsystem sysfs interface is locked, but it gets released on sub-device
closing. Since that moment the driver/device state can be changed
through sysfs interface.

When the sub-device is opened again it cannot be certain that the cached
state of the controls reflects the actual state of the driver/device.

That's why I made the shared settings volatile, maybe abusing the
intended purpose of the related flags.

[1] http://www.spinics.net/lists/linux-media/msg85351.html

-- 
Best Regards,
Jacek Anaszewski
