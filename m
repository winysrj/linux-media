Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55211 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752316AbdFPIDr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 04:03:47 -0400
Subject: Re: [PATCH] omap3isp: fix compilation
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
References: <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170615222302.GB20714@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a9582fc4-408e-3956-d609-8e7abb28f41b@xs4all.nl>
Date: Fri, 16 Jun 2017 10:03:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170615222302.GB20714@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 12:23 AM, Pavel Machek wrote:
> 
> Fix compilation of isp.c
>      
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 4ca3fc9..b80debf 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2026,7 +2026,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
>   
>   	isd->bus = buscfg;
>   
> -	ret = v4l2_fwnode_endpoint_parse(fwn, vep);
> +	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
>   	if (ret)
>   		return ret;
>   
> 

You're using something old since the media tree master already uses &vep.

Regards,

	Hans
