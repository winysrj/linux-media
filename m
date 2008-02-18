Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IGC0k6026316
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 11:12:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1IGBdju010414
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 11:11:39 -0500
Date: Mon, 18 Feb 2008 13:11:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080218131125.2857f7c7@gaivota>
In-Reply-To: <200802171036.19619.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
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

On Sun, 17 Feb 2008 10:36:19 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> The bttv driver seems to be experiencing problems in the 2.6.25-rcX kernels. I 
> have the divided by error that  Robert Fitzsimons has already reported (I'll 
> test his patch and see if it fixes it for me) and I have the following Oops 
> when I try to use the radio:

Have you tested Robert's patch?

I can't see anything wrong on bttv_g_tuner lock. I suspect that the divide
error caused some bad effects at some data on bttv.

I've already applied his fix to my -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git

Hopefully, Linus will pull soon the fixes there.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
