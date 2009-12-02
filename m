Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:36992 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734AbZLBA0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 19:26:10 -0500
Subject: Re: Compile error saa7134 - compro videomate S350
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>,
	Richard Smith <theras@gmail.com>
Cc: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
In-Reply-To: <234254.68438.qm@web110604.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>
	 <1259025174.5511.24.camel@pc07.localdom.local>
	 <990417.69725.qm@web110607.mail.gq1.yahoo.com>
	 <1259107698.2535.10.camel@localhost>
	 <623705.13034.qm@web110608.mail.gq1.yahoo.com>
	 <1259172867.3335.7.camel@pc07.localdom.local>
	 <214960.24182.qm@web110609.mail.gq1.yahoo.com>
	 <1259360050.6061.22.camel@pc07.localdom.local>
	 <8049.95935.qm@web110610.mail.gq1.yahoo.com>
	 <1259363687.6061.45.camel@pc07.localdom.local>
	 <721764.95451.qm@web110610.mail.gq1.yahoo.com>
	 <1259544565.4436.27.camel@pc07.localdom.local>
	 <234254.68438.qm@web110604.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 01:21:12 +0100
Message-Id: <1259713272.4001.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 30.11.2009, 14:35 -0800 schrieb Dominic Fernandes:
> Hi Hermann,
> 
> There is a sign of life coming from the card (I connected my SAT finder and got a loud tone from it).
> 
> > You might want to set dvb_powerdown_on_sleep=0 for dvb_core.
> 
> How do you specify this and which file (saa7134-dvb.c or saa7134-core.c or some other file)?

as said above, you set it for dvb_core.

> I tried Kaffeine, to scan Astra 19.2 but no luck, at first I can see the signal meters light up and then stop.  The output from dmesg at this point shows:
>  
> [   72.944834] DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
> [ 2183.208025] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)
> [ 2191.756534] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)
> [ 2195.908528] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)
> 
> 
> Not sure what this means.

Nothing good at all. Likely there is some breakage in the maths across devices/modules,
often caused by different xtals/oscillators not sufficiently covered
yet.

For sure enough to get you out of the game for now.

If Richard's card still works with latest v4l-dvb and his patch, likely
you have slightly different hardware covered by the same driver too,
including to hit a freq calculation bug exclusively.

Can't tell from your input. The eeproms of yours and Richard's card
differ in byte 0x74 and 0x75. Don't know what that means.

Cheers,
Hermann








