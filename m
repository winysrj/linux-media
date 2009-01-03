Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LJA5B-0002q2-Ng
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 18:14:42 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1243603ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 09:14:38 -0800 (PST)
Date: Sat, 3 Jan 2009 18:14:15 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
cc: linux-dvb@linuxtv.org
In-Reply-To: <495F99CD.8000202@braice.net>
Message-ID: <alpine.DEB.2.00.0901031809200.32128@ybpnyubfg.ybpnyqbznva>
References: <op.um6wpcvirj95b0@localhost> <495F99CD.8000202@braice.net>
MIME-Version: 1.0
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

On Sat, 3 Jan 2009, Brice DUBOST wrote:

> > For instance the scan doesn't find RTL2, but if I add to channels.conf
> > RTL2:12187:h:0:27500:166:128:12020
> > then szap -r works correctly.

> Scan tunes on one frequency, and uses the informations given by the
> provider to find the others
> 
> Sometimes (quite often in fact) the providers doesn't give full informations

In the case of Astra 19E2, the list of transponders is
sufficiently well-managed that pretty much regardless of
which transponder you start on, you'll get a list of most
of them, from which you'll get a list of them all.

Unlike, say, Hotbirds, where it's more or less a free-
for all...


To the original poster, what unusual things does the
output to the console of `scan -v' show, if you don't
see anything unusual for `scan' without -v ?

In particular, search for the particular frequencies
of RTL or any other transponders/channels which you
know are missing, or other obvious errors...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
