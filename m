Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R1hQ0Y007323
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:43:26 -0500
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R1gmBw017895
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:42:49 -0500
Date: Wed, 27 Feb 2008 01:42:38 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080227014238.GA2685@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
	<20080219111640.409870a9@gaivota>
	<20080226154102.GD30463@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226154102.GD30463@localhost>
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

> I think I might have seen this problem but it didn't cause a oops for
> me,

Ok, I found the cause of the oops.  Some of radio tuner code was
expecting a struct bttv_fh to be allocated but this wasn't done in
radio_open.  So it would dereference an invalid data structure, causing
a hang for me and an oops for Bongani.  I also had to add support for
the radio tuner to some shared functions.  Patches to follow.

Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
