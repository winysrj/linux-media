Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1S9PtKY024244
	for <video4linux-list@redhat.com>; Thu, 28 Feb 2008 04:25:55 -0500
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1S9PMBe014804
	for <video4linux-list@redhat.com>; Thu, 28 Feb 2008 04:25:23 -0500
Date: Thu, 28 Feb 2008 09:25:12 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080228092512.GC2662@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080227014238.GA2685@localhost> <20080227014729.GC2685@localhost>
	<200802272345.43209.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802272345.43209.bonganilinux@mweb.co.za>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] bttv: Re-enabling radio support requires the use of
	struct bttv_fh.
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

> I have applied both your patches and my radio works, but my TV doesn't work 
> anymore (no picture or sound). But when I exit the radio program I get this 
> oops:

I've had a quick look and nothing stands out as the cause of the oops,
but I did notice that I introduced a small memory leak.  Over the next
day or so I'll have a look at Mauro's suggestion of combining the opens
like the cx88 driver.

Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
