Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57446 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932705AbdCJWyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 17:54:25 -0500
Date: Sat, 11 Mar 2017 00:54:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-fwnode: Fix clock lane parsing
Message-ID: <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306072323.GA23509@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 06, 2017 at 08:23:24AM +0100, Pavel Machek wrote:
> Fix clock lane parsing in v4l2-fwnode.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index d6666d3..44036b8 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -167,7 +167,7 @@ void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwn,
>                 bus->data_lane = v;
>  
>         if (!fwnode_property_read_u32(fwn, "clock-lanes", &v))
> -               bus->data_lane = v;
> +               bus->clock_lane = v;

Oh my. Did I really write it like that?

I'll merge your fix next Monday. Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
