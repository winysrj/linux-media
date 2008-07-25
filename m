Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from srv6.sysproserver.de ([78.47.47.66])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <m740@wagner-budenheim.de>) id 1KMLlS-0001V4-3r
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 13:47:14 +0200
Received: from smtp.mx6-sysproserver.de
	(static.67.47.47.78.clients.your-server.de [78.47.47.67])
	by srv6.sysproserver.de (Postfix) with ESMTP id ADEB5400F52
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 13:47:10 +0200 (CEST)
Message-ID: <20080725134710.jrc5uk81dwk4k4ck@wagner-budenheim.de>
Date: Fri, 25 Jul 2008 13:47:10 +0200
From: "Dirk E. Wagner" <m740@wagner-budenheim.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Transponder tuning problems with Nova-TD and Nova-T 500
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

Hello there,

I have the following problem with my Nova-TD USB stick:

I'm using vdr 1.6.0 with kernel 2.6.26. If I start a recording on 1 tuner
and at the same time on the other tuner there is a transponder change by
vdr's epgscan, I get:

syslog:Jul 13 07:46:17 etch-server vdr: [5395] PES packet shortened to
3286 bytes (expected: 3470 bytes)

This happens also when I start vdr with only 1 tuner, starting 1
recording on this tuner and starting a
channelscan with w_scan via command line.

It seems that changing the transponder disturb the other tuner with
the running recording.

I tested this with a Nova-TD and Nova-T 500, 3 different MoBos and a
Laptop, Kernel 2.6.25 and 2.6.26.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
