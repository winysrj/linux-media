Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Alan Cox <alan@redhat.com>
In-Reply-To: <20080603220828.GE30842@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
	<200806011215.11489.hverkuil@xs4all.nl>
	<1212346919.3294.6.camel@palomino.walls.org>
	<20080603182052.1080408e@gaivota>
	<20080603220828.GE30842@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 20:44:30 -0400
Message-Id: <1212540270.3177.46.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
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

On Tue, 2008-06-03 at 18:08 -0400, Alan Cox wrote:
> On Tue, Jun 03, 2008 at 06:20:52PM -0300, Mauro Carvalho Chehab wrote:
> > > Yeah, they can go.  I left them in as an aid for double checking that I
> > > didn't forget any callbacks that needed to be implemented.
> > 
> > Please don't do that. All static vars that have a value 0 or NULL shouldn't be
> > initialized, since this will eat some space inside the module.

Mauro,

OK.


Alan,

> The compiler is smarter than that. Besides which 4 bytes will make no difference
> whether it is data or bss given 4K disk block sizes 8)

Objdump reveals, unfortunately the compiler isn't that smart.  It does
explicitly create code to store the NULL pointers.  

For the record, every pointer store looks something like this (before
relocations) on 64-bit:

   1f9:       48 c7 87 c0 04 00 00    movq   $0x0,0x4c0(%rdi)
   200:       00 00 00 00 

11 bytes * 19 NULL pointer stores = 209 bytes + wasted CPU cycles.


Quite honestly, I would have thought the compiler smart enough to do
something like

	xor %rax, %rax
	mov %rax, 0x123(%rdi)

as most of the NULL pointer stores happened in groups of two or three.
But apparently, it wasn't.

-Andy

> It is coding style not to do it but it isn't a bad idea to leave them in if
> they make something explicitly clear IMHO.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
