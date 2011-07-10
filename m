Return-path: <mchehab@localhost>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47380 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1GJJOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 05:14:32 -0400
Received: by gyh3 with SMTP id 3so1197014gyh.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 02:14:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJQbCa=kCtgLp=DhNP+CQUMt6Hr-NR=VtGqmDGNRpF_fx6atDA@mail.gmail.com>
References: <CAJQbCa=kCtgLp=DhNP+CQUMt6Hr-NR=VtGqmDGNRpF_fx6atDA@mail.gmail.com>
Date: Sun, 10 Jul 2011 10:14:32 +0100
Message-ID: <CAJQbCakj4MscEOKeLo4w6m1-8cvSXxiSMk6ZYfvxF591ivZ81Q@mail.gmail.com>
Subject: media_build failure
From: Duncan Brown <dunc.brown@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi all

I'm having issues using the latest drivers using the media_build
script. (Fedora 14 - 2.6.35.13-92.x86_64)

The build appears to go ok apart from midway where I get:

Building modules, stage 2.
  MODPOST 461 modules
WARNING: "put_compat_timespec" [/usr/src/media_build/v4l/
v4l2-compat-ioctl32.ko] undefined!

The build then continues and appears to finish fine. make install is
no problem either.

On reboot all my media/dvb devices have disappeared and any attempt to
modprobe results a load of unknowm symbol in module errors, and in
dmesg:

v4l2_compat_ioctl32: Unknown symbol put_compat_timespec (err 0)

Can anyone help, this was working perfectly only a few weeks ago

thanks

Dunc
