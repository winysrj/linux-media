Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3L4WnvY032241
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 00:32:49 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3L4Wdh1013595
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 00:32:39 -0400
Received: by fk-out-0910.google.com with SMTP id b27so2178392fka.3
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 21:32:38 -0700 (PDT)
Message-ID: <3a4a99ca0804202132s4612fb80y5171b6a5364a793d@mail.gmail.com>
Date: Mon, 21 Apr 2008 14:32:38 +1000
From: stuart <stuart.partridge@gmail.com>
To: "Ben Caldwell" <benny.caldwell@gmail.com>
In-Reply-To: <1dea8a6d0804201923o1e939935lb6a1b5ddd0f542a6@mail.gmail.com>
MIME-Version: 1.0
References: <3a4a99ca0804201807r65151edm464b7943caa7767e@mail.gmail.com>
	<1dea8a6d0804201923o1e939935lb6a1b5ddd0f542a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Connecting my working DVICO dual digi 4 to MythTV
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

 > This card should actually be configured as two cards in mythtv, so make
sure you have added a
 > second card in mythtvsetup.

Yes, have been treating it as two diff cards in MythTV, but still no joy no
matter what configs I choose for each.

> One other thing to watch is that your card device might have been created
with root access only,
> so you might have more luck just running the setup as root.

Have tried it as both the sudo and the regular user, but no good either way.

> It sounds like the driver for your card is working ok now, but if you are
still having problems with
> setup you'll probably get more help from a dedicated mythtv list.

Yes, you're right, this list (& yourself) has got me going with the install
+ system config of the card but it's defo time I found a list dedicated to
MythTV. Thought I'd give it a shot here in case someone knew the solution.

Thanks again.

>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
