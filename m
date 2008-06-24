Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 24 Jun 2008 18:23:34 -0400
From: Alan Cox <alan@redhat.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080624222334.GB2268@devserv.devel.redhat.com>
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
	<20080624133951.GA9910@devserv.devel.redhat.com>
	<200806242334.44102.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806242334.44102.laurent.pinchart@skynet.be>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] Thread safety of ioctls
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

On Tue, Jun 24, 2008 at 11:34:43PM +0200, Laurent Pinchart wrote:
> Buffer dequeuing can sleep for a longer time than most other operations, as it 
> waits for a video buffer to be ready. However, no other operation from the 
> above list should be performed while a VIDIOC_DQBUF is in progress.

Another thread can do so - or want for example to poll(). The case where
you sleep waiting for an event that may take a fair bit of time is perhaps
the one you need to drop the lock for.
> 
> Getting locking right is very difficult. I spent a lot of time checking corner 
> cases when developing the driver, and I'm pretty sure a few race conditions 
> still exist, especially when then ioctl code will not be covered by the BKL 
> anymore. I would greatly appreciate anyone reviewing the patch I will post 
> soon to get the UVC driver included in the mainline kernel for race 
> conditions and locking issues.

Agreed - one construct you will see in some drivers is basically

try_again: /* For the odd case we are beaten to a buffer etc */
	if (conditions) {
		drop_lock
		wait
		take lock
		if (!conditions)
			goto try_again;
	}

Some of this can get quite tricky when you have hardware state to manage


Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
