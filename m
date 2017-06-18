Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54616 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752399AbdFRVTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 17:19:16 -0400
Date: Mon, 19 Jun 2017 00:18:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snawrocki@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hansverk@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC PATCH 1/2] v4l2-ioctl/exynos: fix G/S_SELECTION's type
 handling
Message-ID: <20170618211837.GY12407@valkosipuli.retiisi.org.uk>
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
 <20170616125827.GQ12407@valkosipuli.retiisi.org.uk>
 <baf6fee6-3c65-5aea-f042-cfdd6698e4ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baf6fee6-3c65-5aea-f042-cfdd6698e4ba@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Jun 18, 2017 at 10:53:48PM +0200, Sylwester Nawrocki wrote:
> >> + */
> >> +static int v4l_g_selection(const struct v4l2_ioctl_ops *ops,
> >> +			   struct file *file, void *fh, void *arg)
> >> +{
> >> +	struct v4l2_selection *p = arg;
> >> +	u32 old_type = p->type;
> >> +	int ret;
> >> +
> >> +	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >> +		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> +	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >> +		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> >> +	ret = ops->vidioc_g_selection(file, fh, p);
> >> +	p->type = old_type;
> >> +	return ret;
> >> +}
> >> +
> >> +static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
> >> +			   struct file *file, void *fh, void *arg)
> >> +{
> >> +	struct v4l2_selection *p = arg;
> >> +	u32 old_type = p->type;
> >> +	int ret;
> >> +
> >> +	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >> +		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> +	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >> +		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> >> +	ret = ops->vidioc_s_selection(file, fh, p);
> > 
> > Can it be that ops->vidioc_s_selection() is NULL here? I don't think it's
> > checked anywhere. Same in v4l_g_selection().
> 
> I think it can't be, there is the valid_ioctls bitmap test before a call back 
> to the driver, to see if driver actually implements an ioctl. And the bitmap 
> is populated beforehand in determine_valid_ioctls().

Ack. Looks good to me then.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
