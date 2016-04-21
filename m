Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56494 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbcDUGzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 02:55:52 -0400
Subject: Re: [PATCHv4] [media] rcar-vin: add Renesas R-Car VIN driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ulrich.hecht@gmail.com
References: <1460471585-11225-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57187972.9020904@xs4all.nl>
Date: Thu, 21 Apr 2016 08:55:46 +0200
MIME-Version: 1.0
In-Reply-To: <1460471585-11225-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2016 04:33 PM, Niklas Söderlund wrote:
> +static void rect_set_min_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *min_size)
> +{
> +	if (r->width < min_size->width)
> +		r->width = min_size->width;
> +	if (r->height < min_size->height)
> +		r->height = min_size->height;
> +}
> +
> +static void rect_set_max_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *max_size)
> +{
> +	if (r->width > max_size->width)
> +		r->width = max_size->width;
> +	if (r->height > max_size->height)
> +		r->height = max_size->height;
> +}
> +
> +static void rect_map_inside(struct v4l2_rect *r,
> +			    const struct v4l2_rect *boundary)
> +{
> +	rect_set_max_size(r, boundary);
> +
> +	if (r->left < boundary->left)
> +		r->left = boundary->left;
> +	if (r->top < boundary->top)
> +		r->top = boundary->top;
> +	if (r->left + r->width > boundary->width)
> +		r->left = boundary->width - r->width;
> +	if (r->top + r->height > boundary->height)
> +		r->top = boundary->height - r->height;
> +}
> +

The v4l2-rect.h helpers have been merged, so you should be able to use
those for v5 and drop these functions here.

Regards,

	Hans
