Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QFfgvA023011
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 10:41:42 -0500
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QFfAYe003644
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 10:41:11 -0500
Date: Tue, 26 Feb 2008 15:41:02 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080226154102.GD30463@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
	<20080219111640.409870a9@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219111640.409870a9@gaivota>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Bongani Hlope <bonganilinux@mweb.co.za>
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
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

> Bisecting this won't be that easy. The support for the depreciated V4L1 API
> were removed from bttv driver. Now, it uses v4l1-compat module, that translates
> a V4L1 call into a V4L2 one. I'll try to seek for troubles at the current code.

I think I might have seen this problem but it didn't cause a oops for
me, just that the radio program would hang waiting for the ioctl syscall
to return.  I did tried looking for a new radio program that used the
V4L2 API but couldn't find one.  I'll have a more in-depth look at the
bttv driver when I get home tonight.

Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
