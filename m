Return-path: <mchehab@gaivota>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:60450 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab0LQRXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 12:23:48 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep14-int.chello.at
          (InterMail vM.8.01.02.02 201-2260-120-106-20100312) with ESMTP
          id <20101217172347.PIEF1458.viefep14-int.chello.at@edge04.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Fri, 17 Dec 2010 18:23:47 +0100
Received: from pc13 (pc13 [10.1.1.13])
	by minerva12.dnsalias.com (8.13.8/8.13.8) with ESMTP id oBHHNjRr029594
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 18:23:45 +0100
From: "PC12 Ching" <ching@hispeed.ch>
To: <linux-media@vger.kernel.org>
References: <AANLkTim2oKhS_GLCf8sv1=6ia2GzbYV4Yh9KHnkTY6Pk@mail.gmail.com>
In-Reply-To: <AANLkTim2oKhS_GLCf8sv1=6ia2GzbYV4Yh9KHnkTY6Pk@mail.gmail.com>
Subject: RE: DuoFlex CT PCIe
Date: Fri, 17 Dec 2010 18:23:55 +0100
Message-ID: <033c01cb9e0f$2f0efac0$8d2cf040$@ch>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-gb
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Bert

I raised the same question two weeks ago, I only got an offline answer, see below.$
I hope to get some more replies too.

------------------------------------------------------------------------------
I wanted to know if the Digital Devices DuoFlex CT PCIe TWIN Combo DVB-C DVB-T card is supported.
This card has 2 Ports, using one PCIe slot. Additionally it can be extended by 2 tuners to a total of 4 tuners, still using only one
PCIe slot.
There is also a Octopus version who is able to run 8 tuners using only one PCIe slot.

Is this card supported, is it performing well with 2/4 tuners ?
Will it be able to stream 4 HD channels at once via one PCIe slot ?

currently there is no support for it, might not sound too popular but we have USB based DVB-C tuners which can be used with PCIe
based USB extenders.
So far we tested 3 tuners on a Notebook with 1.3 ghz streaming the entire bouquet (each around 50 Mbit).
HDTV usually requires 15 Mbit
SDTV 4-8 Mbit.

So this is not only related to 4 HD channels but to the entire Bouquet (which could be up to 3 HD Streams for DVB-C).

Additionally those devices support Hardware PID filtering in order to lower the bandwidth, virtually any amount of devices can be
attached until the USB Bandwidth for one controller let's say 300-400 mbit is fully utilized.

The software is hotplug aware and well tested on x86, ARM, MIPS, PPC (some architectures support little/big endian).
The drivers are in userspace, although there's an opensource kernel acceleration module available which can lower the cpu usage
(this one only has around 500 lines of clean written code which is also very stable, it's mostly used with low powered embedded
devices).

If you have any further question about this just let me know.

This mail is not intended to be on the mailinglist since it's slightly offtopic of your initial mail request.

Best Regards,
xxxxxxxx

I hope to get some replies from people using this card.

Thanks
Eckhard


http://shop.digital-devices.de/epages/62357162.sf/de_DE/?ObjectPath=/Shops/62357162/Categories/8
http://shop.digital-devices.de/epages/62357162.sf/de_DE/?ObjectPath=/Shops/62357162/Products/091005
http://shop.digital-devices.de/epages/62357162.sf/de_DE/?ObjectPath=/Shops/62357162/Products/091007
http://shop.digital-devices.de/epages/62357162.sf/de_DE/?ObjectPath=/Shops/62357162/Products/092014

------------------------------------------------------------------------------
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bert Haverkamp
> Sent: 17 December 2010 16:22
> To: linux-media@vger.kernel.org
> Subject: DuoFlex CT PCIe
> 
> Dear all,
> 
> I recently found the DuoFlex CT PCIe TV-card. Finally a dual tuner
> DVB-C card. However, thusfar I haven't found any reference to a linux
> driver for this device. Is anyone working on this? Or do you know what
> is blocking it.
> 
> Regards,
> 
> Bert Haverkamp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

