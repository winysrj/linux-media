Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H6nEDl011951
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 02:49:14 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H6n1M7020870
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 02:49:01 -0400
Received: by wx-out-0506.google.com with SMTP id t16so2278585wxc.6
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 23:49:01 -0700 (PDT)
Message-ID: <1dea8a6d0804162349n271b028bgf2b709d7bb19efa1@mail.gmail.com>
Date: Thu, 17 Apr 2008 14:49:00 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: stuart <stuart.partridge@gmail.com>
In-Reply-To: <3a4a99ca0804162333p1d08e308ufea59a2cd40edd19@mail.gmail.com>
MIME-Version: 1.0
References: <3a4a99ca0804162333p1d08e308ufea59a2cd40edd19@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Fusion/DVICO HDTV Dual 4 not working and crashing lsusb
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

On Thu, Apr 17, 2008 at 2:33 PM, stuart <stuart.partridge@gmail.com> wrote:

> I've had a look around the archives and can't see anything that matches my
> sitch.
>
I have found that the driver for this card has been broken since a certain
change. Compiling from a revision before that change works fine for me, you
can find my post in the archives
http://marc.info/?l=linux-video&m=120716477703566&w=2 to see what revision
works.

Hopefully this works for you too.

- Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
