Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44834 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbcHQM1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:27:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/7] ov7670: call v4l2_async_register_subdev
Date: Wed, 17 Aug 2016 15:27:15 +0300
Message-ID: <1725866.OjAFEA93KG@avalon>
In-Reply-To: <1471415383-38531-3-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl> <1471415383-38531-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Wednesday 17 Aug 2016 08:29:38 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add v4l2-async support for this driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 25f46c7..26ad1a2 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1662,6 +1662,14 @@ static int ov7670_probe(struct i2c_client *client,
>  	v4l2_ctrl_cluster(2, &info->saturation);
>  	v4l2_ctrl_handler_setup(&info->hdl);
> 
> +	ret = v4l2_async_register_subdev(&info->sd);
> +	if (ret < 0) {
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		media_entity_cleanup(&info->sd.entity);
> +#endif

Don't you need to also call v4l2_ctrl_handler_free() ?

> +		return ret;
> +	}
> +
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

