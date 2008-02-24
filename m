Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JT6T0-0006LP-SZ
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 03:19:53 +0100
Message-ID: <47C0D43F.3010800@shikadi.net>
Date: Sun, 24 Feb 2008 12:19:43 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <47BFBA0D.2080607@shikadi.net>	<200802231039.33642.Nicola.Sabbi@poste.it>
	<47C004A4.4020302@shikadi.net>
In-Reply-To: <47C004A4.4020302@shikadi.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How do you stream the entire MPEG-TS with dvbstream?
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

>> with the same drivers and a different version of dvbstream?
>> In any case you should always try a fresh cvs checkout of dvbstream.
>> A simple test you should run  is this:
>>
>>  dvbstream -f 226500 -gi 16 -bw 7 -o 8192 > dump.ts
>> and try to play the dump.ts from another terminal. If you see corruptions
>> then report back, please.
>> P.S. 1.7 and 3 MB/s are really low bandwidth usage that shouldn't cause any 
>> trouble

Well I've upgraded to today's CVS, but the problem remains.  I've also
tried the new version on my old server but it works there, so obviously
there's some issue with my system configuration:

  Working server: Slackware 9.1, kernel 2.6.11.6 (2005-06-19)
  Broken server: Gentoo 2007.0, kernel 2.6.24.2 (2008-02-23)

Both servers have Realtek 8169 gigabit ethernet cards, using the r8169
driver.  Both MTUs are 1500, both are connected via the same switch to
my desktop PC.

According to gkrellmd running on each server and on my desktop PC,
broadcasting PID 8192 on the broken server only transmits/receives
1.7MB/sec, whereas it transmits/receives 3MB/sec on the working server.

Is there any local network config that needs to be set up before
dvbstream will work?

Thanks,
Adam.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
