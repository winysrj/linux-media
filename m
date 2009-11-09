Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:14605 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZKISkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 13:40:36 -0500
Received: by gv-out-0910.google.com with SMTP id r4so284319gve.37
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 10:40:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	 <20091109144647.2f876934@pedra.chehab.org>
	 <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
	 <829197380911090933y76e53e57o940520a0e7912092@mail.gmail.com>
	 <829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
	 <ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
Date: Mon, 9 Nov 2009 13:40:40 -0500
Message-ID: <829197380911091040l46e40bf8t783bbdf3590b1244@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:56 PM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Hi All,
>
> following Devin suggestion, now I managed to compile latest v4l-dvb source.
>
> But the /dev/dvb device is still not created like before.
>
> Could the reason be the kernel version I am using, 2.6.31 instead of 2.6.32-rc1?
> Thanks a lot for you support again, and sorry for my little knowledge
> of linux kernel and of its modules.
>
> Regards,
>
> Valerio

Please don't top post.

Did you reboot after installing the v4l-dvb source?  Performing a
"make install" will not cause the new drivers to be loaded.

If you can provide the full dmesg output from the time the box booted
until after the device was connected, I will take a look.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
