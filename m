Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44304 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031754AbeEXKJA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:09:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 10/11] media: vsp1: Support Interlaced display pipelines
Date: Thu, 24 May 2018 13:08:55 +0300
Message-ID: <6945038.6Y03vj1EZt@avalon>
In-Reply-To: <8df5710f-77c0-f466-e9ed-ffde4dd2f8d9@ideasonboard.com>
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com> <1784754.iAtk829Up8@avalon> <8df5710f-77c0-f466-e9ed-ffde4dd2f8d9@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday, 3 May 2018 16:45:30 EEST Kieran Bingham wrote:
> On 03/05/18 12:13, Laurent Pinchart wrote:

[snip]

> >>> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h
> >>> b/drivers/media/platform/vsp1/vsp1_rwpf.h index
> >>> 70742ecf766f..8d6e42f27908 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> >>> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> >>> @@ -42,6 +42,7 @@ struct vsp1_rwpf {
> >>> 
> >>>  	struct v4l2_pix_format_mplane format;
> >>>  	const struct vsp1_format_info *fmtinfo;
> >>>  	unsigned int brx_input;
> >>> 
> >>> +	bool interlaced;
> > 
> > kerneldoc might be nice :-)
> 
> There's no existing kerneldoc on struct vsp1_rwpf ?

I'm glad we agree it should be added :-)

> >>>  	unsigned int alpha;
> > 
> > [snip]
> > 
> >>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> >>> index 678c24de1ac6..c10883f30980 100644
> >>> --- a/include/media/vsp1.h
> >>> +++ b/include/media/vsp1.h
> >>> @@ -50,6 +50,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
> >>> pipe_index,
> >>>   * @dst: destination rectangle on the display (integer coordinates)
> >>>   * @alpha: alpha value (0: fully transparent, 255: fully opaque)
> >>>   * @zpos: Z position of the plane (from 0 to number of planes minus 1)
> >>> + * @interlaced: true for interlaced pipelines
> > 
> > Maybe "true if the pipeline outputs an interlaced stream" ?
> 
> That's fine - but I've neglected to incorporate this into my v4 repost :-(
> 
> If by any magic - v4 is suitable for integration already, and you're happy
> to take it into your tree - please feel free to update this comment.
> 
> Otherwise it will be in any next update.

I'll check v4 now.

-- 
Regards,

Laurent Pinchart
