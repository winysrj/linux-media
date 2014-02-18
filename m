Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:36305 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaBRIIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 03:08:42 -0500
Date: Tue, 18 Feb 2014 09:08:41 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: OMAP3 ISP capabilities, resizer
In-Reply-To: <1820490.0WrQgPlyuR@avalon>
Message-ID: <alpine.DEB.2.01.1402180854190.17228@pmeerw.net>
References: <alpine.DEB.2.01.1402121601100.6337@pmeerw.net> <1820490.0WrQgPlyuR@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

> > * I have a test program, http://pmeerw.net/scaler.c, which exercises the
> > OMAP3 ISP resizer standalone with the pipeline given below; it crashes the
> > system quite reliably on 3.7 and recent kernels :(
> > 
> > the reason for the crash is that the ISP resizer can still be busy and
> > doesn't like to be turned off then; a little sleep before
> > omap3isp_sbl_disable() helps (or waiting for the ISP resize to become
> > idle, see the patch below)
> > 
> > I'm not sure what omap3isp_module_sync_idle() is supposed to do, it
> > immediately returns since we are in SINGLESHOT mode and
> > isp_pipeline_ready() is false
> 
> The function is supposed to wait until the module becomes idle. I'm not sure 
> why we don't call it for memory-to-memory pipelines, I need to investigate 
> that. Sakari, do you remember what we've done there ?
>
> > with below patch I am happily resizing...
> > 
> > // snip, RFC
> > From: Peter Meerwald <p.meerwald@bct-electronic.com>
> > Date: Wed, 12 Feb 2014 15:59:20 +0100
> > Subject: [PATCH] omap3isp: Wait for resizer to become idle before
> > disabling
> > 
> > ---
> >  drivers/media/platform/omap3isp/ispresizer.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispresizer.c
> > b/drivers/media/platform/omap3isp/ispresizer.c
> > index d11fb26..fea98f7 100644
> > --- a/drivers/media/platform/omap3isp/ispresizer.c
> > +++ b/drivers/media/platform/omap3isp/ispresizer.c
> > @@ -1145,6 +1145,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> > int enable) struct isp_video *video_out = &res->video_out;
> >         struct isp_device *isp = to_isp_device(res);
> >         struct device *dev = to_device(res);
> > +       unsigned long timeout = 0;
> > 
> >         if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
> >                 if (enable == ISP_PIPELINE_STREAM_STOPPED)
> > @@ -1176,6 +1177,15 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> > int enable) if (omap3isp_module_sync_idle(&sd->entity, &res->wait,
> > &res->stopping))
> >                         dev_dbg(dev, "%s: module stop timeout.\n",
> > sd->name);
> > +
> > +               while (omap3isp_resizer_busy(res)) {
> > +                       if (timeout++ > 1000) {
> > +                               dev_alert(isp->dev, "ISP resizer does not
> > become idle\n");
> > +                               return -ETIMEDOUT;
> > +                       }
> > +                       udelay(100);
> > +               }
> > +
> 
> Let's try to avoid busy loops if possible. Does it help if you comment out the 
> condition at the top of omap3isp_module_sync_idle() ?
> 
> >                 omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_RESIZER_READ |
> >                                 OMAP3_ISP_SBL_RESIZER_WRITE);
> >                 omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_RESIZER);

tried without the check at the top of omap3isp_module_sync_idle()

I am not sure yet when and how many interrupts occur in memory-to-memory 
(singleshot) mode... and the code might be racy:

if the resizer is done, we don't want to wait for another interrupt which 
might never happen;

if the resizer is not done (how do we know?), we need to test that and 
set the stopping flag so that omap3isp_module_sync_is_stopping() wakes us 
when done

omap3isp_module_sync_idle():

	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED ||
	    (0 && pipe->stream_state == ISP_PIPELINE_STREAM_SINGLESHOT &&
	     !isp_pipeline_ready(pipe)))
		return 0;

isp_pipeline_ready() seems to be the wrong check for resizer done;
the final interrupt could occur here, before setting 'stopping'

	/*
	 * atomic_set() doesn't include memory barrier on ARM platform for SMP
	 * scenario. We'll call it here to avoid race conditions.
	 */
	atomic_set(stopping, 1);


regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
