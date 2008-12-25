Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1LFmlO-0006ck-RW
	for linux-dvb@linuxtv.org; Thu, 25 Dec 2008 10:44:19 +0100
Received: from [192.168.178.120] (unknown [95.114.180.181])
	by dd16712.kasserver.com (Postfix) with ESMTP id 240841807C9A6
	for <linux-dvb@linuxtv.org>; Thu, 25 Dec 2008 10:44:17 +0100 (CET)
Message-ID: <495355F1.8020406@helmutauer.de>
Date: Thu, 25 Dec 2008 10:44:18 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49293640.10808@cadsoft.de>
	<492A53C4.5030509@makhutov.org>	<492DC5F5.3060501@gmx.de>
	<494FC15C.6020400@gmx.de>
In-Reply-To: <494FC15C.6020400@gmx.de>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

Hello Udo
> After some insights to S2API interface, this looks even better to me:
>
> properties.num = 1;
> properties.props[0].cmd = DTV_DELIVERY_SYSTEM;
> properties.props[0].u.data = SYS_DVBS2;
> if (ioctl(d, FE_CAP_SET_PROPERTY, &properties) >= 0) {
>      // has S2 capability
> }
>
> A generic frontend test function that delivers the necessary S2 
> capability information, and many other capabilities too. And there are a 
> lot more delivery systems that seem to be hard to detect, so a query 
> function 'can do SYS_XXXX' seems necessary anyway.
>
>
>   
That's a good approach, but I doubt that anyone takes care of it.
This mailing list is like WOM (Write only Memory) when you post patches 
or make suggestions :(

-- 
Helmut Auer, helmut@helmutauer.de 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
