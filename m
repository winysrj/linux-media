Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48FbvAP013414
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 11:37:57 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m48FbiV4016204
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 11:37:44 -0400
Date: Thu, 8 May 2008 17:37:20 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Dinesh Bhat <dbhat@linsys.ca>
Message-ID: <20080508153720.GA2727@daniel.bse>
References: <48230D7E.9050503@linsys.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48230D7E.9050503@linsys.ca>
Cc: Video-4l-list <video4linux-list@redhat.com>
Subject: Re: Apple quicktime v210 codec equivalent support on V4L
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

On Thu, May 08, 2008 at 09:26:06AM -0500, Dinesh Bhat wrote:
> We have a card that supports v210 codec type on Mac OS X. We have our 
> regular drivers (we implement frame buffers) and are interested in 
> supporting v4l for this card. I was wondering if there is any direct 
> support available for v210 codec. Can anyone please suggest what is the 
> best way to go here if we want to support v4l?

If I understand you correctly, you want to write a V4L driver for this card.

There is currently no equivalent to v210 defined but adding support for it to
V4L is just a matter of adding

#define V4L2_PIX_FMT_V210    v4l2_fourcc('v','2','1','0') /* 20  YUV 4:2:2 */

to videodev2.h.

A description for the V4L2 API specification should be provided as well.

Conversion between different pixel formats is not supposed to be done in V4L
drivers. It should be done either on the card or in the application if needed.
If you need to reorder bits to have v210, invent a new pixel format and
advertise that one instead of v210. Drivers should not touch the frame buffer.
Only hardware and userspace do.

A userspace library is in the works to aid application writers:
http://linuxtv.org/v4lwiki/index.php/V4L2UserspaceLibrary

So your driver should expect the application to already know about v210.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
