Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1K9pEY-0003An-8X
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 00:37:31 +0200
Received: from webmail.xs4all.nl (dovemail1.xs4all.nl [194.109.26.3])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id m5KMbKed080273
	for <linux-dvb@linuxtv.org>; Sat, 21 Jun 2008 00:37:25 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <22711.82.95.219.165.1214001445.squirrel@webmail.xs4all.nl>
Date: Sat, 21 Jun 2008 00:37:25 +0200 (CEST)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] s2-3200 fec problem?
Reply-To: n.wagenaar@xs4all.nl
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

> Hello all,
>

Good evening :)

> -- SNIP --
> The main issue that I have at the moment is that I can't watch the dutch
> hdtv
> channels.
> astra 23.5, 11778 V 27500 9/10
> After some testing I did notice that I did not get one channel with fec
> 9/10
> to lock.
> Has anyone got a working transponder with fec 9/10?
>

I use the S2-3200 myself with the latest multiproto_plus revision
(compiled it yesterday) in combination with VDR 1.7.0 + HDTV patch. In
short, I don't have the problems you encounter with the Dutch HDTV
Channels.

Here's a snip from my channels.conf:

:->0235-11778__by Linowsat
Discovery
HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:512:0;80=dut:0:100:7010:3:3204:0
NGC
HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:513:82=dut;83=dut:0:100:7015:3:3204:0
VOOM
HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:514:84=dut:0:100:7020:3:3204:0
BravaHDTV;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:515:86=dut:0:100:7025:3:3204:0
NL1
HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:516:88=dut:0:100:7030:3:3204:0

I know it works for a fact since I watch soccer on NL1 HD ;)

You did patch MythTV for usage with Multiproto, right? I read somewhere
that you need the SVN-sources of MythTV for getting it working.

> Thanks,
> Joep Admiraal
>

Cheers,

Niels Wagenaar



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
