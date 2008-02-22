Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JSUtD-0001Av-6S
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 11:12:23 +0100
Received: from [172.21.103.233] (nat-1.rz.uni-karlsruhe.de [129.13.72.153])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 01B9944328
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 11:12:19 +0100 (CET)
Message-ID: <47BEA002.2080409@okg-computer.de>
Date: Fri, 22 Feb 2008 11:12:18 +0100
From: =?ISO-8859-15?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47BDA96B.7080700@okg-computer.de>	<200802212208.05930.dkuhlen@gmx.net>	<47BE095E.3040301@okg-computer.de>
	<200802221106.45303.dkuhlen@gmx.net>
In-Reply-To: <200802221106.45303.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
 STB0899)
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

Dominik Kuhlen schrieb:
> Hi,
>
> -----snip----
>   
>> Great, that was the trick, now scanning and szap work fine.
>>
>> Thanks for that hint!
>>     
> You're welcome.
>
> BTW: do you receive broken streams  (symbol rate 22000 or 27500)?
> Currently I get a loss of about 1 TS packet every second or even more (with both symbol rates).
> And there is exactly one TS packet missing (I diffed a TS hexdump).
> If it were the USB controller that drops packets it would be a loss of 5 consecutive TS packets. (940 bytes iso frame size)
>   


I will test it soon and give a report.

Jens

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
