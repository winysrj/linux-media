Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53758 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753414AbdC0OZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 10:25:51 -0400
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
Date: Sun, 26 Mar 2017 16:31:42 +0300
MIME-Version: 1.0
In-Reply-To: <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

...
> +static int vimc_cap_enum_input(struct file *file, void *priv,
> +			       struct v4l2_input *i)
> +{
> +	/* We only have one input */
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	/* We only have one input */
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	/* We only have one input */
> +	return i ? -EINVAL : 0;
> +}

You can drop the input IOCTLs altogether here. If you had e.g. a TV
tuner, it'd be the TV tuner driver's responsibility to implement them.

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi
