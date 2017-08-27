Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:37456 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdH0KZE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 06:25:04 -0400
Subject: Fwd: Aw: Fwd: [PATCH 1/2] cx23885: Fix use-after-free when
 unregistering the i2c_client for the dvb demod
References: <trinity-baaff6e7-791e-44b8-bf92-f3c2cf7c194f-1503829135710@3c-app-gmx-bs65>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        mchehab@osg.samsung.com
Cc: crope@iki.fi, =?UTF-8?Q?Sven_M=c3=bcller?= <xpert-reactos@gmx.de>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <cea98caf-eefa-296d-0a8d-9f5c96aaf088@gentoo.org>
Date: Sun, 27 Aug 2017 12:25:04 +0200
MIME-Version: 1.0
In-Reply-To: <trinity-baaff6e7-791e-44b8-bf92-f3c2cf7c194f-1503829135710@3c-app-gmx-bs65>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forwarding a tested-by statement (using a HVR-5500).

Regards
Matthias

-------- Weitergeleitete Nachricht --------
Betreff: Aw: Fwd: [PATCH 1/2] cx23885: Fix use-after-free when
unregistering the i2c_client for the dvb demod
Datum: Sun, 27 Aug 2017 12:18:55 +0200
Von: "Sven Müller" <xpert-reactos@gmx.de>
An: Matthias Schwarzott <zzam@gentoo.org>

Tested-by: Sven Müller <xpert-reactos@gmx.de>

> Gesendet: Sonntag, 27. August 2017 um 12:12 Uhr
> Von: "Matthias Schwarzott" <zzam@gentoo.org>
> An: "Sven Müller" <xpert-reactos@gmx.de>
> Betreff: Fwd: [PATCH 1/2] cx23885: Fix use-after-free when unregistering the i2c_client for the dvb demod
>
> 
> 
> 
> -------- Weitergeleitete Nachricht --------
> Betreff: [PATCH 1/2] cx23885: Fix use-after-free when unregistering the
> i2c_client for the dvb demod
> Datum: Wed,  2 Aug 2017 18:45:59 +0200
> Von: Matthias Schwarzott <zzam@gentoo.org>
> An: linux-media@vger.kernel.org
> Kopie (CC): mchehab@osg.samsung.com, crope@iki.fi, Matthias Schwarzott
> <zzam@gentoo.org>
> 
> Unregistering the i2c_client of the demod driver destroys the frontend
> object.
> Calling vb2_dvb_unregister_bus later accesses the frontend (and with the
> refcount_t) conversion the refcount_t code complains:
> 
> kernel: ------------[ cut here ]------------
> kernel: WARNING: CPU: 0 PID: 7883 at lib/refcount.c:128
> refcount_sub_and_test+0x70/0x80
> kernel: refcount_t: underflow; use-after-free.
> kernel: Modules linked in: bluetooth si2165(O) a8293(O) tda10071(O)
> tea5767(O) tuner(O) cx23885(O-) tda18271(O) videobuf2_dvb(O)
> videobuf2_dma_sg(O) m88ds3103(O) tveeprom(O) cx2341x(O) v4l2_common(O)
> dvb_core(O) rc_core(O) videobuf2_memops(O) videobuf2_v4l2(O) ums_realtek
> videobuf2_core(O) uas videodev(O) media(O) rtl8192cu i2c_mux usb_storage
> rtl_usb rtl8192c_common rtlwifi snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core
> x86_pkg_temp_thermal kvm_intel kvm irqbypass
> kernel: CPU: 0 PID: 7883 Comm: rmmod Tainted: G        W  O
> 4.11.3-gentoo #3
> kernel: Hardware name: MEDION E2050 2391/H81H3-EM2, BIOS H81EM2W08.308
> 08/25/2014
> kernel: Call Trace:
> kernel:  dump_stack+0x4d/0x66
> kernel:  __warn+0xc6/0xe0
> kernel:  warn_slowpath_fmt+0x46/0x50
> kernel:  ? kobject_put+0x2f/0x60
> kernel:  refcount_sub_and_test+0x70/0x80
> kernel:  refcount_dec_and_test+0x11/0x20
> kernel:  dvb_unregister_frontend+0x42/0x60 [dvb_core]
> kernel:  vb2_dvb_dealloc_frontends+0x9e/0x100 [videobuf2_dvb]
> kernel:  vb2_dvb_unregister_bus+0xd/0x20 [videobuf2_dvb]
> kernel:  cx23885_dvb_unregister+0xc3/0x110 [cx23885]
> kernel:  cx23885_dev_unregister+0xea/0x150 [cx23885]
> kernel:  cx23885_finidev+0x4f/0x70 [cx23885]
> kernel:  pci_device_remove+0x34/0xb0
> kernel:  device_release_driver_internal+0x150/0x200
> kernel:  driver_detach+0x33/0x70
> kernel:  bus_remove_driver+0x47/0xa0
> kernel:  driver_unregister+0x27/0x50
> kernel:  pci_unregister_driver+0x34/0x90
> kernel:  cx23885_fini+0x10/0x12 [cx23885]
> kernel:  SyS_delete_module+0x166/0x220
> kernel:  ? exit_to_usermode_loop+0x7b/0x80
> kernel:  entry_SYSCALL_64_fastpath+0x17/0x98
> kernel: RIP: 0033:0x7f5901680b07
> kernel: RSP: 002b:00007ffdf6cdb028 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
> kernel: RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5901680b07
> kernel: RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000000001500258
> kernel: RBP: 00000000015001f0 R08: 0000000000000000 R09: 1999999999999999
> kernel: R10: 0000000000000884 R11: 0000000000000206 R12: 00007ffdf6cda010
> kernel: R13: 0000000000000000 R14: 00000000015001f0 R15: 00000000014ff010
> kernel: ---[ end trace c3a4659b89086061 ]---
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>  drivers/media/pci/cx23885/cx23885-dvb.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c
> b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 979b66627f60..e795ddeb7fe2 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -2637,6 +2637,11 @@ int cx23885_dvb_unregister(struct cx23885_tsport
> *port)
>  	struct vb2_dvb_frontend *fe0;
>  	struct i2c_client *client;
>  +	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
> +
> +	if (fe0 && fe0->dvb.frontend)
> +		vb2_dvb_unregister_bus(&port->frontends);
> +
>  	/* remove I2C client for CI */
>  	client = port->i2c_client_ci;
>  	if (client) {
> @@ -2665,11 +2670,6 @@ int cx23885_dvb_unregister(struct cx23885_tsport
> *port)
>  		i2c_unregister_device(client);
>  	}
>  -	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
> -
> -	if (fe0 && fe0->dvb.frontend)
> -		vb2_dvb_unregister_bus(&port->frontends);
> -
>  	switch (port->dev->board) {
>  	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
>  		netup_ci_exit(port);
> -- 
> 2.13.3
> 
> 
>
