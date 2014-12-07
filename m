Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:58272 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaLGVXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 16:23:41 -0500
Received: by mail-oi0-f54.google.com with SMTP id u20so2579689oif.41
        for <linux-media@vger.kernel.org>; Sun, 07 Dec 2014 13:23:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1717818.6PrJVEWcvp@avalon>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
	<10129477.C7LMJl3dKC@avalon>
	<CANOLnOMvBFiR2n0BMBO+DQ+b21Veb3r1dsw7C72OSyskxorY0w@mail.gmail.com>
	<1717818.6PrJVEWcvp@avalon>
Date: Sun, 7 Dec 2014 23:23:41 +0200
Message-ID: <CANOLnONtDgBChFERg8y1HGFnOtU8WO+VSpVK=uktDL5PAb5nxA@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
From: Grazvydas Ignotas <notasas@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Paulo Assis <pj.assis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Dec 7, 2014 at 9:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Grazvydas,
>
> (CC'ing Paulo Assis)
>
> On Saturday 06 December 2014 02:25:25 Grazvydas Ignotas wrote:
>> On Fri, Dec 5, 2014 at 1:46 PM, Laurent Pinchart wrote:
>> > On Thursday 06 November 2014 00:29:53 Grazvydas Ignotas wrote:
>> >> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart wrote:
>> >> > Would you be able to capture images from the C920 using yavta, with the
>> >> > uvcvideo trace parameter set to 4096, and send me both the yavta log
>> >> > and the kernel log ? Let's start with a capture sequence of 50 to 100
>> >> > images.
>> >>
>> >> I've done 2 captures, if that helps:
>> >> http://notaz.gp2x.de/tmp/c920_yavta/
>> >>
>> >> The second one was done using low exposure setting, which allows
>> >> camera to achieve higher frame rate.
>> >
>> > Thank you for the log, they were very helpful. They revealed that the USB
>> > SOF (Start Of Frame) counter values on the device and host side are not
>> > in sync. The counters get incremented are very different rates. What USB
>> > controller are you using ?
>>
>> 00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI
>> Controller (rev 01) (prog-if 20 [EHCI])
>>         Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7592
>>         Flags: bus master, medium devsel, latency 0, IRQ 23
>>         Memory at fe9fbc00 (32-bit, non-prefetchable) [size=1K]
>>         Capabilities: [50] Power Management version 2
>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>         Kernel driver in use: ehci-pci
>>
>> If it helps, I could try on an ARM board, currently don't have any
>> other x86 hardware around.
>
> Actually the frequencies I've computed from the log are correct on the host
> side but quite off on the device side. I'm puzzled.
>
> The following patch allows accessing the contents of the clock data buffer
> through debugfs. Would you be able to apply it and execute the following
> steps ?
>
> 1. Load the uvcvideo module with the clock trace flag (0x1000) set.
>
> 2. Start capturing clock data.
>
> while true; do
>         cat /sys/kernel/debug/usb/uvcvideo/2-6/clocks ;
> done > ~/samples.log
>
> 3. Capture 100 frames.
>
> yavta -c100 > yavta.log
>
> 4. Stop the "while true" with ctrl-C.
>
> 5. Capture the uvcvideo stats.
>
> cat /sys/kernel/debug/usb/uvcvideo/2-6/stats > stats.log
>
> 6. Capture the kernel log.
>
> dmesg > dmesg.log
>
> 7. Send me all the log files.

Done:
http://notaz.gp2x.de/tmp/c920_yavta/3/

--
Gražvydas
