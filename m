Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp31.wxs.nl ([195.121.247.33]:51641 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0FXOzg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 10:55:36 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L4I00F5DXGAK0@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 24 Jun 2010 16:55:23 +0200 (CEST)
Date: Thu, 24 Jun 2010 16:55:20 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Help wanted on removing dibusb_rc_keys from  dvb_usb_rtl2831u module
In-reply-to: <4C1D1228.1090702@holzeisen.de>
To: Thomas Holzeisen <thomas@holzeisen.de>, linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Message-id: <4C2371D8.8090601@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4C1D1228.1090702@holzeisen.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is probably caused by the current dvb_usb_rtl2831u module using 
dibusb_rc_keys, which disapperead due to IR changes.

Syncing the rtl2831-r2/ tree with the main archive cause compilation 
problems in v4l/dibusb-mc.c and I suppose rtd2830u.c will not compile 
anymore either.

Can somebody with knowledge on IR help me with updating the code ?

$ grep dibusb_rc_keys */*.[ch]
v4l/dibusb-mc.c:	.rc_key_map       = dibusb_rc_keys,
v4l/rtd2830u.c:		d->props.rc_key_map = dibusb_rc_keys;
v4l/rtd2830u.c:	.rc_key_map = dibusb_rc_keys,
v4l/rtd2830u.c:	.rc_key_map = dibusb_rc_keys,

I addition, I'd like to get help on how to move the IR code into
http://linuxtv.org/hg/~anttip/rtl2831u

That (in all other respects much better) version has NO IR support at 
all at. Adding IR to that driver, and getting it into the kernel would 
solve all problems.

Thomas Holzeisen wrote:
> Hi,
> 
> i am using a DVB-T USB-Stick with Realtek RTL2831 chip (14aa:0160) on 
> Debian Lenny having the lastest Backport kernel 2.6.32.
> 
>> $ uname -a
>> Linux xbmc 2.6.32-bpo.5-686 #1 SMP Fri Jun 11 22:20:29 UTC 2010 i686 
>> GNU/Linux
> 
> For v4l I took the drivers from here:
> 
>> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/
> 
> The checked out source compile and installs fine. I compiled them 
> starting with "make distclean". But when plugging the DVB-Stick this 
> happens:
> 
>> [  229.524028] usb 4-2: new high speed USB device using ehci_hcd and 
>> address 3
>> [  229.658591] usb 4-2: New USB device found, idVendor=14aa, 
>> idProduct=0160
>> [  229.661204] usb 4-2: New USB device strings: Mfr=1, Product=2, 
>> SerialNumber=3
>> [  229.663841] usb 4-2: Product: DTV Receiver
>> [  229.666308] usb 4-2: Manufacturer: DTV Receiver
>> [  229.668826] usb 4-2: SerialNumber: 0000000000067936
>> [  229.671609] usb 4-2: configuration #1 chosen from 1 choice
>> [  230.266960] dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' in warm 
>> state.
>> [  230.270314] dvb-usb: will pass the complete MPEG2 transport stream 
>> to the software demuxer.
>> [  230.273641] DVB: registering new adapter (Freecom USB 2.0 DVB-T 
>> Device)
>> [  230.277461] DVB: registering adapter 0 frontend 0 (Realtek RTL2831 
>> DVB-T)...
>> [  230.282081] BUG: unable to handle kernel paging request at 02b65c40
>> [  230.285794] IP: [<f7c623ba>] dvb_usb_remote_init+0x12e/0x209 [dvb_usb]
>> [  230.291463] *pde = 00000000
>> [  230.293969] Oops: 0002 [#1] SMP
>> [  230.293969] last sysfs file: 
>> /sys/devices/pci0000:00/0000:00:06.1/usb4/4-2/bmAttributes
>> [  230.293969] Modules linked in: dvb_usb_rtl2831u(+) 
>> dvb_usb_dibusb_common dvb_usb dib3000mc dibx000_common dvb_ttpci 
>> dvb_core saa7146_vv videodev v4l1_compat saa7146 videobuf_dma_sg 
>> videobuf_core ttpci_eeprom iscsi_trgt crc32c loop snd_hda_codec_nvhdmi 
>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
>> snd_seq snd_timer snd_seq_device snd tpm_tis soundcore tpm shpchp 
>> psmouse wmi serio_raw tpm_bios snd_page_alloc pcspkr pci_hotplug 
>> processor evdev button ir_core nvidia(P) lirc_imon i2c_nforce2 
>> i2c_core lirc_dev ext3 jbd mbcache raid1 md_mod usbhid hid sg sr_mod 
>> cdrom sd_mod crc_t10dif usb_storage ahci ata_generic libata ehci_hcd 
>> ohci_hcd scsi_mod usbcore nls_base forcedeth thermal fan thermal_sys 
>> [last unloaded: scsi_wait_scan]
>> [  230.293969]
>> [  230.293969] Pid: 3279, comm: modprobe Tainted: P           
>> (2.6.32-bpo.5-686 #1) Point of View
>> [  230.293969] EIP: 0060:[<f7c623ba>] EFLAGS: 00010246 CPU: 0
>> [  230.293969] EIP is at dvb_usb_remote_init+0x12e/0x209 [dvb_usb]
>> [  230.293969] EAX: 69656148 EBX: f589b000 ECX: c14c18e4 EDX: f589b018
>> [  230.293969] ESI: f5904000 EDI: 000003b8 EBP: 00000077 ESP: f5851e88
>> [  230.293969]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [  230.293969] Process modprobe (pid: 3279, ti=f5850000 task=f5cd4400 
>> task.ti=f5850000)
>> [  230.293969] Stack:
>> [  230.293969]  f589b018 f5904000 f5904000 f5904864 00000001 f7c61945 
>> f5904418 f80bb8d0
>> [  230.293969] <0> f5912000 f5b8f800 f80bad88 00000000 f80bad88 
>> 00000000 f5912000 00000000
>> [  230.293969] <0> f80bb894 f80ba970 f80b886d 00000000 f80ba960 
>> f5912000 f80c8c98 f591201c
>> [  230.293969] Call Trace:
>> [  230.293969]  [<f7c61945>] ? dvb_usb_device_init+0x515/0x51c [dvb_usb]
>> [  230.293969]  [<f80b886d>] ? rtd2831u_usb_probe+0x19/0x48 
>> [dvb_usb_rtl2831u]
>> [  230.293969]  [<f80c8c98>] ? usb_probe_interface+0xe7/0x130 [usbcore]
>> [  230.293969]  [<c11b2c22>] ? driver_probe_device+0x8a/0x11e
>> [  230.293969]  [<c11b2cf6>] ? __driver_attach+0x40/0x5b
>> [  230.293969]  [<c11b2667>] ? bus_for_each_dev+0x37/0x5f
>> [  230.293969]  [<c11b2af5>] ? driver_attach+0x11/0x13
>> [  230.293969]  [<c11b2cb6>] ? __driver_attach+0x0/0x5b
>> [  230.293969]  [<c11b2135>] ? bus_add_driver+0x99/0x1c2
>> [  230.293969]  [<c11b2f2b>] ? driver_register+0x87/0xe0
>> [  230.293969]  [<f80c8aa6>] ? usb_register_driver+0x5d/0xb4 [usbcore]
>> [  230.293969]  [<f80f6000>] ? rtd2831u_usb_module_init+0x0/0x2c 
>> [dvb_usb_rtl2831u]
>> [  230.293969]  [<f80f6015>] ? rtd2831u_usb_module_init+0x15/0x2c 
>> [dvb_usb_rtl2831u]
>> [  230.293969]  [<c100113e>] ? do_one_initcall+0x55/0x155
>> [  230.293969]  [<c1057dd7>] ? sys_init_module+0xa7/0x1d7
>> [  230.293969]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
>> [  230.293969] Code: 3e c6 f7 20 74 18 8b 86 a0 00 00 00 55 ff 74 38 
>> 04 68 59 38 c6 f7 e8 1b a1 60 c9 83 c4 0c 8b 86 a0 00 00 00 8b 14 24 
>> 8b 44 38 04 <f0> 0f ab 02 45 83 c7 08 3b ae a4 00 00 00 7c c2 83 be ac 
>> 00 00
>> [  230.293969] EIP: [<f7c623ba>] dvb_usb_remote_init+0x12e/0x209 
>> [dvb_usb] SS:ESP 0068:f5851e88
>> [  230.293969] CR2: 0000000002b65c40
>> [  230.663846] ---[ end trace e2ebfa1976bffdae ]---
> 
> Mostly interesting, the modules are still getting loaded:
> 
>> $ lsmod | grep dvb
>> dvb_usb_rtl2831u       89189  15
>> dvb_usb_dibusb_common     4578  1 dvb_usb_rtl2831u
>> dvb_usb                13320  2 dvb_usb_rtl2831u,dvb_usb_dibusb_common
>> dib3000mc               8544  1 dvb_usb_dibusb_common
>> dvb_ttpci              70046  0
>> dvb_core               63034  2 dvb_usb,dvb_ttpci
>> saa7146_vv             31312  1 dvb_ttpci
>> saa7146                 9911  2 dvb_ttpci,saa7146_vv
>> ttpci_eeprom            1224  1 dvb_ttpci
>> i2c_core               12700  8 
>> dvb_usb,dib3000mc,dibx000_common,dvb_ttpci,videodev,ttpci_eeprom,nvidia,i2c_nforce2 
>>
>> usbcore                98466  10 
>> dvb_usb_rtl2831u,dvb_usb,lirc_imon,usbhid,usb_storage,ehci_hcd,ohci_hcd
> 
> When plugging the usb-stick after boot I am able to use it as intend. 
> But when having it inserted during boot the system hangs up. Calling 
> lsusb from console causes the used console to hang up as well. Would be 
> great if anyone got a solution for this problem.
> 
> Best regards,
> Thomas
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
