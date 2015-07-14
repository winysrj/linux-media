Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35843 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbGNMvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 08:51:22 -0400
Received: by qkdv3 with SMTP id v3so5264572qkd.3
        for <linux-media@vger.kernel.org>; Tue, 14 Jul 2015 05:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c29a3c94d042b15780c33b68f71d16fc@www.kernellabs.com>
References: <c29a3c94d042b15780c33b68f71d16fc@www.kernellabs.com>
Date: Tue, 14 Jul 2015 08:51:21 -0400
Message-ID: <CALzAhNV7EadNu6Yx78zVxwtx9u01PkrGAoyguvq=ZmLdtKZmew@mail.gmail.com>
Subject: Re: www.kernellabs.com Contact: Hauppauge hvr1275 TV Tuner card linux problem
From: Steven Toth <stoth@kernellabs.com>
To: tonyc@wincomm.com.tw
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding in the linux-media mailing list

> Subject:
> Hauppauge hvr1275 TV Tuner card linux problem
>
> Message:
> I had one trouble about Hauppauge hvr1275 TV Tuner card
>
> Because of I want use tvtime app to play this TV Tuner card with ATI
> V4900 VGA Card under centos 6.5 linux 2.6.32-431.el6.i686
>
> First I have download Firmeare from:
>
> # wget
> http://steventoth.net/linux/hvr1200/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
>
> # wget http://steventoth.net/linux/hvr1200/extract.sh
>
> # /bin/sh extract.sh
>
> # sudo cp v4l-cx23885-enc.fw v4l-cx23885-avcore-01.fw
> dvb-fe-tda10048-1.0.fw /lib/firmware
>
> Second create cx23885.conf in /etc/modprobe.d/
>
> Options cx23885 card=19
>
> Type modprobe cx23885 in terminal
>
> When I execute tvtime app always show can’t open /dev/video0
>
> When I use dmesg in terminal show below
>
> Linux video capture interface: v2.00
>
> cx23885 driver version 0.0.2 loaded
>
> cx23885 0000:04:00.0: PCI INT A -_ GSI 16 (level, low) -_ IRQ 16
>
> CORE cx23885[0]: subsystem: 0070:2a38, board: Hauppauge WinTV-HVR1275
> [card=19,insmod option]
>
> IR NEC protocol handler initialized
>
> IR RC5(x) protocol handler initialized
>
> IR RC6 protocol handler initialized
>
> IR JVC protocol handler initialized
>
> IR Sony protocol handler initialized
>
> lirc_dev: IR Remote Control driver registered, major 248
>
> IR LIRC bridge handler initialized
>
> tveeprom 11-0050: Hauppauge model 161100, rev A1I6, serial# 9140928
>
> tveeprom 11-0050: MAC address is 00:0d:fe:8b:7a:c0
>
> tveeprom 11-0050: tuner model is unknown (idx 186, type 4)
>
> tveeprom 11-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L')
> PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
>
> tveeprom 11-0050: audio processor is CX23888 (idx 40)
>
> tveeprom 11-0050: decoder processor is CX23888 (idx 34)
>
> tveeprom 11-0050: has no radio, has IR receiver, has no IR
> transmitter
>
> cx23885[0]: warning: unknown hauppauge model #161100
>
> cx23885[0]: hauppauge eeprom: model=161100
>
> cx23885_dvb_register() allocating 1 frontend(s)
>
> cx23885[0]: cx23885 based dvb card
>
> lgdt3305_attach: unable to detect LGDT3305 hardware
>
> cx23885[0]: frontend initialization failed
>
> cx23885_dvb_register() dvb_register failed err = -1
>
> cx23885_dev_setup() Failed to register dvb on VID_C
>
> cx23885_dev_checkrevision() Hardware revision = 0xd0
>
> cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 16, latency: 0,
> mmio: 0xfbe00000
>
> cx23885 0000:04:00.0: setting latency timer to 64
>
>  alloc irq_desc for 34 on node -1
>
>  alloc kstat_irqs on node -1
>
> if use dmesg | grep cx23885 in terminal show below
>
> cx23885 driver version 0.0.2 loaded
>
> cx23885 0000:05:00.0: PCI INT A -_ GSI 16 (level, low) -_ IRQ 16
>
> CORE cx23885[0]: subsystem: 0070:2a38, board: Hauppauge WinTV-HVR1275
> [card=19,insmod option]
>
> cx23885[0]: warning: unknown hauppauge model #161100
>
> cx23885[0]: hauppauge eeprom: model=161100
>
> cx23885_dvb_register() allocating 1 frontend(s)
>
> cx23885[0]: cx23885 based dvb card
>
> cx23885[0]: frontend initialization failed
>
> cx23885_dvb_register() dvb_register failed err = -1
>
> cx23885_dev_setup() Failed to register dvb on VID_C
>
> cx23885_dev_checkrevision() Hardware revision = 0xd0
>
> cx23885[0]/0: found at 0000:05:00.0, rev: 4, irq: 16, latency: 0,
> mmio: 0xfbe00000
>
> cx23885 0000:05:00.0: setting latency timer to 64
>
> cx23885 0000:05:00.0: irq 35 for MSI/MSI-X
>
> sorry I don’t know how can I do .. can you help me to fix the
> problem?

Please ensure that all communication include the linux media mailing list.

It looks like Hauppauge have released an updated HVR-1275 card, as
indicated by the updated PCI-SubDevice ID 2A38. The hardware has
changed and the driver needs to be modified to support these changes.

Modprobing with option=19 isn't going to help.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
