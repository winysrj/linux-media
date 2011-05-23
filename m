Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab1EWUEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 16:04:14 -0400
Message-ID: <4DDABDB7.9050409@redhat.com>
Date: Mon, 23 May 2011 17:04:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Alternate setting 1 must be selected for interface 0
 on the model that I received. Else the rest is identical.
References: <201105231637.39053.hselasky@c2i.net> <201105232117.22890.hselasky@c2i.net> <4DDAB9ED.1020309@redhat.com> <201105232152.49155.hselasky@c2i.net>
In-Reply-To: <201105232152.49155.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 16:52, Hans Petter Selasky escreveu:
> On Monday 23 May 2011 21:47:57 Mauro Carvalho Chehab wrote:
>> Em 23-05-2011 16:17, Hans Petter Selasky escreveu:
>>> On Monday 23 May 2011 21:06:32 Mauro Carvalho Chehab wrote:
>>>> Em 23-05-2011 15:48, Hans Petter Selasky escreveu:
>>>>> On Monday 23 May 2011 20:14:45 Mauro Carvalho Chehab wrote:
>>>>>> Em 23-05-2011 11:37, Hans Petter Selasky escreveu:
>>>>>>
>>>>>> I don't have any ttusb device here, but I doubt that this would work.
>>>>>
>>>>> Hi,
>>>>>
>>>>> It is already tested and works fine.
>>>>
>>>> This will work for you, but it will likely break for the others. Your
>>>> patch is assuming that returning an error if selecting alt 1 is enough
>>>> to know that alt 0 should be used.
>>>>
>>>>> What I see is that interface 1 does not have an alternate setting like
>>>>> the driver code expects, while interface 0 does. So it is the opposite
>>>>> of what the driver expects. Maybe the manufacturer changed something.
>>>>> Endpoints are still the same.
>>>>
>>>> That sometimes happen. Or maybe you just need a different size.
>>>>
>>>>> Please find attached an USB descriptor dump from this device.
>>>>
>>>> Int 0, endpoint 0:
>>>>     Interface 0
>>>>     
>>>>       bLength = 0x0009
>>>>       bDescriptorType = 0x0004
>>>>       bInterfaceNumber = 0x0000
>>>>       bAlternateSetting = 0x0000
>>>>       bNumEndpoints = 0x0003
>>>>       bInterfaceClass = 0x0000
>>>>       bInterfaceSubClass = 0x0000
>>>>       bInterfaceProtocol = 0x0000
>>>>       iInterface = 0x0000  <no string>
>>>>
>>>> ...
>>>>
>>>>      Endpoint 2
>>>>      
>>>>         bLength = 0x0007
>>>>         bDescriptorType = 0x0005
>>>>         bEndpointAddress = 0x0082  <IN>
>>>>         bmAttributes = 0x0001  <ISOCHRONOUS>
>>>>         wMaxPacketSize = 0x0000
>>>>         bInterval = 0x0001
>>>>         bRefresh = 0x0000
>>>>         bSynchAddress = 0x0000
>>>>
>>>> ...
>>>>
>>>>     Interface 0 Alt 1
>>>>     
>>>>       bLength = 0x0009
>>>>       bDescriptorType = 0x0004
>>>>       bInterfaceNumber = 0x0000
>>>>       bAlternateSetting = 0x0001
>>>>       bNumEndpoints = 0x0003
>>>>       bInterfaceClass = 0x0000
>>>>       bInterfaceSubClass = 0x0000
>>>>       bInterfaceProtocol = 0x0000
>>>>       iInterface = 0x0000  <no string>
>>>>
>>>> ...
>>>>
>>>>      Endpoint 2
>>>>      
>>>>         bLength = 0x0007
>>>>         bDescriptorType = 0x0005
>>>>         bEndpointAddress = 0x0082  <IN>
>>>>         bmAttributes = 0x0001  <ISOCHRONOUS>
>>>>         wMaxPacketSize = 0x0390
>>>>         bInterval = 0x0001
>>>>         bRefresh = 0x0000
>>>>         bSynchAddress = 0x0000
>>>
>>> Hi,
>>>
>>>> Hmm... assuming that the driver is using ISOC transfers, the difference
>>>> between alt 0 and alt 1 is that, on alt0, the mwMaxPacketSize is 0 (so,
>>>> you can't use it for isoc transfers), while, on alt 1, wMaxPacketSize is
>>>> 0x390.
>>>>
>>>> What the driver should be doing is to select an alt mode where the
>>>> wMaxPacketSize is big enough to handle the transfer.
>>>
>>> I can write the code to do that. Summed up:
>>>
>>> 1) Search interface 0, for alternate settings that have an ISOC-IN and
>>> wMaxPacket != 0. Select this alternate setting.
>>>
>>> 2) Search interface 1, for alternate settings that have an ISOC-IN and
>>> wMaxPacket != 0. Select this alternate setting.
>>>
>>> 3) Done.
>>>
>>> Do you think this will work better?
>>>
>>>> Calculating what "big enough"   is device-dependent, but, basically, a
>>>> 480 Mbps USB bus is capable of providing 800 isoc slots per interval.
>>>> If the packets are bigger, the max bandwidth is bigger.
>>>
>>> This is a FULL speed device, max 10MBit/second.
>>
>> Hmm... USB 1.1 devices are even more limited on the amount of used
>> bandwidth. The above procedure is better than the one you've proposed, but
>> yet you may not be able to receive channels with higher bandwidths.
>>
>> The usb "max" limit is lower than the maximum bandwidth. I think that full
>> speed provides 900 isoc slots per interval, but the interval for usb 1.1 is
>> higher (1s, while the interval for usb 2.0 is 125 us), but you need to
>> double check such constraints at the USB 1.1 and 2.0 specs, as I may be
>> wrong on that, as I read it a long time ago ;)
> 
> Hi,
> 
> There are 1000 frames per second when using Full Speed USB. 

No, it is 900. See [1]:

[1] http://www.google.com.br/url?sa=t&source=web&cd=1&ved=0CBgQFjAA&url=http%3A%2F%2Fmprolab.teipir.gr%2Fvivlio80X86%2Fusb11.pdf&ei=DrzaTfD5HqW90AHY-Jn8Aw&usg=AFQjCNHZW7ogFrjqoim1lTduQTHTDJoAUg

"5.6.4 Isochronous Transfer Bus Access Constraints
 Isochronous transfers can be used only by full-speed devices.
 The USB requires that no more than 90% of any frame be allocated for periodic (isochronous and
 interrupt) transfers."

90% of 1000 frames is 900 frames/s. That's the maximum limit for ISOC transfers.

> I know the device 
> cannot receive all streams, but it is very well suited for DVB radio.

Yeah, for DVB radio, that's ok, but the driver should be ok also for other
usages. Of course, streams with > 9Mbps won't fit on it, but if the driver
is not selecting the maximum alternate, the bandwidth limit will be even
smaller than that.

Mauro.
