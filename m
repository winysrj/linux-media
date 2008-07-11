Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BNgn3w008762
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 19:42:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BNgUuS011881
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 19:42:30 -0400
Date: Fri, 11 Jul 2008 20:42:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20080711204217.5edfaf64@gaivota>
In-Reply-To: <20080630150437.1c61dc08@bike.lwn.net>
References: <20080630205739.74EE1FAA95@dev.laptop.org>
	<20080630150437.1c61dc08@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] OV7670: don't reject unsupported settings
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

Hi Jonathan,

Sorry for not answering before. I was sick those days.

On Mon, 30 Jun 2008 15:04:37 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> On Mon, 30 Jun 2008 16:57:39 -0400 (EDT)
> Daniel Drake <dsd@laptop.org> wrote:
> 
> 
> > This patch makes ov7670 meet that behaviour, and brings it in line
> > with other drivers e.g. stk-webcam. It also fixes compatibility with
> > (unpatched) gstreamer.
> > 
> > Signed-off-by: Daniel Drake <dsd@laptop.org>
> 
> Mauro, I think this is your call - what *is* the desired behavior when
> applications ask for something that the hardware can't provide?

Both behaviours are right, according with the API. In general, drivers that
support just one or a few formats return whatever it supports. This allows a faster
format selection. In fact, most webcam drivers do this.

> I do know that quite a few applications will likely interpret a successful
> return as "I got what I asked for" without checking the actual returned
> format.  But, then, quite a few of them don't bother checking the
> return value either...

We shouldn't expect to solve an userspace trouble at kernelspace. Since the API
allows both ways, the userspace code should check the return format for this ioctl.

> Anyway, if the behavior is correct, add:
> 
> 	Acked-by: Jonathan Corbet <corbet@lwn.net>

Ok, I'll add it.
> 
> jon




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
