Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3H1NeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 09:34:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] V4L2: add a v4l2-clk helper macro to produce an I2C device ID
Date: Wed, 28 Aug 2013 15:35:48 +0200
Message-ID: <14364379.DScLfzIeAP@avalon>
In-Reply-To: <1377696508-3190-3-git-send-email-g.liakhovetski@gmx.de>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de> <1377696508-3190-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Wednesday 28 August 2013 15:28:27 Guennadi Liakhovetski wrote:
> To obtain a clock reference consumers supply their device object to the
> V4L2 clock framework. The latter then uses the consumer device name to
> find a matching clock. For that to work V4L2 clock providers have to
> provide the same device name, when registering clocks. This patch adds
> a helper macro to generate a suitable device name for I2C devices.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> V4L2 clocks use device ID matching, which in case of I2C devices involves
> comparing a specially constructed from an I2C adapter number and a device
> address

Is this text placed below the SoB on purpose ?

> ---
>  include/media/v4l2-clk.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> index a354a9d..0b36cc1 100644
> --- a/include/media/v4l2-clk.h
> +++ b/include/media/v4l2-clk.h
> @@ -65,4 +65,7 @@ static inline struct v4l2_clk
> *v4l2_clk_register_fixed(const char *dev_id, return
> __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE); }
> 
> +#define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \
> +			  "%d-%04x", adap, client)
> +

I would have made this a static inline but I have to confess I don't know why 
:-)

>  #endif
-- 
Regards,

Laurent Pinchart

