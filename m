Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6OEwLMc003919
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 10:58:22 -0400
Received: from mail-bw0-f216.google.com (mail-bw0-f216.google.com
	[209.85.218.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6OEw4YV021980
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 10:58:04 -0400
Received: by bwz12 with SMTP id 12so1452608bwz.3
	for <video4linux-list@redhat.com>; Fri, 24 Jul 2009 07:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090723201823.GS11865@vanheusden.com>
References: <20090717174101.GB15611@vanheusden.com>
	<20090723165929.64cf3933@pedra.chehab.org>
	<20090723201823.GS11865@vanheusden.com>
Date: Fri, 24 Jul 2009 17:58:03 +0300
Message-ID: <36c518800907240758k2a1d8e9btdd841323e4dc2492@mail.gmail.com>
From: vasaka@gmail.com
To: Folkert van Heusden <folkert@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: video4linux loopback device
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

On Thu, Jul 23, 2009 at 11:18 PM, Folkert van
Heusden<folkert@vanheusden.com> wrote:
>> > Any chance that the video4linux loopback device will be integrated in
>> > the main video4linux distribution and included in the kernel?
>> > http://www.lavrsen.dk/foswiki/bin/view/Motion/VideoFourLinuxLoopbackDevice
>> > or
>> > http://sourceforge.net/projects/v4l2vd/
>> > or
>> > http://code.google.com/p/v4l2loopback/
>> > This enables userspace postprocessors to feed the altered stream to
>> > applications like amsn and skype for videochats.
>> If the postprocessor application is LGPL, the better is to add it at libv4l.
>
> I don't agree as the postprocessor implements fun-effects: warhol,
> puzzle, circles, wobble, etc.
>
>
> Folkert van Heusden
>
> --
> Looking for a cheap but fast webhoster with an excellent helpdesk?
> http://keetweej.vanheusden.com/redir.php?id=1001
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

and how one can make skype to get pictue from libv4l or alter the
picture which application is getting through libv4l?
again some proxy is needed here.

vasaka

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
