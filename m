Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32JZFve026267
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 15:35:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32JZ3pT009181
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 15:35:04 -0400
Date: Wed, 2 Apr 2008 16:34:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080402163418.5b250e04@gaivota>
In-Reply-To: <200804021914.13378.bonganilinux@mweb.co.za>
References: <20080330162006.GA6048@joi> <20080401171051.724a9f75@gaivota>
	<200804021914.13378.bonganilinux@mweb.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Morton <akpm@google.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
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


> I confirm that those patches fixed the bttv-driver for me, it was the 
> misapplied patch that caused the Oops. Please push to Linus and I'll ask 
> Rafael to close the bug as soon as it gets to mainline.

Linus already pulled the patches to mainstream, so, the bugs can be closed.

> Thanx for all your work Mauro and the V4L developers.

Thank you for your time reporting and testing the fixes.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
