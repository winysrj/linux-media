Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KCrlu-0006oR-BV
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 09:56:30 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KCrlp-0001vx-9a
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 07:56:25 +0000
Received: from h240n2fls32o1121.telia.com ([217.211.84.240])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 29 Jun 2008 07:56:25 +0000
Received: from dvenion by h240n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 29 Jun 2008 07:56:25 +0000
To: linux-dvb@linuxtv.org
From: Daniel <dvenion@hotmail.com>
Date: Sun, 29 Jun 2008 07:56:17 +0000 (UTC)
Message-ID: <loom.20080629T074739-993@post.gmane.org>
References: <loom.20080628T180915-166@post.gmane.org>
	<1214701520l.6081l.0l@manu-laptop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Re : Re : How to solve the TT-S2-3200 tuning
	problems?
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

manu <eallaud <at> yahoo.fr> writes:

> 
> AFAIK there are only HD channels on this transponder. FEC is 5/6 
> instead of the more common 3/4 for all other transponders. And that's 
> the only difference. I do not understand why this could be a problem 
> for tuning to the transponder.
> And I tried to tune to frequencies between 11485 and 11505 MHz, whereas 
> the freq is advertised as 11495MHz. With no luck: not a single lock.
> For the other transponders lock is fast and reliabke.
> One more thing, the symbol rate is the same across all transponders, 
> 30MBauds.
> Do you have an idea about solving this, or at least how to get useful 
> info.
> Bye
> Manu
> 


Sad enough I have no clue how to solve this. I have this problem too with with a
couple of transponders that just holds mpeg4 channels. But they are DVB-S2 with
8PSK mod, FEC 3/4 and symbolrate 25000 and 30000.
12128, 12015, 11434 and 11421 on Thor 5 1.0W are the ones that are problematic
for me.

//Daniel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
