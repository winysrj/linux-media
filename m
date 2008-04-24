Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3O33nUr015247
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 23:03:50 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3O33cdb004999
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 23:03:38 -0400
Message-ID: <480FF883.7030708@linuxtv.org>
Date: Wed, 23 Apr 2008 23:03:31 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <480F7A0E.2080202@linuxtv.org>
	<Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Mauro Carvalho Chehab wrote:
>>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>>
>>> In this case, it should be reviewed-by.
>>>
>>> I should be sending this soon to Linus.
>>
>>
>> Mauro,
>>
>> I think it's wrong that you alter signatures.  You did this:
>>
>> Reviewed-by: <mkrufky@linuxtv.org <mailto:mkrufky@linuxtv.org>>
>
> Argh! I didn't notice that weird stuff. This should be fixed before
> forwarding the patch. Sorry for the mess.
>
> [snip]
>
> After the merge at mainstream, you'll send this to stable. In this
> case, you'll take it from my tree, add your SOB, and forward it.
>
> Unfortunately, it is a common mistake of people sending SOB's instead
> of acked-by or reviewed-by, so several maintainers warns about the
> improper usage of the tags and corrects it on their trees, or simply
> ignores such improper usage.

Good point.
>
> If you prefer, I may just drop the tag from my tree, or fix the
> "reviewed-by".

Perhaps it makes most sense to just drop my tag, in this case  -- that's
fine with me.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
