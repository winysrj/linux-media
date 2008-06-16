Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1K8LIX-0005oS-Gy
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 22:27:29 +0200
Received: from localhost (localhost [127.0.0.1])
	by ns218.ovh.net (Postfix) with ESMTP id 904198013
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 22:26:45 +0200 (CEST)
Received: from ns218.ovh.net ([127.0.0.1])
	by localhost (ns218.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4x5Wp8rtavZM for <linux-dvb@linuxtv.org>;
	Mon, 16 Jun 2008 22:26:45 +0200 (CEST)
Received: from [192.168.1.50] (droid.chaosmedia.org [82.225.228.49])
	by ns218.ovh.net (Postfix) with ESMTP id 4C7567D11
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 22:26:45 +0200 (CEST)
Message-ID: <4856CC84.8090402@chaosmedia.org>
Date: Mon, 16 Jun 2008 22:26:44 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200805122042.43456.ajurik@quick.cz>	<1213582905l.12580l.1l@manu-laptop>	<200806161020.05437.ajurik@quick.cz>
	<200806162114.27912.joep@groovytunes.nl>
In-Reply-To: <200806162114.27912.joep@groovytunes.nl>
Subject: Re: [linux-dvb] Re : Re : Re : No lock possible at some
 DVB-S2	channels with TT S2-3200/linux
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



joep wrote:
> The most important thing I can't get working is diseqc switching.
> Does anyone use Astra23,5 or hotbird13 with the multiproto driver?
>   
i do use a tt s2-3200 with late april multiproto (after the api change)
i use kaffeine with a beta multiproto patch and have no particular 
problem using diseqc (0=hd 13 / 1=astra19.2).

I do get some "no lock" from time to time when switching from astra 19.2 
to hb 13.0 but zapping back and forth usually fix the problem and i have 
the same kind of problem with my dvb-s card with multiproto and v4l-dvb 
drivers..
> If so, please tell me which channels you can tune to successfuly so I can do 
> my next tests on those channels.
>
>   
i do remember not being able to lock to Eurosport HD transponder no matter what i tried.

i was wondering if it makes any difference if FEC is set to the correct value when tuning or to the "auto" value.
if i'm correct some zap or scan app i tested and browsed the code, did always use the auto value for FEC..

I have to get back to my kaffeine patch and finish it then maybe i can join your testing with my s2-3200

Marc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
