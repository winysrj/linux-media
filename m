Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway05.websitewelcome.com ([64.5.38.5])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KYyTD-0000yA-TP
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 09:32:37 +0200
Received: from [77.109.104.26] (port=44905 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1KYyT0-00012W-K1
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 02:32:22 -0500
Message-ID: <48B7A60C.4050600@kipdola.com>
Date: Fri, 29 Aug 2008 09:32:28 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net>
In-Reply-To: <48B78AE6.1060205@gmx.net>
Subject: Re: [linux-dvb] Future of DVB-S2
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

P. van Gaans schreef:
> On 08/23/2008 10:05 PM, Hans Werner wrote:
>   
>>> An: linux-dvb@linuxtv.org, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
>>> Betreff: [linux-dvb] Future of DVB-S2
>>>       
>>> A question to the maintainer:
>>>
>>> what is your plan for getting DVB-S2 support into the mainline kernel?
>>>
>>> So many people have put so much time and effort into creating a working
>>> API, drivers and applications but I have seen no indications of the direction and timescale anywhere.
>>> All this work is of very little value if it does not end up in the
>>> mainline kernel. Maintaining out-of-kernel projects and patches over the long term is a terrible waste of effort for maintainers, developers and experienced users. It also makes Linux DVB look less than professional, and is almost worthless to most end users.
>>>
>>> Working code already exists but it needs to be managed into a form that can be merged with the kernel.
>>>       
>> It's disappointingly silent so far....
>>
>> ...
>>
>> Hopefully,
>> Hans
>>     
>
> I agree. I wanted to write about this earlier but didn't find time yet.
>
> ...
>
> [Manu] said this as well:
>
> "Users need to have some amount of patience. The developers do this
> mostly out of their free time. It is not that very simple to get
> devices working properly. Users pressurizing the developers to release
> early, brings in those half baked drivers, so a certain percentage of
> the attributes go to the users as well."
>
> Okay, I understand that. But it's taking really long now.
>
> Since multiproto exists, it must be known how to write a driver for the 
> S2-3200 and similar cards. There are patches for the TT S2-3600/3650 
> (USB) that I believe work quite well, but nothing it in-kernel or 
> anywhere close getting in-kernel. I believe there is also seperate code 
> for some other cards (mantis?).
>
> ...
>
> Multiproto requires every userspace application to be changed to support 
> it (and I heard the compatibility layer for non-S2 cards is a pain from 
> dev-POV). The change may not be huge but it's quite a price to pay, and 
> nobody wants to go through this again when another protocol becomes popular.
>
> If the answer is "yes", a decision should be made:
>
> DVB-S2 is getting more and more popular. Even with not too many DVB-S2 
> streams being around yet, when you're buying a new card right now, you 
> prefer to get DVB-S2 so you don't need to upgrade in the near future. 
> DVB-S2 needs (in-kernel) support relatively quickly. We can't wait for 
> multiproto for another 2 years. I see two options:
>
>
> 1. We decide multiproto is awesome, it's status is not that bad and the 
> future path. Fix it and put it in hg.
>
> 2. Multiproto is NOT the way to go in the future, or it's too messed up 
> and too much work to fix. In that case, forget about any other new 
> protocol other than DVB-S2 and port the drivers for the DVB-S2 cards to 
> hg. Apps will get patched soon enough as soon as S2 goes in-kernel.
>
> ...
>
> If it helps, I am willing to have one of the main developers of 
> linux-dvb borrow my TT S2-3200 to test stuff on. In fact, if some kind 
> of promise for in-kernel support in the short term can be made, I'm 
> willing to donate the card, because it is worthless to me right now.
>
> P.
>   
You're making excellent, valid points!

I just hope the developper understand US.
We know all about the "coding in your free time" and we can only have 
the highest respect for that, but the drivers are completely abandonded, 
and that's how we feel, too.

Forgive my ignorance, but wouldn't development have sped up 
siginificantly if multiproto had been integrated in hg?

Anyway, please, don't sacrifice your entire card!
I'd be willing to donate a bit, too. It's just way too important for me.





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
