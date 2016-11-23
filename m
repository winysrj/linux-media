Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48681
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753319AbcKWOZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 09:25:49 -0500
Subject: Re: [PATCH] v4l: async: make v4l2 coexists with devicetree nodes in a
 dt overlay
To: Javi Merino <javi.merino@kernel.org>, linux-media@vger.kernel.org
References: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <cf31105b-e8c1-4379-cd03-0bdcbdea64d6@osg.samsung.com>
Date: Wed, 23 Nov 2016 11:25:39 -0300
MIME-Version: 1.0
In-Reply-To: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javi,

On 11/23/2016 07:09 AM, Javi Merino wrote:
> In asd's configured with V4L2_ASYNC_MATCH_OF, if the v4l2 subdev is in
> a devicetree overlay, its of_node pointer will be different each time
> the overlay is applied.  We are not interested in matching the
> pointer, what we want to match is that the path is the one we are
> expecting.  Change to use of_node_cmp() so that we continue matching
> after the overlay has been removed and reapplied.
>

I'm still not that familiar with DT overlays (and I guess others aren't
either) so I think that including an example of a base tree and overlay
DTS where this is an issue, could make things more clear in the commit.

IIUC, it should be something like this?

-- base tree --

&i2c1 {
	camera: camera@10 {
		reg = <0x10>;
		port {
			cam_ep: endpoint {
				...
			};
		};
	};
};

&media_bridge {
	...
	ports {
		port@0 {
			reg = <0>;
			ep: endpoint {
				remote-endpoint = <&cam_ep>;
			};
		};
	};
};

-- overlay --

/plugin/;
/ {
	...
	fragment@0 {
		target = <&camera>;
		__overlay__ {
			compatible = "foo,bar";
			...
			port {
				cam_ep: endpoint {
					...
				};
			};
		};
	}
}

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
>

I also couldn't think a better way to do this, since IIUC the node's name is
the only thing that doesn't change, and is available at the time the bridge
driver calls v4l2_async_notifier_register() when parsing the base tree.

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
> 

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
