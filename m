Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <IxAYMzFpK2ojlw@sofortsurf.de>) id 1JfqJn-00062O-5Y
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 07:43:00 +0200
Date: Sun, 30 Mar 2008 07:39:00 +0200
From: "L." <IxAYMzFpK2ojlw@sofortsurf.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080330053900.GA31417@localhost>
References: <20080329024154.GA23883@localhost> <47EDB703.10502@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47EDB703.10502@googlemail.com>
Subject: Re: [linux-dvb] Analog capture (saa7113) not working on KNC1 DVB-C
	Plus (MK3)
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

thomas schorpp wrote on Sat 2008-03-29 04:26 CET:
> the videobuf reworks broke it or all the foreign CI code 
> in budget_av.c is disturbing the saa7113 circuit part of the card.

You seem rather unsure about what exactly was breaking it. But did it
work at a certain point of time anyway? All I know is analog input of
this card was already not functional under kernel 2.6.20.

I wish so much it could be fixed or implemented, because I need the
analog inputs very much for various devices. I bought the KNC1 card
especially for its analog inputs (25 EUR more for the analog inputs)

The motherboard here has only one PCI slot, so a workaround with a
second card (bt878 analog capture works) is not possible. 

At the moment, I can make the Composite/S-Video devices accessible only
if I put the KNC1 card out of the computer and put the bt878 card in,
thus losing DVB capability. So any developer's care for this problem is
welcome very much.

Thank you

L.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
