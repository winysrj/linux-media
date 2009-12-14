Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59461 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZLNH1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 02:27:41 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9359594014A
	for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 08:27:35 +0100 (CET)
Received: from [192.168.15.210] (napalm.rochet.org [81.57.142.20])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 71DEA940152
	for <linux-media@vger.kernel.org>; Mon, 14 Dec 2009 08:27:33 +0100 (CET)
Subject: Re: New ASUS P3-100 DVB-T/DVB-S device (1043:48cd)
From: dvblinux <dvblinux@free.fr>
To: linux-media@vger.kernel.org
In-Reply-To: <1260754580.3275.20.camel@pc07.localdom.local>
References: <200912111456.45947.amlopezalonso@gmail.com>
	 <1260543775.4b225f1f4cec9@imp.free.fr>
	 <1260754580.3275.20.camel@pc07.localdom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 08:26:52 +0100
Message-Id: <1260775612.2294.11.camel@hercules.rochet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The complete name of the board is:

"ASUS My Cinema PS3-100/PTS/FM/AV/RC" ouch :-)

You're right:

It features the same features than the "ASUS My Cinema P7131 Hybrid"
that is: S-Video in, Composite and audio in with a special splitter
cord, an FM tuner and IR remote control. All connectors are the same for
both cards, but the additionnal DVB-S.

The remote control seems to behave exactely the same as P7131, i.e new
entries in /dev/input/ as a regular keyboard.

I'll post additionnal stuff later, thanks for your answer.

Regards.


Le lundi 14 décembre 2009 à 02:36 +0100, hermann pitton a écrit :
> Hi,
> 
> sorry for delay, no time for the list during the last days.
> 
> Am Freitag, den 11.12.2009, 16:02 +0100 schrieb dvblinux@free.fr:
> > Hi all, I'm new on this list.
> > 
> > I modified on my own the SAA driver to manage an ASUS PS3-100 combo card not
> > supported yet in current version.
> > 
> > It features two DVB-S and DVB-T receivers packed on the same PCI card.
> 
> I'm not aware of such an Asus PCI card with two DVB-S and DVB-T
> receivers. We might hang in wording ...
> 
> Maybe one DVB-S, one DVB-T/analog hybrid tuner/demod and also support
> for analog radio and external S-Video/Composite and analog audio in?
> 
> > The DVB-T part is identical to ASUS P7131 Hybrid and therefore is managed thru
> > the existing driver after a light patch in the driver source (and card.c):
> > copying relevant stuff from (1043:4876) to (1043:48cd).
> > 
> > I'm not a developper, how to share my successfull experiments ?
> 
> We have support for the Asus Tiger 3in1 since last summer.
> This board was OEM only and also does not come with a remote, but your
> stuff is very likely based on that one.
> 
> Please try all functions and inputs and post related "dmesg" output
> loading the saa7134 driver with "card=147 i2c_scan=1".
> 
> It has the same LNA config like the ASUS P7131 Hybrid LNA too.
> 
> I can't tell anything about a possible remote, but last on Asus was a
> transmitter labeled PC-39 that far and that one we do support.
> 
> Cheers,
> Hermann
> 
> 
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


