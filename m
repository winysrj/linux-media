Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43100 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdLEA5t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 19:57:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038@lists.linaro.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] [media] uvc_video: use ktime_t for timestamps
Date: Tue, 05 Dec 2017 02:58:02 +0200
Message-ID: <5754191.7VT3CuYHXL@avalon>
In-Reply-To: <2878836.BpTQ5Kp5iv@avalon>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-2-arnd@arndb.de> <2878836.BpTQ5Kp5iv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Tuesday, 5 December 2017 02:37:27 EET Laurent Pinchart wrote:
> On Monday, 27 November 2017 15:19:54 EET Arnd Bergmann wrote:
> > uvc_video_get_ts() returns a 'struct timespec', but all its users
> > really want a nanoseconds variable anyway.
> > 
> > Changing the deprecated ktime_get_ts/ktime_get_real_ts to ktime_get
> > and ktime_get_real simplifies the code noticeably, while keeping
> > the resulting numbers unchanged.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_video.c | 37 ++++++++++++---------------------
> >  drivers/media/usb/uvc/uvcvideo.h  |  2 +-
> >  2 files changed, 13 insertions(+), 26 deletions(-)

[snip]

> > -	struct timespec ts;
> > +	u64 timestamp;

[snip]

> >  	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
> >  		  "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
> >  		  stream->dev->name,
> >  		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
> > -		  y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
> > +		  y, timestamp, vbuf->vb2_buf.timestamp,
> >  		  x1, first->host_sof, first->dev_sof,
> >  		  x2, last->host_sof, last->dev_sof, y1, y2);

As you've done lots of work moving code away from timespec I figured out I 
would ask, what is the preferred way to print a ktime in secs.nsecs format ? 
Should I use ktime_to_timespec and print ts.tv_sec and ts.tv_nsec, or is there 
a better way ?

-- 
Regards,

Laurent Pinchart
