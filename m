Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69A1Kle011626
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 06:01:20 -0400
Received: from smtp6.pp.htv.fi (smtp6.pp.htv.fi [213.243.153.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69A162V017980
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 06:01:07 -0400
Date: Wed, 9 Jul 2008 13:00:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080709100008.GA6458@cs181140183.pp.htv.fi>
References: <200807081750.39305.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807081750.39305.hverkuil@xs4all.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Propose removal of the PLANB driver
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

On Tue, Jul 08, 2008 at 05:50:39PM +0200, Hans Verkuil wrote:
> Hi all,
> 
> The PlanB driver ("PlanB Video-In on PowerMac") has been marked as 
> broken for ages. No one seems to care about it. I propose to mark this 
> driver for removal in 2.6.28 as well.

It's broken for ages, and if there's agreement about the removal there's 
no need to wait for 2.6.28.

> Comments?

When I proposed removing removing it last year Benjamin Herrenschmidt 
(Cc'ed) said he'll have a look. [1]

Benjamin?

> 	Hans

cu
Adrian

[1] http://lkml.org/lkml/2007/1/4/265

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
