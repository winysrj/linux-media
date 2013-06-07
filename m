Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53030 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752620Ab3FGKvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jun 2013 06:51:22 -0400
Date: Fri, 7 Jun 2013 13:51:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] omap3isp: ccp2: Don't ignore the regulator_enable()
 return value
Message-ID: <20130607105117.GE3103@valkosipuli.retiisi.org.uk>
References: <1370601341-5597-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370601341-5597-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch, Laurent!

On Fri, Jun 07, 2013 at 12:35:41PM +0200, Laurent Pinchart wrote:
> @@ -851,7 +857,11 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
>  		ccp2_print_status(ccp2);
>  
>  		/* Enable CSI1/CCP2 interface */
> -		ccp2_if_enable(ccp2, 1);
> +		ret = ccp2_if_enable(ccp2, 1);
> +		if (ret < 0) {
> +			omap3isp_csiphy_release(ccp2->phy);

if (ccp2->phy)
	omap3isp_csiphy_release(ccp2->phy);

?

I don't think 3430 has a separate phy, so it's NULL.

> +			return ret;
> +		}
>  		break;
>  
>  	case ISP_PIPELINE_STREAM_SINGLESHOT:

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
