Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FCvXqc015785
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 08:57:33 -0400
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FCvMWG029193
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 08:57:22 -0400
Message-ID: <482C3324.1020804@linuxtv.org>
Date: Thu, 15 May 2008 08:57:08 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <482858AD.1050504@linuxtv.org>
	<1210818265.3202.25.camel@palomino.walls.org>
In-Reply-To: <1210818265.3202.25.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mkrufky@linuxtv.org, Stoth@hauppauge.com
Subject: Re: cx18-0: ioremap failed, perhaps increasing __VMALLOC_RESERVE
 in page.h
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Andy Walls wrote:
> On Mon, 2008-05-12 at 10:48 -0400, mkrufky@linuxtv.org wrote:
>   
>> Steven Toth wrote:
>>     
>>> Steven Toth wrote:
>>>       
>>>>>         if (cx->dev)
>>>>>                 cx18_iounmap(cx);
>>>>>           
>>>> This doesn't feel right.
>>>>         
>>> Hans / Andy,
>>>
>>> Any comments?
>>>       
>> For the record, I've tested again with today's tip ( d87638488880 ) -- 
>> same exact behavior.
>>
>> When I load the modules for the first time, everything is fine.
>>
>> If I unload the cx18 module, I am unable to load it again, the same 
>> error is displayed as I posted in my original message.
>>     
>
> Mike,
>
> Could you apply the attached patch and run this test
>
> 	(precondition: cx18.ko hasn't been loaded once yet)
> 	# cat /proc/iomem /proc/meminfo > ~/memstats
> 	# modprobe cx18 debug=3
> 	# cat /proc/iomem /proc/meminfo >> ~/memstats
> 	# modprobe -r cx18
> 	# cat /proc/iomem /proc/meminfo >> ~/memstats
> 	# modprobe cx18 debug=3
> 	# cat /proc/iomem /proc/meminfo >> ~/memstats
>
> and provide the contents of dmesg (or /var/log/messages) and memstats?
>
> The patch will let me see if the contents of cx->enc_mem are bogus on
> iounmap() and if iounmap() is even being called.
>
> I also want to verify that "cx18 encoder" doesn't get removed
> from /proc/iomem and that "VmallocUsed" doesn't return to it's previous
> size when the module is unloaded.  That would show that the iounmap()
> fails.
>
> I'd also want to ensure there is no overlap in /proc/iomem with "cx18
> encoder" and something else.  The kernel should prevent it, but I want
> to make sure.
>
>
> (Hopefully the patch applies cleanly, the line numbers won't quite match
> up with the latest hg version.)
>
> Regards,
> Andy
>
>   
>> Regards,
>>
>> Mike
>>
>>     
>> ------------------------------------------------------------------------
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list







Andy,

I'm out of town right now, and things will be hectic when I get 
back....  I most likely won't get to this until the middle of the week, 
perhaps even next weekend.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
