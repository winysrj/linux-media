Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43441 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbeKJBWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 20:22:15 -0500
Message-ID: <1541778063.4112.51.camel@pengutronix.de>
Subject: Re: [PATCH v5 8/9] media: uvcvideo: Rename uvc_{un,}init_video()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Date: Fri, 09 Nov 2018 16:41:03 +0100
In-Reply-To: <9290334.s72v5oSQOh@avalon>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
         <1648340.AJeOYgVR3M@avalon>
         <bf3dcb4c-0039-8bf7-d059-30ac5279cda2@ideasonboard.com>
         <9290334.s72v5oSQOh@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-11-07 at 22:25 +0200, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Wednesday, 7 November 2018 16:30:46 EET Kieran Bingham wrote:
> > On 06/11/2018 23:13, Laurent Pinchart wrote:
> > > On Tuesday, 6 November 2018 23:27:19 EET Kieran Bingham wrote:
> > > > From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> > > > 
> > > > We have both uvc_init_video() and uvc_video_init() calls which can be
> > > > quite confusing to determine the process for each. Now that video
> > > > uvc_video_enable() has been renamed to uvc_video_start_streaming(),
> > > > adapt these calls to suit the new flow.
> > > > 
> > > > Rename uvc_init_video() to uvc_video_start() and uvc_uninit_video() to
> > > > uvc_video_stop().
> > > 
> > > I agree that these functions are badly named and should be renamed. We are
> > > however entering the nitpicking territory :-) The two functions do more
> > > that starting and stopping, they also allocate and free URBs and the
> > > associated buffers. It could also be argued that they don't actually
> > > start and stop anything, as beyond URB management, they just queue the
> > > URBs initially and kill them. I thus wonder if we could come up with
> > > better names.
> > 
> > Well the act of killing (poisoning now) the URBs will certainly stop the
> > stream, but I guess submitting the URBs isn't necessarily the key act to
> > starting the stream.
> > 
> > I believe that needs the interface to be set correctly, and the buffers
> > to be available?
> > 
> > Although - I've just double-checked uvc_{video_start,init_video}() and
> > that is indeed what it does?
> > 
> >  - start stats
> >  - Initialise endpoints
> >    - Perform allocations
> >  - Submit URBs
> > 
> > Am I missing something? Is there another step that is pivotal to
> > starting the USB packet/urb stream flow after this point ?
> > 
> > 
> > Is it not true that the USB stack will start processing data at
> > submitting URB completion callbacks after the end of uvc_video_start();
> > and will no longer process data at the end of uvc_video_stop() (and thus
> > no more completion callbacks)?
> > 
> >  (That's a real question to verify my interpretation)
> > 
> > To me - these functions feel like the real 'start' and 'stop' components
> > of the data stream - hence my choice in naming.
> 
> The other part of the start operation is committing the streaming parameters 
> (see uvc_video_start_streaming()). For the stop operation it's issuing a 
> SET_INTERFACE or CLEAR_FEATURE(HALT) request (see uvc_video_stop_streaming()).
> 
> > Is your concern that you would like the functions to be more descriptive
> > over their other actions such as? :
> > 
> >   uvc_video_initialise_start()
> >   uvc_video_allocate_init_start()
> > 
> > Or something else? (I don't think those two are good names though)
> 
> Probably something else :-) A possibly equally bad proposal would be 
> uvc_video_start_transfer() and uvc_video_stop_transfer().

I think this is still better than what we have now.

At least it contains "transfer" to make it clear it deals with the
isoc/bulk transfer setup/teardown part of streaming, not actually
starting or stopping the device streaming.

regards
Philipp
