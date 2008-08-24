Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7OF4Dvc008972
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 11:04:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7OF3hTw003228
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 11:03:43 -0400
Date: Sun, 24 Aug 2008 11:58:35 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808241634.36653.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0808241152400.2897@areia>
References: <48AF1E83.4000102@nachtwindheim.de>
	<Pine.LNX.4.64.0808241045530.2897@areia>
	<200808241634.36653.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
	Henne <henne@nachtwindheim.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L: fix retval in vivi driver for more than one device
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

> Please note that I am working on creating a much improved V4L
> infrastructure to take care of such things. It's simply nuts that v4l
> drivers need to put in all the plumbing just to be able to have
> multiple instances.
>
> In particular, all these limitations on the number of instances should
> disappear (unless you run out of minors).

If you use vivi with a large number of devs (for example, 128), you'll run 
out of minors, since we currently have only 64 for video grabber. Due to 
the videodev limits, in fact, we can allocate "only" 32 virtual devices 
per driver.

Even with the changes on V4L infrastructure, vivi driver still doesn't do 
the right thing if you use a large number of devs.

I'm currently fixing the "vivi" driver and adding some notes on it about 
the current limits.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
