Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALLve46028826
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:57:40 -0500
Received: from mk-outboundfilter-6.mail.uk.tiscali.com
	(mk-outboundfilter-6.mail.uk.tiscali.com [212.74.114.14])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALLvNaC026553
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:57:23 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: kilgota@banach.math.auburn.edu, sqcam-devel@lists.sourceforge.net
Date: Fri, 21 Nov 2008 21:57:21 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<49269369.90805@hhs.nl>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212157.21254.linux@baker-net.org.uk>
Cc: video4linux-list@redhat.com
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
> Where I am coming from is, libgphoto2 uses libusb. When a kernel module
> has "taken over" the device, then as things currently stand, or have stood
> until recently, libgphoto2 has no access to the device unless and until
> the kernel module has been rmmod-ed. I understand that there is a partial
> solution for this. I am trying to figure out how there is a complete
> solution which would make everyone happy, including users who just want to
> plug in their cameras.


The current solution is because of line 256 of libgphoto2_port/usb/libusb.c in 
version 2.4.3 of libgphoto2 (It has actually been in there for quite a while, 
the relevant code was added in svn rev 7283 over 4 years ago although the 
lack of releases around that time (if svn release tags are correct) may mean 
it took years until distributions started shipping it).

Basically what happens is that libgphoto2 calls usb_detach_kernel_driver_np 
which hands the device over to libusb. Unfortunately libusb doesn't include a 
corresponding attach method for libgphoto2 to use when it has finished so it 
can't re-instate the kernel driver.

There is a patch for libusb at 
http://osdir.com/ml/lib.libusb.devel.general/2007-04/msg00239.html to 
implemnt attach which the relevant maintainer claimed he had applied but 
doesn't appear to exist in libusb svn. I'll raise the issue on the 
libusb-devel list.

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
