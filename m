Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM05mBK017143
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:05:48 -0500
Received: from mk-outboundfilter-1.mail.uk.tiscali.com
	(mk-outboundfilter-1.mail.uk.tiscali.com [212.74.114.37])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM05aDh010662
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:05:36 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: sqcam-devel@lists.sourceforge.net
Date: Sat, 22 Nov 2008 00:05:34 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<200811212157.21254.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0811211658290.4727@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211658290.4727@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811220005.34321.linux@baker-net.org.uk>
Cc: video4linux-list@redhat.com, kilgota@banach.math.auburn.edu
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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

On Friday 21 November 2008, kilgota@banach.math.auburn.edu wrote:
> > Unfortunately libusb doesn't include a
> > corresponding attach method for libgphoto2 to use when it has finished so
> > it can't re-instate the kernel driver.
>
> True. But what I am wondering is, if it would be possible to write the
> kernel driver in such a way that it does not need to get detached, then it
> would be possible to solve the problem in both directions,

I don't believe that that is possible because if I understand correctly libusb 
detects that a driver has been loaded that has claimed that device and so it 
needs to be involved in the communication to get the kernel driver to allow 
access.

To acheive what you are suggesting the kernel driver would have to return 
false from its xxx_probe routine and not create it's endpoints but still call 
video_register_device to create the /dev/videox dev file. The problem is I 
don't believe there exists a mechanism whereby it could then obtain access to 
the USB device within it's xxx_open routine and it certainlywouldn't receive 
USB disconnect events so couldn't clean up properly.

The libusb attach/detach mechanism definitely looks like the cleanest solution 
if we can get a shipping version of libusb that implements attach.

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
