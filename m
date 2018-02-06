Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:46776 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753147AbeBFUib (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 15:38:31 -0500
Subject: Re: [PATCH v8 5/7] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
 <1517948874-21681-6-git-send-email-tharvey@gateworks.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3630ba30-eb18-0829-7b0c-f0a786232969@xs4all.nl>
Date: Tue, 6 Feb 2018 21:38:24 +0100
MIME-Version: 1.0
In-Reply-To: <1517948874-21681-6-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 09:27 PM, Tim Harvey wrote:
> Add support for the TDA1997x HDMI receivers.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---

<snip>

> +static int tda1997x_get_dv_timings_cap(struct v4l2_subdev *sd,
> +				       struct v4l2_dv_timings_cap *cap)
> +{
> +	if (cap->pad != TDA1997X_PAD_SOURCE)
> +		return -EINVAL;
> +
> +	*cap = tda1997x_dv_timings_cap;
> +	return 0;
> +}
> +
> +static int tda1997x_enum_dv_timings(struct v4l2_subdev *sd,
> +				    struct v4l2_enum_dv_timings *timings)
> +{
> +	if (timings->pad != TDA1997X_PAD_SOURCE)
> +		return -EINVAL;
> +
> +	return v4l2_enum_dv_timings_cap(timings, &tda1997x_dv_timings_cap,
> +					NULL, NULL);
> +}

You shouldn't need this pad test: it's done in the v4l2-subdev.c core code
already. But please double-check :-)

Can you post the output of the v4l2-compliance test? I'm curious to see it.

Can you also try to run v4l2-compliance -m /dev/mediaX? That also tests
whether the right entity types are set (note: testing for that should
also happen in the subdev compliance test, but I haven't done that yet).

Regards,

	Hans
