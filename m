Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61784 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbCEH4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 02:56:34 -0500
Message-id: <54F80C2B.20705@samsung.com>
Date: Thu, 05 Mar 2015 08:56:27 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v12 04/19] dt-binding: leds: Add common LED DT bindings
 macros
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-5-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/2015 05:14 PM, Jacek Anaszewski wrote:
> Add macros for defining boost mode and trigger type properties
> of flash LED devices.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>   include/dt-bindings/leds/max77693.h |   21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>   create mode 100644 include/dt-bindings/leds/max77693.h

This should be obviously include/dt-bindings/leds/common.h.
It will affect also max77693-led bindings documentation patch.
I'll send the update after receiving review remarks related to the
remaining part of the mentioned patches.

>
> diff --git a/include/dt-bindings/leds/max77693.h b/include/dt-bindings/leds/max77693.h
> new file mode 100644
> index 0000000..79fcef7
> --- /dev/null
> +++ b/include/dt-bindings/leds/max77693.h
> @@ -0,0 +1,21 @@
> +/*
> + * This header provides macros for the common LEDs device tree bindings.
> + *
> + * Copyright (C) 2015, Samsung Electronics Co., Ltd.
> + *
> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + */
> +
> +#ifndef __DT_BINDINGS_LEDS_H__
> +#define __DT_BINDINGS_LEDS_H
> +
> +/* External trigger type */
> +#define LEDS_TRIG_TYPE_EDGE	0
> +#define LEDS_TRIG_TYPE_LEVEL	1
> +
> +/* Boost modes */
> +#define LEDS_BOOST_OFF		0
> +#define LEDS_BOOST_ADAPTIVE	1
> +#define LEDS_BOOST_FIXED	2
> +
> +#endif /* __DT_BINDINGS_LEDS_H */
>


-- 
Best Regards,
Jacek Anaszewski
