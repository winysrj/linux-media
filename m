Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48983 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3EFPpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 11:45:11 -0400
Received: by mail-ea0-f182.google.com with SMTP id z16so1765306ead.27
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 08:45:09 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/3] r820t: fix several potential issues
Date: Mon,  6 May 2013 17:44:34 +0200
Message-Id: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When testing the new r820t driver, I found several potential issues that are
fixed in this patch series.
I've run the driver successfully on several different kernels
(3.2.44 and 3.9.0, in 32 and 64 bit flavors) after upgrading the media drivers
with the media_build script.

Unfortunately, I was not able to run it successfully on 2.6.32 32 bit
(Ubuntu 10.04), as the kernel oops as soon as I plug-in the device:

[   79.650173] usbcore: registered new interface driver dvb_usb_rtl28xxu
[  155.526548] usb 2-1.1: new high speed USB device using ehci_hcd and address 4
[  155.631132] usb 2-1.1: configuration #1 chosen from 1 choice
[  155.636383] usb 2-1.1: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
[  155.703594] BUG: unable to handle kernel NULL pointer dereference at (null)
[  155.703602] IP: [<c0361dd2>] strlen+0x12/0x20
[  155.703611] *pdpt = 00000000008a0001 *pde = 0000000000000000 
[  155.703617] Oops: 0000 [#1] SMP 
[  155.703622] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/interface
[  155.703626] Modules linked in: r820t rtl2832 dvb_usb_rtl28xxu dvb_usb_v2 rc_core rtl2830 dvb_core aes_i586 aes_generic binfmt_misc pci_stub vboxpci vboxnetadp vboxnetflt vboxdrv ppdev parport_pc nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc snd_hda_codec_atihdmi snd_hda_codec_idt snd_hda_intel snd_pcm_oss snd_hda_codec snd_mixer_oss snd_hwdep snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi pcmcia fbcon arc4 dell_wmi snd_seq_midi_event tileblit fglrx(P) dell_laptop snd_seq usb_storage font iwlagn sdhci_pci bitblit snd_timer joydev softcursor agpgart dcdbas iwlcore snd_seq_device video yenta_socket tifm_7xx1 mac80211 sdhci lp vga16fb output snd rsrc_nonstatic xhci psmouse tifm_core vgastate pcmcia_core led_class serio_raw soundcore cfg80211 snd_page_alloc parport usbhid hid ohci1394 ieee1394 ahci tg3
[  155.703717] 
[  155.703722] Pid: 30, comm: events/3 Tainted: P           (2.6.32-46-generic-pae #105-Ubuntu) Precision M6500                 
[  155.703727] EIP: 0060:[<c0361dd2>] EFLAGS: 00010246 CPU: 3
[  155.703732] EIP is at strlen+0x12/0x20
[  155.703735] EAX: 00000000 EBX: ef08015e ECX: ffffffff EDX: 00000000
[  155.703738] ESI: 00000000 EDI: 00000000 EBP: f755dee0 ESP: f755dedc
[  155.703742]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  155.703746] Process events/3 (pid: 30, ti=f755c000 task=f7522640 task.ti=f755c000)
[  155.703749] Stack:
[  155.703752]  00000030 f755def4 c035ef3e ef07ff92 00000000 fb29256c f755df4c fb27eae8
[  155.703761] <0> fb2806b8 c073064c ee483938 fb28047a fb29256c f5049180 f755df30 c0147443
[  155.703770] <0> 00000002 f75cbfc0 de370a89 ce4c94e0 f7522640 f755df88 efede038 ce4c9ae0
[  155.703780] Call Trace:
[  155.703786]  [<c035ef3e>] ? strlcpy+0x1e/0x60
[  155.703793]  [<fb27eae8>] ? dvb_usbv2_init_work+0x278/0xbc0 [dvb_usb_v2]
[  155.703801]  [<c0147443>] ? finish_task_switch+0x43/0xc0
[  155.703808]  [<c016ce2e>] ? run_workqueue+0x8e/0x150
[  155.703814]  [<fb27e870>] ? dvb_usbv2_init_work+0x0/0xbc0 [dvb_usb_v2]
[  155.703820]  [<c016cf74>] ? worker_thread+0x84/0xe0
[  155.703826]  [<c0170f10>] ? autoremove_wake_function+0x0/0x50
[  155.703832]  [<c016cef0>] ? worker_thread+0x0/0xe0
[  155.703836]  [<c0170c84>] ? kthread+0x74/0x80
[  155.703841]  [<c0170c10>] ? kthread+0x0/0x80
[  155.703847]  [<c010a467>] ? kernel_thread_helper+0x7/0x10
[  155.703850] Code: f7 be 01 00 00 00 89 f0 48 5e 5d c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 0f 1f 44 00 00 b9 ff ff ff ff 89 c7 31 c0 <f2> ae f7 d1 49 89 c8 5f 5d c3 8d 74 26 00 55 89 e5 57 0f 1f 44 
[  155.703902] EIP: [<c0361dd2>] strlen+0x12/0x20 SS:ESP 0068:f755dedc
[  155.703908] CR2: 0000000000000000
[  155.703912] ---[ end trace 2ec0a657e95c8a33 ]---

At least the first patch should go in the next 3.10-rc, as it's a real issue.

Best regards,
Gianluca Gennari

Gianluca Gennari (3):
  r820t: do not double-free fe->tuner_priv in r820t_release()
  r820t: remove redundant initializations in r820t_attach()
  r820t: avoid potential memcpy buffer overflow in shadow_store()

 drivers/media/tuners/r820t.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
1.8.2.2

