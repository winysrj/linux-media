Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALLBcZL002447
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:11:38 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALLBMFx007449
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:11:22 -0500
Received: by rn-out-0910.google.com with SMTP id k32so1069201rnd.7
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 13:11:22 -0800 (PST)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Date: Fri, 21 Nov 2008 15:11:13 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211511.14193.vanessaezekowitz@gmail.com>
Cc: 
Subject: cx88 IRQ loop runaway
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I'm not sure whose 'department' this is, so I'm sending this email to the v4l/dvb lists...

About a week ago, my machine started locking up randomly.  Eventually figured out the problem and ended up replacing my dead primary SATA disk with a couple of older IDE disks.  A reinstall of Ubuntu Hardy, and a couple of days of the usual setup and personalizing tweaks later, my system is back up and running.  

There is still one other SATA disk in my system and it is behaving normally.  While adding the replacement disks, I moved it to the port formerly occupied by the dead disk.

My system, for reasons beyond my understanding, insists on sharing IRQ's among the various PCI devices, despite my explicit settings in the BIOS to assign fixed IRQ's to my PCI slots.   One of those IRQ's is being shared between my capture card and SATA controller.  Normally, this would not be an issue, but I seem to have found a nasty bug in the cx88xx driver.

Without trying to use my capture card at all, every time I access the other SATA disk in my system, the cx88 driver spits out a HORRENDOUS number of weird messages, filling my system logs so fast that after two days, I'd used over 6 GB just in the few logs that sysklogd generates.

That was enough log data to max out my / partition and grind my system to a halt.  Not exactly a good thing.   I don't know how long this has been happening, but it is possible that my previous (now dead) drive was simply large enough to contain these huge logs without running out of space.

I am using the 2.6.27.6 kernel (from kernel.org), and using the v4l/dvb code contained within it, since it supports my card.  If necessary, I'll install the v4l-dvb repository instead.

My only solution so far is to unload the cx88 driver modules.  This is a showstopper - I cannot use or even enable my capture card until this is resolved.

Log excerpt below.  I haven't the faintest clue what's causing that garbage at the end of the excerpt.  I didn't keep the older logs for obvious reasons, but that garbage appears multiple times, so it is reproduceable.

HELP!!

----- Text Import Begin -----

Nov 21 01:57:16 rainbird kernel: Linux video capture interface: v2.00
Nov 21 01:57:16 rainbird kernel: cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
Nov 21 01:57:16 rainbird kernel: cx8800 0000:02:07.0: enabling device (0004 -> 0006)
Nov 21 01:57:16 rainbird kernel: cx8800 0000:02:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Nov 21 01:57:16 rainbird kernel: cx88[0]: subsystem: 17de:08c1, board: Kworld PlusTV HD PCI 120 (ATSC 120) [card=67,autodetected]
Nov 21 01:57:16 rainbird kernel: cx88[0]: TV tuner type 71, Radio tuner type -1
Nov 21 01:57:16 rainbird kernel: tveeprom 1-0050: Huh, no eeprom present (err=-6)?
Nov 21 01:57:16 rainbird kernel: cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
Nov 21 01:57:16 rainbird kernel: cx88[0]/0: found at 0000:02:07.0, rev: 5, irq: 19, latency: 32, mmio: 0xe8000000
Nov 21 01:57:16 rainbird kernel: cx88[0]/0: registered device video0 [v4l2]
Nov 21 01:57:16 rainbird kernel: cx88[0]/0: registered device vbi0
Nov 21 01:57:17 rainbird kernel: cx88[0]/0: registered device radio0
Nov 21 01:57:17 rainbird kernel: cx2388x alsa driver version 0.0.6 loaded
Nov 21 01:57:17 rainbird kernel: cx88_audio 0000:02:07.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Nov 21 01:57:17 rainbird kernel: cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.851742] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.866072] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux_0'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.885767] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux_1'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.888505] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_pcm_0'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.900119] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_alsa_capture_0'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.908469] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_pcm_0_0'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.916611] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_alsa_control__1'). 
Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.924818] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_mixer__1'). 
Nov 21 01:57:17 rainbird kdm[4035]: StartServerSucces
Nov 21 01:57:35 rainbird kdm: :0[4060]: pam_unix(kdm:session): session opened for user vanessa by (uid=0)
Nov 21 01:58:06 rainbird pactl: gethostby*.getanswer: asked for "localhost.gateway.2wire.net IN AAAA", got type "A"
Nov 21 01:58:11 rainbird NetworkManager: <info>  Updating allowed wireless network lists. 
Nov 21 01:58:13 rainbird NetworkManager: <WARN>  nm_dbus_get_networks_cb(): error received: org.freedesktop.NetworkManagerInfo.NoNetworks - org.freedesktop.NetworkManagerInfo.NoNetworks. 
Nov 21 01:59:12 rainbird kernel: f [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt f [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dmaf [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: IRQ loop detected, disabling interrupts
Nov 21 01:59:12 rainbird kernel: 0et<ec g82rrt*_qn c*r rf*_***26 e8odu8 cef>t <f0  8c4 fc :[r8ptf  f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Nl2nc<:Ve2nn t5[ 1f1<ey  4In I 11s4 Ni9 y0iV2 cn=4qq01s4> q01s4> q1nc5 A31nc5 A31nc4>Aq1nc5 A31nc5:6lx4:ft<ec g82rrt*_qn c*r _*n*_ec2 1e:rn
Nov 21 01:59:12 rainbird kernel:  fc:f8i<i
Nov 21 01:59:12 rainbird kernel:    8c4qfc  fr8ptf: f0of1cx Iq n N  nc=fV 2r4c9c] 1f1<ey  4In I11115 N nyt<V2 c ]qq01c4>A31n1
Nov 21 01:59:12 rainbird kernel:  A01c4>A31n15 A31n1
Nov 21 01:59:12 rainbird kernel:  q01c4>A31n1
Nov 21 01:59:12 rainbird kernel: :l 4:ft<0c f]2rre_ [ c*rof*n**r  1r:rn> fef>t i
Nov 21 01:59:12 rainbird kernel:   f]c40<  fr>ptf  f0of1cx oqc
Nov 21 01:59:12 rainbird kernel:  N  nc<:V 2r4c9c] 1f1<ey  4In I11114 N 9 40iV2 c ]qq0115 A31n15 q01s4>A31n15 q0115Aq1n15 A31n15:6xx4:ft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs [r8ptf  f0of1cx Iqc
Nov 21 01:59:12 rainbird kernel:  Nl9 c=ffe2tn o5x 1f1<ey  4In I11114 N 9 4tiV2 c 9qA31n15 A31n15 A31n15 A31n15 Aq01s4>A31n1
Nov 21 01:59:12 rainbird kernel:  A0115:6xx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel:  n _*ro_*n*_er  1r:r 
Nov 21 01:59:12 rainbird kernel:  fc:f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Nl2nc<:f  t4c9c] 1f1<ey  4In I 1114 N 9 40iV2 c 9qA31n15 A31n15 Aq1n15 Aq1n15 A31n15 A31n15 A31nc5:6xx4tft<0c fc2rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1e:rn> f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Il28no<ffe2tc1=c] 1f1<ey  4In I11114 N 9 40iV2 c 9qA31nc5 A31n15 I1c n
Nov 21 01:59:12 rainbird kernel: N 9 4 iV2 c 9qAq1n15 A31n15 Aq1n15 A31n15 A31n15 A31n15 Aq1n15:6xx4tft<ec f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n__er  1r:rn
Nov 21 01:59:12 rainbird kernel:  fc:f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r>ptf  f0of1cx Iqc
Nov 21 01:59:12 rainbird kernel:  Nl2nc<:V 2r4c9<] 1f1<ey  4In I11sn
Nov 21 01:59:12 rainbird kernel:  N nrt<ir2te2]qA01c4> q01c4> 31n15 A31nc5 A31n15 A31nc4>A31nc4:6lx4:ft<0c g82rrt*_qn c*r rf*_***26 e8odu8f::f8i<i
Nov 21 01:59:12 rainbird kernel:    8c4 fcs:[r8ptf  f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Nl9 c=ff 2ne t
Nov 21 01:59:12 rainbird kernel: [ 1f1<ey  4In I 1c n
Nov 21 01:59:12 rainbird kernel:  N nyt<iV2te2]qA01s 
Nov 21 01:59:12 rainbird kernel:  q0115 A31nc5 A31nc5 A31nc4> 31nc5 Aq1nc5:6xx4:ft<0c g82rrt*
Nov 21 01:59:12 rainbird kernel: q c*ro_*n__er2 1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf: f0of1cx oqc
Nov 21 01:59:12 rainbird kernel:  Nl28no<:Ve2ne o5[ 1f1<ey  4In I 1114 Ni9 40iV2 c 9qA31n15 A31n15 A31n15 A31n15 A31n15 A31n14 A31n15:6xx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<if  f8c4 fcs:[r8ptf  f0of1cx oqc
Nov 21 01:59:12 rainbird kernel:  Nl9nc<:V 2r4c9c] 1f<ey  4In I111sn
Nov 21 01:59:12 rainbird kernel:  N nrt<ir2te=4qq1n15 Aq1nc5 A31nc5 A31nc4> q01s > q01c4> q01s4>:l 0[eft<0c f82rrt*_qn _*r r*n__ec2 1r:r 
Nov 21 01:59:12 rainbird kernel:  f::f8t<i
Nov 21 01:59:12 rainbird kernel:    cc4qfc  [r>ptf: f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl2nc=:fe2ne o
Nov 21 01:59:12 rainbird kernel: x 1f1<ey  4In I 11sn
Nov 21 01:59:12 rainbird kernel:  N 9 4tiVr cn=qA31nc4 A31nc4 A31nc4> A31nc5 Aq1nc4 Aq1nc4> q01s4>:l [eft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel:  n c*ro_*n*_er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl2 c<fV 2t4c9c] 1f1<ey  4In I11114 Ni9t40iV2 c 9qA31n15 A31n1
Nov 21 01:59:12 rainbird kernel:  A31n15 A31n15 Aq1n15 A31n15 A31n1
Nov 21 01:59:12 rainbird kernel: :l 0[e4<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er* 1r:rn
Nov 21 01:59:12 rainbird kernel:  fc:f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl2n4ff 2tc19<0 1f1<ey  4In I11114 Ni9 40iVr c 9qA31nc5 A31n15 A31n14 Aq1n15 A31n15 Aq1n15 Aq1n15:6xx4tft<ef]_cirrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_ec  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:t<if  f8c4 fcs:[r8ptf  f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Nl2 c<:Ve t4c=c] 1f1<ey  4In I 1114 N 9 40iV2 c 9qA31n15 A31n15 A31n15 A31n15 A31n1> q01s4> 31n15:6lx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n__er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i0  8c4 fcs:[r>ptf  f0of1cx Iqc
Nov 21 01:59:12 rainbird kernel:  Nl2nc<:V 2r4c9<] 1f1<ey  4In I11115 N 9 40iVr c 9qA31n15 Aq1n15 A31n15 q01s4>A31n15 A31n15 A31n15:6xx4tft<f]gci2rt*
Nov 21 01:59:12 rainbird kernel: qn _*ro_*n__er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r>ptf  f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl2nc<:Ve2rcc9c0 1f1<ey  4In I11114 N 9 y0iV2 c 9qA31n14 Aq1n15 A31n15 A31nc5 Aq1n15 A31n15 A31n15:6xx4tft<0c f82rrt*_qn c*ro_*n*_er2 1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:    8c4 fcs:[r8ptf: f0of1cx oqc
Nov 21 01:59:12 rainbird kernel:  Nl28to4fVe2ne o
Nov 21 01:59:12 rainbird kernel: x 1f1<ey  4In I11114 N 9 40iVr c 9qA31n14 A31n15 A01s4> 31nc5 A31n15 A31n14 Aq1n15:6xx4:ft<0c g82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ror*n__er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<if  f8c4 fcs:[r8ptf  f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl2nc=:Ve2r4c9c] 1f1<ey  4In I11114 N 9 40iV2 c =qAq1n15 A31n15 A31n15 Aq1n15 A31n14 Aq1n15 A31n15:6xx4:ft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1r:rn
Nov 21 01:59:12 rainbird kernel:  f::f8iicdzf]c40<] fr8ptf  f0of1cx oqc
Nov 21 01:59:12 rainbird kernel:  Nl9nc=ff 2t4c9c] 1f1<ey  4In I11114 N 9 40iVr 0 9qA31n 
Nov 21 01:59:12 rainbird kernel:  q01s4> 31 15 Aq1n15 A31n15 A31n15 A31n15:6xx4tft<ec f82rrt*
Nov 21 01:59:12 rainbird kernel: qn _*ro_*n*_er  1r:r 
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4qfcs:[rmrx: f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  Nl9nc=ff 2rcc9c] 1f1<ey  4In I11114 Ni9 40iV2 024q31n15 A31nc5 A31n15 A31n14 A31n15 A31n15 A31nc5:6xx4tft<0c fc2rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1e:rn
Nov 21 01:59:12 rainbird kernel:  f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx Iqcn Nl2nc<:Ve2t4c9c] 1f1<ey  4In I1111n Ni9 40iVr c 9qA31nc5 A31n15 A31n15 A31n15 A31n15 A31n15 Aq1n15:6xx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n**261r:rn
Nov 21 01:59:12 rainbird kernel:  f::f:t<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fc :[r8ptf  f0of1cx Ir0n
Nov 21 01:59:12 rainbird kernel:  Nl9 c=ffe2r4c=c] 1f1<ey  4In I 1114 Ni9 40iV2 cn9qAq1n15 A31n15 A31n15 A31n15 A31nc4> q01s4> 31n15:6lx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*r _*n*_er  1r:rnu fc:f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fc :[r8ptf  f0of1cxr n
Nov 21 01:59:12 rainbird kernel:  Nl2nc=:fA ne t
Nov 21 01:59:12 rainbird kernel: [ 1f1<ey  4In I 1114 Ni9 40iVr c 9qA31n15 A31n15 Aq1n15 A31n15 A31nc5 A31n15 A31n14:6xx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er  1e:rn> f::f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r>ptf  f0of1cf [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 01:59:12 rainbird kernel: cqf nc _***i  *1iras:a<c
Nov 21 01:59:12 rainbird kernel:  if]ezfcsx[tmpf: 0:4  frI11n15 22  = 2  o <  0fl rxf  0c[fs2tr4c9c 2 A :r1f1c  fl  yo8f ceuxfe0n4n0f t t]f1tyt8fo t t]f1ty cf8->px0x
Nov 21 01:59:12 rainbird kernel:  x7 c* *]fup_7*1 c ri*248oc  ixfc :f ]sx4df xxdt<s af0ef0sr n   i1c45D 2 1V 9 21 1=0[e1o[f 0rt[fV21tr4c9AL020Dt  c c8fq21ec[f218so0fi  yu] i2cn4:r21 c5 i2cnn:>t00]0]fcf]eco8 irb _d *rcis_lns i06 <vo: 
Nov 21 01:59:12 rainbird kernel:  if8s4ifcsx[>mcf: 0:4:cfc0 bf8 D2n1nx:I c uc2L1 4o> Ac>L9tf18Nr r  i3 2xiNi c408 xfLnt2tA :r1f1c 0 t<ifi 1=4q r144> [q9 0ce 29 0cf 2
Nov 21 01:59:12 rainbird kernel:  ft4xxpeb:(8crigd_d *rriswlns i06 <vo: 
Nov 21 01:59:12 rainbird kernel:  ic8s4ifcs:[ 8r f  0r4:cfc0 bf< D2n1nx:I n uc2L1 4o>cAc>L9tf18Nr r5] i3y98Io cu08::fNnt2tA :r1f1c 0st<ifi y=4q r1n4> [q9 0ce 29 0c  29 0c 0  :f>rft4gxpab:(:crigd_d *rcis_lns i06 <vo: d0 f8s4ifcs:[ 8r f  0:4: f<c]n fcf2t1nxI n uc2L1 4o>cAc>L9tf18Nr r5] i  9 Ii 0408 xfLnt2tA :r1f1c 0 t<ifi 1=4q r144> [q9c0ce 29c0cf 29 0c 0  pf>rft4xxpab:(:crigd_q *rcis_lnsci06 <vo: 
Nov 21 01:59:12 rainbird kernel:  ic8s4ifcs:[ 8r f  0r4:cfc0 bf8 D2n1nx:I c uc2L1 4o>cAc>L9tf18Nr r  i3y28Ii cu 8 xfLnt2tA :r1f1c 0st<ifi y=4q r140xNqcu< fI9 0cf 29 0c 0  pf>rft4xxpa1:(:crigdqfc1rrs_lns i05 cv : 0 cc 4ifcsx[>mcf: 0:4:cfc0 bf8 D2t14xxI n ]if1 4o> Ac>L9tf18Nr r5] i y9 Ii 0u 8 xfLnt2tA :r1f1c 0 t<ifi 1=4q r144> Nqcu< fI9 0cfV2cu<]-0 pf>rft4xxpab:(:crigd_d *r iwb_cnr06 <vo: 
Nov 21 01:59:12 rainbird kernel:  if8s4ifcs:[ 8r f  0fx f<0 bf8 D2n1nx:I c uc2L1c4o>cAc>L9tf18o1y  AI  ncqD29ct4xDlr21tx 3f94on020Dtu fAr20nifLq1 tqfI2 r=  D 1e fA 21=:>0c08ftfc f2>hd4 l>xrrssa:1vyr 2o_crpt49  o et xx efsfd f0sf:f i0[d :f:gf/x0f r84ccfDi11>sfI    ifL29 I =f2yn f2i t8  r8e0[fLq 8nn100]le72tA :r18f2  28    c [fei2nc0for0to0 or0to0 or0to008r >:[f:rf fbbw e)irg__d8ficu _*v_ ee*388oxid [ >c f  0:4:ifc0  <spmf0s 4if Ioq1n9i sr y0r[ i9sris0lnn8fl2  [fV3 1o]ifo2tr419A0i2oIn[21f1<xe22c14fo30n3>fl  t c 1211nf 2101xf 2101xf 2101x0[0>c_c  f<cf:(ulb [erra[x  rii ocbri2* i8/-sctftf<c xacsex: 8 f[qf  :t >sf [i 9rt N 11 n 1nf218fe20>fIq rtxf[10n t
Nov 21 01:59:12 rainbird kernel: [ 22 8xi1f2 or L 8t3 9I  0 4:D2c 1>   nr2<0  nr2<0  nr2<0  nr2<0  nr2<0
Nov 21 01:59:12 rainbird kernel: 848r
Nov 21 01:59:12 rainbird kernel: rxf[tfkl>hd7 i_r <]fccss__w_c*a 2*1erphax fcf[d <if  f c4q<crf[r>rfx: 0fq21ec[le[s 9fI21e :Di cc5 or 0t
Nov 21 01:59:12 rainbird kernel: [qff24on020Dt  c   n1] Iinc2
Nov 21 01:59:12 rainbird kernel: iNrt  <qVq11c4 Aq11c4 Aq11c4 Aq11c4 Aq11c4 Aq11c4:3l0 g<t<e] feh)bb0 i82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_ec  1r:rn
Nov 21 01:59:12 rainbird kernel:  fffff
Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdtef8t <f  f]c40<  fr8ptf  f0of1cx oqcn Nl9nc<fVe2r4c9c] 1f1<ey  4In I 1114 N 9 40iV2 0 9qA31n15 A31n15 Aq1n15 A31n15 A31n15 A3n15 A31n15:6xx4tft<0c f]2rrt*
Nov 21 01:59:12 rainbird kernel: qn id rfn*_ir  1r:rn> fef8t i
Nov 21 01:59:12 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx Iqc
Nov 21 01:59:12 rainbird kernel:  N  tc<fV  t4c9c] 1f1<ey  4In I11114 N 9 40iV2 c 9qA31n15 A31n15 A31n1
Nov 21 01:59:12 rainbird kernel:  A01c4>A31n15 A31n15 A31n1
Nov 21 01:59:12 rainbird kernel: :6 0:f4tec f82rrt*
Nov 21 01:59:12 rainbird kernel: un_id rfn*_er* e8o u8f::f: <f0  c 4 fcs:[r8ptf  f0of1cx r n
Nov 21 01:59:12 rainbird kernel:  N 9nc=fV 2r4c9c] 1f1<ey  4In I11114 N 9 y0iV2 c 9qA31n15 A31n15 A31n15 A31n15 31n15 A31n15 Aq1n15:6xx4tft<0c f82rrt*_qn c*ro_*n_**r2 1e:rn
Nov 21 01:59:12 rainbird kernel:  fc:f:i<i
Nov 21 01:59:12 rainbird kernel:   f8c4qfcs:[r>ptf  f0of1cx Iq n
Nov 21 01:59:12 rainbird kernel:  Nl2 c<:f i1rc19<] 1f1<ey  4In I111sn Ni9 y0iV2 c 9qAq1n15 A31n15 A31n15 Aq1n4 A31n15 A31n1
Nov 21 01:59:12 rainbird kernel:  q01c4>6xx4tft<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn c*ro_*n*_er* e8o u8f::f: <f0  8c4 fcs:[r8ptf  f0of1cx oq n
Nov 21 01:59:12 rainbird kernel:  N  nc<fV  t4c9c] 1f1<ey  4In I11114 N 9 40iVr 0 9qA31n1
Nov 21 01:59:12 rainbird kernel:  A01c4>A31n15 A31n15 A31n1
Nov 21 01:59:12 rainbird kernel:  q01c4> 31 1
Nov 21 01:59:12 rainbird kernel: :6 0:f4<0c f82rrt*
Nov 21 01:59:12 rainbird kernel: qn_id rfn*_er* e8o u8f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4qf8s:[r8p:f f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9nc<fV 2t4c9c] 1f1<ey  4In I11114 Ni9 40iVr c 9qA31n15 A31n15 A31n15 A31n15 A31n15 A31n1
Nov 21 01:59:13 rainbird kernel:  A01c4>6xx4tft<0c f82rre_ [ c*rof*n**c261r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f]cq0<  f[8ptf  f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9nc<ff 2tc19c] 1f1<ey  4In I11114 N 9 4 iV2 c ]qA31n15 A01s4>A31n1>A31 1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n1
Nov 21 01:59:13 rainbird kernel:  q0115:6xxxtftef f82rrtp
Nov 21 01:59:13 rainbird kernel: un_ido_*n*_ir* e8o 
Nov 21 01:59:13 rainbird kernel:  f::
Nov 21 01:59:13 rainbird kernel: : <f0 f8c4 f8sx[rmtf  f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9 c<:Ve2tn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11114 N 9t4 iV2t 9qA31 1
Nov 21 01:59:13 rainbird kernel:  A0n15 A31n1
Nov 21 01:59:13 rainbird kernel:  q0115 A31 1
Nov 21 01:59:13 rainbird kernel:  A0n1
Nov 21 01:59:13 rainbird kernel:  q0115:6xxxtftef]f82rrt*
Nov 21 01:59:13 rainbird kernel: un id rfn*_ir* 18on
Nov 21 01:59:13 rainbird kernel:  f::
Nov 21 01:59:13 rainbird kernel: : <f0 f8c4 fcsx[>mrf1cx oqcn Nl2 nt]fA nn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I 1114 N 9 40iV2 c 9qA31n15 A31n15 A31n15 A31n15 A31n15 A31n15 A31n15:6lx4tft<ec f82rrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  fc:f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl9 c<fV 2r4c9c] 1f1<ey  4In I11114 Ni9 40iV2 c 9qA31n15 Aq1n15 Aq 1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n1
Nov 21 01:59:13 rainbird kernel:  A01c5 A31 1
Nov 21 01:59:13 rainbird kernel: :l 0tft<0cnf]2rr*
Nov 21 01:59:13 rainbird kernel: un_id _*n*_ir* e8on
Nov 21 01:59:13 rainbird kernel:  f::
Nov 21 01:59:13 rainbird kernel: : <i0 f]cq0<s:[r8p:f  0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  N  no]f  nn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11115 N 9 40iV2 0 9qA31 1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n1
Nov 21 01:59:13 rainbird kernel:  A0115 A31 1
Nov 21 01:59:13 rainbird kernel:  A0 1
Nov 21 01:59:13 rainbird kernel:  q0115:6xxxtftef]f82rrtp
Nov 21 01:59:13 rainbird kernel: un ido_*n*_ir* e8on
Nov 21 01:59:13 rainbird kernel:  f::
Nov 21 01:59:13 rainbird kernel: : <f0  c 4 f8s:[>mxcd f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl9nc<:V 2r4c9c] 1f1<ey  4In I11114 N 9 40iV2 c 9qA31n15 A31n15 A31n15 A31nc5 A31n15 Aq1n1
Nov 21 01:59:13 rainbird kernel:  q01c4>:xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r>ptfd f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl9 c=]fAi1n o
Nov 21 01:59:13 rainbird kernel: x 1f1<ey  4In I 1114 N 9 40iVr c 9qAq1n15 A31n15  cs 
Nov 21 01:59:13 rainbird kernel:  A01c4>A31n1
Nov 21 01:59:13 rainbird kernel:  q01c4> 31 1
Nov 21 01:59:13 rainbird kernel: :6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn _*cof*_**c261r:rn
Nov 21 01:59:13 rainbird kernel:  f::f8i<i
Nov 21 01:59:13 rainbird kernel:   f8c4qfcsx[rmtf  f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9nc<fV 2t4c9c] 1f1<ey  4In I11114 Ni9 40iVr c 9qA31n15 A31n15 A31n15 A31n1
Nov 21 01:59:13 rainbird kernel:  q01c4>A31n15 A31n1
Nov 21 01:59:13 rainbird kernel: :l 0:f4<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: un_id rfn*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8cq0<s:[r8ptfd f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  N  no]f  nn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11115 N 9t4 iV2t 9qA31n1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n1
Nov 21 01:59:13 rainbird last message repeated 2 times
Nov 21 01:59:13 rainbird kernel: :l 0tft<0cnf]2rre
Nov 21 01:59:13 rainbird kernel: qn c*cof*_**c261r: n> cef8t i
Nov 21 01:59:13 rainbird kernel:  zf]cq0<s:[r8ptfd 0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9 c<:Ve2tn o
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11115 N n40iV2 c ]qA0n1
Nov 21 01:59:13 rainbird kernel:  A011>Aq1n15 A31n15 q01c4>A31n15 A31n15:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n*_ec  1r:rn
Nov 21 01:59:13 rainbird kernel:  fc:
Nov 21 01:59:13 rainbird kernel: :i<if zf8c4 fcs:[r8ptf  f0of1cx oqcn Nl9nc<fVe2t41=c] 1f1<ey  4In I11115 N 9 40iV2 c ]qA31n15 A31n15 A31n15 A31n15 A31n15 A31n15 A31n15:6lx4tft<ec f]2rre_ [ c*ro_*n*_er  1r:rn> cef8t i
Nov 21 01:59:13 rainbird kernel:  f]cq0<  fr8ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl9 c=fV  t4c9c] 1f1<ey  4In I11114 N 9 4 iV2 c 9qA31n15 A31n15 Aq1n15 A31n15 A31n15 A01c4>A31n1
Nov 21 01:59:13 rainbird kernel: :l 0:f4tef]gcirrt*
Nov 21 01:59:13 rainbird kernel: un_id rfn*_er  1e:rn> cef8t i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r8ptf  f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl9 c=:V 2r4c9c] 1f1<ey  4In I11114 N 9 40iV2 c 9qA3n15 Aq1n15 A31nc5 A31n15 Aq1n15 A31n15 Aq1n15:6xx4tft<ec f82rrt*_qn _*ro_*n__er  1e:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:    8c4 fcs:[r>ptf: f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl28tc=:f i1e t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I111sn Ni9 40iVr c 9qAq1n15 A31n15 Aq1n15 A31nc4 Aq1n15 Aq1n15 Aq1n15:6xx4tft<0c gc2rrt*
Nov 21 01:59:13 rainbird kernel: qn _*ror*n__er  1e:n
Nov 21 01:59:13 rainbird kernel:  f::
Nov 21 01:59:13 rainbird kernel: : <i0  cc4 f8sx[>mrf  f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl9nc<:Ve2tn1=<0 1f1<ey  4In I11115 N nytiV2 0 ]qA0n15 A31n1
Nov 21 01:59:13 rainbird kernel:  q0115 A31 15 q01c4>A31 1
Nov 21 01:59:13 rainbird kernel:  q0115:6xx4tftef]g82rrtp
Nov 21 01:59:13 rainbird kernel: un_ido_*n*_ir* 1r:rn> fef:i<i
Nov 21 01:59:13 rainbird kernel:  zf8cq0<  fr8p:fd f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  N  nc=ffe2tn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11115 i nyt<V2t 9qA31n15 A31n15 Aq1n15 A31n15 A31n1
Nov 21 01:59:13 rainbird kernel:  A01c4>A31n15:6xx4:ft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: un id rfn*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r8ptfd f0of1cx Iqcn Nl2nc<ff 2tcc9c] 1f1<ey  4In I11114 Ni9 40iV2 c 9qA31n15 A31n15 A31n15 Aq1 15 Aq1n15 A31n15 A31n15:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: un id rfn*_e2 1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<f0  c 4 fcsx[rmrf  f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl9 c=fV  t4c9c] 1f1<ey  4In I 1114 N 9 40iV2 c ]qA31n15 A31n15 A31n15 A31n15 Aq1n15 A31n1
Nov 21 01:59:13 rainbird kernel:  A31n15:6xx4tft<ec f82rrt*
Nov 21 01:59:13 rainbird kernel: un c*ro_*n*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<if  f]c40<  fr8ptf  f0of1cx oqcn Nl2nc<fVe2r4c9c] 1f1<ey  4I I 1115 N 9 40iV2 c ]qA31s > q1n1
Nov 21 01:59:13 rainbird kernel:  q01c4>A31n1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n1
Nov 21 01:59:13 rainbird kernel:  A0n15:6xxxtftef]f82rrt*
Nov 21 01:59:13 rainbird kernel: un_id rfn*_ir  1r:rn> cef:i<i
Nov 21 01:59:13 rainbird kernel:  zf]cq0<  fr8p:fd 0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  N  no]f  nn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11115 i nyt<V2 0 9qA31 15 A31 1
Nov 21 01:59:13 rainbird kernel:  q01c4>A31n1
Nov 21 01:59:13 rainbird kernel:  A01c4>A31 15 A31n1
Nov 21 01:59:13 rainbird kernel: :l 0:f4<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: un *r  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f: <i0  8c4 fcs:[r8ptf  f0of1cx oqc
Nov 21 01:59:13 rainbird kernel:  Nl9 c=fV 2r4c9c] 1f1<ey  4In I11114 N 9 40iV2 c 9qA31n1
Nov 21 01:59:13 rainbird kernel:  q0115 A31n15 A31n15 A31n15 A31n15 A31n15:6xx4tftef]gcirrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n*_er  1r:rn> fef8t i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r8ptfd 0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  N  no<:V  r4c9c] 1f1<ey  4Inmmp
Nov 21 01:59:13 rainbird kernel: qn c*r r*n__ec  1e:r 
Nov 21 01:59:13 rainbird kernel:  f::f8i<i
Nov 21 01:59:13 rainbird kernel:    c cq0<] x[rmrxc  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl28tc=]fVe2ne t5[ 1f1<ey  4In I 11s4 N 9 y0iVr cn=qAq01s 
Nov 21 01:59:13 rainbird kernel:  Aq1nc4> A01s 
Nov 21 01:59:13 rainbird kernel:  A01s 
Nov 21 01:59:13 rainbird last message repeated 2 times
Nov 21 01:59:13 rainbird kernel:  Aq1nc4>:l 0[eft<0c gci2rredxun id p_*n***2* 1e:r u8 cef>m <i0  ]cq0<s:[r>ptfd f0of1cx oq n
Nov 21 01:59:13 rainbird kernel:  Nl2nc=:V  tn t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I111s4 Ni9 4tiVr c 9qA31n15 A31n15 A31n15 A31n15 Aq1n15 A31n15 A31n15:6lx4:f4tef]gci2rred [n_*rof*n*_ec  1r:r 
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   fcc4 fcs:[r8ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl2 c<fVe2t4c9c] 1f1<ey  4In I1111n Ni9 40iV2 c ]q01s4> q01s4> 31nc5 Aq1nc4 Aq1nc5 Aq1nc5 A31nc5:6xx4:f4tef]_ci2rredxun _*r _*n*_ec  1e8odt> f::f8t<i
Nov 21 01:59:13 rainbird kernel:    8c4qfc :[r8ptf  f0of1cx Ir0c
Nov 21 01:59:13 rainbird kernel:  Il28to<:fe2t419c] 1f1<ey  4In I 1c n
Nov 21 01:59:13 rainbird kernel:  i nrt<ir2te=4qq01s 
Nov 21 01:59:13 rainbird kernel:  A01s 
Nov 21 01:59:13 rainbird kernel:  A01s4>Aq1nc5 A31nc5 A31nc5 A31nc4>:6 0:ft<ef]_cirrt*_qn c*r _*n*_ec26 e8 
Nov 21 01:59:13 rainbird kernel:  fc:f8t<if0  f]c4qfc :[r>ptf: f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Il28tc=:fA 2ne o
Nov 21 01:59:13 rainbird kernel: x 1f1<ey  4In I 1c  5 Ni9 y0iVr cn=qAq1nc4> A01s 
Nov 21 01:59:13 rainbird kernel:  Aq1nc5 Aq1nc4> A01s 
Nov 21 01:59:13 rainbird kernel:  A31nc4> A01s 
Nov 21 01:59:13 rainbird kernel: :6lx4:f4<ef]_f]2rrt*_qn _*r rf*n***2* 1r:r u fcef>m <if0  c c40<] x[r8ptf: f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl2 c=:fA 2ne4c=
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In 11114 Ni9 40iV2 c 9qA31n15 Aq01s4> q01c4> q01c4> 31n15 Aq1n15 A31n14:6xx4tft<0c f82rrt*_qn c*ro_*n*_er  1e:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4qfcs:[r8ptf  f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl9nc<:Ve2r4c9c0 1f1<ey  4In I 1114 Ni9 40iV2 c 9qA31n14 A31n15 A31nc5 A31n15 A31n15 A31n15 A31n15:6xx4tft<0c f82rr*
Nov 21 01:59:13 rainbird kernel: qn c*r _*n__ec2 1e8odt8 cef>m <f0  c cq0<] x[r>ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl28to<:Ve2t4c9c] 1f1<ey  4In I 11s4 Ni9 yt<ir2te=4qq01s 
Nov 21 01:59:13 rainbird kernel:  Aq1nc4 Aq1nc5 Aq1nc4> q01s 
Nov 21 01:59:13 rainbird kernel:  q01s 
Nov 21 01:59:13 rainbird kernel:  A01s 
Nov 21 01:59:13 rainbird kernel: :6lx4:ft<0c gc2rrt*_ [n_id rf*_***2* 18odt> fc:f8t<i
Nov 21 01:59:13 rainbird kernel:    c cq0<] f[>mrxcd f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl2nc<:Ve2tn t5 1f1<ey  4In I 11sn
Nov 21 01:59:13 rainbird kernel: N 9 y0iV2 cn=qA31nc5 Aq1n15 Aq1n15 A31nc4> 31n14 Aq1n15 Aq1nc5:6xx4:ft<0c gci2rred [n_id rf**_er* 1r:r 
Nov 21 01:59:13 rainbird kernel:  f::f8t <i0  c cqfc  [r>ptf  f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl2nc<:Ve2t4c9c] 1f1<ey  4In I111s4 Ni9 ytiVr cn9qA31nc5 A31nc5 A31nc4>Aq1nc5 A31nc5 A31nc5 A31nc:6lx4:f4t<f]_fi2rredxqn _*r rf*_***2* 1e:r u8 fef>m <f0  f]c4qfc  f[>mrxcd f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl28nc=]fVe 1rc o9c0 1f1<ey  4In I111sn
Nov 21 01:59:13 rainbird kernel:  i nr1 iVr cn=4qA31nc4 A31nc4> A01s 
Nov 21 01:59:13 rainbird kernel:  Aq1nc4>Aq1nc4> A01c4> q01s 
Nov 21 01:59:13 rainbird kernel: :l 0[eft<0c gci2rredxun _*ror*n*_ec26 18o t8 fef>m <if0  f]c4qfc  f[rmrxcd f0of1cx Irn
Nov 21 01:59:13 rainbird kernel:  Nl2nct4fA  t419c] 1f1<ey  4In I 11s4 Ni9 y0iVr cn9qA31n15 A31nc4> q01s4> q01s4> q01s4> q01s4> q01s 
Nov 21 01:59:13 rainbird kernel: :6 0[eft<f]gci2rt*
Nov 21 01:59:13 rainbird kernel: qn c*r _*n*_ec26 18odt> fef>t <f0  c cq0<] f[>mrf  f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl2 c<:Ve 1e t5[ 1f1<ey  4In I 1c n
Nov 21 01:59:13 rainbird kernel:  N nyt<ir2te2]qA31nc5 A31nc4 Aq1nc5 A31nc5 A31 4> 31nc5 A31n15:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n__er  1r:rnu f::f:i<i
Nov 21 01:59:13 rainbird kernel:    8c4 fcs:[r>ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl2nc=:Ve2r4c9<0 1f1<ey  4In I 1114 Ni9 40iV2 c 9qA31n15 Aq1n14 Aq1n15 A31n15 A31nc5 A31n15 A31n14:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn _*ro_*n*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4qfcs:[r8pf: f0of1cx Ir0n
Nov 21 01:59:13 rainbird kernel:  Nl2 c=fVe2t4c9<0 1f1<ey  4In I 11s4 N 9 yt<iV2tn=4qq01s 
Nov 21 01:59:13 rainbird kernel:  Aq1nc4> q01s 
Nov 21 01:59:13 rainbird kernel:  A31nc4 A31nc5 Aq1nc4 Aq01s 
Nov 21 01:59:13 rainbird kernel: :6 0[eft<ec gci2rredxun id pf*n***2* 18odt> fef>t <f0  f]c4 fc :[r8ptf: f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl28to]fVe2tn o
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I 11sn
Nov 21 01:59:13 rainbird kernel:  N nrt<ir2te2]qAq1nc4> A01c41 15 Aq1n15 Aq1n15 Aq1n15:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn c*ro_*n__er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f:i<i
Nov 21 01:59:13 rainbird kernel:   f8c4 fcs:[r>ptf  f0of1cx Iq n
Nov 21 01:59:13 rainbird kernel:  Nl2nc<ffe 1e t
Nov 21 01:59:13 rainbird kernel: [ 1f1<ey  4In I11114 N 9 40iVr c 9qAq1n15 A31n15 A31n15 A31n15 A31n15 Aq1n15 A31n15:6xx4tft<0c f82rrt*
Nov 21 01:59:13 rainbird kernel: qn _*ro_*n*_er  1r:rn
Nov 21 01:59:13 rainbird kernel:  f::f8t i
Nov 21 01:59:13 rainbird kernel:   8c40<  f[>ptf  f0of1cf [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 01:59:13 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 01:59:13 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 01:59:13 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 01:59:13 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 01:59:13 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 01:59:13 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff

[ Etc, etc ad nauseum.  What follows is the end of the log, the last messages emitted before I unloaded the modules]

Nov 21 12:10:08 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
Nov 21 12:10:08 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
Nov 21 12:10:08 rainbird kernel: cx88[0]/1: Audio risc op code error
Nov 21 12:10:08 rainbird kernel: cx88[0]: audio from - dma channel status dump
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: cdt size    : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: iq base     : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: iq size     : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: risc pc     : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: iq wr ptr   : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: iq rd ptr   : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: cdt current : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: pci target  : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cmds: line / byte : 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
Nov 21 12:10:08 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
Nov 21 12:10:08 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
Nov 21 12:10:08 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
Nov 21 12:10:08 rainbird kernel: cx88[0]/1: IRQ loop detected, disabling interrupts

----- Text Import End -----

That last "IRQ loop detected" gets dumped to the console thousands of times - enough so that the console is completely unusable while the card's driver is loaded, if the SATA disk is also being used.  For example, doing a 'du' on its mount point is enough to send the cx88 driver into a tizzy.


-- 
"There are some things in life worth obsessing over.  Most
things aren't, and when you learn that, life improves."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
