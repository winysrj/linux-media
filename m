Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47074 "HELO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758056AbZLMBN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 20:13:29 -0500
Received: by bwz27 with SMTP id 27so1356199bwz.21
        for <linux-media@vger.kernel.org>; Sat, 12 Dec 2009 17:13:26 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Sat, 12 Dec 2009 18:01:01 +0200
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
References: <200912120230.36902.liplianin@me.by> <200912121349.58436.liplianin@me.by> <1260627327.3104.13.camel@palomino.walls.org>
In-Reply-To: <1260627327.3104.13.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912121801.02203.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 декабря 2009 16:15:27 Andy Walls wrote:
> On Sat, 2009-12-12 at 13:49 +0200, Igor M. Liplianin wrote:
> > On 12 декабря 2009 04:58:48 Andy Walls wrote:
> > > On Sat, 2009-12-12 at 03:42 +0200, Igor M. Liplianin wrote:
> > > > On 12 декабря 2009 03:00:37 Andy Walls wrote:
> > > > > On Sat, 2009-12-12 at 02:30 +0200, Igor M. Liplianin wrote:
> > > > > > On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> > > > > > > On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > > > > > > > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > > > > > > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > > > > > > > Igor and Matthias,
> > > > > > > > > > > > >
> > > > > > > > > > > > > Please try the changes that I have for the TeVii
> > > > > > > > > > > > > S470 that are here:
> > > > > > > > > > > > >
> > > > > > > > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > >
> > > I have checked in more changes, please try when you get the chance.
> >
> > cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
> > cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> > cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> > cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count:
> > 0x47381f2a cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> >
> > cx25840 3-0044: AV Core IRQ status (entry): ir
> > cx25840 3-0044: IRQ Status:  tsr
> > cx25840 3-0044: IRQ Enables:     rse rte roe
>
> ?!
>
> Those three lines make no sense together.  Maybe I should take out the
I know. But it is.
There would be something small, but important, which is missing.


> V4L2_SUBDEV_IO_PIN_ACTIVE_LOW setting in cx23885-cards.c.
Low level raises interrupt by default, as I understand.
But it is configurable.


>
> I'm going to have to buy some hardware and experiment for myself.
I can test your code forever ... Until it success


>
>
> BTW, what happens you press a button on an NEC remote?
Nothing.
But remote is working under m$

>
> Thanks for all your help.
>
> Regards,
> Andy

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
