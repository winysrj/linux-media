Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JSsdo-0006vC-AW
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 12:34:04 +0100
Message-ID: <47C004A4.4020302@shikadi.net>
Date: Sat, 23 Feb 2008 21:33:56 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <47BFBA0D.2080607@shikadi.net>
	<200802231039.33642.Nicola.Sabbi@poste.it>
In-Reply-To: <200802231039.33642.Nicola.Sabbi@poste.it>
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

> with the same drivers and a different version of dvbstream?
> In any case you should always try a fresh cvs checkout of dvbstream.
> A simple test you should run  is this:
> 
>  dvbstream -f 226500 -gi 16 -bw 7 -o 8192 > dump.ts
> and try to play the dump.ts from another terminal. If you see corruptions
> then report back, please.
> P.S. 1.7 and 3 MB/s are really low bandwidth usage that shouldn't cause any 
> trouble

OH, well this was with my distribution's most recent version, which I
assumed would be only a month or two behind CVS.  Unfortunately I've
just realised that according to the banner it's version 0.5, whereas the
"old" version I was running (with a last modified date of 2004) is
version 0.6!

I was going to mention a couple of other issues I found while I was
running your above command, but given that the version is so out of date
I think I'll go file a bug report with my distro instead :-)

Thanks for your response!

Cheers,
Adam.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
