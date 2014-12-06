Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34845 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaLFAZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 19:25:25 -0500
Received: by mail-ob0-f174.google.com with SMTP id nt9so1478793obb.33
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 16:25:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <10129477.C7LMJl3dKC@avalon>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
	<7185728.KDKlKP9htJ@avalon>
	<CANOLnOMrdk9Gq+9Cv_e5cboXtbtxHoKVQdNgBvb_NcJfFT7bHQ@mail.gmail.com>
	<10129477.C7LMJl3dKC@avalon>
Date: Sat, 6 Dec 2014 02:25:25 +0200
Message-ID: <CANOLnOMvBFiR2n0BMBO+DQ+b21Veb3r1dsw7C72OSyskxorY0w@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
From: Grazvydas Ignotas <notasas@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Dec 5, 2014 at 1:46 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Grazvydas,
>
> On Thursday 06 November 2014 00:29:53 Grazvydas Ignotas wrote:
>> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart wrote:
>> > Would you be able to capture images from the C920 using yavta, with the
>> > uvcvideo trace parameter set to 4096, and send me both the yavta log and
>> > the kernel log ? Let's start with a capture sequence of 50 to 100 images.
>>
>> I've done 2 captures, if that helps:
>> http://notaz.gp2x.de/tmp/c920_yavta/
>>
>> The second one was done using low exposure setting, which allows
>> camera to achieve higher frame rate.
>
> Thank you for the log, they were very helpful. They revealed that the USB SOF
> (Start Of Frame) counter values on the device and host side are not in sync.
> The counters get incremented are very different rates. What USB controller are
> you using ?

00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7592
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at fe9fbc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci-pci

If it helps, I could try on an ARM board, currently don't have any
other x86 hardware around.

--
Gražvydas
