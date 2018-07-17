Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:56462 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbeGQSPP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 14:15:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham+renesas@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 10/11] media: vsp1: Support Interlaced display pipelines
Date: Tue, 17 Jul 2018 20:42:04 +0300
Message-ID: <24712162.Y2kuyfjJnU@avalon>
In-Reply-To: <08fd7b2c-f725-6018-b96e-72ce62dc21d7@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com> <5111021.qdhzlld4I3@avalon> <08fd7b2c-f725-6018-b96e-72ce62dc21d7@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tuesday, 17 July 2018 19:08:44 EEST Kieran Bingham wrote:
> On 17/07/18 13:52, Laurent Pinchart wrote:
> > On Monday, 16 July 2018 21:21:00 EEST Kieran Bingham wrote:
> >> On 24/05/18 13:51, Laurent Pinchart wrote:
> >>> On Thursday, 3 May 2018 16:36:21 EEST Kieran Bingham wrote:
> >>>> Calculate the top and bottom fields for the interlaced frames and
> >>>> utilise the extended display list command feature to implement the
> >>>> auto-field operations. This allows the DU to update the VSP2 registers
> >>>> dynamically based upon the currently processing field.
> >>>> 
> >>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>>> 
> >>>> ---
> >>>> 
> >>>> v3:
> >>>>  - Pass DL through partition calls to allow autocmd's to be retrieved
> >>>>  - Document interlaced field in struct vsp1_du_atomic_config
> >>>> 
> >>>> v2:
> >>>>  - fix erroneous BIT value which enabled interlaced
> >>>>  - fix field handling at frame_end interrupt
> >>>> 
> >>>> ---
> >>>> 
> >>>>  drivers/media/platform/vsp1/vsp1_dl.c   | 10 ++++-
> >>>>  drivers/media/platform/vsp1/vsp1_drm.c  | 11 ++++-
> >>>>  drivers/media/platform/vsp1/vsp1_regs.h |  1 +-
> >>>>  drivers/media/platform/vsp1/vsp1_rpf.c  | 71 ++++++++++++++++++++++--
> >>>>  drivers/media/platform/vsp1/vsp1_rwpf.h |  1 +-
> >>>>  include/media/vsp1.h                    |  2 +-
> >>>>  6 files changed, 93 insertions(+), 3 deletions(-)
> > 
> > [snip]
> > 
> >>>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> >>>> b/drivers/media/platform/vsp1/vsp1_drm.c index
> >>>> 2c3db8b8adce..cc29c9d96bb7
> >>>> 100644
> >>>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> >>>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> >>>> @@ -811,6 +811,17 @@ int vsp1_du_atomic_update(struct device *dev,
> >>>> unsigned int pipe_index,
> >>>>  		return -EINVAL;
> >>>>  	}
> >>>> 
> >>>> +	if (!(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) && cfg->interlaced) {
> >>> 
> >>> Nitpicking, writing the condition as
> >>> 
> >>> 	if (cfg->interlaced && !(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)))
> >> 
> >> Done.
> >> 
> >>> would match the comment better. You can also drop the parentheses around
> >>> the vsp1_feature() call.
> >>> 
> >>>> +		/*
> >>>> +		 * Interlaced support requires extended display lists to
> >>>> +		 * provide the auto-fld feature with the DU.
> >>>> +		 */
> >>>> +		dev_dbg(vsp1->dev, "Interlaced unsupported on this output\n");
> >>> 
> >>> Could we catch this in the DU driver to fail atomic test ?
> >> 
> >> Ugh - I thought moving the configuration to vsp1_du_setup_lif() would
> >> give us this, but that return value is not checked in the DU.
> >> 
> >> How can we interogate the VSP1 to ask it if it supports interlaced from
> >> rcar_du_vsp_plane_atomic_check()?
> >> 
> >> Some dummy call to vsp1_du_setup_lif() to check the return value ? Or
> >> should we implement a hook to call through to perform checks in the VSP1
> >> DRM API?
> > 
> > Would it be possible to just infer that from the DU compatible string,
> > without querying the VSP driver ? Of course that's a bit of a layering
> > violation, but as we know what type of VSP instance is present in each
> > SoC, such a small hack wouldn't hurt in my opinion. If the need arises
> > later we can introduce an API to query the information from the VSP
> > driver.
> 
> I'm not sure what there is to match on currently.
> 
> I thought that we had restrictions on which display pipelines supported
> interlaced. (i.e. D3/E3 might not) - but they seem to support extended
> display lists ...
> 
> So isn't it the case that any pipeline which we connect to DRM supports
> interlaced? (currently) - we can't / don't physically connect other VSP
> entities to the DRM pipes...

I haven't checked, but if you think that's the case, I'll trust you :-)

> >>>> +		return -EINVAL;
> >>>> +	}
> >>>> +
> >>>> +	rpf->interlaced = cfg->interlaced;
> >>>> +
> >>>>  	rpf->fmtinfo = fmtinfo;
> >>>>  	rpf->format.num_planes = fmtinfo->planes;
> >>>>  	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
> > 
> > [snip]

-- 
Regards,

Laurent Pinchart
