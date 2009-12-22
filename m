Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39237 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZLVQlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 11:41:11 -0500
Received: by ewy19 with SMTP id 19so5443018ewy.21
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2009 08:41:10 -0800 (PST)
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: linux-media@vger.kernel.org
Subject: Re: How to make a Zaapa LR301AP DVB-T card work
Date: Tue, 22 Dec 2009 16:41:04 +0000
References: <200912191400.37814.amlopezalonso@gmail.com> <200912201313.31384.amlopezalonso@gmail.com> <1261428671.3208.10.camel@pc07.localdom.local>
In-Reply-To: <1261428671.3208.10.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912221641.04526.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> Antonio,
> 
> the report for tda10046 firmware loading is missing. Was that OK?

Yes:

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

> 
> LR301 is a LifeView design. It is very common to see multiple other
> subvendors for their cards, but they keep the original subdevice ID.
> In this case 0x0301. The subvendor 0x4e42 is usually Typhoon/Anubis and
> they are distributing clones of almost all LifeView cards.
> 
> Gpio init is the same like on the other known LR301 cards and eeprom
> differs only for a few bytes, but not for tuner type, tuner and demod
> address.
> 
> http://ubuntuforums.org/archive/index.php/t-328140.html
> 
> Since this design with a saa7134 chip and tda8274 DVB-T only tuner is very
>  old, I don't expect an additional Low Noise Amplifier on it.
> 
> We can't detect such LNAs and on newer cards they can cause problems, if
> not configured correctly and might cause "scan" to fail.
> 
> If you mean above other card types did previously work for your card,
> use them and report.

No, I meant other "physical" cards. Just to ensure it is not likely to be an 
aerial problem.

> 
> Sorry, I don't have better ideas for your card so far.

I have not included the "tuner" parameter in the "options" line which I think 
it could be the problem. Is this parameter mandatory? If so, which is the 
proper one?

Cheers,
Antonio
