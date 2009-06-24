Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55169 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFXJvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 05:51:32 -0400
Received: by fxm9 with SMTP id 9so620192fxm.37
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2009 02:51:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <EOPJI6B23SQKFwSx@onasticksoftware.net>
References: <EOPJI6B23SQKFwSx@onasticksoftware.net>
From: =?UTF-8?B?Um9tw6Fu?= <roman.pena.perez@gmail.com>
Date: Wed, 24 Jun 2009 11:51:13 +0200
Message-ID: <28a25ce0906240251ia3a7492y14327289ca1e60cb@mail.gmail.com>
Subject: Re: [linux-dvb] dvb v4l code break webcam drivers
To: linux-media@vger.kernel.org, linux-dvb <linux-dvb@linuxtv.org>,
	jon bird <news@onastick.clara.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/6/23 jon bird <news@onastick.clara.co.uk>:
> I replaced my stock Linux V4l/dvb drivers with the versions from cvs on
> linuxtv.org whilst attempting to resolve problems with my Nova-T stick
> (a red herring as it happens). However what I've discovered since is
> that they argue quite badly with drivers for the 2 webcams I have (of
> course the webcam drivers themselves may be at fault here but I thought
> it worth pointing out....).
>
> Replacing the linux kernel modules (2.6.26) resolves the problem and
> both these and the DVB side work.
>
> here's the log from the snapshot I took 2 days ago:
>
> Jun 22 17:17:55 fridge kernel: ------------[ cut here ]------------
> Jun 22 17:17:55 fridge kernel: WARNING: at
> /opt2/data/kernel/v4l-dvb-6c50c4b2ef70/v4l/v4l2-dev.c:434
> video_register_device_index+0x3a/0x354 [videodev]()
> Jun 22 17:17:55 fridge kernel: Modules linked in: gspca(+) videodev
> v4l1_compat af_packet nfsd exportfs usbserial ppdev parport_pc lp
> parport snd_pcm_oss snd_mixer_oss snd_via82xx snd_ac97_codec ac97_bus
> snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi
> snd_seq_device snd soundcore xt_TCPMSS xt_DSCP ipt_MASQUERADE ipt_LOG
> ipt_REDIRECT xt_state joydev evdev dvb_usb_dib0700 dib7000p dib7000m
> dvb_usb dvb_core firmware_class dib3000mc dibx000_common dib0070
> uhci_hcd ohci_hcd ehci_hcd usbcore ipv6 8139too mii ipt_REJECT
> iptable_mangle iptable_nat nf_nat iptable_filter nf_conntrack_ipv4
> nf_conntrack ip_tables mt2060 i2c_core sata_via libata dock 8250
> serial_core
> Jun 22 17:17:55 fridge kernel: Pid: 3853, comm: modprobe Not tainted
> 2.6.26 #9
> Jun 22 17:17:55 fridge kernel:  [warn_on_slowpath+62/91]
> warn_on_slowpath+0x3e/0x5b
> Jun 22 17:17:55 fridge kernel:  [<c0117690>] warn_on_slowpath+0x3e/0x5b
> Jun 22 17:17:55 fridge kernel:  [__wake_up+15/21] __wake_up+0xf/0x15
> Jun 22 17:17:55 fridge kernel:  [<c0114aa9>] __wake_up+0xf/0x15
> Jun 22 17:17:55 fridge kernel:  [wake_up_klogd+43/45]
> wake_up_klogd+0x2b/0x2d
> Jun 22 17:17:55 fridge kernel:  [<c0118109>] wake_up_klogd+0x2b/0x2d
> Jun 22 17:17:55 fridge kernel:  [<f8982405>]
> usb_internal_control_msg+0x54/0x61 [usbcore]
> Jun 22 17:17:55 fridge kernel:  [<f8982490>] usb_control_msg+0x7e/0x8b
> [usbcore]
> Jun 22 17:17:55 fridge kernel:  [printk+14/17] printk+0xe/0x11
> Jun 22 17:17:55 fridge kernel:  [<c0117cdc>] printk+0xe/0x11
> Jun 22 17:17:55 fridge kernel:  [<f8ca5a6d>]
> spca5xx_getcapability+0xa2/0xad [gspca]
> Jun 22 17:17:55 fridge kernel:  [<f8c353ae>]
> video_register_device_index+0x3a/0x354 [videodev]
> Jun 22 17:17:55 fridge kernel:  [<f8c35372>]
> video_register_device+0x7/0x9 [videodev]
> Jun 22 17:17:55 fridge kernel:  [<f8caa441>] spca5xx_probe+0x1f4/0x287
> [gspca]
> Jun 22 17:17:55 fridge kernel:  [<f8983b95>]
> usb_probe_interface+0xb3/0xde [usbcore]
> Jun 22 17:17:55 fridge kernel:  [__driver_attach+0/85]
> __driver_attach+0x0/0x55
> Jun 22 17:17:55 fridge kernel:  [<c0227384>] __driver_attach+0x0/0x55
> Jun 22 17:17:55 fridge kernel:  [really_probe+112/226]
> really_probe+0x70/0xe2
> Jun 22 17:17:55 fridge kernel:  [<c022725d>] really_probe+0x70/0xe2
> Jun 22 17:17:55 fridge kernel:  [driver_probe_device+54/62]
> driver_probe_device+0x36/0x3e
> Jun 22 17:17:55 fridge kernel:  [<c022731a>]
> driver_probe_device+0x36/0x3e
> Jun 22 17:17:55 fridge kernel:  [__driver_attach+55/85]
> __driver_attach+0x37/0x55
> Jun 22 17:17:55 fridge kernel:  [<c02273bb>] __driver_attach+0x37/0x55
> Jun 22 17:17:55 fridge kernel:  [bus_for_each_dev+53/89]
> bus_for_each_dev+0x35/0x59
> Jun 22 17:17:55 fridge kernel:  [<c02267b6>] bus_for_each_dev+0x35/0x59
> Jun 22 17:17:55 fridge kernel:  [driver_attach+17/19]
> driver_attach+0x11/0x13
> Jun 22 17:17:55 fridge kernel:  [<c02273ea>] driver_attach+0x11/0x13
> Jun 22 17:17:55 fridge kernel:  [__driver_attach+0/85]
> __driver_attach+0x0/0x55
> Jun 22 17:17:55 fridge kernel:  [<c0227384>] __driver_attach+0x0/0x55
> Jun 22 17:17:55 fridge kernel:  [bus_add_driver+138/306]
> bus_add_driver+0x8a/0x132
> Jun 22 17:17:55 fridge kernel:  [<c0226cf4>] bus_add_driver+0x8a/0x132
> Jun 22 17:17:55 fridge kernel:  [driver_register+104/136]
> driver_register+0x68/0x88
> Jun 22 17:17:55 fridge kernel:  [<c0227716>] driver_register+0x68/0x88
> Jun 22 17:17:55 fridge kernel:  [<f898409b>]
> usb_register_driver+0x52/0x9c [usbcore]
> Jun 22 17:17:55 fridge kernel:  [<f8b37014>] usb_spca5xx_init+0x14/0x31
> [gspca]
> Jun 22 17:17:55 fridge kernel:  [<c0131660>] sys_init_module+0x84/0x173
> Jun 22 17:17:55 fridge kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
> Jun 22 17:17:55 fridge kernel:  [<c0102a22>] syscall_call+0x7/0xb
> Jun 22 17:17:55 fridge kernel:  =======================
> Jun 22 17:17:55 fridge kernel: ---[ end trace be190c3dbfd1c67f ]---
>
>
> this happens with the spca5xx webcam driver and the old Logitech
> quickcam express driver.
>
>
> --
> == jon bird - software engineer
> == <reply to address _may_ be invalid, real mail below>
> == <reduce rsi, stop using the shift key>
> == posted as: news 'at' onastick 'dot' clara.co.uk
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

 I can confirm this behaviour on gspcaxx and spcaxx drivers since
several years ago.

  Román
