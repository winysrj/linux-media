Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JhvDV-0002jd-VZ
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 01:21:06 +0200
Received: from mail-in-07-z2.arcor-online.net (mail-in-07-z2.arcor-online.net
	[151.189.8.19])
	by mail-in-01.arcor-online.net (Postfix) with ESMTP id 93E2E10441E
	for <linux-dvb@linuxtv.org>; Sat,  5 Apr 2008 01:21:02 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-07-z2.arcor-online.net (Postfix) with ESMTP id 873552C7064
	for <linux-dvb@linuxtv.org>; Sat,  5 Apr 2008 01:21:02 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id 23CC936E864
	for <linux-dvb@linuxtv.org>; Sat,  5 Apr 2008 01:21:02 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.62.0804041816420.6230@ns.bog.msu.ru>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
	<1206067079.3362.10.camel@pc08.localdom.local>
	<200803210742.57119@orion.escape-edv.de>
	<1206912674.3520.58.camel@pc08.localdom.local>
	<1063704330.20080331082850@a-j.ru>
	<1206999694.7762.41.camel@pc08.localdom.local>
	<1112443057.20080402224744@a-j.ru>
	<1207179525.14887.13.camel@pc08.localdom.local>
	<1207265002.3364.12.camel@pc08.localdom.local>
	<Pine.LNX.4.62.0804041813230.6230@ns.bog.msu.ru>
	<Pine.LNX.4.62.0804041816420.6230@ns.bog.msu.ru>
Date: Sat, 05 Apr 2008 01:20:59 +0200
Message-Id: <1207351259.4591.49.camel@pc08.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Hi,

Am Freitag, den 04.04.2008, 18:17 +0400 schrieb ldvb@ns.bog.msu.ru:
> 
> On Fri, 4 Apr 2008 ldvb@ns.bog.msu.ru wrote:
> 
> >> should we really let hang it like this on 2.6.24?
> > if You are talking about these card, so, I'm using it on 2.6.25.rc-last
> > without any strange effects.
> Ah! sorry!
> with some changes in registers, it was stressed 2 weeks ago.
> 

thanks a lot, that problem is only on 2.6.24.

Michael Krufky could just need one confirming that with the patch it is
almost like on 2.6.23 to get it to stable 2.6.24.

Hartmut's config option patch is already on 2.6.25.

Let know if I can test something else, but on Hotbird 13.0E I get all
what I get with an external receiver too, but there is nothing with high
symbol rates.

Cheers,
Hermann




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
