Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:41400 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933755AbcIVULf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 16:11:35 -0400
Date: Thu, 22 Sep 2016 15:11:31 -0500
From: Bin Liu <b-liu@ti.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <nh26223@gmail.com>
Subject: Re: g_webcam Isoch high bandwidth transfer
Message-ID: <20160922201131.GD31827@uda0271908>
References: <20160920170441.GA10705@uda0271908>
 <871t0d4r72.fsf@linux.intel.com>
 <20160921132702.GA18578@uda0271908>
 <87oa3go065.fsf@linux.intel.com>
 <87lgyknyp7.fsf@linux.intel.com>
 <87d1jw6yfd.fsf@linux.intel.com>
 <20160922133327.GA31827@uda0271908>
 <87a8ezn2av.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87a8ezn2av.fsf@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Fengwei Yin per his request.

On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> Bin Liu <b-liu@ti.com> writes:
> 
> [...]
> 
> >> Here's one that actually compiles, sorry about that.
> >
> > No worries, I was sleeping ;-)
> >
> > I will test it out early next week. Thanks.
> 
> meanwhile, how about some instructions on how to test this out myself?
> How are you using g_webcam and what are you running on host side? Got a
> nice list of commands there I can use? I think I can get to bottom of
> this much quicker if I can reproduce it locally ;-)

On device side:
- first patch g_webcam as in my first email in this thread to enable
  640x480@30fps;
- # modprobe g_webcam streaming_maxpacket=3072
- then run uvc-gadget to feed the YUV frames;
	http://git.ideasonboard.org/uvc-gadget.git

On host side:
- first check the device ep descriptor, which should be
	wMaxPacketSize     0x1400  3x 1024 bytes
- then use luvcview or yavta to capture the video stream

Capture the bus trace to check if multiple IN transactions happens in
each SOF.

The data buffer size in the usb_request coming from the uvc driver is
5120 bytes, so there should be 3 IN transactions if the UDC works
correctly.

Regards,
-Bin.
