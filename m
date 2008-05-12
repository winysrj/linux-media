Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CEmnC5001443
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:48:49 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CEmcEt010385
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:48:38 -0400
Message-ID: <482858AD.1050504@linuxtv.org>
From: mkrufky@linuxtv.org
To: stoth@linuxtv.org
Date: Mon, 12 May 2008 10:48:13 -0400
MIME-Version: 1.0
in-reply-to: <48285754.8010608@linuxtv.org>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: Stoth@hauppauge.com, video4linux-list@redhat.com
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

Steven Toth wrote:
> Steven Toth wrote:
>>>         if (cx->dev)
>>>                 cx18_iounmap(cx);
>>
>> This doesn't feel right.
>
> Hans / Andy,
>
> Any comments?

For the record, I've tested again with today's tip ( d87638488880 ) -- 
same exact behavior.

When I load the modules for the first time, everything is fine.

If I unload the cx18 module, I am unable to load it again, the same 
error is displayed as I posted in my original message.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
