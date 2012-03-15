Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49560 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2CODEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 23:04:00 -0400
Received: by yhmm54 with SMTP id m54so2634075yhm.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 20:03:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
	<CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
	<CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
	<CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
	<CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com>
Date: Thu, 15 Mar 2012 00:03:59 -0300
Message-ID: <CALF0-+XAH3SHi2PcbW8Ryyg=+JuAAcs2sjCmJK0yNYp0u4A3Nw@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>
> I'm positive, the LIRC modules aren't loaded at all if I boot with the
> webcam disconnected. As soon as I plug it into an USB port, em28xx and
> LIRC are loaded.
>

So... why don't you post *this* dmesg:
First boot the computer.
Then change the kernel debug level so to get every output possible.
Then insert the module.

This dmesg is of some interest, not the previous one.

A couple of things you can test:

1. If your module is getting loaded when
the device is plugged, then udev
must be running. I suggest you to
turn it off, just to remove it from the equation.
Once you do this, you'll have to load module
manually.

2. Also modprobe maybe handling dependencies.
To check this you can do:

$ modprobe -v em28xx

3. You can try *not* to use modprobe. So
start fresh (from boot) and load with insmod
providing full path, like this:

$ insmod /lib/modules/3.3.0-rc3-athlon-full-preempt-gentoo+/kernel/drivers/media/video/em28xx/em28xx.ko

Probably you'll bump into unknown symbol errors.
You can see them with dmesg.

Hope it helps,
Ezequiel.
