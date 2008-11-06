Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1KyBfZ-00082m-3b
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 21:41:33 +0100
Message-ID: <49135655.5070806@gmx.de>
Date: Thu, 06 Nov 2008 21:40:53 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Werner <HWerner4@gmx.de>
References: <20081106124730.16840@gmx.net> <20081106144319.268390@gmx.net>
In-Reply-To: <20081106144319.268390@gmx.net>
Cc: linux-dvb@linuxtv.org
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

Hans Werner schrieb:
> Of course it's called w_scan, not wscan, sorry.
>
> Suggestion: how about setting -t 3 (long tuning timeout) and -O 1 (search other services)
> as the *default* options to give the program the best chance of finding all channels without
> having to play with the options? They do make a difference.
>
>   
Long timeout prolonges scan time without guarantee for any improvement - 
i don't like that idea.
This option is more or less only useful for frontends with really bad 
reception or problematic drivers.

Other services should effect output after scan only, but not scan 
itself. Otherwise a lot of useless services will put into channels.conf.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
