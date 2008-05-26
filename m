Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 26 May 2008 13:34:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>, Douglas Landgraf <dougsland@gmail.com>
Message-ID: <20080526133457.6f892af9@gaivota>
In-Reply-To: <20080523090919.GA31575@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<1211508484.3273.86.camel@palomino.walls.org>
	<20080523090919.GA31575@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Fri, 23 May 2008 05:09:19 -0400
Alan Cox <alan@redhat.com> wrote:

> On Thu, May 22, 2008 at 10:08:04PM -0400, Andy Walls wrote:
> > Could someone give me a brief education as to what elements of
> > cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for these
> > drivers' ioctls?   I'm assuming it's not the
> > mutex_un/lock(&....->serialize_lock) and that the answer's not in the
> > diff.
> 
> As it stood previous for historical reasons the kernel called the driver
> ioctl method already holding the big kernel lock. That lock effectively
> serialized a lot of ioctl processing and also serializes against module
> loading and registration/open for the most part. If all the resources you
> are working on within the ioctl handler are driver owned as is likely with
> a video capture driver, and you have sufficient locking of your own you can
> drop the lock.
> 
> video_usercopy currently also uses the BKL so you might want to copy a
> version to video_usercopy_unlocked() without that.

In the specific case of ivtv and cx18, I think that the better would be to
convert it first to video_ioctl2. Then, remove the BKL, with a
video_ioctl2_unlocked version.

Douglas already did an experimental patch converting ivtv to video_ioctl2 and
sent to Hans. It needs testing, since he doesn't have any ivtv board. It should
be trivial to port this to cx18, since both drivers have similar structures.

Douglas,

Could you send this patch to the ML for people to review and for Andy to port
it to cx18?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
