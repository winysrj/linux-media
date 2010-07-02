Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34269 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GBKAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 06:00:18 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OUd2d-0007Tf-Fd
	for linux-media@vger.kernel.org; Fri, 02 Jul 2010 12:00:15 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 02 Jul 2010 12:00:15 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 02 Jul 2010 12:00:15 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: TerraTec Cinergy Hybrid Stick [0ccd:00a5] - worth trying?
Date: Fri, 02 Jul 2010 12:00:04 +0200
Message-ID: <87vd8yw6e3.fsf@nemi.mork.no>
References: <20100702080501.188310@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Dirk Langner" <dirkolus@gmx.de> writes:

> I'm really pissed that whenever I try to find a TV-USB-stick (analog
> in my case), it's not in the shops any longer or it's not listed on
> the linuxtv validated sticks. The names of the USB sticks are only
> slightly changed, which may mean, this is only a rebranding or a
> completely new hardware (even without name change). Therefore is the
> support for these sticks kind of a lottery and one first have to buy
> them, check the USB id and whether it's supported or not. Seems, that
> the product cycles are too short for us linux-users :(
>
> Ok, genug gekotzt, now to the facts: I've purchased the USB-stick
> TerraTec Cinergy Hybrid Stick, although it's a little older (1/2 year)
> it is still in the shops.

Well, Terratec are more helpful than most vendors, so that might not be
a bad choice.  Did you see http://linux.terratec.de/ ?

I'm afraid your card isn't there, but...


> Vendor: TerraTec
> Model: Cinergy Hybrid Stick
> Vendor/Product ID: 0ccd:00a5
> Supports DVB-T and Analog Cable (tested already successful on Windows)

This card is supported by the tm6000 driver currently in staging:

bjorn@canardo:~$ grep 00A5 /usr/local/src/git/linux-2.6/drivers/staging/tm6000/*
/usr/local/src/git/linux-2.6/drivers/staging/tm6000/tm6000-cards.c:     { USB_DEVICE(0x0ccd, 0x00A5), .driver_info = TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },

You may want to try that.  I have no idea how well it works, if at all...


Bjørn

