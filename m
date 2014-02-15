Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44782 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaBOBS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 20:18:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: OMAP3 ISP capabilities, resizer
Date: Sat, 15 Feb 2014 02:20:03 +0100
Message-ID: <1820490.0WrQgPlyuR@avalon>
In-Reply-To: <alpine.DEB.2.01.1402121601100.6337@pmeerw.net>
References: <alpine.DEB.2.01.1402121601100.6337@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Wednesday 12 February 2014 16:19:55 Peter Meerwald wrote:
> Hello,
> 
> some more findings:
> 
> * the driver bug seen below was observed with kernel 3.7 and is already
> fixed in more recent kernels, likely with commit 864a121274,
> [media] v4l: Don't warn during link validation when encountering a V4L2
> devnode

Correct. I tend to forget about bugs that have been fixed ;-)

> * there still is a a confusing warning:
>   omap3isp omap3isp: can't find source, failing now
> which may be addressed by the patch here https://linuxtv.org/patch/15200/,
> but has not been applied

The patch won't apply anymore. I've just submitted two other patches (you've 
been CCed) to fix the problem, could you please test them ?

> * I have a test program, http://pmeerw.net/scaler.c, which exercises the
> OMAP3 ISP resizer standalone with the pipeline given below; it crashes the
> system quite reliably on 3.7 and recent kernels :(
> 
> the reason for the crash is that the ISP resizer can still be busy and
> doesn't like to be turned off then; a little sleep before
> omap3isp_sbl_disable() helps (or waiting for the ISP resize to become
> idle, see the patch below)
> 
> I'm not sure what omap3isp_module_sync_idle() is supposed to do, it
> immediately returns since we are in SINGLESHOT mode and
> isp_pipeline_ready() is false

The function is supposed to wait until the module becomes idle. I'm not sure 
why we don't call it for memory-to-memory pipelines, I need to investigate 
that. Sakari, do you remember what we've done there ?

> with below patch I am happily resizing...
> 
> // snip, RFC
> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> Date: Wed, 12 Feb 2014 15:59:20 +0100
> Subject: [PATCH] omap3isp: Wait for resizer to become idle before
> disabling
> 
> ---
>  drivers/media/platform/omap3isp/ispresizer.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/ispresizer.c
> b/drivers/media/platform/omap3isp/ispresizer.c
> index d11fb26..fea98f7 100644
> --- a/drivers/media/platform/omap3isp/ispresizer.c
> +++ b/drivers/media/platform/omap3isp/ispresizer.c
> @@ -1145,6 +1145,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> int enable) struct isp_video *video_out = &res->video_out;
>         struct isp_device *isp = to_isp_device(res);
>         struct device *dev = to_device(res);
> +       unsigned long timeout = 0;
> 
>         if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
>                 if (enable == ISP_PIPELINE_STREAM_STOPPED)
> @@ -1176,6 +1177,15 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> int enable) if (omap3isp_module_sync_idle(&sd->entity, &res->wait,
> &res->stopping))
>                         dev_dbg(dev, "%s: module stop timeout.\n",
> sd->name);
> +
> +               while (omap3isp_resizer_busy(res)) {
> +                       if (timeout++ > 1000) {
> +                               dev_alert(isp->dev, "ISP resizer does not
> become idle\n");
> +                               return -ETIMEDOUT;
> +                       }
> +                       udelay(100);
> +               }
> +

Let's try to avoid busy loops if possible. Does it help if you comment out the 
condition at the top of omap3isp_module_sync_idle() ?

>                 omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_RESIZER_READ |
>                                 OMAP3_ISP_SBL_RESIZER_WRITE);
>                 omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_RESIZER);

-- 
Regards,

Laurent Pinchart

