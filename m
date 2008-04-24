Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3O2PY12001599
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 22:25:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3O2OvOU015951
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 22:24:57 -0400
Date: Wed, 23 Apr 2008 22:24:55 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: mkrufky@linuxtv.org
In-Reply-To: <480F7A0E.2080202@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
References: <480F7A0E.2080202@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, video4linux-list@redhat.com,
	biercenator@gmail.com, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
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

>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>
>> In this case, it should be reviewed-by.
>>
>> I should be sending this soon to Linus.
>
>
> Mauro,
>
> I think it's wrong that you alter signatures.  You did this:
>
> Reviewed-by: <mkrufky@linuxtv.org <mailto:mkrufky@linuxtv.org>>

Argh! I didn't notice that weird stuff. This should be fixed before 
forwarding the patch. Sorry for the mess.

> But I provided this:
>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>
> I sign the patch, because I have handled it in my -stable queue.

SOB is the proper tag for your -stable queue. However, asking me to add 
this to my tree is not what it is expected.

SOB is meant to track the patch history until it reaches the kernel. So, 
the first SOB(s) is(are) from its author(s). The author(s) will send this 
to a driver maintainer, that will send to a subsystem maintainer, etc, 
until reach mainstream.

In the case of this patch, it was sent to the ML. Hans picked it, as the 
maintainer of ivtv, and asked me to pull.

You didn't wrote the patch, not forwarded it to me, so, the tag doesn't 
apply on my tree.

After the merge at mainstream, you'll send this to stable. In this case, 
you'll take it from my tree, add your SOB, and forward it.

Unfortunately, it is a common mistake of people sending SOB's instead of 
acked-by or reviewed-by, so several maintainers warns about the improper 
usage of the tags and corrects it on their trees, or simply ignores such 
improper usage.

If you prefer, I may just drop the tag from my tree, or fix the 
"reviewed-by".

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
