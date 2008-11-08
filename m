Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1KyoF2-0003ls-AT
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 14:52:45 +0100
Received: from [192.168.1.116] (79.47.51.8) by relay-pt2.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 4914D701000065A3 for linux-dvb@linuxtv.org;
	Sat, 8 Nov 2008 14:52:40 +0100
From: Nico Sabbi <nicola.sabbi@poste.it>
To: linux-dvb@linuxtv.org
In-Reply-To: <49150AF1.5060601@rongage.org>
References: <49150AF1.5060601@rongage.org>
Date: Sat, 08 Nov 2008 14:53:50 +0100
Message-Id: <1226152430.3766.0.camel@suse.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] crash issue with dvbstream
Reply-To: nicola.sabbi@poste.it
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

Il giorno ven, 07/11/2008 alle 22.43 -0500, Ron Gage ha scritto:
> I am having problems with dvbstream segfaulting.  The segfaults are 
> occurring at line 635 of dvbstream.c - PAT.entries[] are basically NULL 
> causing the segfault.
> 
> I was asked by mrec on the IRC channel to make a ts dump of the video 
> signal I am trying to stream.  That stream is at 
> http://www.mi-connect.com/crash.ts.  This dump file is roughly 224 meg 
> in size.
> 
> Let me know if I can help in finding this problem.
> 
> Ron Gage
> Westland, MI
> 
> 

what version of dvbstream? Always use a cvs checkout, there are
important bugfixes in there




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
