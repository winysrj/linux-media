Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750903AbZGGKdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 06:33:35 -0400
From: Nils Kassube <kassube@gmx.net>
To: linux-media@vger.kernel.org
Subject: Fix for crash in dvb-usb-af9015
Date: Tue, 7 Jul 2009 12:32:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071232.00459.kassube@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with my Terratec Cinergy T USB XE I get a crash when I plug the device. 
This is the kernel message:

[  103.380077] usb 1-5: new high speed USB device using ehci_hcd and 
address 2
[  103.516931] usb 1-5: configuration #1 chosen from 1 choice
[  103.852954] dvb-usb: found a 'TerraTec Cinergy T USB XE' in cold 
state, will try to load a firmware
[  103.852970] usb 1-5: firmware: requesting dvb-usb-af9015.fw
[  103.955548] dvb-usb: downloading firmware from file 'dvb-usb-
af9015.fw'
[  104.010486] BUG: unable to handle kernel paging request at e081516a
[  104.010502] IP: [<e03ad25a>] af9015_rw_udev+0x20a/0x2c0 
[dvb_usb_af9015]
[  104.010524] *pde = 1f1f5067 *pte = 16b88161 
[  104.010536] Oops: 0003 [#1] SMP 
[  104.010546] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5/firmware/1-5/loading
[  104.010555] Modules linked in: dvb_usb_af9015(+) dvb_usb dvb_core 
aes_i586 aes_generic lib80211_crypt_ccmp nfsd exportfs nfs lockd nfs_acl 
auth_rpcgss sunrpc sbp2 lp snd_hda_codec_si3054 snd_hda_codec_analog 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
joydev pcmcia snd_seq snd_timer snd_seq_device iTCO_wdt 
iTCO_vendor_support ipw2200 sdhci_pci sdhci tifm_7xx1 yenta_socket 
rsrc_nonstatic libipw snd psmouse ppdev tifm_core led_class pcmcia_core 
soundcore snd_page_alloc lib80211 pcspkr serio_raw parport_pc parport 
ohci1394 ieee1394 r8169 mii fbcon tileblit font bitblit softcursor i915 
drm i2c_algo_bit video output intel_agp agpgart
[  104.010728] 
[  104.010738] Pid: 3400, comm: modprobe Not tainted (2.6.31-1-generic 
#14-Ubuntu) AMILO Pro V2085
[  104.010748] EIP: 0060:[<e03ad25a>] EFLAGS: 00010207 CPU: 0
[  104.010761] EIP is at af9015_rw_udev+0x20a/0x2c0 [dvb_usb_af9015]
[  104.010770] EAX: 00000032 EBX: dd589d34 ECX: 0000000c EDX: 00000000
[  104.010778] ESI: dd589cbe EDI: e081516a EBP: dd589d0c ESP: dd589c98
[  104.010787]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  104.010797] Process modprobe (pid: 3400, ti=dd588000 task=c1951920 
task.ti=dd588000)
[  104.010804] Stack:
[  104.010809]  00000034 dd589cb8 000007d0 00000086 00000000 dd589cc4 
001403e8 deb87000
[  104.010829] <0> 00000002 820000f0 3200006a 007d4006 800cc012 00fa800c 
800cc012 006480bb
[  104.010851] <0> 0000a000 02010201 02010202 39020101 ee04fe18 d510aa0e 
0d13c914 0106fb08
[  104.010874] Call Trace:
[  104.010893]  [<e03adbe7>] ? af9015_download_firmware+0xe7/0x130 
[dvb_usb_af9015]
[  104.010917]  [<e03a730e>] ? dvb_usb_download_firmware+0x7e/0xd0 
[dvb_usb]
[  104.010936]  [<e03a7a37>] ? dvb_usb_device_init+0x257/0x310 [dvb_usb]
[  104.010954]  [<e03aec53>] ? af9015_usb_probe+0x83/0x12c 
[dvb_usb_af9015]
[  104.010975]  [<c040fd17>] ? usb_autopm_do_device+0x67/0xf0
[  104.010989]  [<c0410447>] ? usb_probe_interface+0x87/0x160
[  104.011003]  [<c02367c2>] ? sysfs_create_link+0x12/0x20
[  104.011018]  [<c039f400>] ? really_probe+0x50/0x140
[  104.011031]  [<c056eb7a>] ? _spin_lock_irqsave+0x2a/0x40
[  104.011043]  [<c039f509>] ? driver_probe_device+0x19/0x20
[  104.011055]  [<c039f589>] ? __driver_attach+0x79/0x80
[  104.011066]  [<c039ea78>] ? bus_for_each_dev+0x48/0x70
[  104.011078]  [<c039f2c9>] ? driver_attach+0x19/0x20
[  104.011089]  [<c039f510>] ? __driver_attach+0x0/0x80
[  104.011100]  [<c039eccf>] ? bus_add_driver+0xbf/0x290
[  104.011113]  [<c039f815>] ? driver_register+0x65/0x110
[  104.011126]  [<c040fa69>] ? usb_register_driver+0x79/0xe0
[  104.011149]  [<e038d01b>] ? af9015_usb_module_init+0x1b/0x38 
[dvb_usb_af9015]
[  104.011162]  [<c010113f>] ? do_one_initcall+0x3f/0x190
[  104.011176]  [<e038d000>] ? af9015_usb_module_init+0x0/0x38 
[dvb_usb_af9015]
[  104.011190]  [<c05712a5>] ? notifier_call_chain+0x35/0x70
[  104.011205]  [<c015b6af>] ? __blocking_notifier_call_chain+0x4f/0x60
[  104.011220]  [<c016dd01>] ? sys_init_module+0xb1/0x1f0
[  104.011232]  [<c010338c>] ? syscall_call+0x7/0xb
[  104.011239] Code: 00 80 3b 27 74 3b 0f b6 45 b1 84 c0 0f 85 8c 00 00 
00 80 7d a7 00 0f 85 46 ff ff ff 0f b6 43 06 8d 75 b2 8b 7b 08 89 c1 c1 
e9 02 <f3> a5 89 c1 83 e1 03 74 02 f3 a4 e9 27 ff ff ff 8d b6 00 00 00 
[  104.011355] EIP: [<e03ad25a>] af9015_rw_udev+0x20a/0x2c0 
[dvb_usb_af9015] SS:ESP 0068:dd589c98
[  104.011374] CR2: 00000000e081516a
[  104.011383] ---[ end trace d4a4b19a19820d60 ]---

I found out that the crash happens when the device should boot after 
downloading the firmware because there seems to be no sufficiently big 
buffer for the boot message (or whatever it is) returned from the 
device. As this message is ignored by the calling function anyway, this 
patch fixes the problem:

--- orig/linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-06-30 
11:34:45.000000000 +0200
+++ linux-2.6.31/drivers/media/dvb/dvb-usb/af9015.c	2009-07-06 
21:42:50.000000000 +0200
@@ -158,7 +158,7 @@
 	}
 
 	/* read request, copy returned data to return buf */
-	if (!write)
+	if (!write && req->cmd != BOOT)
 		memcpy(req->data, &buf[2], req->data_len);
 
 error_unlock:

However, it would certainly be better to provide an appropriate buffer 
when calling this function from af9015_download_firmware because I think 
it is called very often here and the extra check for the BOOT command is 
needed only once (after firmware download). As I'm not familiar with the 
hardware, I can't say what buffer size would be appropriate but I can 
say that for my device the parameter "req->data_len" was 32 in the 
memcpy command above when I tried to find the fix.


Nils

