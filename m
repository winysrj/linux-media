Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35650 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZKDCvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 21:51:06 -0500
Subject: Re: cx18: YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
In-Reply-To: <de8cad4d0911030906i224145beg126c1069a163bd84@mail.gmail.com>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
	 <1257036094.3181.7.camel@palomino.walls.org>
	 <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
	 <1257079055.3061.19.camel@palomino.walls.org>
	 <de8cad4d0911011010g1bb3d595ge87e3b168ce41c32@mail.gmail.com>
	 <1257116354.3076.14.camel@palomino.walls.org>
	 <1257117359.3076.22.camel@palomino.walls.org>
	 <de8cad4d0911030906i224145beg126c1069a163bd84@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 21:52:25 -0500
Message-Id: <1257303145.5846.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-03 at 12:06 -0500, Brandon Jenkins wrote:
> On Sun, Nov 1, 2009 at 6:15 PM, Andy Walls <awalls@radix.net> wrote:
> > On Sun, 2009-11-01 at 17:59 -0500, Andy Walls wrote:
> >> On Sun, 2009-11-01 at 13:10 -0500, Brandon Jenkins wrote:
> >> > Hi Andy,
> >> >
> >> > The panic happens upon reboot and it is only 1 line of text oddly shifted.
> >> >
> >> > Kernel panic - not syncing: DMA: Memory would be corrupted
> >> >
> >> > If I switch back to the current v4l-dvb drivers no issue. To switch
> >> > back I have to boot from a USB drive.
> >>
> >> Brandon,
> >>
> >> Eww.  OK.  Nevermind performing any more data collection.  I'm going to
> >> use a new strategy (when I find the time).
> >
> > I forgot to mention that the panic you are running into is in the
> > Software IO Memory Managment Unit Translate Look-aside Buffer (SW IOMMU
> > TLB) in
> >
> >        linux/lib/swiotlb.c
> >
> > Your machine must not have a hardware IO MMU (and mine must).
> >
> > The software IOMMU is trying to allocate a bounce buffer for DMA and it
> > can't get one of the needed size (i.e. 607.5 kB) and the fallback static
> > buffer isn't big enough either (it is only 32 kB).  That's why the panic
> > happens.
> >
> > This certainly means that, in the general linux user case, very large
> > DMA buffers are bad.
> >
> > So now I know....
> >
> >
> > Regards,
> > Andy
> >
> >
> Hi Andy,
> 
> How would I know if I have/don't have a HW IO MMU and maybe isn't
> enabled correctly? 

There's no simple way AFAICT, except for believing that kernel couldn't
find one.

You'll have to research your motherboard's chipset and determine if the
chipset has one.  Chip vendors have IOMMU's as part of larger
specifications:

http://en.wikipedia.org/wiki/IOMMU


Linux has some detection code on startup for IOMMU's it knows about,
provided you've configured the IOMMU support in the kernel. Check your
kernel config I guess.

Also check your BIOS for anymention of an IOMMU there.

> Separately, I also have three cards running too.

3 times as many buffer allocations would exacerbate the ability to find
large contiguous memory buffers in PCI device DMA-able memory.

The CX23418 firmware is smart enough to use scatter gather type lists of
buffers (called MDLs by the firmware); I just need to fix the cx18
driver to use them as such.

Regards,
Andy

> Brandon


