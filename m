Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37843 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1LGSUD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 13:20:03 -0500
Date: Wed, 7 Dec 2011 20:19:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: video: Don't WARN() on unknown pixel formats
Message-ID: <20111207181957.GF938@valkosipuli.localdomain>
References: <1322480254-10461-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201112010026.07592.laurent.pinchart@ideasonboard.com>
 <20111201143451.GJ29805@valkosipuli.localdomain>
 <201112071444.12530.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112071444.12530.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 07, 2011 at 02:44:11PM +0100, Laurent Pinchart wrote:
> Hi Sakari,

Moi,

> On Thursday 01 December 2011 15:34:51 Sakari Ailus wrote:
> > On Thu, Dec 01, 2011 at 12:26:07AM +0100, Laurent Pinchart wrote:
> > > On Wednesday 30 November 2011 09:35:38 Sakari Ailus wrote:
> > > > Laurent Pinchart wrote:
> > > > > On Monday 28 November 2011 17:01:12 Sakari Ailus wrote:
> > > > >> On Mon, Nov 28, 2011 at 12:37:34PM +0100, Laurent Pinchart wrote:
> > > > >>> When mapping from a V4L2 pixel format to a media bus format in the
> > > > >>> VIDIOC_TRY_FMT and VIDIOC_S_FMT handlers, the requested format may
> > > > >>> be unsupported by the driver. Return a hardcoded format instead of
> > > > >>> WARN()ing in that case.
> > > > >>> 
> > > > >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > >>> ---
> > > > >>> 
> > > > >>>  drivers/media/video/omap3isp/ispvideo.c |    8 ++++----
> > > > >>>  1 files changed, 4 insertions(+), 4 deletions(-)
> > > > >>> 
> > > > >>> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > > > >>> b/drivers/media/video/omap3isp/ispvideo.c index d100072..ffe7ce9
> > > > >>> 100644 --- a/drivers/media/video/omap3isp/ispvideo.c
> > > > >>> +++ b/drivers/media/video/omap3isp/ispvideo.c
> > > > >>> @@ -210,14 +210,14 @@ static void isp_video_pix_to_mbus(const
> > > > >>> struct v4l2_pix_format *pix,
> > > > >>> 
> > > > >>>  	mbus->width = pix->width;
> > > > >>>  	mbus->height = pix->height;
> > > > >>> 
> > > > >>> -	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> > > > >>> +	/* Skip the last format in the loop so that it will be selected
> > > > >>> if no
> > > > >>> +	 * match is found.
> > > > >>> +	 */
> > > > >>> +	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
> > > > >>> 
> > > > >>>  		if (formats[i].pixelformat == pix->pixelformat)
> > > > >>>  		
> > > > >>>  			break;
> > > > >>>  	
> > > > >>>  	}
> > > > >>> 
> > > > >>> -	if (WARN_ON(i == ARRAY_SIZE(formats)))
> > > > >>> -		return;
> > > > >>> -
> > > > >>> 
> > > > >>>  	mbus->code = formats[i].code;
> > > > >>>  	mbus->colorspace = pix->colorspace;
> > > > >>>  	mbus->field = pix->field;
> > > > >> 
> > > > >> In case of setting or trying an invalid format, instead of selecting
> > > > >> a default format, shouldn't we leave the format unchanced --- the
> > > > >> current setting is valid after all.
> > > > > 
> > > > > TRY/SET operations must succeed. The format we select when an invalid
> > > > > format is requested isn't specified. We could keep the current
> > > > > format, but wouldn't that be more confusing for applications ? The
> > > > > format they would get in response to a TRY/SET operation would then
> > > > > potentially depend on the previous SET operations.
> > > > 
> > > > I don't think a change to something that has nothing to do what was
> > > > requested is better than not changing it. The application has requested
> > > > a particular format; changing it to something else isn't useful for the
> > > > application. And if the application would try more than invalid format
> > > > in a row, they both would yield to the same default format.
> > > > 
> > > > I would personally not change it.
> > > 
> > > I can agree with you for S_FMT, but I have more doubts about TRY_FMT.
> > > Making TRY_FMT return the current format if the requested format is not
> > > supported seems confusing to me. And if we make TRY_FMT return a fixed
> > > format in that case, why not making S_FMT do the same ? :-)
> > 
> > I'd rather have it the other way around. :-)
> 
> TRY_FMT means "can I use this format?". If the format isn't supported, the 
> driver answers "no, you should use this other format instead". I think that 
> making that other format depend on the current format would be confusing.

Also ENUM_FMT will depend on the format configured on the pipeline. If the
sensor connected to the CCDC produces YUV, the CCDC video capture node
musn't advertise YUV formats either.

I'm not saying this interface should be used by regular V4L2 applications,
but the pipeline configuration library.

> For S_FMT I could agree with you. When asked "please use this format", the 
> driver can answer "I can't, so I'm going to use this other one instead". That 
> other format could be the current one. However, it might be confusing (and 
> more difficult to implement) to return different formats in TRY_FMT and 
> S_FMTfor the same input. That's why I'm inclined to make S_FMT report the same 
> format as TRY_FMT.
> 
> This being said, the TRY_FMT/S_FMT behaviour of the OMAP3 ISP driver is 
> currently a bit broken, and ENUMFMT isn't implemented. Fixing this properly 
> requires getting rid of our current multiple video queues per video node hack 
> and using CREATE_BUFS instead. I'll see if I can find time to fix that. I 
> would still like to integrate this patch (or something close) in the meantime 
> to remove the WARN_ON.

Indeed, choosing a format, whether we agree on which one it should be or
not, is a big improvement over the current kernel warning. I reckon this is
might not reflect what the driver _should_ implement. It will take some time
to get the final answer for that, I guess. This is still one possible
solution.

So,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
