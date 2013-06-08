Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39993 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FHHKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 03:10:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] omap3isp: ccp2: Don't ignore the regulator_enable() return value
Date: Sat, 08 Jun 2013 09:10:06 +0200
Message-ID: <2313842.KY3Bh8lkJk@avalon>
In-Reply-To: <20130607105117.GE3103@valkosipuli.retiisi.org.uk>
References: <1370601341-5597-1-git-send-email-laurent.pinchart@ideasonboard.com> <20130607105117.GE3103@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Friday 07 June 2013 13:51:18 Sakari Ailus wrote:
> On Fri, Jun 07, 2013 at 12:35:41PM +0200, Laurent Pinchart wrote:
> > @@ -851,7 +857,11 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int
> > enable)> 
> >  		ccp2_print_status(ccp2);
> >  		
> >  		/* Enable CSI1/CCP2 interface */
> > 
> > -		ccp2_if_enable(ccp2, 1);
> > +		ret = ccp2_if_enable(ccp2, 1);
> > +		if (ret < 0) {
> > +			omap3isp_csiphy_release(ccp2->phy);
> 
> if (ccp2->phy)
> 	omap3isp_csiphy_release(ccp2->phy);
> 
> ?
> 
> I don't think 3430 has a separate phy, so it's NULL.

Oops, my bad. Fixed in v2.

> > +			return ret;
> > +		}
> > 
> >  		break;
> >  	
> >  	case ISP_PIPELINE_STREAM_SINGLESHOT:

-- 
Regards,

Laurent Pinchart

