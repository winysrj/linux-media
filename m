Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55188 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714AbbABIyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jan 2015 03:54:46 -0500
Date: Fri, 2 Jan 2015 10:54:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 1/1] omap3isp: Correctly set QUERYCAP capabilities
Message-ID: <20150102085441.GP17565@valkosipuli.retiisi.org.uk>
References: <1420146834-13458-1-git-send-email-sakari.ailus@iki.fi>
 <17321888.FUCG9ahuk4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17321888.FUCG9ahuk4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 02, 2015 at 01:04:16AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 01 January 2015 23:13:54 Sakari Ailus wrote:
> > device_caps in struct v4l2_capability were inadequately set in
> > VIDIOC_QUERYCAP. Fix this.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/platform/omap3isp/ispvideo.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > b/drivers/media/platform/omap3isp/ispvideo.c index cdfec27..d644164 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > @@ -602,10 +602,13 @@ isp_video_querycap(struct file *file, void *fh, struct
> > v4l2_capability *cap) strlcpy(cap->card, video->video.name,
> > sizeof(cap->card));
> >  	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
> > 
> > +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> > +		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
> 
> I would align the | under the =. Apart from that,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I assume you'd apply the patch to your tree eventually? Can you make the
change, or would you prefer me to resend?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
