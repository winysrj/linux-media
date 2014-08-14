Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbaHNKKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 06:10:21 -0400
Message-ID: <53EC8B07.1000709@redhat.com>
Date: Thu, 14 Aug 2014 12:10:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: USB list <linux-usb@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
References: <53DCE329.4030106@xs4all.nl> <2923628.39nbDsJU79@avalon> <53E391E3.2050808@xs4all.nl> <53EA2DA2.4060605@redhat.com> <53EA32BC.10100@xs4all.nl>
In-Reply-To: <53EA32BC.10100@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/12/2014 05:29 PM, Udo van den Heuvel wrote:
> On 2014-08-12 17:07, Hans de Goede wrote:
>> lspci -nn
> 
> # lspci -nn
> 00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Root Complex [1022:1410]
> 00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Family 15h
> (Models 10h-1fh) I/O Memory Management Unit [1022:1419]
> 00:01.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
> [AMD/ATI] Trinity [Radeon HD 7660D] [1002:9901]
> 00:01.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
> Trinity HDMI Audio Controller [1002:9902]
> 00:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 15h
> (Models 10h-1fh) Processor Root Port [1022:1414]
> 00:07.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 15h
> (Models 10h-1fh) Processor Root Port [1022:1417]
> 00:10.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB XHCI Controller [1022:7812] (rev 03)
> 00:10.1 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB XHCI Controller [1022:7812] (rev 03)
> 00:11.0 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH
> SATA Controller [AHCI mode] [1022:7801] (rev 40)
> 00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB OHCI Controller [1022:7807] (rev 11)
> 00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB EHCI Controller [1022:7808] (rev 11)
> 00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB OHCI Controller [1022:7807] (rev 11)
> 00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB EHCI Controller [1022:7808] (rev 11)
> 00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus
> Controller [1022:780b] (rev 14)
> 00:14.2 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] FCH
> Azalia Controller [1022:780d] (rev 01)
> 00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC
> Bridge [1022:780e] (rev 11)
> 00:14.4 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] FCH PCI
> Bridge [1022:780f] (rev 40)
> 00:14.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH
> USB OHCI Controller [1022:7809] (rev 11)
> 00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 0 [1022:1400]
> 00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 1 [1022:1401]
> 00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 2 [1022:1402]
> 00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 3 [1022:1403]
> 00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 4 [1022:1404]
> 00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family
> 15h (Models 10h-1fh) Processor Function 5 [1022:1405]
> 01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
> (rev 06)
> 02:00.0 USB controller [0c03]: Etron Technology, Inc. EJ168 USB 3.0 Host
> Controller [1b6f:7023] (rev 01)
> 03:06.0 Serial controller [0700]: MosChip Semiconductor Technology Ltd.
> PCI 9835 Multi-I/O Controller [9710:9835] (rev 01)

Hmm, so you've both an amd xhci and an etron xhci chip. Do you know to
which xhci the port you're trying to use belongs ? And can you try
with a different usb-3 port ?

I've access to an Etron EJ168 controller, since I specifically bought
one to try and deal with the fact that there quality is, erm, somewhat
lacking. So if this is with the Etron controller I can try to reproduce.

Note I'm about to drop of the internet as I'm going on vacation, I'll be
back Mon 25 Aug.

Regards,

Hans
