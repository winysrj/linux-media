Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46404 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1K3CGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 21:06:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] omap3isp: video: Don't WARN() on unknown pixel formats
Date: Wed, 30 Nov 2011 03:06:41 +0100
Cc: linux-media@vger.kernel.org
References: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com> <20111128160112.GE29805@valkosipuli.localdomain>
In-Reply-To: <20111128160112.GE29805@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300306.41892.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 28 November 2011 17:01:12 Sakari Ailus wrote:
> On Mon, Nov 28, 2011 at 12:37:34PM +0100, Laurent Pinchart wrote:
> > When mapping from a V4L2 pixel format to a media bus format in the
> > VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
> > unsupported by the driver. Return a hardcoded format instead of
> > WARN()ing in that case.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap3isp/ispvideo.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index d100072..ffe7ce9 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -210,14 +210,14 @@ static void isp_video_pix_to_mbus(const struct
> > v4l2_pix_format *pix,
> > 
> >  	mbus->width = pix->width;
> >  	mbus->height = pix->height;
> > 
> > -	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> > +	/* Skip the last format in the loop so that it will be selected if no
> > +	 * match is found.
> > +	 */
> > +	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
> > 
> >  		if (formats[i].pixelformat == pix->pixelformat)
> >  		
> >  			break;
> >  	
> >  	}
> > 
> > -	if (WARN_ON(i == ARRAY_SIZE(formats)))
> > -		return;
> > -
> > 
> >  	mbus->code = formats[i].code;
> >  	mbus->colorspace = pix->colorspace;
> >  	mbus->field = pix->field;
> 
> In case of setting or trying an invalid format, instead of selecting a
> default format, shouldn't we leave the format unchanced --- the current
> setting is valid after all.

TRY/SET operations must succeed. The format we select when an invalid format 
is requested isn't specified. We could keep the current format, but wouldn't 
that be more confusing for applications ? The format they would get in 
response to a TRY/SET operation would then potentially depend on the previous 
SET operations.

-- 
Regards,

Laurent Pinchart
