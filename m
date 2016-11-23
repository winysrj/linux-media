Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59592 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935760AbcKWPMh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 10:12:37 -0500
Date: Wed, 23 Nov 2016 17:10:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javi Merino <javi.merino@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] v4l: async: make v4l2 coexists with devicetree nodes in
 a dt overlay
Message-ID: <20161123151042.GD16630@valkosipuli.retiisi.org.uk>
References: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javi,

On Wed, Nov 23, 2016 at 10:09:57AM +0000, Javi Merino wrote:
> In asd's configured with V4L2_ASYNC_MATCH_OF, if the v4l2 subdev is in
> a devicetree overlay, its of_node pointer will be different each time
> the overlay is applied.  We are not interested in matching the
> pointer, what we want to match is that the path is the one we are
> expecting.  Change to use of_node_cmp() so that we continue matching
> after the overlay has been removed and reapplied.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Javi Merino <javi.merino@kernel.org>
> ---
> Hi,
> 
> I feel it is a bit of a hack, but I couldn't think of anything better.
> I'm ccing devicetree@ and Pantelis because there may be a simpler
> solution.

First I have to admit that I'm not an expert when it comes to DT overlays.

That said, my understanding is that the sub-device and the async sub-device
are supposed to point to the exactly same DT node. I wonder if there's
actually anything wrong in the current code.

If the overlay has changed between probing the driver for the async notifier
and the async sub-device, there should be no match here, should there? The
two nodes actually point to a node in a different overlay in that case.

> 
>  drivers/media/v4l2-core/v4l2-async.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 5bada20..d33a17c 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -42,7 +42,8 @@ static bool match_devname(struct v4l2_subdev *sd,
>  
>  static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
> -	return sd->of_node == asd->match.of.node;
> +	return !of_node_cmp(of_node_full_name(sd->of_node),
> +			    of_node_full_name(asd->match.of.node));
>  }
>  
>  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
