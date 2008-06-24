Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 24 Jun 2008 09:39:51 -0400
From: Alan Cox <alan@redhat.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080624133951.GA9910@devserv.devel.redhat.com>
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806240033.41145.laurent.pinchart@skynet.be>
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

On Tue, Jun 24, 2008 at 12:33:40AM +0200, Laurent Pinchart wrote:
> Not really. The ioctl handler is protected by the big kernel lock, so ioctls 
> are currently not reentrant.

Not so - the BKL drops on sleeping so any ioctl that sleeps is re-entrant.
Any code using locks of its own should be dropping their lock before any long
sleeps.

> Most drivers are probably not designed with thread safety in mind, and I'm 
> pretty sure lots of race conditions still lie in the depth of V4L(2) drivers. 

>From looking at the BKL dropping work that would unfortunately seem to be
the case for some drivers

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
