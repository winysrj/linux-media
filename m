Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60777 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965763AbcIZOCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 10:02:55 -0400
Date: Mon, 26 Sep 2016 09:02:48 -0500
From: Bin Liu <b-liu@ti.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <nh26223@gmail.com>, <laurent.pinchart@ideasonboard.com>
Subject: Re: g_webcam Isoch high bandwidth transfer
Message-ID: <20160926140248.GF31827@uda0271908>
References: <20160920170441.GA10705@uda0271908>
 <871t0d4r72.fsf@linux.intel.com>
 <20160921132702.GA18578@uda0271908>
 <87oa3go065.fsf@linux.intel.com>
 <87lgyknyp7.fsf@linux.intel.com>
 <87d1jw6yfd.fsf@linux.intel.com>
 <20160922133327.GA31827@uda0271908>
 <87a8ezn2av.fsf@linux.intel.com>
 <20160922201131.GD31827@uda0271908>
 <87shsr5a3e.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87shsr5a3e.fsf@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 23, 2016 at 10:49:57AM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> Bin Liu <b-liu@ti.com> writes:
> > +Fengwei Yin per his request.
> >
> > On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
> >> 
> >> Hi,
> >> 
> >> Bin Liu <b-liu@ti.com> writes:
> >> 
> >> [...]
> >> 
> >> >> Here's one that actually compiles, sorry about that.
> >> >
> >> > No worries, I was sleeping ;-)
> >> >
> >> > I will test it out early next week. Thanks.
> >> 
> >> meanwhile, how about some instructions on how to test this out myself?
> >> How are you using g_webcam and what are you running on host side? Got a
> >> nice list of commands there I can use? I think I can get to bottom of
> >> this much quicker if I can reproduce it locally ;-)
> >
> > On device side:
> > - first patch g_webcam as in my first email in this thread to enable
> >   640x480@30fps;
> > - # modprobe g_webcam streaming_maxpacket=3072
> > - then run uvc-gadget to feed the YUV frames;
> > 	http://git.ideasonboard.org/uvc-gadget.git
> 
> as is, g_webcam never enumerates to the host. It's calls to

Right, on mainline kernel (I tested 4.8.0-rc7) g_webcam is broken with
DWC3, g_webcam does not enumerate on the host. But it works on v4.4.21.

[snip]

> 
> uvc-gadget keeps printing this error message:
> 
>  159         if ((ret = ioctl(dev->fd, VIDIOC_DQBUF, &buf)) < 0) {
>  160                 printf("Unable to dequeue buffer: %s (%d).\n", strerror(errno),
>  161                         errno);
>  162                 return ret;
>  163         }

I removed this printf, since it floods the console if start uvc-gadget
before connect to the host.

BTY, you don't have to start uvc-gadget first then connect usb cable. I
keep the cable always connected.

Regards,
-Bin.
