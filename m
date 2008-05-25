Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4PNkg4s023589
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 19:46:42 -0400
Received: from cnc.isely.net (cnc.isely.net [64.81.146.143])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4PNkVHd006252
	for <video4linux-list@redhat.com>; Sun, 25 May 2008 19:46:31 -0400
Date: Sun, 25 May 2008 18:46:24 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080522223700.2f103a14@core>
Message-ID: <Pine.LNX.4.64.0805251835520.25571@cnc.isely.net>
References: <20080522223700.2f103a14@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Video4Linux list <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] video4linux: Push down the BKL
Reply-To: Mike Isely <isely@pobox.com>
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

On Thu, 22 May 2008, Alan Cox wrote:

> For most drivers the generic ioctl handler does the work and we update it
> and it becomes the unlocked_ioctl method. Older drivers use the usercopy
> method so we make it do the work. Finally there are a few special cases.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

The pvrusb2 driver already should not require the BKL.  Though since 
this driver (like every V4L driver) is using video_usercopy() then it's 
obviously going along for the ride here with respect to the overall 
issue here in pushing the lock down into video_usercopy().  In the mean 
time, for the pvrusb2 portion of this patch...

Acked-By: Mike Isely <isely@pobox.com>

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
