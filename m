Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 2 Jun 2008 11:58:00 -0400
From: Alan Cox <alan@redhat.com>
To: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Message-ID: <20080602155800.GE933@devserv.devel.redhat.com>
References: <1212421034.7097.19.camel@jaspav.missionsit.net.missionsit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212421034.7097.19.camel@jaspav.missionsit.net.missionsit.net>
Cc: video4linux-list@redhat.com
Subject: Re: NX client and remote video input devices
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

On Mon, Jun 02, 2008 at 11:37:14AM -0400, John A. Sullivan III wrote:
> The SMB share is something NX supports natively.  We noticed we could
> create a symbolic link to /dev/video0 and use this link to manage the

SMB can't export devices, let alone manage a distributed mmap interface

> How can we control and access a video input device on a remote computer?
> This is a high priority project for us (our first potential customer) so
> any help would be greatly appreciated.  Thanks - John

You need some kind of video library in the middle. Look at something like
gstreamer or videolan would be my first thoughts. A lot of video apps already
use gstreamer as their video framework and it means compression and processing
can occur before you burn network bandwidth.

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
