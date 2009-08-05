Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:57818 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZHES0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 14:26:07 -0400
Received: from [192.168.1.21] (151.59.219.5) by cp-out8.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A79A60C000356D4 for linux-media@vger.kernel.org; Wed, 5 Aug 2009 20:26:06 +0200
Message-ID: <4A79CEBD.1050909@iol.it>
Date: Wed, 05 Aug 2009 20:26:05 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it>	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>	 <4A7140DD.7040405@iol.it>	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>	 <4A729117.6010001@iol.it>	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>	 <4A739DD6.8030504@iol.it>	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>	 <4A79320B.7090401@iol.it> <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
In-Reply-To: <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Which distro is this

Ubuntu 9.04
kernel 2.6.28-14-generic

> and have you updated the kernel since checking out the code?

no

> It's also possible if you were playing around with the mcentral
> repository that both versions of em28xx are still installed.

Mauro Carvalho Chehab wrote:
> Try a make rminstall. This is required with Ubuntu, since it installs
> drivers/media at the wrong dir

I disconnected the TV tuner, then
$ sudo make unload
$ sudo make rminstall
in the three following subdirectories:
v4l-dvb
v4l-dvb-kernel  (mcentral hg copy)
ttxs-remote

Then follow instructions from Devin:
hg clone http://kernellabs.com/hg/~dheitmueller/ttxs-remote
cd ttxs-remote
make
sudo make install
reboot

No error on compile and install time.
But same results, Kaffeine do not see the TVtuner, and dmesg report this 
on USB connect:

Aug  5 20:12:16 01ath3200 kernel: [  182.312039] usb 1-3: new high speed 
USB device using ehci_hcd and address 3
Aug  5 20:12:16 01ath3200 kernel: [  182.497009] usb 1-3: configuration 
#1 chosen from 1 choice
Aug  5 20:12:16 01ath3200 kernel: [  182.622103] usbcore: registered new 
interface driver snd-usb-audio
Aug  5 20:12:17 01ath3200 kernel: [  182.810124] Linux video capture 
interface: v2.00
Aug  5 20:12:17 01ath3200 kernel: [  182.831714] em28xx: disagrees about 
version of symbol v4l_compat_translate_ioctl
Aug  5 20:12:17 01ath3200 kernel: [  182.831725] em28xx: Unknown symbol 
v4l_compat_translate_ioctl
Aug  5 20:12:17 01ath3200 kernel: [  182.835363] em28xx: disagrees about 
version of symbol video_unregister_device
Aug  5 20:12:17 01ath3200 kernel: [  182.835370] em28xx: Unknown symbol 
video_unregister_device
Aug  5 20:12:17 01ath3200 kernel: [  182.835754] em28xx: disagrees about 
version of symbol video_device_alloc
Aug  5 20:12:17 01ath3200 kernel: [  182.835759] em28xx: Unknown symbol 
video_device_alloc
Aug  5 20:12:17 01ath3200 kernel: [  182.835944] em28xx: disagrees about 
version of symbol video_register_device
Aug  5 20:12:17 01ath3200 kernel: [  182.835949] em28xx: Unknown symbol 
video_register_device
Aug  5 20:12:17 01ath3200 kernel: [  182.836988] em28xx: disagrees about 
version of symbol video_usercopy
Aug  5 20:12:17 01ath3200 kernel: [  182.836993] em28xx: Unknown symbol 
video_usercopy
Aug  5 20:12:17 01ath3200 kernel: [  182.837178] em28xx: disagrees about 
version of symbol video_device_release
Aug  5 20:12:17 01ath3200 kernel: [  182.837183] em28xx: Unknown symbol 
video_device_release
... (repeated 3 times)
Aug  5 20:12:18 01ath3200 pulseaudio[4364]: alsa-util.c: Cannot find 
fallback mixer control "Mic" or mixer control is no combination of 
switch/volume.

