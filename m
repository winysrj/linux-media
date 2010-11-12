Return-path: <mchehab@pedra>
Received: from 200-232-120-2.rf.com.br ([200.232.120.2]:53335 "EHLO rf.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0KLNb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 08:31:27 -0500
Received: from rf.com.br (yankee.rf.com.br [127.0.0.1])
	by rf.com.br (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id oACDVN6R008601
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 11:31:23 -0200
From: "Joao S Veiga" <jsveiga@rf.com.br>
To: linux-media@vger.kernel.org
Subject: Re: DVB-S/S2 Card for a linux-based dish pointer
Date: Fri, 12 Nov 2010 11:31:23 -0200
Message-Id: <20101112093829.M32985@rf.com.br>
In-Reply-To: <AANLkTikUAbiv52vt0eGDn8akHBPMf=CQwBpy-=jrL0yh@mail.gmail.com>
References: <20101111175421.M41484@rf.com.br> <AANLkTikUAbiv52vt0eGDn8akHBPMf=CQwBpy-=jrL0yh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thank you Jason,

I had stumbled on the TBS website while looking for receiver cards, but had not considered them because I was looking
for something supported by the mainstream kernel.

We expect a low volume for the positioner controllers (at least in the beginning), so we want to use as much
off-the-shelf (COTS) parts as possible to reduce sw&hw development to a minimum. Also, I believe that if we use only
what is supported by the mainstream kernel, we would not be tied to a single dvb card model/supplier/version/special driver.

Can the linux dvb support be used in the situation I mentioned?
(- no X running
- send tuning/cps/etc configuration/commands via command line
- get signal strength (dBm?) and quality (BER?), signal lock, and other sat info via command line or api or somewhere in
/proc/ for example)

Best regards,

Joao S Veiga




---------- Original Message -----------
 From: jason duhamell 

> You guys will want to contact http://tbsdtv.com/ for help. I my self make embedded electronics. right now out of arm
and mips based soc's if you want to cut out intel. tbs is an oem that makes the cards that other companies buy. they
also make their own linux drivers. 
> 
> On Fri, Nov 12, 2010 at 2:34 AM, Joao S Veiga  wrote:
>  Hello guys,
> 
> We're developing an automatic satellite dish pointer controller (for Satellite News Gathering vehicles and other
> applications), and it will be based on a mini-itx Atom motherboard running debian.
>

