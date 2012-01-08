Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52098 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2AHWYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 17:24:40 -0500
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Martin Herrman'" <martin.herrman@gmail.com>,
	<linux-media@vger.kernel.org>
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
In-Reply-To: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
Subject: RE: [DVB Digital Devices Cine CT V6] status support
Date: Sun, 8 Jan 2012 23:24:38 +0100
Message-ID: <01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Martin Herrman
> Sent: dimanche 8 janvier 2012 23:15
> To: linux-media@vger.kernel.org
> Subject: [DVB Digital Devices Cine CT V6] status support
> 
> Dear list-members,
> 
> I'm building a HTPC based on Linux and searching for an DVB-C tuner card
> that:
> - fits the mobo (only pci-e/usb available, not pci or firewire)
> - fits the case (antec fusion remote, big enough)
> - is supported by linux
> - is dual tuner
> - supports encrypted HD content
> - provides good quality
> 
> digital devices cine ct v6 seems to be a perfect solution, together with
> a softcam based on smargo cartreader.
> 
> http://shop.digital-
> devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Categori
> es/HDTV_Karten_fuer_Mediacenter/Cine_PCIe_Serie/DVBC_T
> 
> But.. is this card supported by the Linux kernel?
> 

The short answer is yes, and as far as I know, it's working fine with DVB-T
(I've never tested the DVB-C).
For support, you need to compile the drivers from Oliver Endriss as they are
not merged in mainstream kernel.

Check here (kernel > 2.6.31):
http://linuxtv.org/hg/~endriss/media_build_experimental/
Or here (kernel < 2.6.36) :
http://linuxtv.org/hg/~endriss/ngene-octopus-test/

> In 3.2.0-rc7 kernel I have found the driver for most of the digital
> devices cards, which includes the Cine S2 v6, but not the Cine CT v6.
> (I have also found some experimental drivers for CI moduels in the
> staging drivers section).
> 
> On the other hand, this discussion seems to indicate that drivers for
> Cine CT v6 should be working at this time:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg37183.html
> 
> Can you give me an update on the status of a possibly existing driver
> for Cine CT v6?
> 
> Much thanks in advance,
> 
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

