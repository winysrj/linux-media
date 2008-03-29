Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1JfRik-0004Z4-OR
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 04:27:07 +0100
Received: by fg-out-1718.google.com with SMTP id 22so463823fge.25
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 20:27:03 -0700 (PDT)
Message-ID: <47EDB703.10502@googlemail.com>
Date: Sat, 29 Mar 2008 04:26:59 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <20080329024154.GA23883@localhost>
In-Reply-To: <20080329024154.GA23883@localhost>
Subject: Re: [linux-dvb] Analog capture (saa7113) not working on KNC1 DVB-C
 Plus	(MK3)
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
> Hello,
> 
> with a KNC One "TV-Station DVB-C Plus" PCI card (MK3 - Philips SAA7146
> with CU1216L/A I G H-3 Tunerbox with TDA10023) equipped with composite 
> and s-video inputs ('Plus' version, Philips SAA7113), analog capture 
> is not working. Most recent kernel sources I tested were 2.6.25-rc7.
> 
> DVB-C television works fine with this card using 'budget_av' kernel
> module (from kernel 2.6.20 on, using e9hack's tda1002x patch, and
> later with mainstream kernel sources alone), but when opening an
> analog input, there are no data coming. A black screen is shown with
> 'xawtv' application. Xawtv correctly shows up the two video sources
> this card provides: 'S-Video' and 'Composite'. 
> 
> I checked the cables and video sources, they work fine with another
> card with analog input.
> 
> I can do tests or compile something if you want me to. Information from 
> lspci, dmesg and lsmod please see below. Help to get analog capture
> working is appreciated very much.
> 
> Thank you
> 
> L.
> 

Thx for the confirmation, I've reported this before at 12/2007 with topic

budget_av 'plus' cards saa7113 capture broken by CI code or incomplete

on this list. the videobuf reworks broke it or all the foreign CI code 
in budget_av.c is disturbing the saa7113 circuit part of the card.
on this list, CI CAM functionality has priority it seems. sorry.

y
tom

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
