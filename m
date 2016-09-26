Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56954 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbcIZQGb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 12:06:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: yfw <nh26223@gmail.com>, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: g_webcam Isoch high bandwidth transfer
Date: Mon, 26 Sep 2016 19:06:23 +0300
Message-ID: <1685763.WH6ULF9Rxs@avalon>
In-Reply-To: <87k2e358cx.fsf@linux.intel.com>
References: <20160920170441.GA10705@uda0271908> <b73898d0-b5ff-d591-0946-acf127453aba@gmail.com> <87k2e358cx.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

On Friday 23 Sep 2016 11:27:26 Felipe Balbi wrote:
> yfw <nh26223@gmail.com> writes:
> >>>>>> Here's one that actually compiles, sorry about that.
> >>>>> 
> >>>>> No worries, I was sleeping ;-)
> >>>>> 
> >>>>> I will test it out early next week. Thanks.
> >>>> 
> >>>> meanwhile, how about some instructions on how to test this out myself?
> >>>> How are you using g_webcam and what are you running on host side? Got a
> >>>> nice list of commands there I can use? I think I can get to bottom of
> >>>> this much quicker if I can reproduce it locally ;-)
> >>> 
> >>> On device side:
> >>> - first patch g_webcam as in my first email in this thread to enable
> >>>   640x480@30fps;
> >>> - # modprobe g_webcam streaming_maxpacket=3072
> >>> - then run uvc-gadget to feed the YUV frames;
> >>> 	http://git.ideasonboard.org/uvc-gadget.git
> >> 
> >> as is, g_webcam never enumerates to the host. It's calls to
> >> usb_function_active() and usb_function_deactivate() are unbalanced. Do
> >> you have any other changes to g_webcam?
> > 
> > With uvc function gadget driver, user daemon uvc-gadget must be started
> > before connect to host. Not sure whether g_webcam has same requirement.
> 
> f_uvc.c should be handling that by means for usb_function_deactivate().
> 
> I'll try keeping cable disconnected until uvc-gadget is running.

Things might have changed since we've discussed the issue several years ago, 
but back then at least the musb UDC started unconditionally connected.

-- 
Regards,

Laurent Pinchart

