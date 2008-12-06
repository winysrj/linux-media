Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6A6ILD011285
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:06:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6A64d8030156
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:06:04 -0500
Date: Sat, 6 Dec 2008 08:05:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Message-ID: <20081206080555.6764076d@pedra.chehab.org>
In-Reply-To: <208cbae30812051604t6d74a0cbr4177262324563688@mail.gmail.com>
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
	<1227410369.16932.31.camel@tux.localhost>
	<30353c3d0811240635t3649fa2bk5f5982c4d3d6e87c@mail.gmail.com>
	<1227787210.11477.7.camel@tux.localhost>
	<30353c3d0811292119y226c5af3tb63dbf130da59c69@mail.gmail.com>
	<208cbae30812051604t6d74a0cbr4177262324563688@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [PATCH 1/1] radio-mr800: fix unplug
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


On Sat, 6 Dec 2008 03:04:49 +0300
"Alexey Klimov" <klimov.linux@gmail.com> wrote:


> Mauro, should i make patch for current hg-tree ?

Yes.

> Probably this thing should go to current upstream, because it will fix an oops.
> I start working to fix the same oops in dsbr100 module.

So, you need to hurry! We are already at -rc7.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
