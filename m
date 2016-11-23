Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36633 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965195AbcKWQD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 11:03:27 -0500
Date: Wed, 23 Nov 2016 16:03:13 +0000
From: Javi Merino <javi.merino@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] v4l: async: make v4l2 coexists with devicetree nodes in
 a dt overlay
Message-ID: <20161123160313.GA1753@ct-lt-587>
References: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
 <cf31105b-e8c1-4379-cd03-0bdcbdea64d6@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cf31105b-e8c1-4379-cd03-0bdcbdea64d6@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 11:25:39AM -0300, Javier Martinez Canillas wrote:
> Hello Javi,
> 
> On 11/23/2016 07:09 AM, Javi Merino wrote:
> > In asd's configured with V4L2_ASYNC_MATCH_OF, if the v4l2 subdev is in
> > a devicetree overlay, its of_node pointer will be different each time
> > the overlay is applied.  We are not interested in matching the
> > pointer, what we want to match is that the path is the one we are
> > expecting.  Change to use of_node_cmp() so that we continue matching
> > after the overlay has been removed and reapplied.
> >
> 
> I'm still not that familiar with DT overlays (and I guess others aren't
> either) so I think that including an example of a base tree and overlay
> DTS where this is an issue, could make things more clear in the commit.
> 
> IIUC, it should be something like this?
> 
> -- base tree --
> 
> &i2c1 {
> 	camera: camera@10 {
> 		reg = <0x10>;
> 		port {
> 			cam_ep: endpoint {
> 				...
> 			};
> 		};
> 	};
> };
> 
> &media_bridge {
> 	...
> 	ports {
> 		port@0 {
> 			reg = <0>;
> 			ep: endpoint {
> 				remote-endpoint = <&cam_ep>;
> 			};
> 		};
> 	};
> };
> 
> -- overlay --
> 
> /plugin/;
> / {
> 	...
> 	fragment@0 {
> 		target = <&camera>;
> 		__overlay__ {
> 			compatible = "foo,bar";
> 			...
> 			port {
> 				cam_ep: endpoint {
> 					...
> 				};
> 			};
> 		};
> 	}
> }

Yes, that's right.  What I have is that the whole camera can be
plugged or unplugged, so the overlay adds/removes the camera node:

/ {
	fragment@0 {
		target-path = "/i2c0";
		__overlay__ {
			my_cam {
				compatible = "foo,bar";
				port {
					camera0: endpoint {
						remote-endpoint = <&vin2a>;
						...
					};
				};
			};
		};
	};

I will add it to the commit message.

> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Javi Merino <javi.merino@kernel.org>
> > ---
> > Hi,
> > 
> > I feel it is a bit of a hack, but I couldn't think of anything better.
> > I'm ccing devicetree@ and Pantelis because there may be a simpler
> > solution.
> >
> 
> I also couldn't think a better way to do this, since IIUC the node's name is
> the only thing that doesn't change, and is available at the time the bridge
> driver calls v4l2_async_notifier_register() when parsing the base tree.
> 
> >  drivers/media/v4l2-core/v4l2-async.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index 5bada20..d33a17c 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -42,7 +42,8 @@ static bool match_devname(struct v4l2_subdev *sd,
> >  
> >  static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> >  {
> > -	return sd->of_node == asd->match.of.node;
> > +	return !of_node_cmp(of_node_full_name(sd->of_node),
> > +			    of_node_full_name(asd->match.of.node));
> >  }
> >  
> >  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
> > 
> 
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Best regards,
> -- 
> Javier Martinez Canillas
> Open Source Group
> Samsung Research America
