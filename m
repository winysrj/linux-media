Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Ky65R-0005Fn-6i
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 15:43:54 +0100
Date: Thu, 06 Nov 2008 15:43:19 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081106124730.16840@gmx.net>
Message-ID: <20081106144319.268390@gmx.net>
MIME-Version: 1.0
References: <20081106124730.16840@gmx.net>
To: linux-dvb@linuxtv.org, handygewinnspiel@gmx.de
Subject: Re: [linux-dvb] [PATCH] wscan: improved frontend autodetection
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

> Currently wscan will not autodetect frontends which which have frontend !=
> 0,
> i.e. it only detects /dev/dvb/adapterN/frontend0 where N=0-3.
> 
> Since multiple frontends per adapter are supported in 2.6.28, this means
> the correct
> frontend may not be found. For example with the HVR4000, DVB-T is always
> at frontend1.
> 
> The attached patch fixes this, searching for frontend 0-3 for each adapter
> 0-3.
> 
> Signed-off-by: Hans Werner <hwerner4@gmx.de>.

Of course it's called w_scan, not wscan, sorry.

Suggestion: how about setting -t 3 (long tuning timeout) and -O 1 (search other services)
as the *default* options to give the program the best chance of finding all channels without
having to play with the options? They do make a difference.

-- 
Release early, release often.

"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
