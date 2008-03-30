Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1Jfr6Z-0001Uo-W3
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 08:33:30 +0200
Received: by fg-out-1718.google.com with SMTP id 22so943503fge.25
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 23:33:20 -0700 (PDT)
Message-ID: <47EF342C.5010908@googlemail.com>
Date: Sun, 30 Mar 2008 08:33:16 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080329024154.GA23883@localhost> <47EDB703.10502@googlemail.com>
	<20080330053900.GA31417@localhost>
In-Reply-To: <20080330053900.GA31417@localhost>
Subject: Re: [linux-dvb] Analog capture (saa7113) not working on KNC1 DVB-C
 Plus (MK3)
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
> thomas schorpp wrote on Sat 2008-03-29 04:26 CET:
>> the videobuf reworks broke it or all the foreign CI code 
>> in budget_av.c is disturbing the saa7113 circuit part of the card.
> 
> You seem rather unsure about what exactly was breaking it. But did it
> work at a certain point of time anyway? All I know is analog input of
> this card was already not functional under kernel 2.6.20.

can't remember.
btw, could You test if the crappy knc-1 (odsoft?) non-bda winxp driver which 
supports the saa7113 input BSOD's on Your machine, too, on install?

> 
> I wish so much it could be fixed or implemented, because I need the
> analog inputs very much for various devices. I bought the KNC1 card

get a v4l supported usb2 analogtv/av usb-grabber with full PAL/SECAM res. 
cheap from the bay, since dvb-t is replacing terrestrial analog tv in europe fastly.
majority of developers set priority for dvb paytv CI CAM, so no fast fix.

> L.
y
tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
