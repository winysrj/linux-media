Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:32984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbZBOUlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 15:41:22 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LYorI-0005Nm-MD
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sun, 15 Feb 2009 22:49:04 +0100
Date: Sun, 15 Feb 2009 21:41:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Subject: General protection fault on rmmod cx8800
Message-ID: <20090215214108.34f31c39@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Today I have hit the following general protection fault when removing
module cx8800:

Feb 15 18:30:09 hyperion kernel: cx88/2: unregistering cx8802 driver, type: dvb access: shared
Feb 15 18:30:09 hyperion kernel: cx88[0]/2: subsystem: 107d:665f, board: WinFast DTV1000-T [card=35]
Feb 15 18:30:09 hyperion kernel: cx88-mpeg driver manager 0000:02:04.2: PCI INT A disabled
Feb 15 18:30:09 hyperion kernel: cx8800 0000:02:04.0: PCI INT A disabled
Feb 15 18:30:09 hyperion kernel: general protection fault: 0000 [#1]
Feb 15 18:30:09 hyperion kernel: last sysfs file: /sys/devices/pnp0/00:08/i2c-adapter/i2c-3/3-004c/temp2_crit_alarm
Feb 15 18:30:09 hyperion kernel: CPU 0
Feb 15 18:30:09 hyperion kernel: Modules linked in: lm90 w83627ehf
  hwmon_vid i2c_parport isofs ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG
  xt_limit binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
  nfs lockd sunrpc radeon drm nf_conntrack_ipv6 ip6t_REJECT xt_NOTRACK
  ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle
  nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
  ip_tables ip6table_filter ip6_tables x_tables ipv6 nls_iso8859_1
  nls_cp437 vfat fuse loop dm_mod dvb_pll cx22702 cx88_vp3054_i2c zr36060
  cx88xx snd_intel8x0 ir_common snd_ac97_codec saa7110 snd_pcsp tveeprom
  ac97_bus zr36067 videobuf_dvb i2c_algo_bit compat_ioctl32 dvb_core
  snd_pcm snd_timer v4l2_common videocodec parport_pc parport btcx_risc
  iTCO_wdt snd videobuf_dma_sg 8139too soundcore videodev videobuf_core
  v4l1_compat mii i2c_i801 snd_page_alloc sr_mod cdrom intel_agp button
  sg sd_mod ehci_hcd uhci_hcd usbcore edd ext3 mbcache jbd fan
  ide_pci_generic piix ide_core ata_generic ata_piix libata thermal
  processor thermal_sys hwmon [last unloaded: cx8800]
Feb 15 18:30:09 hyperion kernel: Pid: 5, comm: events/0 Not tainted 2.6.28.5 #5
Feb 15 18:30:09 hyperion kernel: RIP: 0010:[<ffffffffa0256c18>]  [<ffffffffa0256c18>] cx88_ir_work+0x32/0x236 [cx88xx]
Feb 15 18:30:09 hyperion kernel: RSP: 0000:ffff88003f86be20  EFLAGS: 00010202
Feb 15 18:30:09 hyperion kernel: RAX: 0000000000350010 RBX: ffff88003e1c0ec8 RCX: 0000000000000001
Feb 15 18:30:09 hyperion kernel: RDX: ffffffff80666ee0 RSI: ffffffff809fc750 RDI: ffff88003e1c0ec0
Feb 15 18:30:09 hyperion kernel: RBP: ffff88003f86be50 R08: 0000000000000001 R09: ffffffbff9b00198
Feb 15 18:30:09 hyperion kernel: R10: 0000000000000080 R11: 0000000000000001 R12: ffff88003e1c0ec0
Feb 15 18:30:09 hyperion kernel: R13: ffff88003e1c0c00 R14: 2f4065766f6d6572 R15: ffff88003f8201f0
Feb 15 18:30:09 hyperion kernel: FS:  0000000000000000(0000) GS:ffffffff805f3020(0000) knlGS:0000000000000000
Feb 15 18:30:09 hyperion kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 15 18:30:09 hyperion kernel: CR2: 00000000004042e0 CR3: 000000003ee63000 CR4: 00000000000006e0
Feb 15 18:30:09 hyperion kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 15 18:30:09 hyperion kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 15 18:30:10 hyperion kernel: Process events/0 (pid: 5, threadinfo ffff88003f86a000, task ffff88003f845140)
Feb 15 18:30:10 hyperion kernel: Stack:
Feb 15 18:30:10 hyperion kernel:  ffff88003f86be50 ffff88003e1c0ec8 ffff88003e1c0ec0 ffff88003f8201c0
Feb 15 18:30:10 hyperion kernel:  ffffffffa0256be6 ffff88003f8201f0 ffff88003f86bec0 ffffffff802426b0
Feb 15 18:30:10 hyperion kernel:  ffffffff8024268a ffffffff8042a910 ffffffffa0264444 0000000000000000
Feb 15 18:30:10 hyperion kernel: Call Trace:
Feb 15 18:30:10 hyperion kernel:  [<ffffffffa0256be6>] ? cx88_ir_work+0x0/0x236 [cx88xx]
Feb 15 18:30:10 hyperion kernel:  [<ffffffff802426b0>] run_workqueue+0xee/0x21f
Feb 15 18:30:10 hyperion kernel:  [<ffffffff8024268a>] ? run_workqueue+0xc8/0x21f
Feb 15 18:30:10 hyperion kernel:  [<ffffffff8042a910>] ? thread_return+0x30/0x1cd
Feb 15 18:30:10 hyperion kernel:  [<ffffffff80242c7e>] worker_thread+0xa6/0x111
Feb 15 18:30:10 hyperion kernel:  [<ffffffff802465b1>] ? autoremove_wake_function+0x0/0x3b
Feb 15 18:30:10 hyperion kernel:  [<ffffffff80242bd8>] ? worker_thread+0x0/0x111
Feb 15 18:30:10 hyperion kernel:  [<ffffffff80246306>] kthread+0x49/0x7b
Feb 15 18:30:10 hyperion kernel:  [<ffffffff8020c019>] child_rip+0xa/0x11
Feb 15 18:30:10 hyperion kernel:  [<ffffffff8020bb34>] ? restore_args+0x0/0x30
Feb 15 18:30:10 hyperion kernel:  [<ffffffff802462bd>] ? kthread+0x0/0x7b
Feb 15 18:30:10 hyperion kernel:  [<ffffffff8020c00f>] ? child_rip+0x0/0x11
Feb 15 18:30:10 hyperion kernel: Code: 56 41 55 41 54 53 48 83 ec 08 49 89 fc 4c 8d af 40 fd ff ff 4c 8b b7 40 fd ff ff 41 8b 85 48 03 00 00 c1 e8 02 89 c0 48 c1 e0 02 <49> 03 46 40 8b 18 41 8b 86 10 0a 00 00 83 f8 23 0f 84 fc 00 00
Feb 15 18:30:10 hyperion kernel: RIP  [<ffffffffa0256c18>] cx88_ir_work+0x32/0x236 [cx88xx]
Feb 15 18:30:10 hyperion kernel:  RSP <ffff88003f86be20>
Feb 15 18:30:10 hyperion kernel: ---[ end trace 45f7ffdbf475eafd ]---
Feb 15 18:30:10 hyperion kernel: pci 0000:02:01.0: PCI INT A disabled

This was with kernel 2.6.28.5 on x86-64. I then hit it a second time
using Hans Verkuil's v4l-dvb-zoran tree. In both case the keyboard
started acting weirdly, first time it didn't respond to any key, second
time it was like the return key was stuck. Both time I was able to
reboot the machine with some insistence (SysRq or remote logging,
killing X and reboot.)

It doesn't happen on each rmmod cx8800, but as I managed to reproduce
it once, I guess I should be able to reproduce it again if needed.
Please let me know if you need more information or want me to test
something.

-- 
Jean Delvare
