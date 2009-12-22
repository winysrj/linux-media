Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:38623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZLVPue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 10:50:34 -0500
Received: by fg-out-1718.google.com with SMTP id 22so2551532fge.1
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2009 07:50:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
Date: Tue, 22 Dec 2009 10:50:26 -0500
Message-ID: <829197380912220750j116894baw8343010b123f929@mail.gmail.com>
Subject: Re: em28xx driver - xc3028 tuner - readreg error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 22, 2009 at 10:11 AM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Before the update, v4l-dvb driver worked fine, and now it doesn't work
> even if I remove the updated packages.
> Checking for kernel modules conflict, I found only the modules
> installed by v4l-dvb sources.
> #find /lib/modules/`uname -r` -name 'em28xx*' | xargs -i ls -l {}
> totale 236
> -rw-r--r-- 1 root root 21464 22 dic 16:03
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> -rw-r--r-- 1 root root 26176 22 dic 16:03
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> -rw-r--r-- 1 root root 184936 22 dic 16:03
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx.ko

My guess is that these files were provided by your distro through a
kernel update (and in 2.6.31 this board is known to have problems
which have been fixed in the latest v4l-dvb tree).

I would suggest the following going into your v4l-dvb tree and doing
the following:

make distclean && make && make install && reboot

And see if the problem clears up.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
