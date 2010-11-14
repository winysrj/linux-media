Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab0KNQ5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 11:57:44 -0500
Received: by wyb28 with SMTP id 28so3634513wyb.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 08:57:43 -0800 (PST)
Message-ID: <4CE01503.2010706@gmail.com>
Date: Sun, 14 Nov 2010 17:57:39 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Zdenek Styblik <stybla@turnovfree.net>
CC: linux-media@vger.kernel.org
Subject: Re: RTL2832U version 2.0.1 by Realtek
References: <4CDC4CA9.1040505@gmail.com> <4CDC51D5.4050702@turnovfree.net> <4CDD47B6.3050601@gmail.com> <4CDD4B09.6000800@turnovfree.net>
In-Reply-To: <4CDD4B09.6000800@turnovfree.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Zdenek Styblik wrote:
> On 11/12/2010 02:57 PM, poma wrote:
>> Zdenek Styblik wrote:
>> ...
>>> I'm also glad to see I'm not the only one whom has been contacted by
>>> Realtek. And since you're V4L developer; how is it going with
>>> integrating RTL driver into V4L?
>> Linux user, not V4L developer.
>>
> 
> Ok.
> 
>>> Realtek showed gratitude, well more like - made a wish, to get "their"
>>> driver into kernel, however I doubt that's possible unless they clear
>>> out licensing. But I'm no lawyer. Well, that's what my reply was anyway.
>>  grep "GPL\|Copyright\|Rights" rtl2832u_v2.0.1/*
> [...]
> 
> That's why I've said so.
> 

  grep "GPL\|Copyright\|Rights" rtl2832u_v2.0.1/*
rtl2832u_v2.0.1/rtl2832u.c:MODULE_LICENSE("GPL");
rtl2832u_v2.0.1/tuner_e4000.c://  Copyright (c)  Elonics Ltd
rtl2832u_v2.0.1/tuner_e4000.c://  Copyright (c)  Elonics Ltd
rtl2832u_v2.0.1/tuner_fc0012.c://       Copyright 2008, All rights reversed.
rtl2832u_v2.0.1/tuner_max3543.c:| Copyright (C) 2009 Maxim Integrated 
Products.
rtl2832u_v2.0.1/tuner_max3543.h:| Copyright (C) 2009 Maxim Integrated 
Products
rtl2832u_v2.0.1/tuner_mt2063.c:**  Copyright 2007-2008 Microtune, Inc. 
All Rights Reserved
rtl2832u_v2.0.1/tuner_mt2063.c:**  Copyright 2006-2008 Microtune, Inc. 
All Rights Reserved
rtl2832u_v2.0.1/tuner_mt2063.h:**  Copyright 2004-2007 Microtune, Inc. 
All Rights Reserved
rtl2832u_v2.0.1/tuner_mt2063.h:**  Copyright 2006-2008 Microtune, Inc. 
All Rights Reserved
rtl2832u_v2.0.1/tuner_mt2063.h:**  Copyright 2007 Microtune, Inc. All 
Rights Reserved
rtl2832u_v2.0.1/tuner_mt2063.h:**  Copyright 2006-2008 Microtune, Inc. 
All Rights Reserved
rtl2832u_v2.0.1/tuner_mt2266.c:**  Copyright 2007 Microtune, Inc. All 
Rights Reserved
rtl2832u_v2.0.1/tuner_mt2266.h:**  Copyright 2007 Microtune, Inc. All 
Rights Reserved
rtl2832u_v2.0.1/tuner_mxl5007t.c: Copyright, Maxlinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.c: All Rights Reserved
rtl2832u_v2.0.1/tuner_mxl5007t.c: Copyright, Maxlinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.c: All Rights Reserved
rtl2832u_v2.0.1/tuner_mxl5007t.c: Copyright, Maxlinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.c: All Rights Reserved
rtl2832u_v2.0.1/tuner_mxl5007t.h: *                Copyright (c) 2006, 
MaxLinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.h: Copyright, Maxlinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.h: All Rights Reserved
rtl2832u_v2.0.1/tuner_mxl5007t.h: Copyright, Maxlinear, Inc.
rtl2832u_v2.0.1/tuner_mxl5007t.h: All Rights Reserved
rtl2832u_v2.0.1/tuner_tua9001.c:** Copyright (C) 1997-2007 Infineon AG 
All rights reserved.
rtl2832u_v2.0.1/tuner_tua9001.h:** Copyright (C) 1997-2007 Infineon AG 
All rights reserved.

rtl2832u.c is "GPL'ed";
Linked tuners are NOT "GPL'ed"!
Also There Are SOME of them(tuners) already in the v4l-dvb tree.
But NOT ones bundled with 'dvb-usb-rtl2832u.ko'
Major Bummer!

>>> I'm going to link page later on. I'm waiting for Realtek's reply, if
>>> any. Then I'm going to decide. However "Realtek RTL2831U / RTL2832U
>>> drivers; * driver not ready" makes some of it pointless, which is not
>>> necessary a bad thing :)
>> At least you CAN build and use module(dvb-usb-rtl2832u.ko), and it is
>> working.
>>
>> Regards,
>> poma
>>
> 
> And? If nobody is going to work at improving it; if nobody is going to
> add support for other devices; if nobody [from RTL] is going to talk
> with people [= community] nor willing to provide documents to work at
> driver? Pardon me, but I don't feel satisfied or happy with just "build
> and use module" which is basically troublesome for a lot of people. And
> you have virtually almost nothing to change that.
> So yeah. If possible, I would like to do more than just that.
> 
> Have a nice weekend,
> Zdenek
> 

rtl2832u support discussion on:
http://vger.kernel.org/vger-lists.html#linux-media
archived on:
http://www.spinics.net/lists/linux-media/msg24207.html

You are welcome to subscribe, and join the discussions.

A Couple Bits about hardware:

Afatech AF9015 & MaxLinear MXL5007T dual tuner:
http://www.spinics.net/lists/linux-media/msg22232.html
http://www.spinics.net/lists/linux-media/msg23162.html

Realtek RTL2832U & Fitipower FC0012:
http://www.spinics.net/lists/linux-media/msg23229.html

btw
-GIGABYTE USB Digital TV Dongle U7300
current link:
http://www.gigabyte.com/products/product-page.aspx?pid=3493#sp

Regards,
poma

