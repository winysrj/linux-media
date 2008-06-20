Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1K9cdr-000857-UW
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 11:10:48 +0200
Message-ID: <485B73EB.6050700@chaosmedia.org>
Date: Fri, 20 Jun 2008 11:10:03 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1213788359.8904.5.camel@sat>	<53265.212.50.194.254.1213908236.squirrel@webmail.kapsi.fi>
	<200806192325.25370.joep@groovytunes.nl>
In-Reply-To: <200806192325.25370.joep@groovytunes.nl>
Subject: Re: [linux-dvb] s2-3200 fec problem?
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
> Hello all,
>
> Today I replaced my skystar hd2 with a tt s2-3200.
> Installed the current multiproto drivers and...
> The problems that I had on the skystar still exist on this new card.
> However I did discover that I can tune to other satalites (diseqc) with 
> scan/szap.
> So I moved from mythtv to these tools for testing purposes.
> The main issue that I have at the moment is that I can't watch the dutch hdtv 
> channels.
> astra 23.5, 11778 V 27500 9/10
> After some testing I did notice that I did not get one channel with fec 9/10 
> to lock.
> Has anyone got a working transponder with fec 9/10?
>
>
>   
here on my tt s2-3200 / latest multiproto i can tune to :

Astra 1H (19.2E) - 11914.50 H - Txp: 75 
<http://en.kingofsat.net/tp.php?tp=75> - Beam: Astra 1H 
<http://en.kingofsat.net/beams.php?s=8&b=11> DVB-S2 (QPSK) - 27500 9/10 
- NID:133 - TID:6


FEC is set to AUTO in the app (kaffeine)

Marc

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
