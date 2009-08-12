Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.17.9])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <SRS0=Cnoi=EE=gmx.de=jens.nixdorf@srs.kundenserver.de>)
	id 1MbJWi-0007tX-2B
	for linux-dvb@linuxtv.org; Wed, 12 Aug 2009 21:30:24 +0200
From: Jens Nixdorf <jens.nixdorf@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 12 Aug 2009 21:30:15 +0200
References: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908122130.15270.jens.nixdorf@gmx.de>
Subject: Re: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Am Dienstag 11 August 2009 schrieb Christopher Thornley:

> S2API installation seemed to be successful but I have no way of
> confirming this. I had to "Sudo insmod" the modules to install them. I
> am not to sure if they will survive a reboot or will I have to install
> them again. These appear to install without any complaints.
>
> Multiproto installation did not seem to be entirely successful. I
> followed the instructions but the modules are not found when I arrive
> at the insmod stage. I suspect they did not compile successfully. I am
> clueless as how to get these to work.

As Niels told you already, you cant use both types of driver. I own the 
same DVB-S2-Box from Technotrend and i'm using it with VDR 1.7.0 in 
ubuntu 9.04. I was following the wiki for installing s2-liplianin-
drivers, and since this time the box is running including its CI. 

Maybe there could be some optimization (the log is full with some 
bandwisth-messages from the stb6100-part), but it works at least good 
enough for me.

To your dvb-t-box i have nothing to say, because of my lack of knowledge 
;)


regards, Jens


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
