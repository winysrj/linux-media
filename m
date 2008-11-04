Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA4Eh1KF029961
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 09:43:01 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA4EgmrP018901
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 09:42:49 -0500
Date: Tue, 4 Nov 2008 15:42:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87k5bk30h0.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811040020330.7744@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
	<87mygg4l5l.fsf@free.fr>
	<Pine.LNX.4.64.0811032131410.7744@axis700.grange>
	<Pine.LNX.4.64.0811032322420.7744@axis700.grange>
	<87k5bk30h0.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
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

On Mon, 3 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Ok, just thinking one step further - Antonio most certainly was testing 
> > V4L2_PIX_FMT_YUYV, i.e., packed with his application, any other YCbCr 
> > format would be rejected by mt9m111 and YUYV _is_ packed. So, I think this 
> > is indeed the case - there are mo errors in datasheets, we just named the 
> > formats wrongly in pxa-camera and mt9m111 drivers.
> 
> I don't agree. This has nothing to do with naming, this has to do with byte
> order on qif bus and out of mt9m111 sensor.

We agree, that YCbCr _in_ _memory_ format as defined in pxa270 datasheet 
table 27-21 is UYVY, right?

To get that byte-order in memory data should appear on the camera bus as 
specified in Table 27-19. This order is also the default order for 
mt9m111. So, I think, it is reasonable to expect, that when a user 
application requests a UYVY format, we have to configure the camera to its 
defaults and the PXA will work as documented.

Instead, this configuration in the current mainline state is called YUYV, 
so, we provide data in UYUV format to an application, requesting YUYV. 
Then, of course, corrupted image result as in Antonio's test.

Hence, the first thing we shouldn't lie to applications - the format we 
currently provide is UYUV and this is how we should advertise it. That's 
why it _is_ a naming issue.

And, according to PXA documentation, pxa270 doesn't support any other 
byte-order variants on the camera bus, so, in principle one could stop 
here. Note, I think, this restriction is imposed to make image 
post-processing possible (see 7.4.9.2)

Next, what we observe, I think, is that in this mode pxa acts just in a 
pass-through mode with 16-bit pixels packing bytes as they arrive in the 
FIFO in RAM buffers. So, if we don't use post-processing, we can (ab)use 
this mode for other 16-bit YCbCr formats, e.g., YUYV. For this we leave 
PXA as it is, and just configure the sensor to provide YUYV. This is what 
essentially Antonio's patch does. In this sense it is "correct" - mt9m111 
is indeed configured for YUYV and it is the only YCbCr format it 
advertises, and pxa pretends to support YUYV. But, that's exactly why I am 
not quite happy about it - we abandon mt9m111's default UYUV format and 
switch it unconditionally to YUYV and we leave PXA270 lying about its 
supported pixel format. Instead, extending mt9m111 to claim support for 
all 4 formats, switching between them dynamically, and fixing pxa-camera 
to support all these four formats, and providing a comment, that we just 
use PXA270's UYUV as 16-bit pass-through, is a more complete fix and, 
probably, would have taken less time than this discussion:-)

> But you can change my mind : just tell me where my thinking was
> wrong in the previous mail where I stated bytes order (out of mt9m111 and in pxa
> qif bus).

Let's see if I managed...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
