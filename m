Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1K9RZP-00014i-IL
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 23:21:34 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m5JLLNG8010555
	for <linux-dvb@linuxtv.org>; Thu, 19 Jun 2008 23:21:23 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Thu, 19 Jun 2008 23:25:25 +0200
References: <1213788359.8904.5.camel@sat>
	<53265.212.50.194.254.1213908236.squirrel@webmail.kapsi.fi>
In-Reply-To: <53265.212.50.194.254.1213908236.squirrel@webmail.kapsi.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806192325.25370.joep@groovytunes.nl>
Subject: [linux-dvb] s2-3200 fec problem?
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

Hello all,

Today I replaced my skystar hd2 with a tt s2-3200.
Installed the current multiproto drivers and...
The problems that I had on the skystar still exist on this new card.
However I did discover that I can tune to other satalites (diseqc) with 
scan/szap.
So I moved from mythtv to these tools for testing purposes.
The main issue that I have at the moment is that I can't watch the dutch hdtv 
channels.
astra 23.5, 11778 V 27500 9/10
After some testing I did notice that I did not get one channel with fec 9/10 
to lock.
Has anyone got a working transponder with fec 9/10?

Thanks,
Joep Admiraal

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
