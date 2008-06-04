Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 4 Jun 2008 06:02:13 -0400
From: Alan Cox <alan@redhat.com>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080604100213.GB30924@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
	<200806011215.11489.hverkuil@xs4all.nl>
	<1212346919.3294.6.camel@palomino.walls.org>
	<20080603182052.1080408e@gaivota>
	<20080603220828.GE30842@devserv.devel.redhat.com>
	<1212540270.3177.46.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212540270.3177.46.camel@palomino.walls.org>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Subject: Re: [ivtv-devel] [PATCH] cx18: convert driver to video_ioctl2()
	(Re: [PATCH] video4linux: Push down the BKL)
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

On Tue, Jun 03, 2008 at 08:44:30PM -0400, Andy Walls wrote:
> For the record, every pointer store looks something like this (before
> relocations) on 64-bit:
> 
>    1f9:       48 c7 87 c0 04 00 00    movq   $0x0,0x4c0(%rdi)
>    200:       00 00 00 00 
> 
> 11 bytes * 19 NULL pointer stores = 209 bytes + wasted CPU cycles.

Static objects don't get stored at init.. they are either in the data
segment (older compilers) or BSS (smarter ones)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
