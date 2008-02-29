Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVE67-0002Mk-2Z
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 23:52:59 +0100
Message-ID: <47C88CBF.7010304@gmail.com>
Date: Sat, 01 Mar 2008 02:52:47 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <47BDA96B.7080700@okg-computer.de>	<47BE095E.3040301@okg-computer.de>	<200802221106.45303.dkuhlen@gmx.net>
	<200802292325.17473.dkuhlen@gmx.net>
In-Reply-To: <200802292325.17473.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
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

Dominik Kuhlen wrote:
> On Friday 22 February 2008, Dominik Kuhlen wrote:
>> Hi,
>>
>> -----snip----
>>> Great, that was the trick, now scanning and szap work fine.
>>>
>>> Thanks for that hint!
>> You're welcome.
>>
>> BTW: do you receive broken streams  (symbol rate 22000 or 27500)?
>> Currently I get a loss of about 1 TS packet every second or even more (with both symbol rates).
>> And there is exactly one TS packet missing (I diffed a TS hexdump).
>> If it were the USB controller that drops packets it would be a loss of 5 consecutive TS packets. (940 bytes iso frame size)
> 
> I have to correct that statement (I didn't record the whole TS): 
> The loss is exactly one USB frame (5 consecutive TS packets in this case)
> which happens about every 1000 TS packets (200 USB frames)


Is it really isochronous transfer that the device really uses in it's
default mode ? I guess many vendors prefer bulk transfers for the
default transfer mode ?

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
