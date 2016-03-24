Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41465 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbcCXFAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 01:00:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1aixNL-0005p3-Sv
	for linux-media@vger.kernel.org; Thu, 24 Mar 2016 06:00:04 +0100
Received: from cpe-173-89-11-34.wi.res.rr.com ([173.89.11.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 06:00:03 +0100
Received: from luke.suchocki by cpe-173-89-11-34.wi.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 06:00:03 +0100
To: linux-media@vger.kernel.org
From: Luke Suchocki <luke.suchocki@embedtek.net>
Subject: Re: [PATCH v2] [media] cx231xx: fix close sequence for VBI + analog
Date: Thu, 24 Mar 2016 04:51:57 +0000 (UTC)
Message-ID: <loom.20160324T050741-728@post.gmane.org>
References: <1454092619-27700-1-git-send-email-jtheou@adeneo-embedded.us> <1454094304-4520-1-git-send-email-jtheou@adeneo-embedded.us> <20160201133325.069f22ad@recife.lan> <1454348833.16224.1@mxadeneo.adeneo-embedded.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Baptiste Theou <jtheou <at> adeneo-embedded.us> writes:

> 
> Hi Mauro,
> 
> Thanks for your feedback.
> 
> On Mon, Feb 1, 2016 at 7:33 AM, Mauro Carvalho Chehab 
> <mchehab <at> osg.samsung.com> wrote:
> > Em Fri, 29 Jan 2016 11:05:04 -0800
> > Jean-Baptiste Theou <jtheou <at> adeneo-embedded.us> escreveu:
> > 
> >>  For tuners with no_alt_vanc=0, and VBI and analog video device
> >>  open.
> >>  There is two ways to close the devices:
> >> 
> >>  *First way (start with user=2)
> >> 
> >>  VBI first (user=1): URBs for the VBI are killed properly
> >>  with cx231xx_uninit_vbi_isoc
> >> 
> >>  Analog second (user=0): URBs for the Analog are killed
> >>  properly with cx231xx_uninit_isoc
> >> 
> >>  *Second way (start with user=2)
> >> 
> >>  Analog first (user=1): URBs for the Analog are NOT killed
> >>  properly with cx231xx_uninit_isoc, because the exit path
> >>  is not called this time.
> >> 
> >>  VBI first (user=0): URBs for the VBI are killed properly with
> >>  cx231xx_uninit_vbi_isoc, but we are exiting the function
> >>  without killing the URBs for the Analog
> >> 
> >>  This situation lead to various kernel panics, since
> >>  the URBs are still processed, without the device been
> >>  open.
> >> 
> >>  The patch fix the issue by calling the exit path no matter
> >>  what, when user=0, plus remove a duplicate trace.
> >> 
> >>  Signed-off-by: Jean-Baptiste Theou <jtheou <at> adeneo-embedded.us>
> >> 
> >>  ---
> >> 
> >>   - v2: Avoid duplicate code and ensure that the queue are freed
> >>         properly.
> >>  ---
....
> > 
> > But the above code should be kept, as we should only stop/free
> > resources when neither VBI or Video is running. Other drivers do
> > similar things and work properly. See em28xx for example (I'm sure
> > em28xx video/vbi is working as expected, as I did such tests last
> > week).
> 
> My understanding of this code is that the VBI and the VIDEO device have 
> they own vb_vidq,
> so if videobuf_stop and video_mmap_free are called only when user=0, 
> one device
> (the first one to be close) will not be freed properly.
> 
> This is why I am stopping the use of the buffers and release the memory 
> first for every call
> of close().
> 
> Am I missing the way this code works?
> 
> > 
> > Regards,
> > Mauro
> 
> Best regards,
> 
> Jean-Baptiste


Not to hijack, but I've just worked through this same issue.

For my implementation, i could see that the video endpoint was not properly 
shutdown by enabling 'isoc_debug' since get_next_buf() would print the "No 
active queue" messages after the video file handle was closed and not torn 
down correctly, and while VBI was still open.. I also saw the panics when 
trying to rmmod.

Since the VBI and video are different endpoints and different buffers when 
(!dev->board.no_alt_vanc) is true, they must be cx231xx_uninit_* 
independently. 

When the video fh is closed first and VBI still open, dev->users is > 0 and 
video is never uninit_. dev->users decrements, VBI fh gets closed, users == 
0 and VBI is torn down, but the video endpoint is still running.

My solution was to track fh opens of type V4L2_BUF_TYPE_VBI_CAPTURE 
independently with a new dev->vbi_users and run the 
cx231xx_uninit_vbi_isoc() block on close when that is 0, and run the other 
cx231xx_uninit_isoc() block when dev->users == 0.

Even if dev->users == 0 while VBI is open, video can still shutdown 
beforehand.

Also, I think the V2 proposed patch might be ok, as long as there's never 2 
VBI users (or 1 user and it's just VBI) and thus when dev->users == 0 it's 
always ok to run the video cx231xx_uninit_* code / set_alt_setting(dev, 
INDEX_VIDEO,0). 

I would be happy to share my patch w/ RFC if you're interested, but now I 
think there's more to this than what all of us have fully considered.

--Luke Suchocki

