Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751750AbZIEWFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 18:05:12 -0400
Date: Sun, 6 Sep 2009 00:05:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
In-Reply-To: <200909052317.24048.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909052358080.4670@axis700.grange>
References: <200908031031.00676.marek.vasut@gmail.com>
 <200909051149.56343.marek.vasut@gmail.com> <Pine.LNX.4.64.0909052219030.4670@axis700.grange>
 <200909052317.24048.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 5 Sep 2009, Marek Vasut wrote:

> Dne So 5. září 2009 22:19:42 Guennadi Liakhovetski napsal(a):
> > On Sat, 5 Sep 2009, Marek Vasut wrote:
> > > Dne So 5. září 2009 10:55:55 Guennadi Liakhovetski napsal(a):
> > > >
> > > > Marek, please, look in PXA270 datasheet. To support a specific pixel
> > > > format means, e.g., to be able to process it further, according to this
> > > > format's particular colour component ordering. Process further can mean
> > > > convert to another format, extract various information from the data
> > > > (statistics, etc.)... Now RGB555 looks like (from wikipedia)
> > > >
> > > > 15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
> > > > R4  R3  R2  R1  R0  G4  G3  G2  G1  G1  B4  B3  B2  B1  B1  --
> > > >
> > > > (Actually, I thought bit 15 was unused, but it doesn't matter for this
> > > > discussion.) Now, imagine what happens if you swap the two bytes. I
> > > > don't think the PXA will still be able to meaningfully process that
> > > > format.
> > >
> > > Not on the pxa side, but on the camera side -- Bs and Rs swapped in the
> > > diagram above.
> >
> > And then? Are you trying to tell me, that the PXA then swaps them back?...
> 
> No, the software has to do it then, I'm trying to tell you that it has nothing 
> to do with PXA (as PXA really doesnt care if the channel is actually blue or 
> red).

Of course it does. I asked you to swap the above two bytes, you would get 
this:

15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
G1  G0  B4  B3  B2  B1  B0  --  R4  R3  R2  R1  R0  G4  G3  G2  

and PXA would still inerpret this as 

R4  R3  R2  R1  R0  G4  G3  G2  G1  G0  B4  B3  B2  B1  B0  --

i.e., it would take bits

R2 R1 R0 G4 G3

for blue, bits

B1 B0 -- R4 R3

for green, and bits

G1 G0 B4 B3 B2

as red. Which, as you see, makes no sense. That's why I'm saying, that it 
doesn't support this format, and we can only pass it through as raw data.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
