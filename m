Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51979 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2IIOCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 10:02:03 -0400
Received: by eekc1 with SMTP id c1so568849eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 07:02:02 -0700 (PDT)
Message-ID: <504CA157.4070303@gmail.com>
Date: Sun, 09 Sep 2012 16:01:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 05/28] DocBook: bus_info can no longer be empty.
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <201209081315.15411.hverkuil@xs4all.nl> <504B53E6.6000107@gmail.com> <201209091045.56740.hverkuil@xs4all.nl>
In-Reply-To: <201209091045.56740.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2012 10:45 AM, Hans Verkuil wrote:
>>>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>>>>> index f33dd74..d5b1248 100644
>>>>> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>>>>> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
>>>>> @@ -90,11 +90,17 @@ ambiguities.</entry>
>>>>>     	<entry>__u8</entry>
>>>>>     	<entry><structfield>bus_info</structfield>[32]</entry>
>>>>>     	<entry>Location of the device in the system, a
>>>>> -NUL-terminated ASCII string. For example: "PCI Slot 4". This
>>>>> +NUL-terminated ASCII string. For example: "PCI:0000:05:06.0". This
>>>>>     information is intended for users, to distinguish multiple
>>>>> -identical devices. If no such information is available the field may
>>>>> -simply count the devices controlled by the driver, or contain the
>>>>> -empty string (<structfield>bus_info</structfield>[0] = 0).<!-- XXX pci_dev->slot_name example --></entry>
>>>>> +identical devices. If no such information is available the field must
>>>>> +simply count the devices controlled by the driver ("vivi-000"). The bus_info
>>>>> +must start with "PCI:" for PCI boards, "PCIe:" for PCI Express boards,
>>>>> +"usb-" for USB devices, "I2C:" for i2c devices, "ISA:" for ISA devices and
>>>>> +"parport" for parallel port devices.
>>>>> +For devices without a bus it should start with the driver name, optionally
>>>>
>>>> Most, if not all, devices are on some sort of bus. What would be an example
>>>> of a device "without a bus" ?
>>>
>>> Virtual devices like vivi and platform devices. Or is there some sort of
>>> platform bus?
>>
>> OK, then virtual devices like vivi are indeed not on any bus. But saying so,
>> or implicitly assuming, about platform devices would have been misleading.
>>
>> On ASICs and SoCs such devices are on some kind of on-chip peripheral bus,
>> e.g. AMBA APB/AHB [1].
> 
> Yes, but such busses are internal to the hardware and are not enumerated by
> the kernel. The kernel will generate unique names for e.g. usb and pci busses
> which is used to identify the device on that bus. And that's used also when
> generating the bus_info.

They are not enumerated but are commonly referred to as simple bus or AMBA 
bus and mapped to system address space. See drivers/of/platform.c or 
Documentation/devicetree/usage-model.txt. And the device names must also be 
unique IIRC. platform_bus_type is also often used for devices that don't match 
with any other existing bus_type. One could look at /sys/bus/platform/devices 
for sample list of platform devices.

> That said, I checked drivers/base/platform.c and there is actually a platform
> bus that's created in the kernel for platform devices. So perhaps something
> like platform:devname wouldn't be such a bad idea after all. I'd have to do
> some tests with this to see how it would look.

Yeah, obviously. platform:devname sounds good, bus_info would be then telling 
something about the bus, rather than being a redundant copy of driver's name.

--

Regards,
Sylwester
