Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab1FVS0o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:26:44 -0400
Message-ID: <4E0233DE.6030802@redhat.com>
Date: Wed, 22 Jun 2011 15:26:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: nogueira13 <nogueira13@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: KAIOMY ISDB-T Hybrid USB Dongle Receiver
References: <BANLkTimRt5m_+LBGqF25YY9jU=OLUtXFeg@mail.gmail.com>
In-Reply-To: <BANLkTimRt5m_+LBGqF25YY9jU=OLUtXFeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Antônio,

Em 22-06-2011 15:13, nogueira13 escreveu:
> I bought a KAIOMY ISDB-T Hybrid USB Dongle Receiver to use with my
> Dell Inspiron 15 Laptop under Ubuntu 11.04 Linux. But I connect it in
> the USB port and it doesn't recognises it. The kernel version I am
> using is the 2.6.38-8-generic. I opened the menuconfig of the kernel
> and I could saw that all modules in the especific section "Device
> Drivers --> Multimedia support --> DVB/ATSC Adapters" are all set to
> <M>. I was thinking that the driver v2l already was buit in this
> modules. But when I connected the device in the USB port I got the
> following autputs to the lsusb and dmesg commands in the console:
> 
> Without the device connected
> 
> nogueira@nogueira-Inspiron-1545:~$ lsusb
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
> Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
> Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
> Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub
> (part of BCM2046 Bluetooth)
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 004: ID 0c45:63ee Microdia
> Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0
> multicard reader
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> nogueira@nogueira-Inspiron-1545:~$
> 
> 
> With the device connected
> 
> nogueira@nogueira-Inspiron-1545:~$ lsusb
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
> Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
> Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
> Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub
> (part of BCM2046 Bluetooth)
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 014: ID 1554:5019 Prolink Microsystems Corp.
> Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 004: ID 0c45:63ee Microdia
> Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0
> multicard reader
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> nogueira@nogueira-Inspiron-1545:~$
> 
> I guess that the device pointed is Device 014, Prolink Microsystems Corp.

Hmm... This device seems to be, in reality, a Prolink device. It is probably
close to the current Prolink/Pixelview ISDB-T devices already supported.

The first devices from this manufacturer were using dib0700/dib8000. Newer
devices were using cx231xx chipsets.

I have a few Prolink devices here, but I don't think that any of them have
this USB ID (1554:5019). I'll need to double-check though. I'm seeking for some
spare time to add support for a mew more devices.

Anyway, I'm not sure what's the chipset used inside your device. If the device 
is hybrid, it probably has a cx231xx chipset. If so, probably, all that it is 
needed is to add the USB ID at cx231xx driver in order to make it work, of 
course assuming that they didn't make any other hange like using a different 
tuner on it.

Abraços,
Mauro





