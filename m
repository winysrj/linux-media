Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1Jfulw-0004tY-9H
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 12:28:21 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1016313fge.25
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 03:28:16 -0700 (PDT)
Message-ID: <47EF6B3E.5060901@googlemail.com>
Date: Sun, 30 Mar 2008 12:28:14 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080329024154.GA23883@localhost>
	<47EDB703.10502@googlemail.com>	<20080330053900.GA31417@localhost>	<47EF342C.5010908@googlemail.com>
	<20080330080010.GA1688@localhost>
In-Reply-To: <20080330080010.GA1688@localhost>
Subject: Re: [linux-dvb] CI code in budget_av or videobuf rework break
 analog input? (was Re: Analog capture (saa7113) not working on KNC1	DVB-C
 Plus (MK3))
Reply-To: thomas.schorpp@googlemail.com
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

L. wrote:
> thomas schorpp wrote on Sun 2008-03-30 08:33 CEST:
>> L. wrote:
>>> thomas schorpp wrote on Sat 2008-03-29 04:26 CET:
>>>> the videobuf reworks broke it or all the foreign CI code 
>>>> in budget_av.c is disturbing the saa7113 circuit part of the card.
>>> You seem rather unsure about what exactly was breaking it. But did it
>>> work at a certain point of time anyway? All I know is analog input of
>>> this card was already not functional under kernel 2.6.20.
>> can't remember.
> 
> But you say that it was broken by "videobuf reworks or all the foreign 
> CI code in budget_av.c". How can you know then?
> 

mercurial logs, I've stated that in my older reports, maybe You read them.
it was broken for saa7134 cards, too, and later fixed, but not for saa7146 
based capture or our cards.

y
tom

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
