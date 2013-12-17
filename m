Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59816 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3LQR1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 12:27:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] v4l: omap4iss: use snprintf() to make smatch happy
Date: Tue, 17 Dec 2013 18:27:33 +0100
Message-ID: <1936770.TGxEZqmgZS@avalon>
In-Reply-To: <20131216201950.GA19601@elgon.mountain>
References: <20131216201950.GA19601@elgon.mountain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Monday 16 December 2013 23:19:50 Dan Carpenter wrote:
> Smatch complains here because name is a 32 character buffer and we
> adding the "OMAP4 ISS " prefix as well for a total of 42 characters.
> The sd->name buffer can only hold 32 characters.  I've changed it to use
> snprintf() to silence the overflow warning.
> 
> Also I have removed the call to strlcpy() which is a no-op.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> diff --git a/drivers/staging/media/omap4iss/iss_csi2.c
> b/drivers/staging/media/omap4iss/iss_csi2.c index
> 0ee8381c738d..7ab05126be5d 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.c
> +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> @@ -1273,8 +1273,7 @@ static int csi2_init_entities(struct iss_csi2_device
> *csi2, const char *subname) v4l2_subdev_init(sd, &csi2_ops);
>  	sd->internal_ops = &csi2_internal_ops;
>  	sprintf(name, "CSI2%s", subname);
> -	strlcpy(sd->name, "", sizeof(sd->name));
> -	sprintf(sd->name, "OMAP4 ISS %s", name);
> +	snprintf(sd->name, sizeof(sd->name), "OMAP4 ISS %s", name);
> 
>  	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
>  	v4l2_set_subdevdata(sd, csi2);
-- 
Regards,

Laurent Pinchart

