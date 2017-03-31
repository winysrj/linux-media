Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50718
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932677AbdCaJdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:33:17 -0400
Date: Fri, 31 Mar 2017 06:33:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        jgebben@codeaurora.org
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
Message-ID: <20170331063304.4bba8e7e@vento.lan>
In-Reply-To: <1539709.tvRnEGTVFr@avalon>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
        <2926010.76lXoG2CJo@avalon>
        <34146d93-6651-69a2-0997-aa3ae91b4fd3@collabora.com>
        <1539709.tvRnEGTVFr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 31 Mar 2017 11:41:51 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Helen,
> 
> On Thursday 30 Mar 2017 23:39:01 Helen Koike wrote:
> > On 2017-03-30 04:56 PM, Laurent Pinchart wrote:  
> > > On Thursday 30 Mar 2017 13:02:17 Helen Koike wrote:  
> > >> Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to be
> > >> used when no inputs are available in the device
> > >> 
> > >> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> > >> ---
> > >> 
> > >>  drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
> > >>  include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
> > >>  include/uapi/linux/videodev2.h       |  1 +
> > >>  3 files changed, 54 insertions(+)
> > >> 
> > >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > >> b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238..ccaf04b 100644
> > >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > >> @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct
> > >> video_device *vdev, unsigned cmd) return vdev->lock;
> > >> 
> > >>  }
> > >> 
> > >> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> > >> +				  struct v4l2_input *i)
> > >> +{
> > >> +	if (i->index > 0)
> > >> +		return -EINVAL;
> > >> +
> > >> +	memset(i, 0, sizeof(*i));
> > >> +	i->type = V4L2_INPUT_TYPE_DEFAULT;
> > >> +	strlcpy(i->name, "Default", sizeof(i->name));
> > >> +
> > >> +	return 0;
> > >> +}
> > >> +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);  
> > > 
> > > V4L2 tends to use EXPORT_SYMBOL_GPL.  
> > 
> > The whole v4l2-ioctl.c file is using EXPORT_SYMBOL instead of
> > EXPORT_SYMBOL_GPL, should we change it all to EXPORT_SYMBOL_GPL then (in
> > another patch) ?  
> 
> You're right, let's leave it as-is then.

At the time V4L2 was written, there was no EXPORT_SYMBOL_GPL(). That's
why there are some parts that aren't explicit about the symbol usage
license.

For newer symbols, we're using EXPORT_SYMBOL_GPL(), in order to let
clear about the licensing for the code.

Thanks,
Mauro
