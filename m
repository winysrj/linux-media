Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3J727DV029459
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 03:02:07 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3J71qTx027234
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 03:01:52 -0400
Received: by rv-out-0506.google.com with SMTP id k40so252364rvb.51
	for <video4linux-list@redhat.com>; Sun, 19 Apr 2009 00:01:52 -0700 (PDT)
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: "B. Moser" <sy@itakka.at>
In-Reply-To: <597D1543B3BA4400910B04E46280B6C3@wuschlbuschl>
References: <597D1543B3BA4400910B04E46280B6C3@wuschlbuschl>
Message-Id: <CF5BC408-3595-4B22-BF39-BF624B6D8F3E@gmail.com>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Date: Sun, 19 Apr 2009 16:01:48 +0900
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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

Hello Bernhard,

I suppose you to need a time machine feature like a brand new tele in  
these days.
I think you should make a new application on your own, that does  
buffering jobs, or you can do qbuf and dqbuf with a long term between  
them (but it should look like a series of still shots)
I prefer the first one.
Cheers,

Nate


2008. 06. 24, 오후 5:45, B. Moser 작성:

> I have a small problem - maybe someone out there can help me:
>
> I have a camera connected to my compuer ( /dev/video0 ).
> So far it is no problem to watch the pictures from the camera in  
> realtime
> (for example with mplayer or similar programs).
>
> But I want to watch on screen what this camera showed 5 seconds ago.
> So the pictures/video from this camera should go into a buffer -  
> which I
> would like to show on the monitor time-delayed a few seconds later.
>
> regards
> Bernhard
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
