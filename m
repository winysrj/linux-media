Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59885 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab0GJWiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 18:38:46 -0400
Received: by vws5 with SMTP id 5so3166795vws.19
        for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 15:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTil1wXrhQJwdxYoAQubAzgoK3qp5J6czsg0Z_qJU@mail.gmail.com>
References: <AANLkTil3JUgSE43P12RWUkErU1Uj5uQrTJQTzkq9eZQB@mail.gmail.com>
	<AANLkTil1wXrhQJwdxYoAQubAzgoK3qp5J6czsg0Z_qJU@mail.gmail.com>
Date: Sun, 11 Jul 2010 00:38:42 +0200
Message-ID: <AANLkTinzFK28263MVfFe-rFeyI-siefWAaPqTtsGS7X8@mail.gmail.com>
Subject: Re: 2.6.35-rc4 doesn't play well with TerraTec cinergyT2
From: Jan Willies <jan@willies.info>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/7/11 Jan Willies <jan@willies.info>:
> 2010/7/5 Jan Willies <jan@willies.info>:
[...]

and now this:

Jul 11 00:37:06 htpc kernel: usb 2-1: new high speed USB device using
ehci_hcd and address 2
Jul 11 00:37:06 htpc kernel: usb 2-1: config 1 interface 0 altsetting
0 bulk endpoint 0x1 has invalid maxpacket 64
Jul 11 00:37:06 htpc kernel: usb 2-1: config 1 interface 0 altsetting
0 bulk endpoint 0x81 has invalid maxpacket 64
Jul 11 00:37:06 htpc kernel: usb 2-1: New USB device found,
idVendor=0ccd, idProduct=0038
Jul 11 00:37:06 htpc kernel: usb 2-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
Jul 11 00:37:06 htpc kernel: usb 2-1: Product: Cinergy T²
Jul 11 00:37:06 htpc kernel: usb 2-1: Manufacturer: TerraTec GmbH
Jul 11 00:37:06 htpc kernel: dvb-usb: found a 'TerraTec/qanu USB2.0
Highspeed DVB-T Receiver' in warm state.
Jul 11 00:37:06 htpc kernel: ------------[ cut here ]------------
Jul 11 00:37:06 htpc kernel: WARNING: at lib/dma-debug.c:866
check_for_stack+0x71/0x9b()
Jul 11 00:37:06 htpc kernel: Hardware name: System Product Name
Jul 11 00:37:06 htpc kernel: ehci_hcd 0000:00:06.1: DMA-API: device
driver maps memory fromstack [addr=eff95e66]
Jul 11 00:37:06 htpc kernel: Modules linked in: dvb_usb_cinergyT2(+)
dvb_usb dvb_core sunrpc ipv6 uinput snd_hda_codec_nvhdmi
snd_hda_codec_via btusb bluetooth snd_hda_intel rfkill microcode
snd_hda_codec snd_hwdep snd_seq snd_seq_device r8169 snd_pcm mii wmi
asus_atk0110 serio_raw snd_timer snd soundcore snd_page_alloc
i2c_nforce2 usb_storage nouveau ttm drm_kms_helper drm i2c_algo_bit
video output i2c_core [last unloaded: scsi_wait_scan]
Jul 11 00:37:06 htpc kernel: Pid: 1475, comm: modprobe Not tainted
2.6.33.6-147.fc13.i686.debug #1
Jul 11 00:37:06 htpc kernel: ehci_hcd 0000:00:06.1: DMA-API: device
driver maps memory fromstack [addr=eff95e66]
Jul 11 00:37:06 htpc kernel: Modules linked in: dvb_usb_cinergyT2(+)
dvb_usb dvb_core sunrpc ipv6 uinput snd_hda_codec_nvhdmi
snd_hda_codec_via btusb bluetooth snd_hda_intel rfkill microcode
snd_hda_codec snd_hwdep snd_seq snd_seq_device r8169 snd_pcm mii wmi
asus_atk0110 serio_raw snd_timer snd soundcore snd_page_alloc
i2c_nforce2 usb_storage nouveau ttm drm_kms_helper drm i2c_algo_bit
video output i2c_core [last unloaded: scsi_wait_scan]
Jul 11 00:37:06 htpc kernel: Pid: 1475, comm: modprobe Not tainted
2.6.33.6-147.fc13.i686.debug #1
Jul 11 00:37:06 htpc kernel: Call Trace:
Jul 11 00:37:06 htpc kernel: [<c043b5c6>] warn_slowpath_common+0x6a/0x81
Jul 11 00:37:06 htpc kernel: [<c05ccc84>] ? check_for_stack+0x71/0x9b
Jul 11 00:37:06 htpc kernel: [<c043b61b>] warn_slowpath_fmt+0x29/0x2c
Jul 11 00:37:06 htpc kernel: [<c05ccc84>] check_for_stack+0x71/0x9b
Jul 11 00:37:06 htpc kernel: [<c05ccc84>] ? check_for_stack+0x71/0x9b
Jul 11 00:37:06 htpc kernel: [<c043b61b>] warn_slowpath_fmt+0x29/0x2c
Jul 11 00:37:06 htpc kernel: [<c05ccc84>] check_for_stack+0x71/0x9b
Jul 11 00:37:06 htpc kernel: [<c05cd7e3>] debug_dma_map_page+0xef/0x104
Jul 11 00:37:06 htpc kernel: [<c06b045f>] dma_map_single_attrs.clone.2+0x6d/0x77
Jul 11 00:37:06 htpc kernel: [<c06b05aa>] usb_hcd_submit_urb+0x141/0x882
Jul 11 00:37:06 htpc kernel: [<c04627d0>] ? trace_hardirqs_on_caller+0x104/0x125
Jul 11 00:37:06 htpc kernel: [<c06b05aa>] usb_hcd_submit_urb+0x141/0x882
Jul 11 00:37:06 htpc kernel: [<c04627d0>] ? trace_hardirqs_on_caller+0x104/0x125
Jul 11 00:37:06 htpc kernel: [<c0461b51>] ? lockdep_init_map+0x88/0xf3
Jul 11 00:37:06 htpc kernel: [<c06b130d>] usb_submit_urb+0x244/0x2a5
Jul 11 00:37:06 htpc kernel: [<c06b2049>] usb_start_wait_urb+0x4d/0x14b
Jul 11 00:37:06 htpc kernel: [<c04d7c45>] ? __kmalloc+0x11b/0x155
Jul 11 00:37:06 htpc kernel: [<c06b2049>] usb_start_wait_urb+0x4d/0x14b
Jul 11 00:37:06 htpc kernel: [<c04d7c45>] ? __kmalloc+0x11b/0x155
Jul 11 00:37:06 htpc kernel: [<c06b1670>] ? usb_alloc_urb+0x14/0x34
Jul 11 00:37:06 htpc kernel: [<c06b2221>] usb_bulk_msg+0xda/0xe4
Jul 11 00:37:06 htpc kernel: [<fe6e3a14>]
dvb_usb_generic_rw+0x9a/0x13f [dvb_usb]
Jul 11 00:37:06 htpc kernel: [<fe6e3a14>]
dvb_usb_generic_rw+0x9a/0x13f [dvb_usb]
Jul 11 00:37:06 htpc kernel: [<fe6f204a>]
cinergyt2_power_ctrl+0x2a/0x2c [dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<fe6e32e7>]
dvb_usb_device_power_ctrl+0x37/0x3d [dvb_usb]
Jul 11 00:37:06 htpc kernel: [<fe6e3675>]
dvb_usb_device_init+0x258/0x4bb [dvb_usb]
Jul 11 00:37:06 htpc kernel: [<fe6f201e>]
cinergyt2_usb_probe+0x1e/0x20 [dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<c06b48fa>] usb_probe_interface+0x12d/0x1ce
Jul 11 00:37:06 htpc kernel: [<c066414f>] driver_probe_device+0xca/0x1d2
Jul 11 00:37:06 htpc kernel: [<c066429f>] __driver_attach+0x48/0x64
Jul 11 00:37:06 htpc kernel: [<c0663736>] bus_for_each_dev+0x42/0x6c
Jul 11 00:37:06 htpc kernel: [<c0663f3d>] driver_attach+0x19/0x1b
Jul 11 00:37:06 htpc kernel: [<c0664257>] ? __driver_attach+0x0/0x64
Jul 11 00:37:06 htpc kernel: [<c06639c5>] bus_add_driver+0x101/0x24a
Jul 11 00:37:06 htpc kernel: [<c066450a>] driver_register+0x81/0xe8
Jul 11 00:37:06 htpc kernel: [<c05c709a>] ? __raw_spin_lock_init+0x28/0x4e
Jul 11 00:37:06 htpc kernel: [<c06b465f>] usb_register_driver+0x79/0x11c
Jul 11 00:37:06 htpc kernel: [<fe6f6000>] ?
cinergyt2_usb_init+0x0/0x32 [dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<fe6f6018>] cinergyt2_usb_init+0x18/0x32
[dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<c0401143>] do_one_initcall+0x51/0x144
Jul 11 00:37:06 htpc kernel: [<fe6f6000>] ?
cinergyt2_usb_init+0x0/0x32 [dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<fe6f6018>] cinergyt2_usb_init+0x18/0x32
[dvb_usb_cinergyT2]
Jul 11 00:37:06 htpc kernel: [<c0401143>] do_one_initcall+0x51/0x144
Jul 11 00:37:06 htpc kernel: [<c046e294>] sys_init_module+0xae/0x1e6
Jul 11 00:37:06 htpc kernel: [<c07b4c44>] syscall_call+0x7/0xb
Jul 11 00:37:06 htpc kernel: ---[ end trace 1425b070763525e2 ]---
Jul 11 00:37:06 htpc kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Jul 11 00:37:06 htpc kernel: DVB: registering new adapter
(TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
Jul 11 00:37:06 htpc kernel: DVB: registering adapter 0 frontend 0
(TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)...
Jul 11 00:37:06 htpc kernel: input: IR-receiver inside an USB DVB
receiver as /devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input3
Jul 11 00:37:06 htpc kernel: dvb-usb: schedule remote query interval
to 50 msecs.
Jul 11 00:37:06 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver successfully initialized and connected.
Jul 11 00:37:06 htpc kernel: usbcore: registered new interface driver cinergyT2

Is this a hardware error? maybe because it's too warm in here?
