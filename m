Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45022 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdFSLPj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 07:15:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] v4l: vsp1: Remove WPF vertical flip support on VSP2-B[CD] and VSP2-D
Date: Mon, 19 Jun 2017 14:16:10 +0300
Message-ID: <1880337.HyBPYQX1Jb@avalon>
In-Reply-To: <01747c5c-bb5e-77ff-c46d-9589c606cef7@xs4all.nl>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com> <20170615082409.9523-2-laurent.pinchart+renesas@ideasonboard.com> <01747c5c-bb5e-77ff-c46d-9589c606cef7@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 15 Jun 2017 10:53:33 Hans Verkuil wrote:
> On 06/15/17 10:24, Laurent Pinchart wrote:
> > The WPF vertical flip is only supported on Gen3 SoCs on the VSP2-I.
> > Don't enable it on other VSP2 instances.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Should this go to older kernels as well? Or is that not needed?

Now that I have access to the hardware again, after further testing, it looks 
like vertical flip is implemented in the VSP2-B[CD] and VSP2-D even though the 
datasheet states otherwise. Let's ignore this patch for now, I'll try to 
double-check with Renesas.

> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drv.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> > b/drivers/media/platform/vsp1/vsp1_drv.c index 048446af5ae7..239996cf882e
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drv.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> > @@ -690,7 +690,7 @@ static const struct vsp1_device_info
> > vsp1_device_infos[] = { 
> >  		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
> >  		.model = "VSP2-BD",
> >  		.gen = 3,
> > -		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
> > +		.features = VSP1_HAS_BRU,
> >  		.rpf_count = 5,
> >  		.wpf_count = 1,
> >  		.num_bru_inputs = 5,
> > @@ -700,7 +700,7 @@ static const struct vsp1_device_info
> > vsp1_device_infos[] = { 
> >  		.model = "VSP2-BC",
> >  		.gen = 3,
> >  		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
> > -			  | VSP1_HAS_LUT | VSP1_HAS_WPF_VFLIP,
> > +			  | VSP1_HAS_LUT,
> >  		.rpf_count = 5,
> >  		.wpf_count = 1,
> >  		.num_bru_inputs = 5,
> > @@ -709,7 +709,7 @@ static const struct vsp1_device_info
> > vsp1_device_infos[] = { 
> >  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
> >  		.model = "VSP2-D",
> >  		.gen = 3,
> > -		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
> > +		.features = VSP1_HAS_BRU | VSP1_HAS_LIF,
> >  		.rpf_count = 5,
> >  		.wpf_count = 2,
> >  		.num_bru_inputs = 5,

-- 
Regards,

Laurent Pinchart
