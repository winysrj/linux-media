Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41124 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbZKJPt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 10:49:27 -0500
Received: by fxm21 with SMTP id 21so152335fxm.21
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 07:49:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911100739k1b1a1c78t97c5a9dddae89b00@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	<20091109144647.2f876934@pedra.chehab.org> <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
	<829197380911090933y76e53e57o940520a0e7912092@mail.gmail.com>
	<829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
	<ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
	<829197380911091040l46e40bf8t783bbdf3590b1244@mail.gmail.com>
	<ad6681df0911100139u6ea649c7rcc8c2f840167d4bc@mail.gmail.com>
	<829197380911100739k1b1a1c78t97c5a9dddae89b00@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Tue, 10 Nov 2009 16:49:12 +0100
Message-ID: <ad6681df0911100749p13bc917al2390f85d471e2765@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/10 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Tue, Nov 10, 2009 at 4:39 AM, Valerio Bontempi
> <valerio.bontempi@gmail.com> wrote:
>> Yes I rebooted the system after compiling and installing through 'make
>> install' last v4l-dvb source, but with no luck, /dev/dvb device is
>> still not present.
>>
>> Attached you can find the full dmesg, since system boot
>>
>> Thanks a lot again.
>>
>>
>> P.s. Sorry for top posting, it's gmail0s default and sometimes I forget.
>
> Hello Valerio,
>
> Now that I have taken another look at the dmesg output, I see that
> this device is 0ccd:0043 and *not* 0ccd:0042.  This prompted me to
> take another look at the driver, and indeed that board is not
> presently supported.  It's the DVB only version of the board (as
> opposed to the hybrid).
>
> I can probably make it work, but it's a rather old board and not
> terribly high on my list of priorities.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Hi Devin,

I feared about that
So, in this moment my only possibilities available to make it work are:
- use an older kernel (<=2.6.27) to compile successfully em28xx-new
(maybe it could be better to use older linux distro)
- make em28xx-new to compile on 2.6.31 kernel version
- wait for device support on next kernel releases

I have good programming knowledge, but few with C and driver
programming, so if you can suggest me how can I modify em28xx-new
sources to make them work on 2.6.31, then I can try to adjust them and
then make this driver available just waiting for kernel support.

Thanks a lot

Valerio
