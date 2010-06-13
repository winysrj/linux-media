Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48476 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753821Ab0FMPWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 11:22:48 -0400
Date: Sun, 13 Jun 2010 11:22:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: thomas.schorpp@gmail.com
cc: "C. Hemsing" <C.Hemsing@gmx.net>, <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>
Subject: Re: was: af9015, af9013 DVB-T problems. now: Intermittent USB
 disconnects with many (2.0) high speed devices
In-Reply-To: <4C14E971.5020604@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006131117530.23535-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Jun 2010, thomas schorpp wrote:

> Am 13.06.2010 15:57, schrieb Alan Stern:
> > On Sun, 13 Jun 2010, thomas schorpp wrote:
> >
> >> ehci-hcd is broken and halts silently or disconnects after hours or a few days, with the wlan usb adapter
> >
> > How do you know the bug is in ehci-hcd and not in the hardware?
> 
> All 3 usb devices and 2 different series VIA usb hosts and Hemsing's and many other broken i2c comms reporter's on linux-media are broken instead?

It's certainly possible and has been known to happen.

> Well, if we get that confirmed, I'll buy 2 of those with NEC chipset:
> http://cgi.ebay.de/ws/eBayISAPI.dll?ViewItem&item=190318779935
> 
> >
> >> I was able to catch a dmesg err message like "ehci...force halt... handshake failed" once only.
> >
> > Can you please post the error message?
> 
> Jun  3 08:38:29 tom3 kernel: [75071.004062] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 -> -110
> Jun  3 08:45:13 tom3 kernel: [75475.004061] ehci_hcd 0000:00:0e.2: force halt; handhake cc9c0814 0000c000 00000000 -> -110
> Previous debian testing version of Linux tom3 2.6.32-5-686 #1 SMP Tue Jun 1 04:59:47 UTC 2010 i686 GNU/Linux,
> not yet reproduced with current version.

You may need to copy the "broken periodic workaround" code from the
PCI_VENDOR_ID_INTEL case in ehci_pci_setup(),
drivers/usb/host/ehci-pci.c into the PCI_VENDOR_ID_VIA case.

Alan Stern

