Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FDwF8I008622
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:58:15 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au
	(outbound.icp-qv1-irony-out4.iinet.net.au [203.59.1.150])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FDvud4011887
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:57:58 -0400
Message-ID: <48551FE5.6090209@iinet.net.au>
Date: Sun, 15 Jun 2008 21:57:57 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <48513259.6030003@iinet.net.au>	<20080615083447.4d288a9e@gaivota>	<4855044D.7000702@iinet.net.au>	<4855085A.8070002@iinet.net.au>	<20080615092942.312627a1@gaivota>	<485517D8.5040607@iinet.net.au>
	<20080615103739.526659ff@gaivota>
In-Reply-To: <20080615103739.526659ff@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506
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

Mauro Carvalho Chehab wrote:
> On Sun, 15 Jun 2008 21:23:36 +0800
> timf <timf@iinet.net.au> wrote:
>  
>   
>> Invisible whitespaces! Grrr!
>>     
>
> Happens all the time :)
>
>  "make whitespace" clears it.
>  
>   
>> timf@ubuntu:~/1/try2$ diff -upr v4l-dvb v4l-dvb-tim > tim.patch
>> timf@ubuntu:~/1/try2$ cd v4l-dvb-tim
>> timf@ubuntu:~/1/try2/v4l-dvb-tim$ make checkpatch
>> make -C /home/timf/1/try2/v4l-dvb-tim/v4l checkpatch
>> make[1]: Entering directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
>> scripts/check.pl -c
>> # WARNING: /lib/modules/`uname -r`/build/scripts/checkpatch.pl version 
>> 0.12 is
>> #         older than scripts/checkpatch.pl --no-tree version 0.16.
>> #          Using in-tree one.
>> #
>> make[1]: Leaving directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
>> timf@ubuntu:~/1/try2/v4l-dvb-tim$
>>
>> My confidence is shot to pieces, you realise!
>>
>> Attached - tim.patch
>>
>> Please, please work!
>>     
>
> Worked ;)
>
> Patch applied, thanks. 
>
> Now, all we need to do is to make tda1004x more stable. The weird thing is that
> it works fine with my Intel based notebook. It just fails on my dual core AMD,
> with a higher clock. I suspect that this is due to a timeout issue, but not
> 100% sure.
>
>
> Cheers,
> Mauro
>
>   
Fantastic!

I have an old box which I'm pretty sure has a cpu about 1.6, non-dual core.
Tomorrow,  (too much noise at this hour of night here!)  I will try 
either/or Kworld 210, Pinnacle 310i, Kworld 220.
I will  try  both current v4l-dvb and that patch of yours in  
tda10046x.c, and see what happens.

Is it worth trying different msleep values?

All I can think of is this is a relatively recent event with this 
"revision FF" business,
but I can't be exact as to how long ago I noticed it.

Regards,
Timf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
