Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-4.orange.nl ([193.252.22.249])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1Kj74n-0003U3-Lm
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 08:45:19 +0200
Message-ID: <48DC84D5.2030504@verbraak.org>
Date: Fri, 26 Sep 2008 08:44:37 +0200
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48DB3388.2030303@verbraak.org>
	<1222389776.2762.35.camel@morgan.walls.org>
In-Reply-To: <1222389776.2762.35.camel@morgan.walls.org>
Subject: Re: [linux-dvb] [RFC] Let the future decide between the two.
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

Andy Walls schreef:
> On Thu, 2008-09-25 at 08:45 +0200, Michel Verbraak wrote:
>   
>> I have been following the story about the discussion of the future of 
>> the DVB API for the last two years and after seen all the discussion I 
>> would like to propose the following:
>>
>> - Keep the two different DVB API sets next to one another. Both having a 
>> space on Linuxtv.org to explain their knowledge and how to use them.
>> - Each with their own respective maintainers to get stuff into the 
>> kernel. I mean V4L had two versions.
>> - Let driver developers decide which API they will follow. Or even 
>> develop for both.
>> - Let application developers decide which API they will support.
>> - Let distribution packagers decide which API they will have activated 
>> by default in their distribution.
>> - Let the end users decide which one will be used most. (Probably they 
>> will decide on: Is my hardware supported or not).
>>     
>
> Having two API's is a software maintenance burden both for kernel
> developers and application dev's that want their stuff to "just work"
> for the end user in all situations.
>
> The purpose of an API is to insulate apps developers from kernel
> changes.  What you propose is, I would think, the worst case scenario
> for an application developer: an API that can change completely out from
> under them at any time (e.g. at the choice of a distribution packager).
>
> If you really want that sort of choice for application developers, you
> would build a library that is a thunking layer to present a different
> API to the app than the in kernel API.  (I am not a serious application
> developer, but for what it's worth, I don't think I would bother with
> that unless I had a large complex app already written.)
>
> Regards,
> Andy
>
>   
Andy,

I agree that the best solution is to have one working API (Application 
Programming interface). But as we live in a complex world  we see the 
same social events happening on the Linux DVB ML as in the real world 
where we have two groups who think and say their solution is the best 
and none is willing to cooperate with one another. We see a fight about 
which group is the strongest measured by send in patches or who is able 
to attend a single meeting.

The main thing is that we have hardware developers who, I think, would 
like their hardware being used by end users.  They spend time in 
developing their hardware but do not sponsor developers to get the 
hardware working in non Windows environments. The reason for this is 
simple Windows is used most and more profitable. What I hear on this ML 
is that the linux DVB developers do it in their free time and this, I 
think, is not completely true. I think that for most of the current 
developers that also respond on this mailing list there is a commercial 
benefit in it to them or some company and we the end users must be happy 
with whatever they produce or not produce.

What I would like to know from the current Linux DVB driver developers 
is who is working for which company and gets paid for his work. If their 
employers/contracters would like to have one common API they would 
arrange that the developers could meet more.

With DVB on linux we have different groups with different solutions for 
different hardware but each hardware group has a (partial) working 
solution. I as an end user will choose one of the hardware groups based 
on price and user experience and follow the solution for this group.

I as an end user will make the descision on what I think is best for me.

Regards,

Michel.

>> - If democracy is that strong one of them will win or maybey the two 
>> will get merged and we, the end users, get best of both worlds.
>>     
>
>
>   
>> As the subject says: This is a Request For Comment.
>>
>> Regards,
>>
>> Michel (end user and application developer).
>>     
>
>
>   



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
