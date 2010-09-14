Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:12400 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328Ab0INLjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 07:39:18 -0400
Subject: Re: extend video capture example to capture mpeg video file
From: Andy Walls <awalls@md.metrocast.net>
To: bad boy <badmash69@yahoo.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <768645.43657.qm@web45308.mail.sp1.yahoo.com>
References: <768645.43657.qm@web45308.mail.sp1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 07:39:04 -0400
Message-ID: <1284464344.2827.24.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 21:43 -0700, bad boy wrote:
> Hi

Please note, the video4linux-list is about dead; use
linux-media@vger.kernel.org instead.

> I have a Hauppage TV capture card that seems to be working . I can use the
> 
> cat /dev/video0 > test.mpeg to capture a video file to hard disk.
> 
> I am trying to adapt the video capture example, source  "capture.c" to  capture 
> the mpeg file.
> 
> The example code ins capture.c calls the read_frame() function that then calls 
> process image, which writes a "." to the screen.
> 
> 
> What do I need to modify to capture a proper mpeg file ? 

If you have a Hauppauge card whose driver supports the read() method and
provides MPEG output (ivtv or cx18?), then 'cat /dev/video0' does
capture a proper MPEG file to standard output.  

Drivers that support the read() method, like ivtv and cx18, usually do
not support the methods that use mmap().  I'm guessing capture.c uses
the one of the mmap() methods, which is a completely different way of
reading from a video device node than a read() call.  By the time you
are done rewriting capture.c, you will end up with something close to
cat.c.


> Your help would be deeply appreciated.

$ mplayer /dev/video0 -cache 8192

will display the video and audio as it is captured.

Regards,
Andy

> Thanks
> badam


