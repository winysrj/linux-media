Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59538 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750849AbdGUO5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 10:57:10 -0400
Date: Fri, 21 Jul 2017 14:53:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javi Merino <javi.merino@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH] Revert "[media] v4l: async: make v4l2 coexist with
 devicetree nodes in a dt overlay"
Message-ID: <20170721115328.4lm2sb4zlqeb2twb@valkosipuli.retiisi.org.uk>
References: <20170720220622.21470-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720220622.21470-1-robh@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Thu, Jul 20, 2017 at 05:06:22PM -0500, Rob Herring wrote:
> This reverts commit d2180e0cf77dc7a7049671d5d57dfa0a228f83c1.
> 
> The commit was flawed in that if the device_node pointers are different,
> then in fact a different device is present and the device node could be
> different in ways other than full_name.
> 
> As Frank Rowand explained:
> 
> "When an overlay (1) is removed, all uses and references to the nodes and
> properties in that overlay are no longer valid.  Any driver that uses any
> information from the overlay _must_ stop using any data from the overlay.
> Any driver that is bound to a new node in the overlay _must_ unbind.  Any
> driver that became bound to a pre-existing node that was modified by the
> overlay (became bound after the overlay was applied) _must_ adjust itself
> to account for any changes to that node when the overlay is removed.  One
> way to do this is to unbind when notified that the overlay is about to
> be removed, then to re-bind after the overlay is completely removed.
> 
> If an overlay (2) is subsequently applied, a node with the same
> full_name as from overlay (1) may exist.  There is no guarantee
> that overlay (1) and overlay (2) are the same overlay, even if
> that node has the same full_name in both cases."

The idea was that you could replace the DT snippet which is still referred
to by another graph endpoint. This was risky as there was no guarantee that
the stable endpoint configuration would still reflect the one that got
replaced. But I guess with DT overlays you always have to know what you're
doing.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> Also, there's not sufficient overlay support in mainline to actually
> remove and re-apply an overlay to hit this condition as overlays can
> only be applied from in kernel APIs.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Javi Merino <javi.merino@kernel.org>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Mauro, please apply this for 4.13. It could be marked for stable, too, 
> but it's not going to apply cleanly with the fwnode changes.
> 
> Rob
> 
>  drivers/media/v4l2-core/v4l2-async.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 851f128eba22..d741a8e0fdac 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -44,12 +44,7 @@ static bool match_devname(struct v4l2_subdev *sd,
>  
>  static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>  {
> -	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
> -		return sd->fwnode == asd->match.fwnode.fwnode;
> -
> -	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
> -			    of_node_full_name(
> -				    to_of_node(asd->match.fwnode.fwnode)));
> +	return sd->fwnode == asd->match.fwnode.fwnode;
>  }
>  
>  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> -- 
> 2.11.0
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
