Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KCexk-0008Ch-Iy
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 20:16:51 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KCexd-00026e-4Y
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 18:15:45 +0000
Received: from h240n2fls32o1121.telia.com ([217.211.84.240])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 28 Jun 2008 18:15:45 +0000
Received: from dvenion by h240n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 28 Jun 2008 18:15:45 +0000
To: linux-dvb@linuxtv.org
From: Daniel <dvenion@hotmail.com>
Date: Sat, 28 Jun 2008 18:15:37 +0000 (UTC)
Message-ID: <loom.20080628T180915-166@post.gmane.org>
References: <1214015056l.6292l.1l@manu-laptop>
	<200806211114.46921.ajurik@quick.cz>
	<1214657052l.7275l.0l@manu-laptop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Re :  How to solve the TT-S2-3200 tuning problems?
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
> One more datapoint: I have one transponder which has only HD Channels 
> on it; the only difference with the other transponders (which are 
> working great using TT 3200) is the FEC (and the fact that it is MPEG4, 
> but that changes nothing for getting the lock); symbol rate and 
> modulation are the same. But it does not lock. Here is the dmesg of a 
> simpledvbtune session: one with a success on another transponder, and 
> then a failure on this transponder.
> I'd like to know where to put some printks or tweak the code to be able 
> to debug this, if someone with the know-how could explain a bit. I can 
> definitely do some coding, but without data it is kind of hard.
> HTH
> Bye
> Manu
> 


What FEC is it on the transponder you can't lock? 
I have one transponder witch is DVB-S with QPSK mod, FEC 7/8 and SR 28000 that
has one mpeg4 channel (Eurosport HD) and I get lock on that one all the time,
could it be becuse there are regular channels on that transponder too?

//Daniel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
