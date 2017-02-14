Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55606 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751351AbdBNWDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:03:01 -0500
Date: Wed, 15 Feb 2017 00:02:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 07/13] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170214220256.GN16975@valkosipuli.retiisi.org.uk>
References: <20170214134000.GA8550@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214134000.GA8550@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel and Sebastian,

On Tue, Feb 14, 2017 at 02:40:00PM +0100, Pavel Machek wrote:
> From: Sebastian Reichel <sre@kernel.org>
> 
> Without this, exposure / gain controls do not work in the camera application.

:-)

> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/media/v4l2-core/v4l2-device.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index f364cc1..b3afbe8 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -235,6 +235,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
>  			continue;
>  
> +		if(sd->devnode)
> +			continue;

This has been recognised as a problem but you're the first to submit a patch
I believe. Please add an appropriate description. :-)

s/if\(/if (/

I think this one should go in before the rest.

> +
>  		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
>  		if (!vdev) {
>  			err = -ENOMEM;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
