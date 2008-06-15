Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FDc56M002473
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:38:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FDbmuI003539
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:37:49 -0400
Date: Sun, 15 Jun 2008 10:37:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080615103739.526659ff@gaivota>
In-Reply-To: <485517D8.5040607@iinet.net.au>
References: <48513259.6030003@iinet.net.au> <20080615083447.4d288a9e@gaivota>
	<4855044D.7000702@iinet.net.au> <4855085A.8070002@iinet.net.au>
	<20080615092942.312627a1@gaivota> <485517D8.5040607@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

On Sun, 15 Jun 2008 21:23:36 +0800
timf <timf@iinet.net.au> wrote:
 
> Invisible whitespaces! Grrr!

Happens all the time :)

 "make whitespace" clears it.
 
> timf@ubuntu:~/1/try2$ diff -upr v4l-dvb v4l-dvb-tim > tim.patch
> timf@ubuntu:~/1/try2$ cd v4l-dvb-tim
> timf@ubuntu:~/1/try2/v4l-dvb-tim$ make checkpatch
> make -C /home/timf/1/try2/v4l-dvb-tim/v4l checkpatch
> make[1]: Entering directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
> scripts/check.pl -c
> # WARNING: /lib/modules/`uname -r`/build/scripts/checkpatch.pl version 
> 0.12 is
> #         older than scripts/checkpatch.pl --no-tree version 0.16.
> #          Using in-tree one.
> #
> make[1]: Leaving directory `/home/timf/1/try2/v4l-dvb-tim/v4l'
> timf@ubuntu:~/1/try2/v4l-dvb-tim$
> 
> My confidence is shot to pieces, you realise!
> 
> Attached - tim.patch
> 
> Please, please work!

Worked ;)

Patch applied, thanks. 

Now, all we need to do is to make tda1004x more stable. The weird thing is that
it works fine with my Intel based notebook. It just fails on my dual core AMD,
with a higher clock. I suspect that this is due to a timeout issue, but not
100% sure.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
