Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58891 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZLLLtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 06:49:53 -0500
Received: by bwz27 with SMTP id 27so1136192bwz.21
        for <linux-media@vger.kernel.org>; Sat, 12 Dec 2009 03:49:58 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Sat, 12 Dec 2009 13:49:58 +0200
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
References: <200912120230.36902.liplianin@me.by> <200912120342.40061.liplianin@me.by> <1260586728.1826.11.camel@localhost>
In-Reply-To: <1260586728.1826.11.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912121349.58436.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 декабря 2009 04:58:48 Andy Walls wrote:
> On Sat, 2009-12-12 at 03:42 +0200, Igor M. Liplianin wrote:
> > On 12 декабря 2009 03:00:37 Andy Walls wrote:
> > > On Sat, 2009-12-12 at 02:30 +0200, Igor M. Liplianin wrote:
> > > > On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> > > > > On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > > > > > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > > > > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > > > > > Igor and Matthias,
> > > > > > > > > > >
> > > > > > > > > > > Please try the changes that I have for the TeVii S470
> > > > > > > > > > > that are here:
> > > > > > > > > > >
> > > > > > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > > > >
> > > > > > First try, without pressing IR keys
> > > > > >
> > > > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > > > cx25840 3-0044: IRQ Status:  tsr
> > > > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > > > irq 16: nobody cared (try booting with the "irqpoll" option)
> > > > >
> > > > > please try again when you have time.
> > > > >
> > > > > 	# modprobe cx25840 debug=2 ir_debug=2
> > > > > 	# modprobe cx23885 debug=7
> > > >
> > > > dmesg is full of repeated lines:
> > > >
> > > > cx25840 3-0044: AV Core IRQ status (entry):
> > > > cx25840 3-0044: AV Core IRQ status (exit):
> > >
> > > A strange thing here is that under this condition my changes should
> > > never claim the AV Core interrupt is "handled".  I don't know why you
> > > didn't get the "nobody cared" message again.
> >
> > I did, but not frequently. I thought it is obvious :)
>
> OK, that's better. :P
>
> I have checked in more changes, please try when you get the chance.
>
> Please be aware that I reconfigured the drive of one signal PAD in the
> AV Core - I'm hoping to stop false interrupts.  I did not reconfigure
> the corresponding IO pin in the bridge driver - I left it at whatever
> was the default.

cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0x47381f2a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr                    
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: AV Core audio IRQ status: 0x80
cx25840 3-0044: AV Core audio MC IRQ status: 0x20000000
cx25840 3-0044: AV Core video IRQ status: 0x0002
cx25840 3-0044: AV Core IRQ status (exit): ir        
cx23885[0]/0: pci_status: 0x08004000  pci_mask: 0x08000000
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0x47381f2a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr                    
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: AV Core audio IRQ status: 0x80
cx25840 3-0044: AV Core audio MC IRQ status: 0x20000000
cx25840 3-0044: AV Core video IRQ status: 0x0002
cx25840 3-0044: AV Core IRQ status (exit): ir        
cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0x47381f2a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr                    
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: AV Core audio IRQ status: 0x80
cx25840 3-0044: AV Core audio MC IRQ status: 0x20000000
cx25840 3-0044: AV Core video IRQ status: 0x0123
cx25840 3-0044: AV Core IRQ status (exit): ir        
cx23885[0]/0: pci_status: 0x08004000  pci_mask: 0x08000000
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0x47381f2a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
cx25840 3-0044: AV Core IRQ status (entry): ir        

>
>
> (I think I'm going to have to buy a CX23885 based card soon...)
>
> Regards,
> Andy

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
