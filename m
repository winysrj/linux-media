Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <IxAYMzFpK2ojlw@sofortsurf.de>) id 1JfroP-00053j-Pc
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 09:18:48 +0200
Date: Sun, 30 Mar 2008 09:16:47 +0200
From: "L." <IxAYMzFpK2ojlw@sofortsurf.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080330071647.GA990@localhost>
References: <20080329024154.GA23883@localhost> <47EDB703.10502@googlemail.com>
	<20080330053900.GA31417@localhost>
	<47EF342C.5010908@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47EF342C.5010908@googlemail.com>
Subject: [linux-dvb] KNC1 DVB-C Plus analog input (was: Re: Analog capture
	(saa7113) not working on KNC1 DVB-C Plus (MK3))
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

thomas schorpp wrote on Sun 2008-03-30 08:33 CET:
> L. wrote:
> > thomas schorpp wrote on Sat 2008-03-29 04:26 CET:
> >> the videobuf reworks broke it or all the foreign CI code 
> >> in budget_av.c is disturbing the saa7113 circuit part of the card.
> >
> > You seem rather unsure about what exactly was breaking it. But did it
> > work at a certain point of time anyway? All I know is analog input of
> > this card was already not functional under kernel 2.6.20.
> 
> can't remember.
> btw, could You test if the crappy knc-1 (odsoft?) non-bda winxp driver which 
> supports the saa7113 input BSOD's on Your machine, too, on install?

I don't have winxp but if it produces a crash it may be related to this: 

KNC One FAQ: Programmabsturz bei Auswahl des analogen Videoeingangs (DVB-x PLUS Karten)
http://www.knc1.de/d/faq/faqs.htm#18

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
