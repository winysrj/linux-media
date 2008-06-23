Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 23 Jun 2008 09:29:30 -0400
From: Alan Cox <alan@redhat.com>
To: Gregor Jasny <jasny@vidsoft.de>
Message-ID: <20080623132930.GA499@devserv.devel.redhat.com>
References: <485F7A42.8020605@vidsoft.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F7A42.8020605@vidsoft.de>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de
Subject: Re: Thread safety of ioctls
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

On Mon, Jun 23, 2008 at 12:26:10PM +0200, Gregor Jasny wrote:
> Can I enable more logging than setting the trace parameter to 0xfff?
> Have you any idea what went wrong here? Is the V4L2-API designed to be 
> thread safe?

It should be yes. Could be someone is taking a semaphore around a sleeping
ioctl operation and didn't drop it from the sound of the bug report.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
