Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <psofa.psofa@gmail.com>) id 1K9iat-0002ok-41
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 17:32:10 +0200
Received: by yw-out-2324.google.com with SMTP id 3so595656ywj.41
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 08:32:02 -0700 (PDT)
Message-ID: <8e485a510806200832s2c7a4d55r9ac8c1d871f59b96@mail.gmail.com>
Date: Fri, 20 Jun 2008 18:32:00 +0300
From: psofa <psofa.psofa@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <loom.20080620T142728-129@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <200805122042.43456.ajurik@quick.cz>
	<200806162245.22999.ajurik@quick.cz>
	<loom.20080620T131302-220@post.gmane.org>
	<200806201547.28906.ajurik@quick.cz>
	<loom.20080620T142728-129@post.gmane.org>
Subject: Re: [linux-dvb] Re : Re : Re : No lock possible at some DVB-S2
	channels with TT S2-3200/linux
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

I have a skystar hd (tt 3200 rebranded) and both qpsk and 8psk
transpoders generally work with mythtv.
However tuning at many transpoders is rubbish for me.Take for example
premiere's @ 19e.
adding +4 mhz works for some transpoders ive tried but for some others
like the eurosport hd one
wont help at all.Also even when tuning correctly i see lots of ber
artifacts even though my previous
skystar 2 and my dreambox receiver  work flawlessly.
There is a thread here ->
http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024080.html
where one guy reported that after 7200 the successfully tuned
transpoders are much fewer but it seems
these changes where never reverted.(i suppose because theres a last
reply there where another user says its good)



> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
