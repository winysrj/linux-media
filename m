Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HondaNSX@gmx.de>) id 1LNtc2-0006Tm-9l
	for linux-dvb@linuxtv.org; Fri, 16 Jan 2009 19:40:11 +0100
Received: from [192.168.25.4] (laptop.yaris.dyndns.org [192.168.25.4])
	by yaris.yaris.dyndns.org (Postfix) with ESMTP id E0BA3A93B9
	for <linux-dvb@linuxtv.org>; Fri, 16 Jan 2009 19:39:35 +0100 (CET)
Message-ID: <4970D464.5070509@gmx.de>
Date: Fri, 16 Jan 2009 19:39:32 +0100
From: AlexW <HondaNSX@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
Reply-To: linux-media@vger.kernel.org, HondaNSX@gmx.de
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

Patrick Boettcher wrote:
> Hi lists,
>
> For years there has been the Video Data Stream Borken-error with VDR and
> Technisat cards: The error occured randomly and unfrequently. A 
> work-around for that problem was to restart VDR and let the driver 
> reset the pid-filtering and streaming interface.
>
> In fact it turned out, that the problem is worse with setups not based 
> on VDR and the "VDSB-error" could be really easily reproduced (I'm not 
> sure if this applies to all generations on SkyStar2-card). I'm 
> skipping the description of the problem here...
>
>

Which generation of cards have this problem? I did not see any VDSB with 
my two Skystar 2.6D.



BR,
Walter



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
