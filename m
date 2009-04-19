Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3JBpMDk002811
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 07:51:22 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.188])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3JBp93N026345
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 07:51:09 -0400
Received: by fk-out-0910.google.com with SMTP id e30so808813fke.3
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 04:51:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CF5BC408-3595-4B22-BF39-BF624B6D8F3E@gmail.com>
References: <597D1543B3BA4400910B04E46280B6C3@wuschlbuschl>
	<CF5BC408-3595-4B22-BF39-BF624B6D8F3E@gmail.com>
Date: Sun, 19 Apr 2009 15:51:08 +0400
Message-ID: <208cbae30904190451ve1735d2rac3cb9e656645499@mail.gmail.com>
From: Alexey Klimov <klimov.linux@gmail.com>
To: Dongsoo Kim <dongsoo.kim@gmail.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, "B. Moser" <sy@itakka.at>
Subject: Re: how to get timedelayed pictures of camera on /dev/video0
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

Hello, all

2009/4/19 Dongsoo Kim <dongsoo.kim@gmail.com>:
> Hello Bernhard,
>
> I suppose you to need a time machine feature like a brand new tele in these
> days.
> I think you should make a new application on your own, that does buffering
> jobs, or you can do qbuf and dqbuf with a long term between them (but it
> should look like a series of still shots)
> I prefer the first one.
> Cheers,
>
> Nate

If you want to hack/write application you can use v4l2 loopback driver
+ userspace programs for that.
I asked Vasily Levin (he is on c/c) and he said that it's possible. His answer:
"I think my v4lsink(http://code.google.com/p/v4lsink/) program, given
the right gstreamer pipeline can do this."

> 2008. 06. 24, 오후 5:45, B. Moser 작성:
>
>> I have a small problem - maybe someone out there can help me:
>>
>> I have a camera connected to my compuer ( /dev/video0 ).
>> So far it is no problem to watch the pictures from the camera in realtime
>> (for example with mplayer or similar programs).
>>
>> But I want to watch on screen what this camera showed 5 seconds ago.
>> So the pictures/video from this camera should go into a buffer - which I
>> would like to show on the monitor time-delayed a few seconds later.
>>
>> regards
>> Bernhard

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
