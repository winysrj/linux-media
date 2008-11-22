Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM3G0qO005047
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 22:16:00 -0500
Received: from joan.kewl.org (joan.kewl.org [212.161.35.248])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM3FnuO029791
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 22:15:49 -0500
From: Darron Broad <darron@kewl.org>
To: Andy Walls <awalls@radix.net>
In-reply-to: <1227322200.3602.17.camel@palomino.walls.org> 
References: <200811211511.14193.vanessaezekowitz@gmail.com>
	<1227322200.3602.17.camel@palomino.walls.org>
Date: Sat, 22 Nov 2008 03:15:48 +0000
Message-ID: <1027.1227323748@kewl.org>
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

In message <1227322200.3602.17.camel@palomino.walls.org>, Andy Walls wrote:

hi.

>On Fri, 2008-11-21 at 15:11 -0600, Vanessa Ezekowitz wrote:
>> I'm not sure whose 'department' this is, so I'm sending this email to
>> the v4l/dvb lists...
>> 
>> About a week ago, my machine started locking up randomly.  Eventually
>> figured out the problem and ended up replacing my dead primary SATA
>> disk with a couple of older IDE disks.  A reinstall of Ubuntu Hardy,
>> and a couple of days of the usual setup and personalizing tweaks
>> later, my system is back up and running.  
>> 
>> There is still one other SATA disk in my system and it is behaving
>> normally.  While adding the replacement disks, I moved it to the port
>> formerly occupied by the dead disk.
>> 
>> My system, for reasons beyond my understanding, insists on sharing
>> IRQ's among the various PCI devices, despite my explicit settings in
>> the BIOS to assign fixed IRQ's to my PCI slots.   One of those IRQ's
>> is being shared between my capture card and SATA controller.
>> Normally, this would not be an issue, but I seem to have found a nasty
>> bug in the cx88xx driver.
>
>I'm not so sure about that (see below), but you have found a nasty
>problem with your system I think.
>
>
>> Without trying to use my capture card at all, every time I access the
>> other SATA disk in my system, the cx88 driver spits out a HORRENDOUS
>> number of weird messages, filling my system logs so fast that after
>> two days, I'd used over 6 GB just in the few logs that sysklogd
>> generates.
>
>Every time the sata controller generates an interrupt, the kernel calls
>the IRQ handler routines sharing that interrupt.  Your cx88 driver
>*always* thinks it has interrupts to service - but it actually doesn't.
>
>Note how many of the dumped registers are '0xffffffff' including the
>'irq aud' interrupt status register:
>
>> Nov 21 01:59:12 rainbird kernel: cx88[0]: irq aud [0xffffffff] dn_risci1* up_risci1* rds_dn_risc1* 3* dn_risci2* up_risci2* rds_dn_risc2* 7* dnf_of* u
>pf_uf* rds_dnf_uf* 11* dn_sync* up_sync* rds_dn_sync* 15* opc_err* par_err* rip_err* pci_abort* ber_irq* mchg_irq* 22* 23* 24* 25* 26* 27* 28* 29* 30* 3
>1*
>
>A 0xffffffff is likely not a real interrupt status, but a PCI bus read
>error, for which the PCI-PCI bridge or Host-PCI bridge returns the all
>ones value.  The interrupt handler sees every possible interrupt that it
>could be interested in as having occurred and likely tries to process
>them.  The further PCI MMIO accesses are also failing as evinced by all
>the 0xffffffff values being dumped.

This is a good point. Elsewhere I have seen exactly this kind of
all ones error within an IRQ when pulling a running cardbus device
from a system. 

The recommendation to remove the card and reseat it would appear
to be a sensible 1st step.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
