Return-path: <mchehab@gaivota>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:57174 "EHLO
	bordeaux.papayaltd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0LSK3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 05:29:07 -0500
Subject: Re: DuoFlex CT PCIe
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andre <linux-media@dinkum.org.uk>
In-Reply-To: <033c01cb9e0f$2f0efac0$8d2cf040$@ch>
Date: Sun, 19 Dec 2010 11:29:02 +0100
Cc: <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D0728591-0878-42BA-BCD1-08FBFD362F6C@dinkum.org.uk>
References: <AANLkTim2oKhS_GLCf8sv1=6ia2GzbYV4Yh9KHnkTY6Pk@mail.gmail.com> <033c01cb9e0f$2f0efac0$8d2cf040$@ch>
To: PC12 Ching <ching@hispeed.ch>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 17 Dec 2010, at 18:23, PC12 Ching wrote:

> Hello Bert
> 
> I raised the same question two weeks ago, I only got an offline answer, see below.$
> I hope to get some more replies too.
> 
> ------------------------------------------------------------------------------
> I wanted to know if the Digital Devices DuoFlex CT PCIe TWIN Combo DVB-C DVB-T card is supported.

I think this is related to the SatixS2 I have and uses the same driver, if so there is some support working, have a look at this thread:

http://www.spinics.net/lists/linux-media/msg25462.html

When I asked why the newer driver made 5 devices for a dual tuner the answer was because of support for the digital devices duoflex adaptors.

Andre


> This card has 2 Ports, using one PCIe slot. Additionally it can be extended by 2 tuners to a total of 4 tuners, still using only one
> PCIe slot.
> There is also a Octopus version who is able to run 8 tuners using only one PCIe slot.
> 
> Is this card supported, is it performing well with 2/4 tuners ?
> Will it be able to stream 4 HD channels at once via one PCIe slot ?

The Satix S2 is happy to record 6 HD channels across two tuners, there are some small glitches when the second tuner changes freq but it's minor. I don't have any more channels in my subscription to test 8 HD!

Andre