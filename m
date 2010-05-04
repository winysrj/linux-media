Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailhost-y8-p4.internext.fr ([195.5.209.113]:53883 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932273Ab0EDOzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 10:55:09 -0400
Received: from maiev.nerim.net (smtp-116-tuesday.nerim.net [62.4.16.116])
	by smtp-delay1.nerim.net (Postfix) with ESMTP id B6912B4EE17
	for <linux-media@vger.kernel.org>; Tue,  4 May 2010 16:48:42 +0200 (CEST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [linux-dvb] pci_abort errors with Hauppauge WinTV Nova-HD-S2 
Date: Tue, 4 May 2010 16:48:18 +0200
Message-ID: <91E6C7608D34E145A3D9634F0ED7163E81D4CC@venus.logiways-france.fr>
From: "Thierry LELEGARD" <tlelegard@logiways.com>
To: <linux-dvb@linuxtv.org>, <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently added a Hauppauge WinTV Nova-HD-S2 into a Linux system.
I experience frequent packet loss and pci_abort errors.

Each time my application detects packet loss (continuity errors
actually),
I get the following messages in dmesg:

cx88[0]: irq mpeg  [0x80000] pci_abort*
cx88[0]/2-mpeg: general errors: 0x00080000

Such problems occur every few seconds.

I use firmware file dvb-fe-cx24116.fw version 1.26.90.0.

Since the IRQ was shared with the nVidia card and a Dektec modulator,
I swapped some PCI boards. The IRQ is still shared but with another
tuner
I do not use when using the S2 tuner. After swapping the PCI boards,
the errors occur less frequently but still happen.

Assuming that the pci_abort was due to an interrupted DMA transfer, I
tried to increase the PCI latency timer of the device to 248 but this
did not change anything (setpci -s 05:05 latency_timer=f8).

I use the tuner with a custom application which reads the complete
transport
stream. This application had worked for years using DVB-T and DVB-S
tuners.
I tried to reduce the application read buffer input size and it did not
change anything at all.

Note that my application still uses the V3 API, not the S2API. But,
using
DVB-S transponders, it works (except the pci_abort errors).

I disabled the serial port, the parallel port and the PS/2 ports in the
BIOS.
It did not change anything either.

Does anyone have an idea, please?
Thanks a lot in advance for any help.
-Thierry

PS: some additional information:

# lspci -v -s 05:05
05:05.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 248, IRQ 17
        Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx8800
        Kernel modules: cx8800

05:05.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 248, IRQ 17
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

05:05.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 248, IRQ 17
        Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802

05:05.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI
Video and Audio Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Flags: bus master, medium devsel, latency 248, IRQ 10
        Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

# cat /proc/interrupts
            CPU0       CPU1
   0:        296          4   IO-APIC-edge      timer
   1:          1          2   IO-APIC-edge      i8042
   8:          1          0   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  16:        279     122104   IO-APIC-fasteoi   uhci_hcd:usb4,
uhci_hcd:usb10, HDA Intel, Dta1xx, nvidia
  17:       1863     507353   IO-APIC-fasteoi   uhci_hcd:usb5,
uhci_hcd:usb8, uhci_hcd:usb11, cx88[0], cx88[0], cx88[0]
  18:     130224       8533   IO-APIC-fasteoi   ehci_hcd:usb3,
uhci_hcd:usb9
  22:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb6
  23:     170156        246   IO-APIC-fasteoi   ehci_hcd:usb2,
uhci_hcd:usb7
  28:      57235       4517   PCI-MSI-edge      ahci
  29:         69      15965   PCI-MSI-edge      eth0
 NMI:          0          0   Non-maskable interrupts
 LOC:    2529023    2281329   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 PND:          0          0   Performance pending work
 RES:      42023      29529   Rescheduling interrupts
 CAL:        123        994   Function call interrupts
 TLB:     150508     136321   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:         16         16   Machine check polls
 ERR:          1
 MIS:          0

