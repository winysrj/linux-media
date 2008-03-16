Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JavPY-00066k-Fs
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 17:08:37 +0100
Message-ID: <47DD45FE.3030702@gmail.com>
Date: Sun, 16 Mar 2008 20:08:30 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <47BDA96B.7080700@okg-computer.de>	<200802292325.17473.dkuhlen@gmx.net>
	<47C88CBF.7010304@gmail.com> <200803161603.24956.dkuhlen@gmx.net>
In-Reply-To: <200803161603.24956.dkuhlen@gmx.net>
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
> Hi,
> 
> The attached pctv452e.c works for me without frame drops in DVB-S and DVB-S2.
> 
> On Friday 29 February 2008, Manu Abraham wrote:
>> Dominik Kuhlen wrote:
>>> On Friday 22 February 2008, Dominik Kuhlen wrote:
>>>> Hi,
>>>>
>>>> -----snip----
>>>>> Great, that was the trick, now scanning and szap work fine.
>>>>>
>>>>> Thanks for that hint!
>>>> You're welcome.
>>>>
>>>> BTW: do you receive broken streams  (symbol rate 22000 or 27500)?
>>>> Currently I get a loss of about 1 TS packet every second or even more (with both symbol rates).
>>>> And there is exactly one TS packet missing (I diffed a TS hexdump).
>>>> If it were the USB controller that drops packets it would be a loss of 5 consecutive TS packets. (940 bytes iso frame size)
>>> I have to correct that statement (I didn't record the whole TS): 
>>> The loss is exactly one USB frame (5 consecutive TS packets in this case)
>>> which happens about every 1000 TS packets (200 USB frames)
> The problem seems to be  wrong initial config parameter set in init_s1_demod table.
> I copied this table from the mantis 1041 and it seems to be working now.
> (I should probably check the USB logs and use these values.)
> The first tuning after powerup/init fails quite often for me but the folllowings are fine
> even switching from DVB-S to DVB-S2 works like a charm.


Nice to know it works great. Should i pull the patch into the multiproto 
tree to
make it easier, since it works as expected ?

Also, can you test DVB-S2, a 30MSPS stream whether it works as expected ?
(in case you have access to such a transponder ?)

Currently, i have mixed results, so some amount of further test results 
would
be quite nice

>> Is it really isochronous transfer that the device really uses in it's
>> default mode ? I guess many vendors prefer bulk transfers for the
>> default transfer mode ?
> There's a bulk pipe but it's only used for setup/control afaik.
> 
> 
> Happy testing,
> Dominik
> 
> 
> BTW: why is the mantis development in a separate HG repo?
>  I merged the mantis driver to the multiproto repo and can use the
>  mantis-1041 and pctv452e simultanously :)

I do expect quite some changes to the mantis bridge and have been touching
very much mantis/bridge specific changes in that tree. Additionally, i 
plan to push
out multiproto prior to mantis, so both in one tree will make it a bit 
messy.


Regards,
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
