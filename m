Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1LIVN7-0001O1-CT
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 22:46:30 +0100
Received: from [192.168.1.116] (79.40.176.222) by relay-pt1.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 495C161000004DF4 for linux-dvb@linuxtv.org;
	Thu, 1 Jan 2009 22:46:25 +0100
From: Nico Sabbi <nicola.sabbi@poste.it>
To: linux-dvb@linuxtv.org
In-Reply-To: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
References: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
Date: Thu, 01 Jan 2009 22:40:27 +0100
Message-Id: <1230846027.3818.1.camel@linux-wcrt.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dvbsream v0-5 and -n switch
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

Il giorno gio, 01/01/2009 alle 18.33 +0000, Mike Martin ha scritto:
> Hi - hope this is the right list to ask questions about dvbstream.
> 
> I am using dvbstream for an application I am developing
> (www.sourceforge.net/epgrec) and when I try using the -n switch
> (according to help should set number of seconds to record) it has no
> effect
> 
> I have tried all place on command line and no errors just no effect
> 
> example
> dvbstream -ps  640 641 -n 1800 -o >
> /media/video2/BBC_NewsREC_2009_01_01_18_31_45.mpeg

no tuning?? Also, -ps is very dangerous. It's better to save the TS

> 
> Am I missing something?
> 

use a fresh checkout, not the 0.5 release.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
