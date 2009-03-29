Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:34843 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZC2SRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 14:17:15 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id C219077FC4E
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 20:17:08 +0200 (CEST)
From: Olivier MENUEL <omenuel@laposte.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: AverMedia Volar Black HD (A850)
Date: Sun, 29 Mar 2009 20:15:49 +0200
Cc: Laurent Haond <lhaond@bearstech.com>, linux-media@vger.kernel.org
References: <200903291334.00879.olivier.menuel@free.fr> <200903291919.54610.omenuel@laposte.net> <49CFB126.7000006@iki.fi>
In-Reply-To: <49CFB126.7000006@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903292015.49152.omenuel@laposte.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


ok
Thanks

Let me know if I can help you in anyway

Antti Palosaari wrote :
> 
> Olivier MENUEL wrote:
> > 
> > Antti Palosaari wrote:
> >> Could you take longer sniff. Probably 2 sniffs.
> >> 1) successful tune to channel using 1st tuner
> >> 2) successful tune to channel using 2nd tuner
> >>
> >> One sec is enough, log increases very fast when streaming picture....
> > 
> > I'm not sure what the 2nd tuner is.
> > This is a quite cheap DVB-T card.
> > They don't say anything special on the box except that you can watch HDTV with it.
> > So, I'm guessing the 2nd tuner would be for HD channels ?
> 
> ah shit, there is not even 2nd tuner! This device eeprom is totally crap 
> and useless, you cannot trust any values it does contain :(
> Eeprom says:
> 1) there is 2 tuners
> * bullshit there is only one
> 2) 0x38 is 2nd fe i2c addr
> * 0x38 is reserved for 1st FE and cannot be even changed.
> 3) xtal is 28000
> * not sure yet
> 4) tuner is MXL5005
> * could be
> 5) used IF is 36125
> * I doubt that no, for Maxlinear tuner other IF is typically used
> 
> totally wrongly configured device, designers must be weenies :(
> 
> > Or is there a radio tuner in it ? There's nothing about it on the box, but there is a radio switch in the averTV software. But I can't find any channel when scanning for radio channels ...
> > So, I guess it does not handle radio ...
> > 
> > Anyway, I don't need HDTV nor radio. Normal TV is enough for me.
> > Only special thing I can see on the box is that there is blue light on the device when the signal is detected (maybe you'll see weird stuff in the sniff because of that...). But I don't care about that light either.
> > 
> > I sniffed a regular TV channel and a HD channel (I truncated the end of the log as they were too big to send by emails). You'll find them in attachments.
> > 
> >> I did look your sniffs and immediately found some bad values :( There is 
> >> byte in eeprom which tells 2nd demodulator i2c address, and guess what 
> >> there was - i2c address of 1st integrated af9015 demodulator :( There 
> >> should be 38 as i2c addr of 1st demod and 3a as 2nd demod.
> > 
> > you're impressive ;)
> > But I don't know much about these. Is it hard to fix ? Is it something to change in the af9015 driver ? Or does it need a completely different driver ?
> > Or is it in the firmware ?
> > If you can tell me where these addresses are I can try to change them and retest
> 
> This device have bad eeprom and thus all configuration values are needed 
> to discover from elsewhere. I will continue...
> 
> regards
> Antti
