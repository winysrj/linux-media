Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LJ3dI-0005vk-OD
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 11:21:30 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1230443ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 02:21:25 -0800 (PST)
Date: Sat, 3 Jan 2009 11:19:32 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Mike Martin <redtux1@googlemail.com>
In-Reply-To: <ecc841d80901022041w72031858pc9b7bf6b6cb199fb@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901031058380.32128@ybpnyubfg.ybpnyqbznva>
References: <ecc841d80901022041w72031858pc9b7bf6b6cb199fb@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Is it posible to view digital teletext
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

On Sat, 3 Jan 2009, Mike Martin wrote:

> Does anyone know if it is possible to view dvb teletext through linux

Yes, but first, in your subject, you ask about Digital
Teletext which, in the UK, at least over satellite (Freesat)
is MHEG, while Sky uses the proprietary OpenWozzit, and
here you ask about DVB Teletext, as used by most of the
rest of the world (when not MHP), and which is different...


> if i am getting the right pid

The PID for DVB Teletext will be given on the PMT, as will
the necessary info for the MHEG carousels.  Note that over
satellite, pretty much the only DVB teletext is subtitles
on page 888 for the large channels (BBC, ITV, C4, etc),
and only Five has regular teletext pages otherwise.

Check out `redbutton-download' and `redbutton-browser'
for an application that can display MHEG pages, as sent
out by at least the Beeb last time I looked, shortly
before the official launch of Freesat, which was written
for DVB-T, but also works for select Freesat DVB-S.


> Any help apreciated  (I am in the UK)

Probably the above is what you need.  For regular DVB
teletext, like Five via Freesat, I use `dvbstream' on
the teletext PIDs from a particular transponder, piped
to a hacked version of `jpvtx' that writes the individual
pages.  For viewing, there's an X-aware `xvtx-p', or I've
a heavily hacked `vtx-to-utf8' from the `jpvtx' package
(originally not UTF8 but to 8859-15 with added support
for colours, non-ASCII characters, and limited graphics)


hope this is helpful
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
