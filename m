Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM2nMn5029287
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 21:49:22 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM2n93t022854
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 21:49:10 -0500
From: Andy Walls <awalls@radix.net>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
In-Reply-To: <200811211511.14193.vanessaezekowitz@gmail.com>
References: <200811211511.14193.vanessaezekowitz@gmail.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 21:50:00 -0500
Message-Id: <1227322200.3602.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: cx88 IRQ loop runaway
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

On Fri, 2008-11-21 at 15:11 -0600, Vanessa Ezekowitz wrote:
> I'm not sure whose 'department' this is, so I'm sending this email to
> the v4l/dvb lists...
> 
> About a week ago, my machine started locking up randomly.  Eventually
> figured out the problem and ended up replacing my dead primary SATA
> disk with a couple of older IDE disks.  A reinstall of Ubuntu Hardy,
> and a couple of days of the usual setup and personalizing tweaks
> later, my system is back up and running.  
> 
> There is still one other SATA disk in my system and it is behaving
> normally.  While adding the replacement disks, I moved it to the port
> formerly occupied by the dead disk.
> 
> My system, for reasons beyond my understanding, insists on sharing
> IRQ's among the various PCI devices, despite my explicit settings in
> the BIOS to assign fixed IRQ's to my PCI slots.   One of those IRQ's
> is being shared between my capture card and SATA controller.
> Normally, this would not be an issue, but I seem to have found a nasty
> bug in the cx88xx driver.

I'm not so sure about that (see below), but you have found a nasty
problem with your system I think.


> Without trying to use my capture card at all, every time I access the
> other SATA disk in my system, the cx88 driver spits out a HORRENDOUS
> number of weird messages, filling my system logs so fast that after
> two days, I'd used over 6 GB just in the few logs that sysklogd
> generates.

Every time the sata controller generates an interrupt, the kernel calls
the IRQ handler routines sharing that interrupt.  Your cx88 driver
*always* thinks it has interrupts to service - but it actually doesn't.

Note how many of the dumped registers are '0xffffffff' including the
'irq aud' interrupt status register:

> Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*

A 0xffffffff is likely not a real interrupt status, but a PCI bus read
error, for which the PCI-PCI bridge or Host-PCI bridge returns the all
ones value.  The interrupt handler sees every possible interrupt that it
could be interested in as having occurred and likely tries to process
them.  The further PCI MMIO accesses are also failing as evinced by all
the 0xffffffff values being dumped.




> My only solution so far is to unload the cx88 driver modules.  This is
> a showstopper - I cannot use or even enable my capture card until this
> is resolved.

I have no good ideas for you on how to clean up the PCI MMIO errors.
Increasing PCI bus latency timers of devices and PCI bridges may help.
Look for bridges and devices that are declaring Master or Target Aborts
or SERR or PERR in lspci.  That may narrow down the culprits.  You may
wish to try pulling out the cards, blowing the dust out, reseating the
cards, and hoping for the best.

To get the SATA controller and the cx88 off the same IRQ line, the
easiest thing to do is move the cx88 card over to another slot.


Good luck.

Regards,
Andy

> Log excerpt below.  I haven't the faintest clue what's causing that
> garbage at the end of the excerpt.  I didn't keep the older logs for
> obvious reasons, but that garbage appears multiple times, so it is
> reproduceable.




> HELP!!
> 
> ----- Text Import Begin -----
> 
> Nov 21 01:57:16 rainbird kernel: Linux video capture interface: v2.00
> Nov 21 01:57:16 rainbird kernel: cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> Nov 21 01:57:16 rainbird kernel: cx8800 0000:02:07.0: enabling device (0004 -> 0006)
> Nov 21 01:57:16 rainbird kernel: cx8800 0000:02:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> Nov 21 01:57:16 rainbird kernel: cx88[0]: subsystem: 17de:08c1, board: Kworld PlusTV HD PCI 120 (ATSC 120) [card=67,autodetected]
> Nov 21 01:57:16 rainbird kernel: cx88[0]: TV tuner type 71, Radio tuner type -1
> Nov 21 01:57:16 rainbird kernel: tveeprom 1-0050: Huh, no eeprom present (err=-6)?
> Nov 21 01:57:16 rainbird kernel: cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> Nov 21 01:57:16 rainbird kernel: cx88[0]/0: found at 0000:02:07.0, rev: 5, irq: 19, latency: 32, mmio: 0xe8000000
> Nov 21 01:57:16 rainbird kernel: cx88[0]/0: registered device video0 [v4l2]
> Nov 21 01:57:16 rainbird kernel: cx88[0]/0: registered device vbi0
> Nov 21 01:57:17 rainbird kernel: cx88[0]/0: registered device radio0
> Nov 21 01:57:17 rainbird kernel: cx2388x alsa driver version 0.0.6 loaded
> Nov 21 01:57:17 rainbird kernel: cx88_audio 0000:02:07.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> Nov 21 01:57:17 rainbird kernel: cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.851742] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.866072] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux_0'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.885767] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8800_video4linux_1'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.888505] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_pcm_0'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.900119] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_alsa_capture_0'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.908469] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_pcm_0_0'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.916611] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_alsa_control__1'). 
> Nov 21 01:57:17 rainbird NetworkManager: <debug> [1227254236.924818] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_14f1_8801_oss_mixer__1'). 
> Nov 21 01:57:17 rainbird kdm[4035]: StartServerSucces
> Nov 21 01:57:35 rainbird kdm: :0[4060]: pam_unix(kdm:session): session opened for user vanessa by (uid=0)
> Nov 21 01:58:06 rainbird pactl: gethostby*.getanswer: asked for "localhost.gateway.2wire.net IN AAAA", got type "A"
> Nov 21 01:58:11 rainbird NetworkManager: <info>  Updating allowed wireless network lists. 
> Nov 21 01:58:13 rainbird NetworkManager: <WARN>  nm_dbus_get_networks_cb(): error received: org.freedesktop.NetworkManagerInfo.NoNetworks - org.freedesktop.NetworkManagerInfo.NoNetworks. 
> Nov 21 01:59:12 rainbird kernel: f [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
> Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]: irq pci [0xfc02] aud risc_rd_err* risc_wr_err* brdg_err* src_dma_err* dst_dma_err* ipb_dma_err*
> Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* upf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 31*
> Nov 21 01:59:12 rainbird kernel: cx88[0]/1: Audio risc op code error
> Nov 21 01:59:12 rainbird kernel: cx88[0]: audio from - dma channel status dump
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: initial risc: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt base    : 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cmds: cdt f [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
> Nov 21 01:59:12 rainbird kernel: cx88[0]: fifo: 0x00185400 -> 0x186400
> Nov 21 01:59:12 rainbird kernel: cx88[0]: ctrl: 0x00180680 -> 0x1806e0
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr1_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   ptr2_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt1_reg: 0xffffffff
> Nov 21 01:59:12 rainbird kernel: cx88[0]:   cnt2_reg: 0xffffffff

[snip]

> ----- Text Import End -----
> 
> That last "IRQ loop detected" gets dumped to the console thousands of
> times - enough so that the console is completely unusable while the
> card's driver is loaded, if the SATA disk is also being used.  For
> example, doing a 'du' on its mount point is enough to send the cx88
> driver into a tizzy.
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
