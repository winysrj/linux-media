Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1K3X0B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 18:26:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] omap3isp: video: Don't WARN() on unknown pixel formats
Date: Thu, 1 Dec 2011 00:26:07 +0100
Cc: linux-media@vger.kernel.org
References: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com> <201111300306.41892.laurent.pinchart@ideasonboard.com> <4ED5EADA.502@iki.fi>
In-Reply-To: <4ED5EADA.502@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112010026.07592.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 30 November 2011 09:35:38 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Monday 28 November 2011 17:01:12 Sakari Ailus wrote:
> >> On Mon, Nov 28, 2011 at 12:37:34PM +0100, Laurent Pinchart wrote:
> >>> When mapping from a V4L2 pixel format to a media bus format in the
> >>> VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may be
> >>> unsupported by the driver. Return a hardcoded format instead of
> >>> WARN()ing in that case.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> ---
> >>> 
> >>>  drivers/media/video/omap3isp/ispvideo.c |    8 ++++----
> >>>  1 files changed, 4 insertions(+), 4 deletions(-)
> >>> 
> >>> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> >>> b/drivers/media/video/omap3isp/ispvideo.c index d100072..ffe7ce9 100644
> >>> --- a/drivers/media/video/omap3isp/ispvideo.c
> >>> +++ b/drivers/media/video/omap3isp/ispvideo.c
> >>> @@ -210,14 +210,14 @@ static void isp_video_pix_to_mbus(const struct
> >>> v4l2_pix_format *pix,
> >>> 
> >>>  	mbus->width = pix->width;
> >>>  	mbus->height = pix->height;
> >>> 
> >>> -	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> >>> +	/* Skip the last format in the loop so that it will be selected if 
no
> >>> +	 * match is found.
> >>> +	 */
> >>> +	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
> >>> 
> >>>  		if (formats[i].pixelformat == pix->pixelformat)
> >>>  		
> >>>  			break;
> >>>  	
> >>>  	}
> >>> 
> >>> -	if (WARN_ON(i == ARRAY_SIZE(formats)))
> >>> -		return;
> >>> -
> >>> 
> >>>  	mbus->code = formats[i].code;
> >>>  	mbus->colorspace = pix->colorspace;
> >>>  	mbus->field = pix->field;
> >> 
> >> In case of setting or trying an invalid format, instead of selecting a
> >> default format, shouldn't we leave the format unchanced --- the current
> >> setting is valid after all.
> > 
> > TRY/SET operations must succeed. The format we select when an invalid
> > format is requested isn't specified. We could keep the current format,
> > but wouldn't that be more confusing for applications ? The format they
> > would get in response to a TRY/SET operation would then potentially
> > depend on the previous SET operations.
> 
> I don't think a change to something that has nothing to do what was
> requested is better than not changing it. The application has requested
> a particular format; changing it to something else isn't useful for the
> application. And if the application would try more than invalid format
> in a row, they both would yield to the same default format.
> 
> I would personally not change it.

I can agree with you for S_FMT, but I have more doubts about TRY_FMT. Making 
TRY_FMT return the current format if the requested format is not supported 
seems confusing to me. And if we make TRY_FMT return a fixed format in that 
case, why not making S_FMT do the same ? :-)

> What I can find in the spec is this:
> 
> "When the application calls the VIDIOC_S_FMT ioctl with a pointer to a
> v4l2_format structure the driver checks and adjusts the parameters
> against hardware abilities."
> 
> I wonder how other drivers behave.

uvcvideo returns -EINVAL, which I think should be fixed.

The sensor drivers I wrote return a fixed format (this isn't strictly 
S_FMT/TRY_FMT, but I think it's related).

-- 
Regards,

Laurent Pinchart
