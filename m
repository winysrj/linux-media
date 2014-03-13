Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:18913 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaCMN5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 09:57:34 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2D00HZVO3WSF70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 09:57:32 -0400 (EDT)
Date: Thu, 13 Mar 2014 10:57:27 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 02/16] e4000: implement controls via v4l2 control
 framework
Message-id: <20140313105727.43c3d689@samsung.com>
In-reply-to: <1393461025-11857-3-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
 <1393461025-11857-3-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Feb 2014 02:30:11 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Implement gain and bandwidth controls using v4l2 control framework.
> Pointer to control handler is provided by exported symbol.
> 
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
>  drivers/media/tuners/e4000.h      |  14 +++
>  drivers/media/tuners/e4000_priv.h |  75 ++++++++++++++
>  3 files changed, 298 insertions(+), 1 deletion(-)

...
> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
> index e74b8b2..989f2ea 100644
> --- a/drivers/media/tuners/e4000.h
> +++ b/drivers/media/tuners/e4000.h
> @@ -40,4 +40,18 @@ struct e4000_config {
>  	u32 clock;
>  };
>  
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
> +extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> +		struct dvb_frontend *fe
> +);
> +#else
> +static inline struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> +		struct dvb_frontend *fe
> +)
> +{
> +	pr_warn("%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
>  #endif

There are two things to be noticed here:

1) Please don't add any EXPORT_SYMBOL() on a pure I2C module. You
should, instead, use the subdev calls, in order to callback a
function provided by the module;

2) As you're now using request_module(), you don't need to use
#if IS_ENABLED() anymore. It is up to the module to register
itself as a V4L2 subdevice. The caller module should use the
subdevice interface to run the callbacks.

If you don't to that, you'll have several issues with the
building system.

Regards,
Mauro
