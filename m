Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:47811 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760790Ab2FDPoF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:44:05 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 4 Jun 2012 23:43:49 +0800
Subject: RE: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF5@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
 <20120604151355.GA20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
 <20120604152831.GB20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4@EAPEX1MAIL1.st.com>
 <20120604154052.GD20313@arwen.pp.htv.fi>
In-Reply-To: <20120604154052.GD20313@arwen.pp.htv.fi>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Monday, June 04, 2012 9:11 PM
> To: Bhupesh SHARMA
> Cc: balbi@ti.com; laurent.pinchart@ideasonboard.com; linux-
> usb@vger.kernel.org; linux-media@vger.kernel.org;
> gregkh@linuxfoundation.org
> Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
> videobuf2 framework
> 
> Hi,
> 
> On Mon, Jun 04, 2012 at 11:37:59PM +0800, Bhupesh SHARMA wrote:
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Monday, June 04, 2012 8:59 PM
> > > To: Bhupesh SHARMA
> > > Cc: balbi@ti.com; laurent.pinchart@ideasonboard.com; linux-
> > > usb@vger.kernel.org; linux-media@vger.kernel.org;
> > > gregkh@linuxfoundation.org
> > > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to
> > > use
> > > videobuf2 framework
> > >
> > > On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> > > > Hi Felipe,
> > > >
> > > > > -----Original Message-----
> > > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > > Sent: Monday, June 04, 2012 8:44 PM
> > > > > To: Bhupesh SHARMA
> > > > > Cc: laurent.pinchart@ideasonboard.com;
> > > > > linux-usb@vger.kernel.org; balbi@ti.com;
> > > > > linux-media@vger.kernel.org; gregkh@linuxfoundation.org
> > > > > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam
> gadget
> > > > > to use
> > > > > videobuf2 framework
> > > > >
> > > > > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > > > > This patch reworks the videobuffer management logic present
> in
> > > the
> > > > > UVC
> > > > > > webcam gadget and ports it to use the "more apt" videobuf2
> > > > > > framework for video buffer management.
> > > > > >
> > > > > > To support routing video data captured from a real V4L2 video
> > > > > > capture device with a "zero copy" operation on videobuffers
> > > > > > (as they pass
> > > > > from
> > > > > > the V4L2 domain to UVC domain via a user-space application),
> > > > > > we need to support USER_PTR IO method at the UVC gadget side.
> > > > > >
> > > > > > So the V4L2 capture device driver can still continue to use
> > > > > > MMAO IO method and now the user-space application can just
> > > > > > pass a pointer to the video buffers being DeQueued from the
> > > > > > V4L2 device side while Queueing them at the UVC gadget end.
> > > > > > This ensures that we have a "zero-copy" design as the
> > > > > > videobuffers pass from the
> > > > > > V4L2 capture
> > > > > device to the UVC gadget.
> > > > > >
> > > > > > Note that there will still be a need to apply UVC specific
> > > payload
> > > > > > headers on top of each UVC payload data, which will still
> > > > > > require a copy operation to be performed in the 'encode'
> > > > > > routines of the UVC
> > > > > gadget.
> > > > > >
> > > > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > > >
> > > > > this patch doesn't apply. Please refresh on top of v3.5-rc1 or
> > > > > my gadget branch which I will update in a while.
> > > > >
> > > >
> > > > I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> > > > Should I now refresh my patches on top of your "v3.5-rc1" branch
> ?
> > > >
> > > > I am a bit confused on what is the latest gadget branch to be
> used
> > > now.
> > > > Thanks for helping out.
> > >
> > > The gadget branch is the branch called gadget on my kernel.org
> tree.
> > > For some reason this didn't apply. Probably some patches on
> > > drivers/usb/gadget/*uvc* went into v3.5 without my knowledge.
> > > Possibly because I was out for quite a while and asked Greg to help
> > > me out during the merge window.
> > >
> > > Anyway, I just pushed gadget with a bunch of new patches and part
> of
> > > your series.
> > >
> >
> > Yes. I had sent two patches some time ago for
> drivers/usb/gadget/*uvc*.
> > For one of them I received an *applied* message from you:
> 
> that was already applied long ago. ;-)
> 
> >
> > > > usb: gadget/uvc: Remove non-required locking from
> > > > 'uvc_queue_next_buffer' routine
> >
> > > > This patch removes the non-required spinlock acquire/release
> calls
> > > > on 'queue->irqlock' from 'uvc_queue_next_buffer' routine.
> > > >
> > > > This routine is called from 'video->encode' function (which
> > > translates
> > > > to either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> > > 'uvc_video.c'.
> > > > As, the 'video->encode' routines are called with 'queue->irqlock'
> > > > already held, so acquiring a 'queue->irqlock' again in
> > > > 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> > > >
> > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >
> > > applied, thanks
> >
> > Not sure, if that can cause the merge conflict issue.
> > So now, should I send a clean patchset on top of your 3.5-rc1 branch
> > to ensure the entire new patchset for drivers/usb/gadget/*uvc* is
> pulled properly?
> 
> Yes please, just give kernel.org about 20 minutes to sync all git
> servers.
> 
> Just so you know, head on my gadget branch is:
> 
> commit fbcaba0e3dcec8451cccdc1fa92fcddbde2bc3f2
> Author: Bhupesh Sharma <bhupesh.sharma@st.com>
> Date:   Fri Jun 1 15:08:56 2012 +0530
> 
>     usb: gadget: uvc: Add super-speed support to UVC webcam gadget
> 
>     This patch adds super-speed support to UVC webcam gadget.
> 
>     Also in this patch:
>         - We add the configurability to pass bInterval, bMaxBurst, mult
>           factors for video streaming endpoint (ISOC IN) through module
>           parameters.
> 
>         - We use config_ep_by_speed helper routine to configure video
>           streaming endpoint.
> 
>     Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> --

Ok. Thanks for your help :)

Regards,
Bhupesh
