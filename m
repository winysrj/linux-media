Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JkSm7-00068p-3Q
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 01:35:20 +0200
Received: from mail-in-03-z2.arcor-online.net (mail-in-03-z2.arcor-online.net
	[151.189.8.15])
	by mail-in-12.arcor-online.net (Postfix) with ESMTP id 925914C2A1
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 01:35:15 +0200 (CEST)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mail-in-03-z2.arcor-online.net (Postfix) with ESMTP id 755592D3968
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 01:35:15 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-14.arcor-online.net (Postfix) with ESMTP id E6CBB187A6D
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 01:35:14 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200804112329.47476@orion.escape-edv.de>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200804102240.13933@orion.escape-edv.de>
	<1207870397.17744.12.camel@pc08.localdom.local>
	<200804112329.47476@orion.escape-edv.de>
Date: Sat, 12 Apr 2008 01:35:14 +0200
Message-Id: <1207956914.6271.60.camel@pc08.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT
	S-1401	Horizontal	transponder fails
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Freitag, den 11.04.2008, 23:29 +0200 schrieb Oliver Endriss:
> hermann pitton wrote:
> > Hi,
> > 
> > Am Donnerstag, den 10.04.2008, 22:40 +0200 schrieb Oliver Endriss:
> > > Hi,
> > > 
> > > Manu Abraham wrote:
> > > > Oliver Endriss wrote:
> > > > ...
> > > > > Ok, some calculations according your formula
> > > > > 
> > > > >>>>> BW = (1 + RO) * SR/2 + 5) * 1.3
> > > > > 
> > > > > 45 MSPS:
> > > > > BW = ((1 + 0.35) * 45/2 + 5) * 1.3 = 46
> > > > > 
> > > > > -> cutoff 36 MHz (maximum value supported)
> > > > > 
> > > > > 27 MSPS:
> > > > > BW = ((1 + 0.35) * 27/2 + 5) * 1.3 = 30,2
> > > > > 
> > > > > -> cutoff 31 MHz
> > > > > 
> > > > > 22 MSPS:
> > > > > BW = ((1 + 0.35) * 22/2 + 5) * 1.3 = 25,8
> > > > > 
> > > > > -> cutoff 26 MHz
> > > > > 
> > > > > Are these calculations correct, or did I miss something here?
> > > > 
> > > > 
> > > > It looks fine, just round it off to the next integer. ie always round it
> > > > up, rather than rounding it down. For the cutoff at 36MHz, it is fine as
> > > > well, since at the last step, you will not need an offset, since it
> > > > would be the last step in the spectrum.
> > > > ...
> > > > > Afaics a simple pre-calculated lookup table with 32 entries should do
> > > > > the job. At least for the cut-off frequency.
> > > > 
> > > > That's possible, since you need only 32 precomputed entries, rather than
> > > > continuous values. That would be much better too, without any runtime
> > > > overheads. Just the table needs to be done nice.
> > > 
> > > Now I found some time to come back to this issue,
> > > 
> > > I prepared a small patch to set the cutoff according to Manu's formula.
> > > The calculation is simple enough for integer arithmetic, so it is not
> > > worth to prepare a lookup-table.
> > > 
> > > @ldvb:
> > > Please test and report whether it works for you.
> > > 
> > > CU
> > > Oliver
> > > 
> > 
> > I'm not asked, but give you a report anyway.
> 
> ;-)
> 
> > On Hotbird 13.0E it makes no difference for me.
> 
> Are you saying that you did not have any problems without the patch,
> and is works with the patch, too?
> 
> I do not expect a big difference for common symbol rates like 22 MSPS
> or 27.5 MSPS, but it will probably make a difference for high or low
> symbol rates.
> 
> CU
> Oliver
> 

There is only one transponder slightly above 27.5 MSPS (29), IIRC.

With the current scan file, derived from lyngsat data, but likely still
not perfect, the first kaffeine scan under old conditions with current
weather, returned 1357 TV services and 505 radio services on 109
transponders.

With the patch applied last night, sorry I also have a neerd cold ;),
a first run returned 1323 TV services and 491 radio services.

A next scan came to 1355 for TV and 504 for radio.

Some more showed that it is about 15 more or less services on several
scans as average.

That lead me to that first conclusion for my conditions.

BTW, since Hartmut has a problem within his location to set up a dish
with sufficient reception, this was a problem here too, drop me a note
and I try to move the CTX948 to you. With Mauro I had a problem to get
something to him as normal parcel in Frankfurt, but then went well on
the last minute. To Hartmut one is lost as simple letter, not such a
clever idea, if it does not fit in the letter box, but should not happen
again.

Cheers,
Hermann











_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
