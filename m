Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jk9Z9-0002c7-Nj
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 05:04:45 +0200
Received: from mail-in-13-z2.arcor-online.net (mail-in-13-z2.arcor-online.net
	[151.189.8.30])
	by mail-in-05.arcor-online.net (Postfix) with ESMTP id 33BE727ACA9
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 05:04:36 +0200 (CEST)
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mail-in-13-z2.arcor-online.net (Postfix) with ESMTP id 8AFB2209518
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 03:35:08 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-08.arcor-online.net (Postfix) with ESMTP id BD3A02C29E7
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 01:33:19 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200804102240.13933@orion.escape-edv.de>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803220711.07186@orion.escape-edv.de> <47E53E1B.5050302@gmail.com>
	<200804102240.13933@orion.escape-edv.de>
Date: Fri, 11 Apr 2008 01:33:17 +0200
Message-Id: <1207870397.17744.12.camel@pc08.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401
	Horizontal	transponder fails
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

Am Donnerstag, den 10.04.2008, 22:40 +0200 schrieb Oliver Endriss:
> Hi,
> 
> Manu Abraham wrote:
> > Oliver Endriss wrote:
> > ...
> > > Ok, some calculations according your formula
> > > 
> > >>>>> BW = (1 + RO) * SR/2 + 5) * 1.3
> > > 
> > > 45 MSPS:
> > > BW = ((1 + 0.35) * 45/2 + 5) * 1.3 = 46
> > > 
> > > -> cutoff 36 MHz (maximum value supported)
> > > 
> > > 27 MSPS:
> > > BW = ((1 + 0.35) * 27/2 + 5) * 1.3 = 30,2
> > > 
> > > -> cutoff 31 MHz
> > > 
> > > 22 MSPS:
> > > BW = ((1 + 0.35) * 22/2 + 5) * 1.3 = 25,8
> > > 
> > > -> cutoff 26 MHz
> > > 
> > > Are these calculations correct, or did I miss something here?
> > 
> > 
> > It looks fine, just round it off to the next integer. ie always round it
> > up, rather than rounding it down. For the cutoff at 36MHz, it is fine as
> > well, since at the last step, you will not need an offset, since it
> > would be the last step in the spectrum.
> > ...
> > > Afaics a simple pre-calculated lookup table with 32 entries should do
> > > the job. At least for the cut-off frequency.
> > 
> > That's possible, since you need only 32 precomputed entries, rather than
> > continuous values. That would be much better too, without any runtime
> > overheads. Just the table needs to be done nice.
> 
> Now I found some time to come back to this issue,
> 
> I prepared a small patch to set the cutoff according to Manu's formula.
> The calculation is simple enough for integer arithmetic, so it is not
> worth to prepare a lookup-table.
> 
> @ldvb:
> Please test and report whether it works for you.
> 
> CU
> Oliver
> 

I'm not asked, but give you a report anyway.

On Hotbird 13.0E it makes no difference for me.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
