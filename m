Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58AU6Pp029329
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 06:30:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58ATrfm014832
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 06:29:53 -0400
Date: Sun, 8 Jun 2008 07:29:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20080608072942.59d495f8@gaivota>
In-Reply-To: <20080607224835.GA25025@joi>
References: <20080607224835.GA25025@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and oops)
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

On Sun, 8 Jun 2008 00:48:40 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> While looking for a reason of multiple oopses in empress_querycap as reported
> by kerneloops.org I noticed that only first open of device initializes
> struct_file->private_data properly. (Closing the device was broken too).
> 
> So initialize private_date and free all resources on last close.
> I think this change will fix oops in empress_querycap.
> 
> http://kerneloops.org/guilty.php?guilty=empress_querycap&version=2.6.25-release&start=1671168&end=1703935&class=oops
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: video4linux-list@redhat.com
> ---
> 
> Compile tested only. Please test on real hardware.

Thanks.

The patch looks sane to my eyes. I'll apply at the tree, in order to allow more
people to test it.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
