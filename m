Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1Jfuib-00045S-Ly
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 12:24:54 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1015130fge.25
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 03:24:50 -0700 (PDT)
Message-ID: <47EF6A6F.50401@googlemail.com>
Date: Sun, 30 Mar 2008 12:24:47 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080329024154.GA23883@localhost>
	<47EDB703.10502@googlemail.com>	<20080330053900.GA31417@localhost>	<47EF342C.5010908@googlemail.com>
	<20080330071647.GA990@localhost>
In-Reply-To: <20080330071647.GA990@localhost>
Subject: Re: [linux-dvb] KNC1 DVB-C Plus analog input
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
> thomas schorpp wrote on Sun 2008-03-30 08:33 CET:
>> L. wrote:
>>> thomas schorpp wrote on Sat 2008-03-29 04:26 CET:
>>>> the videobuf reworks broke it or all the foreign CI code 
>>>> in budget_av.c is disturbing the saa7113 circuit part of the card.
>>> You seem rather unsure about what exactly was breaking it. But did it
>>> work at a certain point of time anyway? All I know is analog input of
>>> this card was already not functional under kernel 2.6.20.
>> can't remember.
>> btw, could You test if the crappy knc-1 (odsoft?) non-bda winxp driver which 
>> supports the saa7113 input BSOD's on Your machine, too, on install?
> 
> I don't have winxp but if it produces a crash it may be related to this: 
> 
> KNC One FAQ: Programmabsturz bei Auswahl des analogen Videoeingangs (DVB-x PLUS Karten)
> http://www.knc1.de/d/faq/faqs.htm#18

No. bluescreen is a kernel crash, not crash of a userspace app, and I've not got any HD audio.
Your only chance to get analog working at this time is trying the non-bda winxp driver.
If it crashes Your winxp kernel, You got a warranty case to return in the 
card to the dealer or knc-1 and get money back, +assured product feature failure case ;)

y
tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
