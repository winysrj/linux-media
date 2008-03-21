Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JcXGt-0000DE-FW
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 03:46:22 +0100
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net
	[151.189.8.17])
	by mail-in-14.arcor-online.net (Postfix) with ESMTP id 11CB91877F3
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 03:46:16 +0100 (CET)
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mail-in-05-z2.arcor-online.net (Postfix) with ESMTP id D234B2DAC09
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 03:46:15 +0100 (CET)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-09.arcor-online.net (Postfix) with ESMTP id 56C6D3425E3
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 03:46:15 +0100 (CET)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200803200048.15063@orion.escape-edv.de>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
Date: Fri, 21 Mar 2008 03:37:59 +0100
Message-Id: <1206067079.3362.10.camel@pc08.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Am Donnerstag, den 20.03.2008, 00:48 +0100 schrieb Oliver Endriss:
> Andrew Junev wrote:
> > Hello All,
> > 
> > I was successfully using two TT S-1401 DVB-S cards in my HTPC running
> > Fedora 8. One of my antennas is positioned to Astra 19.2E and its
> > signal quality is quite low in my area. But the setup worked just fine
> > for me most of the time.
> > 
> > Last weekend I updated my system from kernel-2.6.23.15-137.fc8 to
> > kernel-2.6.24.3-12.fc8. It was just a 'yum update', nothing else.
> > Right after that I got no lock on most of Astra transponders (other
> > satellites were still Ok, but they normally have a far better signal).
> > After checking everything twice without any success, I booted back to
> > 2.6.23.15 and my Astra was back!
> > 
> > Is this a known behavior? I suppose it was not discussed before, so
> > this makes me think I am the only one with such a problem...
> > Strange... I think the problem is somehow related to the signal level / 
> > signal error rate. Looks like weak transponders are harder to lock
> > with the new kernel...
> > I'd appreciate any comments on this. I don't think I have an urgent
> > need to move to 2.6.24 now, but I'd still like to be able to do that
> > without loosing my TV... 
> > 
> > 
> > P.S. I can see there's kernel-2.6.24.3-34.fc8 already available for
> > Fedora 8. But I didn't try it yet...
> 
> Afaik this is a known regression in 2.6,24.
> 
> See 
>   http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023477.html
> and
>   http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023559.html
> for the fix.
> 
> CU
> Oliver
> 

hmm, thought that this we exactly did avoid on 2.6.24 and 2.6.25.

IIRC, this should never made it into 2.6.24, at least I thought we could
always stop it on 2.6.25 before it harms.

Fedora downports from release canditates, and almost always is fine,
so I don't trust the 2.6._24_ here.

If nothing else to do ..., might investigate it.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
