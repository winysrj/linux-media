Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58148 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZKJRam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 12:30:42 -0500
Received: by ewy3 with SMTP id 3so263670ewy.37
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 09:30:47 -0800 (PST)
Date: Tue, 10 Nov 2009 18:30:44 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: tw68-v2/tw68-i2c.c:145: error: unknown field
 ???client_register??? specified in initializer
Message-ID: <20091110173044.GA7332@raptus.dandreoli.com>
References: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
 <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
 <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
 <b40acdb70911100450i4902900eu92c3529de9b5b9a0@mail.gmail.com>
 <921ad39e0911100516i6e930650m65b5e133d581f93e@mail.gmail.com>
 <921ad39e0911100548i6f115aduba39b3b7fc570f58@mail.gmail.com>
 <20091110150328.GA4514@raptus.dandreoli.com>
 <921ad39e0911100851m3ebd34et5c059838109f66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <921ad39e0911100851m3ebd34et5c059838109f66@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 10, 2009 at 04:51:47PM +0000, Roman Gaufman wrote:
> 2009/11/10 Domenico Andreoli <cavokz@gmail.com>:
> > On Tue, Nov 10, 2009 at 01:48:43PM +0000, Roman Gaufman wrote:
> >> I swapped my graphics card and techwell DVR card places and now it
> >> works, thanks you!!!
> >
> > have you a PCI-E techwell board?
> 
> Yep, it's PCI-E 8 audio/video dvr card.

there are a lot of cheap boards based on these chips on ebay

> > i'm taking the driver out of the freezer trying to get rid of
> > the IRQF_DISABLED warning flag. i'm interested in seeing your
> > /proc/interrupts, if possible, before and after the boards swap.
> 
> Both with the patch:
> 
> After the swap (working):
> 
>            CPU0       CPU1       CPU2       CPU3
>   0:         22          0          0         40   IO-APIC-edge      timer
>   1:          0          0          0          2   IO-APIC-edge      i8042
>   4:          0          0          0          2   IO-APIC-edge
>   8:          0          0          0          1   IO-APIC-edge      rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  16:          0          0          0     543773   IO-APIC-fasteoi   ahci, uhci_hcd:usb3, uhci_hcd:usb9, tw6804[0], tw6804[4]
>  17:          0          0          0      40297   IO-APIC-fasteoi   pata_jmicron, ohci1394, tw6804[1], tw6804[5]
>  18:          0          0          0      24680   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8, tw6804[2], tw6804[6]
>  19:          0          0      40184          0   IO-APIC-fasteoi   uhci_hcd:usb7, tw6804[3], tw6804[7]
>  21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  22:          0        218          0          0   IO-APIC-fasteoi   HDA Intel
>  23:          0          0          0        108   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
>  24:     934040          0          0          0  HPET_MSI-edge      hpet2
>  25:          0     390326          0          0  HPET_MSI-edge      hpet3
>  26:          0          0     590635          0  HPET_MSI-edge      hpet4
>  27:          0          0          0     845999  HPET_MSI-edge      hpet5
>  33:          0          0          0          0   PCI-MSI-edge      ahci
>  34:     812442          0          0          0   PCI-MSI-edge      eth1
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:         54         38         23          8   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> CNT:          0          0          0          0   Performance counter interrupts
> PND:          0          0          0          0   Performance pending work
> RES:       4027       5400       6102       6462   Rescheduling interrupts
> CAL:        124        139        137         44   Function call interrupts
> TLB:      27517      22022      23155      17498   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:         41         41         41         41   Machine check polls
> ERR:          0
> MIS:          0
> 
> Before swap (system freezes as soon as I try to open video device):
> 
> # cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         22          0          0          1   IO-APIC-edge      timer
>   1:          0          0          0          2   IO-APIC-edge      i8042
>   4:          0          0          0          2   IO-APIC-edge
>   8:          0          0          0          1   IO-APIC-edge      rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  16:          0          0          0       9090   IO-APIC-fasteoi   ahci, uhci_hcd:usb3, uhci_hcd:usb9, tw6804[0], tw6804[4]
>  17:          0          0          0          3   IO-APIC-fasteoi   pata_jmicron, ohci1394, tw6804[1], tw6804[5]
>  18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8, tw6804[2], tw6804[6]
>  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb7, tw6804[3], tw6804[7]
>  21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  22:          0        218          0          0   IO-APIC-fasteoi   HDA Intel
>  23:          0          0          0        103   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
>  24:       3102          0          0          0  HPET_MSI-edge      hpet2
>  25:          0       2403          0          0  HPET_MSI-edge      hpet3
>  26:          0          0       1899          0  HPET_MSI-edge      hpet4
>  27:          0          0          0       2835  HPET_MSI-edge      hpet5
>  33:          0          0          0          0   PCI-MSI-edge      ahci
>  34:        816          0          0          0   PCI-MSI-edge      eth1
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:         54         38         23          8   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> CNT:          0          0          0          0   Performance counter interrupts
> PND:          0          0          0          0   Performance pending work
> RES:          8          7          6          7   Rescheduling interrupts
> CAL:        118        130        129         46   Function call interrupts
> TLB:        970        879        706        739   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          2          2          2          2   Machine check polls
> ERR:          0
> MIS:          0

they are identical. where is the graphic controller here? i expected
to see it sharing an irq with some tw68 device, at least before the swap.

i forgot to say that simply removing the IRQF_DISABLED flag makes the
warning go away but may introduce some error with shared irq handling.

> >> Only 1 question, the readme says there is no audio yet - any ideas
> >> when/if audio will be available? :)
> >
> > bad news here, i can't promise anything. anyway i'd like to push this
> > driver to kernel staging and audio support is required for this step. so
> > it is one of my topmost TODO entries.
> 
> Heh, fair enough - thank you for working on this!

actually i did not write a line of code of this driver, it's all by
William Brack. i only have a different implementation never published.

regards,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
