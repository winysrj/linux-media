Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33445 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZKIR5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 12:57:07 -0500
Received: by fxm21 with SMTP id 21so379205fxm.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 09:57:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	<20091109144647.2f876934@pedra.chehab.org> <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
	<829197380911090933y76e53e57o940520a0e7912092@mail.gmail.com>
	<829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Mon, 9 Nov 2009 18:56:49 +0100
Message-ID: <ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

following Devin suggestion, now I managed to compile latest v4l-dvb source.

But the /dev/dvb device is still not created like before.

Could the reason be the kernel version I am using, 2.6.31 instead of 2.6.32-rc1?
Thanks a lot for you support again, and sorry for my little knowledge
of linux kernel and of its modules.

Regards,

Valerio

2009/11/9 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Mon, Nov 9, 2009 at 12:33 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> The tree doesn't compile cleanly against Karmic due to a bug in their
>> packaging of the kernel headers.  To workaround it, open v4l/.config
>> and change the fedtv driver from "=m" to "=n".
>
> Pardon, I meant to say "firedtv" and not "fedtv".
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
