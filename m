Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40862 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbbBRPip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:38:45 -0500
Message-ID: <54E4B1ED.2090404@xs4all.nl>
Date: Wed, 18 Feb 2015 16:38:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 5/7] [media] cx25840: better document the media controller
 TODO
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com> <b42dd11d90c964db544f176c1e0d1637bb79b474.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <b42dd11d90c964db544f176c1e0d1637bb79b474.1424273378.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2015 04:29 PM, Mauro Carvalho Chehab wrote:
> Analog video inputs are the tuner, plus composite, svideo, etc,
>  e. g. the input pat should actually be like:
> 
>                 ___________
> TUNER --------> |         |
>                 |         |
> SVIDEO .......> | cx25840 |
>                 |         |
> COMPOSITE1 ...> |_________|
> 
> (in the above, dashes represent the enabled link, and periods
> represent the disabled ones)
> 
> In other words, if we want to properly represent the pipeline,
> it should be possible to see via the media controller if the tuner
> is being used as an image source, or if the source is something else.
> 
> I didn't map those other inputs here yet, due to a few things:
> - The extra inputs would require subdevs that won't be controlled
> - I was in doubt about the best way for doing that
> - That would likely require some extra setup for cx25840 caller
>   drivers, in order to represent what of the possible internal
>   inputs are actually used on each specific board
> 
> Actually, at least for now, I was unable to see much benefit
> on adding such map now, so let's just document it, as this could
> be added later on, as needed.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index bdb5bb6b58da..cb4e03de9b75 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -5182,7 +5182,20 @@ static int cx25840_probe(struct i2c_client *client,
>  	sd = &state->sd;
>  	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	/* TODO: need to represent analog inputs too */
> +	/*
> +	 * TODO: add media controller support for analog video inputs like
> +	 * composite, svideo, etc.
> +	 * A real input pad for this analog demod would be like:
> +	 *                 ___________
> +	 * TUNER --------> |         |
> +	 *		   |         |
> +	 * SVIDEO .......> | cx25840 |
> +	 *		   |         |
> +	 * COMPOSITE1 ...> |_________|
> +	 *
> +	 * However, at least for now, there's no much gain on modelling
> +	 * those extra inputs. So, let's add it only when needed.
> +	 */
>  	state->pads[0].flags = MEDIA_PAD_FL_SINK;	/* Tuner or input */
>  	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;	/* Video */
>  	state->pads[2].flags = MEDIA_PAD_FL_SOURCE;	/* VBI */
> 

