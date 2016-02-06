Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:40145 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcBFUC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2016 15:02:56 -0500
Received: from [192.168.0.3] (tobbe.lan [192.168.0.3])
	by gammdatan.lan (8.15.2/8.14.7) with ESMTP id u16K2pxh008407
	for <linux-media@vger.kernel.org>; Sat, 6 Feb 2016 21:02:51 +0100
Subject: Re: dvb_usb_dvbsky module not loading (ida_remove something)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <56B5CEFC.3080105@mbox200.swipnet.se>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <56B6516B.1060402@mbox200.swipnet.se>
Date: Sat, 6 Feb 2016 21:02:51 +0100
MIME-Version: 1.0
In-Reply-To: <56B5CEFC.3080105@mbox200.swipnet.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

managed to bisect this and found the commit from where it broke.

this one does not work:
0d3ab84 [media] dvb core: must check dvb_create_media_graph()

but the commit just before do work:
13f6e88 [media] v4l2 core: enable all interface links at init

unfortunately i know too little of the code to understand why it broke.


while doing this i learned several other things, like it is not fun to 
try to bisect thru the non media changes (kernel update i think).
and in media_build backports/api_version.patch tends to not apply 
cleanly sometimes so had to go back to media_build commit 2679653 to do 
the testing.


On 2016-02-06 11:46, Torbjorn Jansson wrote:
> Hello.
>
> i was testing media_build on a test vm with one of my usb dvb-t2 devices.
> a few weeks ago this worked fine and modules loaded but now during boot
> i get the below errors in dmesg.
>
> any idea whats going on?
>
> can someone also tell me how to go back to an earlier version or point
> me to where i can do some reading about it so i can try to find out when
> it broke?
>
>
>
> ----
> [    5.377423] WARNING: You are using an experimental version of the
> media stack.
>                  As the driver is backported to an older kernel, it
> doesn't offer
>                  enough quality for its usage in production.
>                  Use it with care.
>                 Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
>                  e545ac872ff884801a48beb7e6e0fc7513555fd9 [media]
> tvp5150: Add pad-level subdev operations
>                  4f57d27be2a5a10ad042fcfd97c5ea9f4d5215f7 [media]
> tvp5150: fix tvp5150_fill_fmt()
>                  841502d731f1708aae907d5bdf1659e8a372fc9a Revert [media]
> tvp5150: Fix breakage for serial usage
> [    5.559672] usb 1-5: dvb_usb_v2: found a 'TechnoTrend TT-connect
> CT2-4650 CI v1.1' in warm state
> [    5.559759] usb 1-5: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [    5.559777] DVB: registering new adapter (TechnoTrend TT-connect
> CT2-4650 CI v1.1)
> [    5.559781] usb 1-5: media controller created
> [    5.561329] usb 1-5: dvb_usb_v2: MAC address: bc:ea:2b:65:06:6f
> [    5.561816] dvb_create_media_entity: media entity 'dvb-demux'
> registered.
> [    5.566366] i2c i2c-1: Added multiplexed i2c bus 2
> [    5.566369] si2168 1-0064: Silicon Labs Si2168 successfully attached
> [    5.577179] si2157 2-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [    5.587843] dvb_create_media_entity: media entity 'dvb-ca-en50221'
> registered.
> [    5.588476] sp2 1-0040: CIMaX SP2 successfully attached
> [    5.588484] usb 1-5: DVB: registering adapter 0 frontend 0 (Silicon
> Labs Si2168)...
> [    5.588488] dvb_create_media_entity: media entity 'Silicon Labs
> Si2168' registered.
> [    5.591376] ------------[ cut here ]------------
> [    5.591383] WARNING: CPU: 1 PID: 560 at lib/idr.c:1051
> ida_remove+0xef/0x120()
> [    5.591384] ida_remove called for id=512 which is not allocated.
> [    5.591385] Modules linked in: sp2(OE) si2157(OE) si2168(OE)
> dvb_usb_dvbsky(OE+) m88ds3103(OE) dvb_usb_v2(OE) i2c_mux dvb_core(OE)
> rc_core(OE) media(OE) joydev ppdev iosf_mbi crct10dif_pclmul
> crc32_pclmul crc32c_intel snd_hda_codec_generic snd_hda_intel
> snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device
> virtio_balloon snd_pcm snd_timer pvpanic snd parport_pc parport
> i2c_piix4 soundcore acpi_cpufreq tpm_tis tpm qxl drm_kms_helper ttm
> 8021q garp stp virtio_console llc virtio_blk mrp virtio_net drm
> serio_raw virtio_pci virtio_ring virtio ata_generic pata_acpi
> [    5.591436] CPU: 1 PID: 560 Comm: systemd-udevd Tainted: G OE
> 4.3.4-200.fc22.x86_64 #1
> [    5.591437] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    5.591438]  0000000000000000 00000000999f62be ffff8800369cb6f8
> ffffffff813a625f
> [    5.591440]  ffff8800369cb740 ffff8800369cb730 ffffffff810a07c2
> ffff88007b61b3e8
> [    5.591442]  ffff88007b61b3e8 0000000000000206 ffff8800369e3500
> ffff88007b45c158
> [    5.591491] Call Trace:
> [    5.591504]  [<ffffffff813a625f>] dump_stack+0x44/0x55
> [    5.591507]  [<ffffffff810a07c2>] warn_slowpath_common+0x82/0xc0
> [    5.591516]  [<ffffffff810a085c>] warn_slowpath_fmt+0x5c/0x80
> [    5.591519]  [<ffffffff813bab85>] ? find_next_bit+0x15/0x20
> [    5.591521]  [<ffffffff813a73ff>] ida_remove+0xef/0x120
> [    5.591523]  [<ffffffff813a7e7b>] ida_simple_remove+0x2b/0x50
> [    5.591527]  [<ffffffffa022004d>]
> __media_device_unregister_entity+0x2d/0xd0 [media]
> [    5.591529]  [<ffffffffa022011c>]
> media_device_unregister_entity+0x2c/0x40 [media]
> [    5.591532]  [<ffffffffa023a0ff>] dvb_media_device_free+0x1f/0x130
> [dvb_core]
> [    5.591535]  [<ffffffffa023a252>] dvb_unregister_device+0x42/0x80
> [dvb_core]
> [    5.591539]  [<ffffffffa0240a05>] dvb_ca_en50221_release+0x75/0xb0
> [dvb_core]
> [    5.591541]  [<ffffffffa0235289>] sp2_remove+0x49/0xa0 [sp2]
> [    5.591554]  [<ffffffff815dc18b>] i2c_device_remove+0x4b/0xa0
> [    5.591557]  [<ffffffff814d9501>] __device_release_driver+0xa1/0x150
> [    5.591566]  [<ffffffff814d95d3>] device_release_driver+0x23/0x30
> [    5.591568]  [<ffffffff814d8c21>] bus_remove_device+0x101/0x170
> [    5.591571]  [<ffffffff814d4ec9>] device_del+0x139/0x260
> [    5.591573]  [<ffffffff813a8647>] ? kobject_put+0x27/0x50
> [    5.591575]  [<ffffffff815dc680>] ? __unregister_dummy+0x30/0x30
> [    5.591577]  [<ffffffff814d500e>] device_unregister+0x1e/0x60
> [    5.591578]  [<ffffffff815dc6be>] __unregister_client+0x3e/0x50
> [    5.591581]  [<ffffffff814d4970>] device_for_each_child+0x50/0x90
> [    5.591583]  [<ffffffff815de99e>] i2c_del_adapter+0x20e/0x300
> [    5.591586]  [<ffffffff81203ed8>] ? kfree+0x128/0x130
> [    5.591599]  [<ffffffffa0263974>] dvb_usbv2_exit+0x1c4/0x3c0
> [dvb_usb_v2]
> [    5.591602]  [<ffffffffa026444f>] dvb_usbv2_probe+0xff/0x1270
> [dvb_usb_v2]
> [    5.591605]  [<ffffffff814e4619>] ? __pm_runtime_set_status+0x189/0x230
> [    5.591616]  [<ffffffff81570282>] usb_probe_interface+0x1b2/0x2d0
> [    5.591658]  [<ffffffff814d9b82>] driver_probe_device+0x222/0x480
> [    5.591660]  [<ffffffff814d9e64>] __driver_attach+0x84/0x90
> [    5.591662]  [<ffffffff814d9de0>] ? driver_probe_device+0x480/0x480
> [    5.591663]  [<ffffffff814d765c>] bus_for_each_dev+0x6c/0xc0
> [    5.591665]  [<ffffffff814d933e>] driver_attach+0x1e/0x20
> [    5.591666]  [<ffffffff814d8e7b>] bus_add_driver+0x1eb/0x280
> [    5.591668]  [<ffffffff814da6b0>] driver_register+0x60/0xe0
> [    5.591670]  [<ffffffff8156eb24>] usb_register_driver+0x84/0x140
> [    5.591672]  [<ffffffffa003f000>] ? 0xffffffffa003f000
> [    5.591675]  [<ffffffffa003f01e>] dvbsky_usb_driver_init+0x1e/0x1000
> [dvb_usb_dvbsky]
> [    5.591677]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
> [    5.591680]  [<ffffffff8120427e>] ? kmem_cache_alloc_trace+0x19e/0x220
> [    5.591682]  [<ffffffff811a4947>] ? do_init_module+0x27/0x1e5
> [    5.591684]  [<ffffffff811a497f>] do_init_module+0x5f/0x1e5
> [    5.591688]  [<ffffffff811254fe>] load_module+0x201e/0x2630
> [    5.591700]  [<ffffffff811219c0>] ? __symbol_put+0x60/0x60
> [    5.591703]  [<ffffffff81229830>] ? kernel_read+0x50/0x80
> [    5.591706]  [<ffffffff81125d59>] SyS_finit_module+0xb9/0xf0
> [    5.591716]  [<ffffffff8178182e>] entry_SYSCALL_64_fastpath+0x12/0x71
> [    5.591718] ---[ end trace 60bef98e54788a23 ]---
> [    5.592176] dvb_usb_dvbsky: probe of 1-5:1.0 failed with error -12
> [    5.592198] usbcore: registered new interface driver dvb_usb_dvbsky
> ----

