Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62803 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762665AbZLLBmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 20:42:32 -0500
Received: by bwz27 with SMTP id 27so1018524bwz.21
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 17:42:38 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Sat, 12 Dec 2009 03:42:39 +0200
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
References: <200912120230.36902.liplianin@me.by> <1260579637.1826.4.camel@localhost>
In-Reply-To: <1260579637.1826.4.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912120342.40061.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 декабря 2009 03:00:37 Andy Walls wrote:
> On Sat, 2009-12-12 at 02:30 +0200, Igor M. Liplianin wrote:
> > On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> > > On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > > > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > > > Igor and Matthias,
> > > > > > > > >
> > > > > > > > > Please try the changes that I have for the TeVii S470 that
> > > > > > > > > are here:
> > > > > > > > >
> > > > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > >
> > > > First try, without pressing IR keys
> > > >
> > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > cx25840 3-0044: IRQ Status:  tsr
> > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > irq 16: nobody cared (try booting with the "irqpoll" option)
> > >
> > > please try again when you have time.
> > >
> > > 	# modprobe cx25840 debug=2 ir_debug=2
> > > 	# modprobe cx23885 debug=7
> >
> > dmesg is full of repeated lines:
> >
> > cx25840 3-0044: AV Core IRQ status (entry):
> > cx25840 3-0044: AV Core IRQ status (exit):
>
> A strange thing here is that under this condition my changes should
> never claim the AV Core interrupt is "handled".  I don't know why you
> didn't get the "nobody cared" message again.
I did, but not frequently. I thought it is obvious :)

cx23885[0]/0: pci_status: 0x083f4000  pci_mask: 0x08000001
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x20
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7383f3a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
cx25840 3-0044: AV Core IRQ status (entry):           
cx25840 3-0044: AV Core IRQ status (exit):           
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 2521, comm: syslogd Not tainted 2.6.32 #2
Call Trace:
 [<c1052db0>] ? __report_bad_irq+0x24/0x69
 [<c1052db7>] ? __report_bad_irq+0x2b/0x69
 [<c1052edc>] ? note_interrupt+0xe7/0x13f
 [<c1053416>] ? handle_fasteoi_irq+0x7a/0x97
 [<c1004411>] ? handle_irq+0x38/0x3f
 [<c1003bd1>] ? do_IRQ+0x38/0x89
 [<c1002ea9>] ? common_interrupt+0x29/0x30
handlers:
[<c13179ad>] (usb_hcd_irq+0x0/0x59)
[<f86275e7>] (azx_interrupt+0x0/0xe7 [snd_hda_intel])
[<f88a8d2b>] (cx23885_irq+0x0/0x4e1 [cx23885])
Disabling IRQ #16
cx23885[0]/0: pci_status: 0x083f4000  pci_mask: 0x08000001
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x20
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7383f3a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)

Igor

