Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:42360 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbZLNBoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 20:44:54 -0500
Subject: Re: New ASUS P3-100 DVB-T/DVB-S device (1043:48cd)
From: hermann pitton <hermann-pitton@arcor.de>
To: dvblinux@free.fr
Cc: linux-media@vger.kernel.org
In-Reply-To: <1260543775.4b225f1f4cec9@imp.free.fr>
References: <200912111456.45947.amlopezalonso@gmail.com>
	 <1260543775.4b225f1f4cec9@imp.free.fr>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 02:36:20 +0100
Message-Id: <1260754580.3275.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sorry for delay, no time for the list during the last days.

Am Freitag, den 11.12.2009, 16:02 +0100 schrieb dvblinux@free.fr:
> Hi all, I'm new on this list.
> 
> I modified on my own the SAA driver to manage an ASUS PS3-100 combo card not
> supported yet in current version.
> 
> It features two DVB-S and DVB-T receivers packed on the same PCI card.

I'm not aware of such an Asus PCI card with two DVB-S and DVB-T
receivers. We might hang in wording ...

Maybe one DVB-S, one DVB-T/analog hybrid tuner/demod and also support
for analog radio and external S-Video/Composite and analog audio in?

> The DVB-T part is identical to ASUS P7131 Hybrid and therefore is managed thru
> the existing driver after a light patch in the driver source (and card.c):
> copying relevant stuff from (1043:4876) to (1043:48cd).
> 
> I'm not a developper, how to share my successfull experiments ?

We have support for the Asus Tiger 3in1 since last summer.
This board was OEM only and also does not come with a remote, but your
stuff is very likely based on that one.

Please try all functions and inputs and post related "dmesg" output
loading the saa7134 driver with "card=147 i2c_scan=1".

It has the same LNA config like the ASUS P7131 Hybrid LNA too.

I can't tell anything about a possible remote, but last on Asus was a
transmitter labeled PC-39 that far and that one we do support.

Cheers,
Hermann








