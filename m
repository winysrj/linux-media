Return-path: <mchehab@gaivota>
Received: from fep20.mx.upcmail.net ([62.179.121.40]:56940 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0LUSph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 13:45:37 -0500
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep20-int.chello.at
          (InterMail vM.8.01.02.02 201-2260-120-106-20100312) with ESMTP
          id <20101221184535.CLFL1667.viefep20-int.chello.at@edge03.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Tue, 21 Dec 2010 19:45:35 +0100
Received: from pc13 (pc13 [10.1.1.13])
	by minerva12.dnsalias.com (8.13.8/8.13.8) with ESMTP id oBLIjVi4003965
	for <linux-media@vger.kernel.org>; Tue, 21 Dec 2010 19:45:31 +0100
From: "PC12 Ching" <ching@hispeed.ch>
To: <linux-media@vger.kernel.org>
References: <AANLkTim2oKhS_GLCf8sv1=6ia2GzbYV4Yh9KHnkTY6Pk@mail.gmail.com> <033c01cb9e0f$2f0efac0$8d2cf040$@ch> <D0728591-0878-42BA-BCD1-08FBFD362F6C@dinkum.org.uk>
In-Reply-To: <D0728591-0878-42BA-BCD1-08FBFD362F6C@dinkum.org.uk>
Subject: RE: DuoFlex CT PCIe
Date: Tue, 21 Dec 2010 19:45:36 +0100
Message-ID: <05c101cba13f$41861930$c4924b90$@ch>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-gb
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Thanks Andre for your reply. The Digital Devices DuoFlex CT is a DVB-C/T card. 
Looking at the Mystique CaBiX-C2 DVB-C Card, they do not look in similar.

Does anybody else have experience with the Digital Devices DuoFlex CT card ?

Cheers
Eckhard


> -----Original Message-----
> From: Andre [mailto:linux-media@dinkum.org.uk]
> Sent: 19 December 2010 11:29
> To: PC12 Ching
> Cc: linux-media@vger.kernel.org
> Subject: Re: DuoFlex CT PCIe
> 
> 
> On 17 Dec 2010, at 18:23, PC12 Ching wrote:
> 
> > Hello Bert
> >
> > I raised the same question two weeks ago, I only got an offline answer, see below.$
> > I hope to get some more replies too.
> >
> > ------------------------------------------------------------------------------
> > I wanted to know if the Digital Devices DuoFlex CT PCIe TWIN Combo DVB-C DVB-T card is supported.
> 
> I think this is related to the SatixS2 I have and uses the same driver, if so there is some support working,
> have a look at this thread:
> 
> http://www.spinics.net/lists/linux-media/msg25462.html
> 
> When I asked why the newer driver made 5 devices for a dual tuner the answer was because of support for the
> digital devices duoflex adaptors.
> 
> Andre
> 
> 
> > This card has 2 Ports, using one PCIe slot. Additionally it can be extended by 2 tuners to a total of 4
> tuners, still using only one
> > PCIe slot.
> > There is also a Octopus version who is able to run 8 tuners using only one PCIe slot.
> >
> > Is this card supported, is it performing well with 2/4 tuners ?
> > Will it be able to stream 4 HD channels at once via one PCIe slot ?
> 
> The Satix S2 is happy to record 6 HD channels across two tuners, there are some small glitches when the second
> tuner changes freq but it's minor. I don't have any more channels in my subscription to test 8 HD!
> 
> Andre=

