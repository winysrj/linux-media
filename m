Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 3 Jun 2008 18:08:28 -0400
From: Alan Cox <alan@redhat.com>
To: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Message-ID: <20080603220828.GE30842@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
	<200806011215.11489.hverkuil@xs4all.nl>
	<1212346919.3294.6.camel@palomino.walls.org>
	<20080603182052.1080408e@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603182052.1080408e@gaivota>
Cc: video4linux-list@redhat.com
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

On Tue, Jun 03, 2008 at 06:20:52PM -0300, Mauro Carvalho Chehab wrote:
> > Yeah, they can go.  I left them in as an aid for double checking that I
> > didn't forget any callbacks that needed to be implemented.
> 
> Please don't do that. All static vars that have a value 0 or NULL shouldn't be
> initialized, since this will eat some space inside the module.

The compiler is smarter than that. Besides which 4 bytes will make no difference
whether it is data or bss given 4K disk block sizes 8)

It is coding style not to do it but it isn't a bad idea to leave them in if
they make something explicitly clear IMHO.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
