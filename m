Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53LLar2023145
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:21:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53LLEaG005914
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:21:14 -0400
Date: Tue, 3 Jun 2008 18:20:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080603182052.1080408e@gaivota>
In-Reply-To: <1212346919.3294.6.camel@palomino.walls.org>
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
	<200806011215.11489.hverkuil@xs4all.nl>
	<1212346919.3294.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] cx18: convert driver to video_ioctl2() (Re: [PATCH]
 video4linux: Push down the BKL)
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

On Sun, 01 Jun 2008 15:01:59 -0400
Andy Walls <awalls@radix.net> wrote:

> On Sun, 2008-06-01 at 12:15 +0200, Hans Verkuil wrote:
> 
> 
> > Thanks Andy!
> > 
> > I'll take a closer look on Tuesday or Wednesday, but I noticed one 
> > thing: you set unused callbacks to NULL in cx18_set_funcs(), however 
> > these can just be removed as they are NULL by default.
> 
> Yeah, they can go.  I left them in as an aid for double checking that I
> didn't forget any callbacks that needed to be implemented.

Please don't do that. All static vars that have a value 0 or NULL shouldn't be
initialized, since this will eat some space inside the module.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
