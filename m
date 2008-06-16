Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1K8Jr1-0007z6-2w
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 20:54:59 +0200
Received: by fk-out-0910.google.com with SMTP id f40so3669070fka.1
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 11:54:55 -0700 (PDT)
Message-ID: <4856B6FD.1080906@gmail.com>
Date: Mon, 16 Jun 2008 21:54:53 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <20080615192300.90886244.SiestaGomez@web.de>	<4855F6B0.8060507@gmail.com>
	<1213620050.6543.6.camel@pascal>	<20080616142616.75F9C3BC99@waldorfmail.homeip.net>
	<1213626832.6543.23.camel@pascal>
In-Reply-To: <1213626832.6543.23.camel@pascal>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

Sigmund Augdal wrote:
> Both transponders reported to not tune here has different symbolrates
> from what I used for my testing. Maybe this is relevant in some way.
> Could you please compare this with the channels that did tune to see if
> there is a pattern? 

 From my side i can add that all frequency from local cable provider's 
works with c-1501 except one:
274
282
290
298
306
314
386 NO LOCK
394
402
410
All channels QAM64 and SR 6875.

In the same PC I have second DVB-C card (KNC One DVB-C), which sharing 
same cable with c-1501 and there no problem with reception and signal's 
strength. This is reason why I did not discover current problem earlier. :(

Arthur






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
