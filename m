Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4NFtQGD010051
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 11:55:26 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4NFtF0h004625
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 11:55:15 -0400
Date: Fri, 23 May 2008 16:39:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Message-ID: <20080523163956.6e93746c@core>
In-Reply-To: <9027.1211551014@vena.lwn.net>
References: <20080522223700.2f103a14@core>
	<9027.1211551014@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL
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

> On the other hand, the next level of BKL pushdown would be painful as
> all hell, given the massive number of callbacks in the V4L2 API.  So I'm
> thinking it might be justified to create a video_ioctl2_locked() for
> V4L2 drivers which are not yet known to be safe in the absence of the
> BKL.  The amount of extra code would be quite small, and it would let
> safe drivers operate BKL-free.

The problem is that currently they are almost all unsafe - I did a quick
survey as part of the changes. Pushing it down to the video2_ioctl is a
starting point, but the v4l layer is going to need a lot of love and its
own gradual migration.

Right now we've gone from BKL buried in fs to BKL at top of v4l layer
which is indeed only a starting point. I'd assumed the same as you are
think a new video_ioctl2 and switching drivers one by one (I was assuming
adding video2_ioctl_unlocked())

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
