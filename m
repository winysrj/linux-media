Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbeIVQPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Sep 2018 12:15:09 -0400
Date: Sat, 22 Sep 2018 07:21:59 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Dan Ziemba <zman0900@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: 4.18 regression: dvb-usb-v2: General Protection Fault shortly
 after boot
Message-ID: <20180922072159.4e0f9a84@coco.lan>
In-Reply-To: <8b990b3c13db04ee04bcb1b5b3a566f8054754f3.camel@gmail.com>
References: <8b990b3c13db04ee04bcb1b5b3a566f8054754f3.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Sep 2018 00:07:09 -0400
Dan Ziemba <zman0900@gmail.com> escreveu:

> I reported this on bugzilla also a few days ago, but I'm not sure if
> that is actually the right place to report, so copying to the mailing
> list...

I saw a report on BZ, but haven't time yet to dig into it. Those
days, it is usually better to report via the ML.
 
> 
> Starting with the first 4.18 RC kernel, my system experiences general
> protection faults leading to kernel panic shortly after the login
> prompt appears on most boots.  Occasionally that doesn't happen and
> instead numerous other seemingly random stack traces are printed (bad
> page map, scheduling while atomic, null pointer deref, etc), but either
> way the system is unusable.  This bug remains up through the latest
> mainline kernel 4.19-rc2.
> 
> Booting with my USB ATSC tv tuner disconnected prevents the bug from
> happening.
> 
> 
> Kernel bisection between v4.17 and 4.18-rc1 shows problem is caused by:
> 
> 1a0c10ed7bb1 media: dvb-usb-v2: stop using coherent memory for URBs
> 
> 
> Building both 4.18.6 and 4.19-rc2 with that commit reverted resolves
> the bug for me.  

There's something really weird on it: that patch changes a code that
it is only called when the device is streaming. It shouldn't be
causing GFP/kernel panic, depending if the machine was booted with
or without it.

Perhaps it would be a side effect due to some changes at the USB
subsystem? There are some changes happening there changing some
locks.

I see one minor issue there: it is using GFP_ATOMIC instead
of GFP_KERNEL.

Could you please try to change this line:

	stream->buf_list[stream->buf_num] = kzalloc(size, GFP_ATOMIC);

to

	stream->buf_list[stream->buf_num] = kzalloc(size, GFP_KERNEL);

Also, it would be great if you could post the GPF logs.

> 
> 
> My DVB hardware uses driver mxl111sf:
> 
> Bus 002 Device 003: ID 2040:c61b Hauppauge 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0        64
>   idVendor           0x2040 Hauppauge
>   idProduct          0xc61b 
>   bcdDevice            0.00
>   iManufacturer           1 Hauppauge
>   iProduct                2 WinTV Aero-M
> 
> Other system info:
> 
> Arch Linux x86_64
> Intel i7-3770
> 16 GB ram
> 
> Bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=201055
> 
> Arch bug:
> https://bugs.archlinux.org/task/59990
> 
> 
> Thanks,
> Dan Ziemba
> 
> 



Thanks,
Mauro
