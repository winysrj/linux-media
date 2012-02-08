Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39181 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab2BHXEh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Feb 2012 18:04:37 -0500
Received: by obcva7 with SMTP id va7so1428988obc.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 15:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
	<CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com>
Date: Thu, 9 Feb 2012 00:04:36 +0100
Message-ID: <CAJ_iqtY2y5+jo2rirm1LbfDHVytcnaXE5x+KuA_MD-H5N4pnwA@mail.gmail.com>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 8, 2012 at 10:32 PM, Torfinn Ingolfsen <tingox@gmail.com> wrote:
> Do I need to do anything special to make this driver work?
> I just installed the newest media drivers (by following instructions at
> http://git.linuxtv.org/media_build.git) on a maxhine running Xubuntu 11.10:
> tingo@kg-f4:~/work/media_
> build$ uname -a
> Linux kg-f4 3.0.0-15-generic #26-Ubuntu SMP Fri Jan 20 17:23:00 UTC
> 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> This machine has a TerraTec H7 connected, lsusb shows:
> tingo@kg-f4:~/work/media_build$ sudo lsusb  -s 1:6
> Bus 001 Device 006: ID 0ccd:10a3 TerraTec Electronic GmbH
>
> But after installing the drivers, and after a reboot of the machine,
> the dvb-usb-az6007 driver doesn't load.
> If I manually do 'sudo modprobe dvb-usb-az6007', the driver loads, but
> all I get in dmesg is this:
> [ 1049.838911] WARNING: You are using an experimental version of the
> media stack.
> [ 1049.838917]  As the driver is backported to an older kernel, it doesn't offer
> [ 1049.838922]  enough quality for its usage in production.
> [ 1049.838925]  Use it with care.
> [ 1049.838928] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [ 1049.838932]  59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
> 'v4l_for_linus' into staging/for_v3.4
> [ 1049.838936]  72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
> cxd2820r: sleep on DVB-T/T2 delivery system switch
> [ 1049.838941]  46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
> anysee: fix CI init
> [ 1049.857524] IR NEC protocol handler initialized
> [ 1049.892787] usbcore: registered new interface driver dvb_usb_az6007
> [ 1049.905264] IR RC5(x) protocol handler initialized
> [ 1049.919476] IR RC6 protocol handler initialized
> [ 1049.929152] IR JVC protocol handler initialized
> [ 1049.943103] IR Sony protocol handler initialized
> [ 1049.956308] IR SANYO protocol handler initialized
> [ 1049.966667] IR MCE Keyboard/mouse protocol handler initialized
> [ 1049.989256] lirc_dev: IR Remote Control driver registered, major 250
> [ 1050.003618] IR LIRC bridge handler initialized
> [ 1445.609008] usb 1-2: USB disconnect, device number 5
> [ 1449.944046] usb 1-2: new high speed USB device number 6 using ehci_hcd
>
> and there aren't anything created in /dev/dvb.
>
> What am I doing wrong?

Never mind. after adding this patch:
http://patchwork.linuxtv.org/patch/9691/

and rebuilding the media drivers, the device is now detected:
tingo@kg-f4:~$ dmesg | grep -i terratec
[   19.755806] dvb-usb: found a 'TerraTec DTV StarBox DVB-T/C USB2.0
(az6007)' in warm state.
[   20.949045] DVB: registering new adapter (TerraTec DTV StarBox
DVB-T/C USB2.0 (az6007))
[   23.732039] Registered IR keymap rc-nec-terratec-cinergy-xs
[   23.732442] dvb-usb: TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)
successfully initialized and connected.


-- 
Regards,
Torfinn Ingolfsen
