Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:64839 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbZKJPwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 10:52:51 -0500
Received: by gv-out-0910.google.com with SMTP id r4so14326gve.37
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 07:52:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0911100749p13bc917al2390f85d471e2765@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	 <20091109144647.2f876934@pedra.chehab.org>
	 <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
	 <829197380911090933y76e53e57o940520a0e7912092@mail.gmail.com>
	 <829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
	 <ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
	 <829197380911091040l46e40bf8t783bbdf3590b1244@mail.gmail.com>
	 <ad6681df0911100139u6ea649c7rcc8c2f840167d4bc@mail.gmail.com>
	 <829197380911100739k1b1a1c78t97c5a9dddae89b00@mail.gmail.com>
	 <ad6681df0911100749p13bc917al2390f85d471e2765@mail.gmail.com>
Date: Tue, 10 Nov 2009 10:52:56 -0500
Message-ID: <829197380911100752yf4ff138rb3ecae613586f59f@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 10, 2009 at 10:49 AM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Hi Devin,
>
> I feared about that
> So, in this moment my only possibilities available to make it work are:
> - use an older kernel (<=2.6.27) to compile successfully em28xx-new
> (maybe it could be better to use older linux distro)
> - make em28xx-new to compile on 2.6.31 kernel version
> - wait for device support on next kernel releases
>
> I have good programming knowledge, but few with C and driver
> programming, so if you can suggest me how can I modify em28xx-new
> sources to make them work on 2.6.31, then I can try to adjust them and
> then make this driver available just waiting for kernel support.

In theory you just need your board profile properly defined in
em28xx-cards.c and em28xx-dvb.c.  If I were going to choose between
trying to make the old em28xx-new compile under the current kernel,
and adding the 10-15 lines of code to the in-kernel em28xx driver, I
would probably consider choosing the latter (and then feel free to
submit the patch to be merged upstream).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
