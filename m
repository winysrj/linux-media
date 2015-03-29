Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48691 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbC2VFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 17:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1YcKOG-0004C8-Mv
	for linux-media@vger.kernel.org; Sun, 29 Mar 2015 23:05:04 +0200
Received: from gw1.bhd-akl1.xsrv.net.nz ([163.47.112.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2015 23:05:04 +0200
Received: from bugs by gw1.bhd-akl1.xsrv.net.nz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2015 23:05:04 +0200
To: linux-media@vger.kernel.org
From: Milos Ivanovic <bugs@milos.nz>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Mon, 30 Mar 2015 09:59:33 +1300
Message-ID: <mf9p3n$hqs$1@ger.gmane.org>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>	<10129477.C7LMJl3dKC@avalon>	<CANOLnOMvBFiR2n0BMBO+DQ+b21Veb3r1dsw7C72OSyskxorY0w@mail.gmail.com>	<1717818.6PrJVEWcvp@avalon> <CANOLnONtDgBChFERg8y1HGFnOtU8WO+VSpVK=uktDL5PAb5nxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOLnONtDgBChFERg8y1HGFnOtU8WO+VSpVK=uktDL5PAb5nxA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/12/2014 10:23 am, Grazvydas Ignotas wrote:
> Hi,
>
> On Sun, Dec 7, 2014 at 9:23 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Grazvydas,
>>
>> (CC'ing Paulo Assis)
>>
>> On Saturday 06 December 2014 02:25:25 Grazvydas Ignotas wrote:
>>> On Fri, Dec 5, 2014 at 1:46 PM, Laurent Pinchart wrote:
>>>> On Thursday 06 November 2014 00:29:53 Grazvydas Ignotas wrote:
>>>>> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart wrote:
>>>>>> Would you be able to capture images from the C920 using yavta, with the
>>>>>> uvcvideo trace parameter set to 4096, and send me both the yavta log
>>>>>> and the kernel log ? Let's start with a capture sequence of 50 to 100
>>>>>> images.
>>>>>
>>>>> I've done 2 captures, if that helps:
>>>>> http://notaz.gp2x.de/tmp/c920_yavta/
>>>>>
>>>>> The second one was done using low exposure setting, which allows
>>>>> camera to achieve higher frame rate.
>>>>
>>>> Thank you for the log, they were very helpful. They revealed that the USB
>>>> SOF (Start Of Frame) counter values on the device and host side are not
>>>> in sync. The counters get incremented are very different rates. What USB
>>>> controller are you using ?
>>>
>>> 00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI
>>> Controller (rev 01) (prog-if 20 [EHCI])
>>>          Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7592
>>>          Flags: bus master, medium devsel, latency 0, IRQ 23
>>>          Memory at fe9fbc00 (32-bit, non-prefetchable) [size=1K]
>>>          Capabilities: [50] Power Management version 2
>>>          Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>          Kernel driver in use: ehci-pci
>>>
>>> If it helps, I could try on an ARM board, currently don't have any
>>> other x86 hardware around.
>>
>> Actually the frequencies I've computed from the log are correct on the host
>> side but quite off on the device side. I'm puzzled.
>>
>> The following patch allows accessing the contents of the clock data buffer
>> through debugfs. Would you be able to apply it and execute the following
>> steps ?
>>
>> 1. Load the uvcvideo module with the clock trace flag (0x1000) set.
>>
>> 2. Start capturing clock data.
>>
>> while true; do
>>          cat /sys/kernel/debug/usb/uvcvideo/2-6/clocks ;
>> done > ~/samples.log
>>
>> 3. Capture 100 frames.
>>
>> yavta -c100 > yavta.log
>>
>> 4. Stop the "while true" with ctrl-C.
>>
>> 5. Capture the uvcvideo stats.
>>
>> cat /sys/kernel/debug/usb/uvcvideo/2-6/stats > stats.log
>>
>> 6. Capture the kernel log.
>>
>> dmesg > dmesg.log
>>
>> 7. Send me all the log files.
>
> Done:
> http://notaz.gp2x.de/tmp/c920_yavta/3/
>
> --
> Gražvydas
>

Hello,

I've reproduced this issue on a Logitech C920 in the following environments:

1. x86_64 Linux 3.19.3 (Gentoo, custom kernel)
2. x86_64 Linux 3.13.0-46-generic (Ubuntu)
3. armv7a Linux 3.19.3 (Arch Linux, custom kernel)

I can confirm that the issue is not present in Linux 3.8.y.

I'm not sure if there have been any developments in regards to this in 
recent months, but I'm happy to help out in any way possible. If someone 
is in need of new debug logs, I can follow the steps above and provide them.

--
Milos

