Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALNe1J9008553
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 18:40:01 -0500
Received: from mk-outboundfilter-5.mail.uk.tiscali.com
	(mk-outboundfilter-5.mail.uk.tiscali.com [212.74.114.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALNdiIE001249
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 18:39:44 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: sqcam-devel@lists.sourceforge.net
Date: Fri, 21 Nov 2008 23:39:42 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
	<200811212157.21254.linux@baker-net.org.uk>
In-Reply-To: <200811212157.21254.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212339.42492.linux@baker-net.org.uk>
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

On Friday 21 November 2008, Adam Baker wrote:
> There is a patch for libusb at
> http://osdir.com/ml/lib.libusb.devel.general/2007-04/msg00239.html to
> implemnt attach which the relevant maintainer claimed he had applied but
> doesn't appear to exist in libusb svn. I'll raise the issue on the

Further investigation reveals that the reason this patch hasn't been applied 
is because libusb-0.1 is in bug fixes only mode while a new libusb variant is 
being developed. It did get applied to a previous development branch but that 
branch got killed.

I've asked the question anyway.

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
