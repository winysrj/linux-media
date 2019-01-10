Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A40C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A03C214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfAJNa0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:30:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:16284 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbfAJNa0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 08:30:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 05:30:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,461,1539673200"; 
   d="scan'208";a="113679420"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jan 2019 05:30:22 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3BD00209AC; Thu, 10 Jan 2019 15:30:21 +0200 (EET)
Date:   Thu, 10 Jan 2019 15:30:21 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes before using it
Message-ID: <20190110133020.y3bqba7sdkunm3ik@paasikivi.fi.intel.com>
References: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
 <b2dde2b4-65c7-2dc7-c66a-62a93d36be23@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2dde2b4-65c7-2dc7-c66a-62a93d36be23@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Thu, Jan 10, 2019 at 02:02:14PM +0100, Hans Verkuil wrote:
> On 01/10/19 13:43, Sakari Ailus wrote:
> > The for loop to reset the memory of the plane reserved fields runs over
> > num_planes provided by the user without validating it. Ensure num_planes
> > is no more than VIDEO_MAX_PLANES before the loop.
> > 
> > Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi folks,
> > 
> > This patch goes on top of Thierry's patch "media: v4l2-ioctl: Clear only
> > per-plane reserved fields".
> > 
> >  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index 392f1228af7b5..9e68a608ac6d3 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1551,6 +1551,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
> >  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
> >  			break;
> >  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> > +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> > +			break;
> 
> I would check this not here but in check_fmt: all *_FMT ioctls call that function
> first, so it makes sense to do the check there.

check_fmt() just takes the buffer type, no more parameters than that. But
I'm fine with introducing another function for the purpose, perhaps
renaming check_fmt() as check_buf_type().

I'll send v2.

> 
> v4l_print_format should also be adjusted (take the minimum of num_planes and
> VIDEO_MAX_PLANES), since it can still be called even if check_fmt returns an
> error if num_planes is too large.
> 
> In fact, the change to v4l_print_format should be a separate patch since that
> should be backported. It can leak memory in the kernel log if num_planes is
> too large.

Yes. I'm trying to figure out the affected versions. The code has been
mangled multiple times over the years so it's not entirely trivial.

> 
> Regards,
> 
> 	Hans
> 
> >  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> >  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
> >  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
> > @@ -1581,6 +1583,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
> >  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
> >  			break;
> >  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> > +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> > +			break;
> >  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> >  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
> >  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
> > @@ -1648,6 +1652,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
> >  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
> >  			break;
> >  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> > +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> > +			break;
> >  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> >  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
> >  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
> > @@ -1678,6 +1684,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
> >  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
> >  			break;
> >  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> > +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> > +			break;
> >  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> >  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
> >  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
> > 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
