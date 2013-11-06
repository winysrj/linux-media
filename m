Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35645 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab3KFB2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 20:28:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.chehab@samsung.com
Subject: Re: [PATCH 2/6] [media] mt9p031: Include linux/of.h header
Date: Wed, 06 Nov 2013 02:28:50 +0100
Message-ID: <2965670.TUVZegLOBr@avalon>
In-Reply-To: <1382065635-27855-2-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org> <1382065635-27855-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for the patch, and sorry for the late reply.

On Friday 18 October 2013 08:37:11 Sachin Kamat wrote:
> 'of_match_ptr' is defined in linux/of.h. Include it explicitly to avoid
> build breakage in the future.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will push it upstream.

> ---
>  drivers/media/i2c/mt9p031.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 4734836..1c2303d 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -19,6 +19,7 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/pm.h>
>  #include <linux/regulator/consumer.h>
-- 
Regards,

Laurent Pinchart

