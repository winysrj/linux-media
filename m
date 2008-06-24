Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OLaUpF017152
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 17:36:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OLaJrG022683
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 17:36:19 -0400
Date: Tue, 24 Jun 2008 18:36:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080624183601.235ff1d5@gaivota>
In-Reply-To: <200806240033.41145.laurent.pinchart@skynet.be>
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] Thread safety of ioctls
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

> > Can I enable more logging than setting the trace parameter to 0xfff?
> 
> No without adding more printk's to the driver, which I encourage you to do.

This would be one advantage of having uvc driver using video_ioctl2. to see
ioctl's it is just a matter of using debug=1. If you use debug=3, you'll also
view all arguments of the ioctl.

Cheers,
Mauro

PS.: I'm still waiting for uvc patches for its kernel addition.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
