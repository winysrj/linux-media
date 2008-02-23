Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT0s7-0001DK-5j
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 21:21:23 +0100
Message-ID: <47C0803D.2020504@gmail.com>
Date: Sun, 24 Feb 2008 00:21:17 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>
	<20080223174406.GB30387@moelleritberatung.de>
In-Reply-To: <20080223174406.GB30387@moelleritberatung.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

Artem Makhutov wrote:
> Hi,
> 
> On Sat, Feb 23, 2008 at 12:35:49PM +0000, Vangelis Nonas wrote:
>>> My problems are:
>>> - When I scan the same transponder more than once, sometimes I get some services, sometimes I get no services.
> 
> I have never tried to scan with the SkyStar HD.
> 
>>> - When I zap (with szap2) to a station more than once, sometimes I get a lock, sometimes I get no lock.
> 
> I have the same problem. I was trying to tune to ProSieben 100 times today. And I got only 11 successful locks.
> The signal strengt should be ok, as I have no problems to tune this
> channel with other DVB-S cards...
> 
> Here is a little script to do such tests:
> http://www.makhutov.org/downloads/dvb/tune.sh
> 
> You need this szap (http://abraham.manu.googlepages.com/szap.c) and this
> patch (http://www.makhutov.org/downloads/dvb/szap.patch) to make the script work.
> 
> Has anyone any ideas why the tuning failes so often? Is it a problem of
> szap or the driver itself? I heard, that this card works perfect with VDR for other users...


Can you guys please update from the multiproto tree and test again at
the earliest and give me your feedback ?

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
