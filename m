Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5Q8dXnh025748
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 04:39:33 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5Q8dH9J026872
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 04:39:17 -0400
Received: from [87.234.250.194] (helo=orca)
	by aragorn.vidconference.de with esmtps
	(TLS-1.0:RSA_AES_256_CBC_SHA1:32) (Exim 4.63)
	(envelope-from <jasny@vidsoft.de>) id 1KBn0e-0004A6-ST
	for video4linux-list@redhat.com; Thu, 26 Jun 2008 10:39:16 +0200
Received: from jasny by orca with local (Exim 4.63)
	(envelope-from <jasny@vidsoft.de>) id 1KBn0e-0007GN-FB
	for video4linux-list@redhat.com; Thu, 26 Jun 2008 10:39:16 +0200
Date: Thu, 26 Jun 2008 10:39:16 +0200
To: video4linux-list@redhat.com
Message-ID: <20080626083915.GA18818@vidsoft.de>
References: <4862BF41.9090208@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4862BF41.9090208@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Subject: Re: Announcing libv4l 0.1
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

Hi,

On Wed, Jun 25, 2008 at 11:57:21PM +0200, Hans de Goede wrote:
> As most of you know I've been working on a userspace library which can be 
> used to (very) easily add support for all kind of pixelformats to v4l2 
> applications.
> 
> Just replace open("dev/video0", ...) with v4l2_open("dev/video0", ...), 
> ioctl
> with v4l2_ioctl, etc. libv4l2 will then do conversion of any known (webcam)
> pixelformats to bgr24 or yuv420.

I'll give the conversion and v4l2 userspace library a try during
weekend. Is there a public rcs where I can pull updates from?

Thanks for your work!
Gregor


--- libv4lconvert/spca561-decompress.c.orig	2008-06-26 07:49:43.000000000 +0000
+++ libv4lconvert/spca561-decompress.c	2008-06-26 08:31:32.000000000 +0000
@@ -31,7 +31,7 @@
  
 /*fixme: not reentrant */
 static unsigned int bit_bucket;
-static unsigned char *input_ptr;
+static const unsigned char *input_ptr;
 
 static inline void refill(int *bitfill)
 {
@@ -300,7 +300,7 @@
 }
 
 static int internal_spca561_decode(int width, int height,
-				   unsigned char *inbuf,
+				   const unsigned char *inbuf,
 				   unsigned char *outbuf)
 {
 	/* buffers */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
