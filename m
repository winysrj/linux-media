Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47262 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2BHVcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 16:32:16 -0500
Received: by vbjk17 with SMTP id k17so651815vbj.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 13:32:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
Date: Wed, 8 Feb 2012 22:32:15 +0100
Message-ID: <CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sat, Jan 21, 2012 at 5:04 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Terratec H7 is a Cypress FX2 device with a mt2063 tuner and a drx-k
> demod. This series add support for it. It started with a public
> tree found at:
>         http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
>
> The driver were almost completely re-written, and it is now working,
> at least with DVB-C. I don't have a DVB-T signal here for testing,
> but I suspect it should also work fine.
>
> The FX2 firmware has a NEC IR decoder. The driver has support for
> it. The default keytable has support for the black Terratec IR
> and for the grey IR with orange keys.
>

Do I need to do anything special to make this driver work?
I just installed the newest media drivers (by following instructions at
http://git.linuxtv.org/media_build.git) on a maxhine running Xubuntu 11.10:
tingo@kg-f4:~/work/media_
build$ uname -a
Linux kg-f4 3.0.0-15-generic #26-Ubuntu SMP Fri Jan 20 17:23:00 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

This machine has a TerraTec H7 connected, lsusb shows:
tingo@kg-f4:~/work/media_build$ sudo lsusb  -s 1:6
Bus 001 Device 006: ID 0ccd:10a3 TerraTec Electronic GmbH

But after installing the drivers, and after a reboot of the machine,
the dvb-usb-az6007 driver doesn't load.
If I manually do 'sudo modprobe dvb-usb-az6007', the driver loads, but
all I get in dmesg is this:
[ 1049.838911] WARNING: You are using an experimental version of the
media stack.
[ 1049.838917]  As the driver is backported to an older kernel, it doesn't offer
[ 1049.838922]  enough quality for its usage in production.
[ 1049.838925]  Use it with care.
[ 1049.838928] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[ 1049.838932]  59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[ 1049.838936]  72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[ 1049.838941]  46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[ 1049.857524] IR NEC protocol handler initialized
[ 1049.892787] usbcore: registered new interface driver dvb_usb_az6007
[ 1049.905264] IR RC5(x) protocol handler initialized
[ 1049.919476] IR RC6 protocol handler initialized
[ 1049.929152] IR JVC protocol handler initialized
[ 1049.943103] IR Sony protocol handler initialized
[ 1049.956308] IR SANYO protocol handler initialized
[ 1049.966667] IR MCE Keyboard/mouse protocol handler initialized
[ 1049.989256] lirc_dev: IR Remote Control driver registered, major 250
[ 1050.003618] IR LIRC bridge handler initialized
[ 1445.609008] usb 1-2: USB disconnect, device number 5
[ 1449.944046] usb 1-2: new high speed USB device number 6 using ehci_hcd

and there aren't anything created in /dev/dvb.

What am I doing wrong?
--
Regards,
Torfinn Ingolfsen
