Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Alan Cox <alan@redhat.com>
Date: Tue, 24 Jun 2008 23:34:43 +0200
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
	<20080624133951.GA9910@devserv.devel.redhat.com>
In-Reply-To: <20080624133951.GA9910@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242334.44102.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de
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

On Tuesday 24 June 2008, Alan Cox wrote:
> On Tue, Jun 24, 2008 at 12:33:40AM +0200, Laurent Pinchart wrote:
> > Not really. The ioctl handler is protected by the big kernel lock, so
> > ioctls are currently not reentrant.
>
> Not so - the BKL drops on sleeping so any ioctl that sleeps is re-entrant.

Thanks for the information.

> Any code using locks of its own should be dropping their lock before any
> long sleeps.

How long is a long sleep ?

The UVC driver uses five mutexes:

- to guard against the open()/disconnect() race
- to serialize access to the global controls list
- to serialize access to device controls
- to serialize streaming format negotiation
- to serialize access to the video buffers queue

Access to device controls shouldn't take more than 10ms, unless the device is 
buggy in which case the URB will timeout after 300ms. Likewise, streaming 
format negotiation shouldn't sleep for more than a few dozens of 
milliseconds.

The video buffers queue mutex is taken when performing the following 
operations:

- buffer allocation/deallocation
- buffer query (VIDIOC_QUERYBUF)
- buffer enqueuing and dequeuing (VIDIO_QBUF and VIDIOC_DQBUF)
- buffer queue activation and deactivation (VIDIOC_STREAMON and
  VIDIOC_STREAMOFF, release(), system resume)
- poll()
- mmap()
- release()

Buffer dequeuing can sleep for a longer time than most other operations, as it 
waits for a video buffer to be ready. However, no other operation from the 
above list should be performed while a VIDIOC_DQBUF is in progress.

Does this make sense, or is there a place where I should try to drop a lock 
before sleeping ?

> > Most drivers are probably not designed with thread safety in mind, and
> > I'm pretty sure lots of race conditions still lie in the depth of V4L(2)
> > drivers.
>
> From looking at the BKL dropping work that would unfortunately seem to be
> the case for some drivers

Getting locking right is very difficult. I spent a lot of time checking corner 
cases when developing the driver, and I'm pretty sure a few race conditions 
still exist, especially when then ioctl code will not be covered by the BKL 
anymore. I would greatly appreciate anyone reviewing the patch I will post 
soon to get the UVC driver included in the mainline kernel for race 
conditions and locking issues.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
