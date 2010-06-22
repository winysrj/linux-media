Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1OR0iZ-0004Sh-O1
	for linux-dvb@linuxtv.org; Tue, 22 Jun 2010 12:28:36 +0200
Received: from mail-wy0-f182.google.com ([74.125.82.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OR0iZ-0001r3-0C; Tue, 22 Jun 2010 12:28:35 +0200
Received: by wyb33 with SMTP id 33so3758903wyb.41
	for <linux-dvb@linuxtv.org>; Tue, 22 Jun 2010 03:28:28 -0700 (PDT)
Date: Tue, 22 Jun 2010 12:28:25 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: "Erich N. Pekarek" <epek@gmx.net>
In-Reply-To: <20100622090854.12710@gmx.net>
Message-ID: <alpine.DEB.2.01.1006221217090.6056@localhost.localdomain>
References: <4C0CAE38.8050806@gmx.net>
	<alpine.DEB.2.01.1006161906320.13184@localhost.localdomain>
	<20100622090854.12710@gmx.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha tuning (again)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Moin moin,

On Tue (Tuesday) 22.Jun (June) 2010, 11:08,  Erich N. Pekarek wrote:

> > That is, no frontend gets loaded for me.  So, no tuning.  The
> > other two devices attached at the moment both work properly.
> 
> Yes, that problem sounds familiar - see my comment on this below, please.

This is also the case with the latest (at the time I built it a
few days ago) 2.6.35-rc3 kernel.



> > Plus I'll have to see what changes I need to get the DAB support
> > from Siano working properly, as I hadn't done that yet with the
> > 2.6.34-rc2 kernel.
> 
> I can't help in that case, since, up to my knowlegde, in favour to dvb-t radio there is no dab-radio in Austria.

It is true that the ORF tests of DAB radio from Wien and Innsbruck
were discontinued -- a shame in my opinion, as part of the 
services they offered were in better quality or at least 
comparable to what I receive by satellite in .mp2 audio.

However I have some DAB/DAB+ ensembles nearby that I can receive
so my attempts to get that working should present no problem.

I will try to see what I can get working -- the 2.6.35-rc3 kernel
that I built has some serious networking issues (retries
apparently don't happen) and is useless for on-line use, as I want
the Siano device to be useful to me.


thanks,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
