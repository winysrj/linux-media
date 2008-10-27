Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RLImVf007493
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 17:18:48 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9RLIbYx019458
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 17:18:38 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.13.8) with ESMTP id m9RLIb9E022568
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 16:18:37 -0500
Received: (from mporter@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id m9RLIbLT022567
	for video4linux-list@redhat.com; Mon, 27 Oct 2008 16:18:37 -0500
Date: Mon, 27 Oct 2008 16:18:37 -0500
From: Matt Porter <mporter@kernel.crashing.org>
To: video4linux-list@redhat.com
Message-ID: <20081027211837.GA20197@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: output overlay driver and pix format
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

I'm working on a driver for an internal image processing block in an
SoC. This functionality can combine a buffer stream in various YUV/RGB
formats (selectable) with the framebuffer (or any arbitrary buffer one
wishes to overlay).

This fits quite well into the OUTPUT_OVERLAY support for the most part.
However, the driver will not have OUTPUT capability at all. That is, there is
not a direct external output from the image processor so it doesn't not make
sense to define OUTPUT capability. The results of the image processing
are left in a target buffer that may be used for tv/lcd encoding or fed
back in for additional image processing operations.

So the idea is to set the OUTPUT_OVERLAY pix format to one of the supported
formats, set cropping/scaling/blending. Feed it buffers and it blends
with the framebuffer, shoving the result to the internal target buffer.

The problem is that the V4L2 spec seems to imply that an OUTPUT_OVERLAY
device should not touch the fmtdesc pix fields. In my case, the user needs
to configure 1 of N pixelformat types that can be fed to the OUTPUT_OVERLAY
device. Is this allowed or am I using OUTPUT_OVERLAY differently than
intended? It seems that overlay devices may only be intended to be used
with an associated OUTPUT (or INPUT) device that defines the pix format.

The bottom line is: does it make sense to have a driver with only
OUTPUT_OVERLAY capability?

Any clues here are appreciated.

Thanks,
Matt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
