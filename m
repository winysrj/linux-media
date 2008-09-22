Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Khovj-0005Uf-Ap
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 19:10:37 +0200
Received: by ug-out-1314.google.com with SMTP id 39so4182889ugf.16
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 10:10:31 -0700 (PDT)
Date: Mon, 22 Sep 2008 19:10:16 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <546961.66460.qm@web38804.mail.mud.yahoo.com>
Message-ID: <alpine.DEB.1.10.0809221901350.25652@ybpnyubfg.ybpnyqbznva>
References: <546961.66460.qm@web38804.mail.mud.yahoo.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] DVB-H support
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

On Mon, 22 Sep 2008, Uri Shkolnik wrote:

> > I'm a complete novice
> > with LinuxTV/dvb-utils. First I wanted to know if it was
> > possible to get
> > DVB-H streams with it and what hardware would be proper. I
> > supposed that
> > demuxing and selecting the contents would be nearly the
> > same that in DVB-T,
> > as the main difference is the time slicing in DVB-H
> > streams.
> 
> Not so easily. DVB-H is RTP based, so the content is delivered using IP multicast.

Just to pop in here, while searching for something else,
I came upon a good how-to on all the steps needed to get
one particular service out of a DVB-H test multiplex --
specifically receiving FM4 from the DVB-H test in Wien
(Vienna Austria -- or was it Graz or somewhere else?),
which is no longer broadcasting as such -- under Linux-DVB.

You might find this useful, though I no longer remember what
language it was...


barry bouwsma
parse, parse, parse

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
