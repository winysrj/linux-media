Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1KYwfY-0003ik-K8
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 07:37:15 +0200
Message-ID: <48B78AE6.1060205@gmx.net>
Date: Fri, 29 Aug 2008 07:36:38 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
In-Reply-To: <20080823200531.246370@gmx.net>
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

On 08/23/2008 10:05 PM, Hans Werner wrote:
>> An: linux-dvb@linuxtv.org, mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
>> Betreff: [linux-dvb] Future of DVB-S2
> 
>> A question to the maintainer:
>>
>> what is your plan for getting DVB-S2 support into the mainline kernel?
>>
>> So many people have put so much time and effort into creating a working
>> API, drivers
>> and applications but I have seen no indications of the direction and
>> timescale anywhere.
>>
>> All this work is of very little value if it does not end up in the
>> mainline kernel. Maintaining
>> out-of-kernel projects and patches over the long term is a terrible waste
>> of effort for
>> maintainers, developers and experienced users. It also makes Linux DVB
>> look less than
>> professional, and is almost worthless to most end users.
>>
>> Working code already exists but it needs to be managed into a form that
>> can be merged
>> with the kernel.
>>
>> So how is it going to be done? It's really not that hard.
> 
> Bump.
> 
> It's disappointingly silent so far....
> 
> In the interest of making progress I will be more specific.
>  
> It is easily possible to use the work that has already been done to quickly create (and debug
> and merge) kernel patches which will provide support for one or more DVB-S2 cards.
> 
> But before such patches can be created,  there needs to be a clear statement about
> which API changes (if any) will be permitted.
> 
> How will the API change? Who is going to make the decision? When?
> 
> Hopefully,
> Hans
> 

I agree. I wanted to write about this earlier but didn't find time yet.

I bought my TT S2-3200 august 2007, a little over 1 year ago. Look for a 
thread of mine called "[linux-dvb] TT S2-3200 stable, CI, go or no-go?". 
Here a now "funny" quote from Manu Abraham answering the question about 
when S2-support is coming to hg:

"Most probably, if all goes well sometime next month."

That was august 2007. So this obviously didn't happen.

He said this as well:

"Users need to have some amount of patience. The developers do this
mostly out of their free time. It is not that very simple to get
devices working properly. Users pressurizing the developers to release
early, brings in those half baked drivers, so a certain percentage of
the attributes go to the users as well.

It is not easy, when a user comes with a patch for something stating,
well this fixes issue "x" whereas in reality the patch has got nothing
to do with "x".

Moreover we have had just high noise levels alone rather than useful
talks, which hasd additional attributes for developments to crawl."

Okay, I understand that. But it's taking really long now.

Since multiproto exists, it must be known how to write a driver for the 
S2-3200 and similar cards. There are patches for the TT S2-3600/3650 
(USB) that I believe work quite well, but nothing it in-kernel or 
anywhere close getting in-kernel. I believe there is also seperate code 
for some other cards (mantis?).

Here are my thoughts:

I understood some stuff in multiproto is messy and that's why it's not 
getting in hg. And few if any people work on multiproto so it's not 
getting less messy. I would like to ask these questions:

Multiproto was made to support DVB-S2 and possibly some more stuff. Can 
multiproto easily be extended to support future protocols like DVB-T2, 
DVB-C2, DAB, DAB v2, FMeXtra, DMB and unknown future protocols? If the 
answer is NO, I believe even thoughts of getting multiproto to hg should 
be dropped immediately. Why?

Multiproto requires every userspace application to be changed to support 
it (and I heard the compatibility layer for non-S2 cards is a pain from 
dev-POV). The change may not be huge but it's quite a price to pay, and 
nobody wants to go through this again when another protocol becomes popular.

If the answer is "yes", a decision should be made:

DVB-S2 is getting more and more popular. Even with not too many DVB-S2 
streams being around yet, when you're buying a new card right now, you 
prefer to get DVB-S2 so you don't need to upgrade in the near future. 
DVB-S2 needs (in-kernel) support relatively quickly. We can't wait for 
multiproto for another 2 years. I see two options:


1. We decide multiproto is awesome, it's status is not that bad and the 
future path. Fix it and put it in hg.

2. Multiproto is NOT the way to go in the future, or it's too messed up 
and too much work to fix. In that case, forget about any other new 
protocol other than DVB-S2 and port the drivers for the DVB-S2 cards to 
hg. Also, make a small extension to v4l-dvb that makes it possible for 
an application to tell v4l-dvb that the upcoming frequency data is going 
to be DVB-S2 and it wants the tuner to go to DVB-S2 mode. If such a 
signal is NOT send, v4l-dvb should assume DVB-S so old unpatched 
applications work with new S2 cards. If applications want to support S2 
they will need to be patched to send the extra message, but some kind of 
patch for S2 for enduser apps is unavoidable anyway. It's no problem as 
long as unpatched apps can work with DVB-S. Apps will get patched soon 
enough as soon as S2 goes in-kernel.

If it helps, I am willing to have one of the main developers of 
linux-dvb borrow my TT S2-3200 to test stuff on. In fact, if some kind 
of promise for in-kernel support in the short term can be made, I'm 
willing to donate the card, because it is worthless to me right now.

P.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
