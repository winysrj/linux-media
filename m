Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41799 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2AEKuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 05:50:10 -0500
Date: Thu, 5 Jan 2012 12:50:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Check media bus code on links
Message-ID: <20120105105005.GM9323@valkosipuli.localdomain>
References: <1325754619-2520-1-git-send-email-sakari.ailus@iki.fi>
 <201201051112.14459.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201051112.14459.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jan 05, 2012 at 11:12:14AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 05 January 2012 10:10:19 Sakari Ailus wrote:
> > Check media bus code on links. The user could configure different formats
> > at different ends of the link, say, 8 bits-per-pixel in the source and 10
> > bits-per-pixel in the sink. This leads to interesting and typically
> > undesired results image-wise.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispvideo.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index 615dae5..dbdd5b4 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -352,7 +352,8 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe)
> > 
> >  		/* Check if the two ends match */
> >  		if (fmt_source.format.width != fmt_sink.format.width ||
> > -		    fmt_source.format.height != fmt_sink.format.height)
> > +		    fmt_source.format.height != fmt_sink.format.height ||
> > +		    fmt_source.format.code != fmt_sink.format.code)
> 
> If you scroll down a bit, the check is already present in the second branch of 
> the if statement. The reason why the driver doesn't enforce the same format 
> unconditionally is that the lane shifter on the CCDC sink link can shift data, 
> so a special check is needed there.

Ooops. My mistake --- I had made an error in implementing
validate_pipeline() op. Somehow my assumption was the resulted issue would
be present in the original code.

You may thus ignore this patch completely.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
