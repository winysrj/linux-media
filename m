Return-path: <mchehab@localhost>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42337 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1GJLZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 07:25:37 -0400
Received: by gyh3 with SMTP id 3so1209023gyh.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 04:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJQbCakj4MscEOKeLo4w6m1-8cvSXxiSMk6ZYfvxF591ivZ81Q@mail.gmail.com>
References: <CAJQbCa=kCtgLp=DhNP+CQUMt6Hr-NR=VtGqmDGNRpF_fx6atDA@mail.gmail.com>
	<CAJQbCakj4MscEOKeLo4w6m1-8cvSXxiSMk6ZYfvxF591ivZ81Q@mail.gmail.com>
Date: Sun, 10 Jul 2011 12:25:37 +0100
Message-ID: <CAJQbCak5Xs1Ch_GAiaNezbepFeyj48tmgyeHXkNqDkErwX=YfQ@mail.gmail.com>
Subject: Re: media_build failure
From: Duncan Brown <dunc.brown@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Sun, Jul 10, 2011 at 10:14 AM, Duncan Brown <dunc.brown@gmail.com> wrote:
> Hi all
>
> I'm having issues using the latest drivers using the media_build
> script. (Fedora 14 - 2.6.35.13-92.x86_64)
>
> The build appears to go ok apart from midway where I get:
>
> Building modules, stage 2.
>   MODPOST 461 modules
> WARNING: "put_compat_timespec" [/usr/src/media_build/v4l/
> v4l2-compat-ioctl32.ko] undefined!
>
> The build then continues and appears to finish fine. make install is
> no problem either.
>
> On reboot all my media/dvb devices have disappeared and any attempt to
> modprobe results a load of unknowm symbol in module errors, and in
> dmesg:
>
> v4l2_compat_ioctl32: Unknown symbol put_compat_timespec (err 0)
>
> Can anyone help, this was working perfectly only a few weeks ago
>
>

As a temporary fix, I've just copied over the original
v4l2-compat-ioctl32.ko from the fedora kernel tree over the
media_build version in lib/modules. After a reboot everything is back
and running again.

Would be nice to know why its failing to build properly however

Dunc
