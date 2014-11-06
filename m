Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54056 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaKFMyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 07:54:13 -0500
Received: by mail-lb0-f170.google.com with SMTP id z12so849192lbi.1
        for <linux-media@vger.kernel.org>; Thu, 06 Nov 2014 04:54:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB0d6Edzi1MNBkB0K+Src+oj2x3oiAt-XChbd5OsEpfLqH3pXw@mail.gmail.com>
References: <CAB0d6EdsnrRmMxz=d2Di=NvitX3LLxzJMRM7ee1ZKsFViG0EDA@mail.gmail.com>
	<20141029170853.1ee823cb.m.chehab@samsung.com>
	<CAB0d6EcD9OGqmHVm+tt8rrdpqSBqv6pMWWE3NeYR85Z=CH3ntQ@mail.gmail.com>
	<CAB0d6Edzi1MNBkB0K+Src+oj2x3oiAt-XChbd5OsEpfLqH3pXw@mail.gmail.com>
Date: Thu, 6 Nov 2014 10:54:11 -0200
Message-ID: <CAB0d6EdmYNn2XiVJo1--GsgS7-B-967JpX4vP+y+qqYthbqRCw@mail.gmail.com>
Subject: Re: Issues with Empia + saa7115
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found out, the problem that "dd" was not getting any data was due
BeagleBoneBlack usb dma configuration on kernel:
config_musb_pio_only
This should be true to  Disable DMA (always use PIO).

Now I can debug if the problem is the saa711x driver version.

2014-11-03 10:03 GMT-02:00 Rafael Coutinho <rafael.coutinho@phiinnovations.com>:
> I have tried now with a newer kernel (3.14) and I can't even get an
> stream from /dev/video0. The file is always empty.
>
> Here is the dmesg of it:
> http://pastebin.com/pm720UnR
>
> It is correctly identifying the device, however it cannot grab any
> bytes from the dd command as below:
> dd if=/dev/video0 of=ImageOut.raw bs=10065748 count=1
>
> Any tips on how to investigate it further?
>
> 2014-10-29 18:13 GMT-02:00 Rafael Coutinho <rafael.coutinho@phiinnovations.com>:
>> Ok, just to be sure, I have others capture boards like  Silan SC8113,
>> that's only on newer kernels? If so I'll backport it.
>>
>> 2014-10-29 17:08 GMT-02:00 Mauro Carvalho Chehab <m.chehab@samsung.com>:
>>> Em Wed, 29 Oct 2014 16:34:09 -0200
>>> Rafael Coutinho <rafael.coutinho@phiinnovations.com> escreveu:
>>>
>>>> Hi all,
>>>>
>>>> I'm having trouble to make an SAA7115 (Actually it's the generic
>>>> GM7113 version) video capture board to work on a beagle board running
>>>> Android (4.0.3).
>>>> For some reason I cannot capture any image, it always output a green image file.
>>>> The kernel is Linux-3.2.0
>>>
>>> Support for GM7113 were added only on a recent version.
>>>
>>> So, you need to get a newer driver. So, you'll need to either upgrade
>>> the Kernel, use either Linux backports or media-build to get a newer
>>> driver set or do the manual work of backporting saa7115 and the bridge
>>> driver changes for gm7113 for it to work.
>>>
>>> Regards,
>>> Mauro
>>>
>>>>
>>>> My current approach is the simplest I have found so far, to avoid any
>>>> issues with other sw layers. I'm forcing a 'dd' from the /dev/video
>>>> device.
>>>>
>>>> dd if=/dev/video0 of=ImageOut.raw bs=10065748 count=1
>>>>
>>>> And then I open the raw image file converting it on an image editor.
>>>>
>>>> In my ubuntu PC (kernel 3.13.0) it works fine. however on the Beagle
>>>> Bone with android it fails to get an image.
>>>>
>>>> I have now tried with a Linux (angstron) on beagle bone with 3.8
>>>> kernel and this time is even worse, the 'dd' command does not result
>>>> on any byte written on the output file.
>>>>
>>>> The v4l2-ctl works fine on the 3 environments. I can even set values
>>>> as standard, input etc...
>>>>
>>>> I have attached the dmesg of the environments here:
>>>>
>>>> * Android - dmesg http://pastebin.com/AFdB9N9c
>>>>
>>>> * Linux Angstron - dmesg http://pastebin.com/s3S3iCph
>>>> * Linux Angstron - lsmod http://pastebin.com/vh89TBKQ
>>>>
>>>> * Desktop PC - dmesg http://pastebin.com/HXzHwnUJ
>>>>
>>>> I have one restriction on the kernel of android due the HAL drivers
>>>> for BBB. So changing kernel is not a choice.
>>>>
>>>> Anyone could give me some tips on where to look for other issues or debug it?
>>>>
>>>> Thanks in advance
>>>>
>>
>>
>>
>> --
>> Regards,
>> Coutinho
>> www.phiinnovations.com
>
>
>
> --
> Regards,
> Coutinho
> www.phiinnovations.com



-- 
Regards,
Coutinho
www.phiinnovations.com
