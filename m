Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0ECAIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 20:08:12 -0400
Message-ID: <4BDE13E7.1010409@infradead.org>
Date: Sun, 02 May 2010 21:08:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	stefan Ringel <stefan.ringel@arcor.de>
Subject: Re: [PATCH] tm6000: Prevent Kernel Oops changing channel when stream
 is 	still on.
References: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com>
In-Reply-To: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two patches fixed the OOPS I was having.

The big problem I'm still suffering with HVR-900H is that tm6000 insists on dying:

hub 1-0:1.0: port 8 disabled by hub (EMI?), re-enabling...
usb 1-8: USB disconnect, address 5
tm6000 tm6000_irq_callback :urb resubmit failed (error=-19)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-19)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-19)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-19)
tm6000 tm6000_irq_callback :urb resubmit failed (error=-19)
tm6000: disconnecting tm6000 #2
xc2028 2-0061: destroying instance

As the chipset stops answering USB, a new, non-fatal bug hits:

------------[ cut here ]------------
WARNING: at lib/list_debug.c:48 list_del+0x30/0x87()
Hardware name:  
list_del corruption. prev->next should be ffff88003df65ec0, but was (null)
Modules linked in: ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder ir_core tm6000(C) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core autofs4 hidp rfcomm l2cap crc16 bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 powernow_k8 dm_multipath scsi_dh sbs sbshc battery acpi_memhotplug ac lp snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device i2c_algo_bit snd_pcm_oss snd_mixer_oss sg snd_pcm nvidia(P) ide_cd_mod snd_timer serio_raw parport_pc cdrom snd button parport floppy i2c_nforce2 k8temp soundcore snd_page_alloc pcspkr shpchp hwmon forcedeth i2c_core dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod sata_nv libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: tuner_xc2028]
Pid: 12402, comm: mplayer Tainted: P        WC 2.6.33 #4
Call Trace:
 [<ffffffff81179c24>] ? list_del+0x30/0x87
 [<ffffffff8103a43f>] ? warn_slowpath_common+0x77/0x8e
 [<ffffffff8103a4b2>] ? warn_slowpath_fmt+0x51/0x59
 [<ffffffff810c54a5>] ? free_block+0xdf/0xfe
 [<ffffffff8102c9bc>] ? __wake_up_sync_key+0x3a/0x56
 [<ffffffff81179c24>] ? list_del+0x30/0x87
 [<ffffffffa015e9c8>] ? videobuf_queue_cancel+0x48/0xba [videobuf_core]
 [<ffffffffa013e2b3>] ? videobuf_vm_close+0x80/0x14d [videobuf_vmalloc]
 [<ffffffff810b23d1>] ? remove_vma+0x2c/0x72
 [<ffffffff810b2522>] ? exit_mmap+0x10b/0x129
 [<ffffffff8103813c>] ? mmput+0x34/0xa2
 [<ffffffff8103c077>] ? exit_mm+0x109/0x114
 [<ffffffff8103d2b0>] ? do_exit+0x1de/0x66e
 [<ffffffff8103d7ad>] ? do_group_exit+0x6d/0x97
 [<ffffffff8103d7e9>] ? sys_exit_group+0x12/0x16
 [<ffffffff810028ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace fed27d3fe75cb89b ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:51 list_del+0x5c/0x87()
Hardware name:  
list_del corruption. next->prev should be ffff88003df65bc0, but was (null)
Modules linked in: ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder ir_core tm6000(C) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core autofs4 hidp rfcomm l2cap crc16 bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 powernow_k8 dm_multipath scsi_dh sbs sbshc battery acpi_memhotplug ac lp snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device i2c_algo_bit snd_pcm_oss snd_mixer_oss sg snd_pcm nvidia(P) ide_cd_mod snd_timer serio_raw parport_pc cdrom snd button parport floppy i2c_nforce2 k8temp soundcore snd_page_alloc pcspkr shpchp hwmon forcedeth i2c_core dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod sata_nv libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: tuner_xc2028]
Pid: 12402, comm: mplayer Tainted: P        WC 2.6.33 #4
Call Trace:
 [<ffffffff81179c50>] ? list_del+0x5c/0x87
 [<ffffffff8103a43f>] ? warn_slowpath_common+0x77/0x8e
 [<ffffffff8103a4b2>] ? warn_slowpath_fmt+0x51/0x59
 [<ffffffff810c54a5>] ? free_block+0xdf/0xfe
 [<ffffffff81035d58>] ? __wake_up+0x30/0x44
 [<ffffffff81179c50>] ? list_del+0x5c/0x87
 [<ffffffffa015e9c8>] ? videobuf_queue_cancel+0x48/0xba [videobuf_core]
 [<ffffffffa013e2b3>] ? videobuf_vm_close+0x80/0x14d [videobuf_vmalloc]
 [<ffffffff810b23d1>] ? remove_vma+0x2c/0x72
 [<ffffffff810b2522>] ? exit_mmap+0x10b/0x129
 [<ffffffff8103813c>] ? mmput+0x34/0xa2
 [<ffffffff8103c077>] ? exit_mm+0x109/0x114
 [<ffffffff8103d2b0>] ? do_exit+0x1de/0x66e
 [<ffffffff8103d7ad>] ? do_group_exit+0x6d/0x97
 [<ffffffff8103d7e9>] ? sys_exit_group+0x12/0x16
 [<ffffffff810028ab>] ? system_call_fastpath+0x16/0x1b
---[ end trace fed27d3fe75cb89c ]---
usbcore: deregistering interface driver tm6000


Cheers,
Mauro

-- 

Cheers,
Mauro
