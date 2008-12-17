Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHIUPK9016402
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:30:25 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHIUB5G002710
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:30:12 -0500
Date: Wed, 17 Dec 2008 19:30:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87iqpi4qb0.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0812171921420.8733@axis700.grange>
References: <1228166159-18164-1-git-send-email-robert.jarzmik@free.fr>
	<87iqpi4qb0.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: soc-camera: current stack (was Re: [PATCH] mt9m111: Add automatic
 white balance control)
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

On Wed, 17 Dec 2008, Robert Jarzmik wrote:

> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
> > Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> > ---
> >  drivers/media/video/mt9m111.c |   28 +++++++++++++++++++++++++++-
> >  1 files changed, 27 insertions(+), 1 deletions(-)
> 
> Hi Guennadi,
> 
> As I see you working for the next tree submission, I wonder if you had seen that
> patch a couple of days ago ?

Yes. My current stack is at

http://gross-embedded.homelinux.org/~lyakh/v4l-20081217/

the first 9 of those patch have been pushed upstream with a previous 
request.

Everyone who has contributed to soc-camera is kindly requested to have a 
look, if I have missed anything, besides, we should very well test it - 
there are a lot of changes there in the core and in all drivers.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
