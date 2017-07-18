Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40063 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752294AbdGRKD0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:03:26 -0400
Subject: Re: [PATCH] [media] platform: video-mux: convert to multiplexer
 framework
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20170717105514.18426-1-p.zabel@pengutronix.de>
Cc: kernel@pengutronix.de
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <39517db4-d249-4073-e6cb-b0204474da87@xs4all.nl>
Date: Tue, 18 Jul 2017 12:03:22 +0200
MIME-Version: 1.0
In-Reply-To: <20170717105514.18426-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/07/17 12:55, Philipp Zabel wrote:
> Now that the multiplexer framework is merged, drop the temporary
> mmio-mux implementation from the video-mux driver and convert it to use
> the multiplexer API.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/video-mux.c | 53 +++++---------------------------------
>  1 file changed, 7 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> index 665744716f73b..ee89ad76bee23 100644
> --- a/drivers/media/platform/video-mux.c
> +++ b/drivers/media/platform/video-mux.c
> @@ -17,8 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> -#include <linux/regmap.h>
> -#include <linux/mfd/syscon.h>
> +#include <linux/mux/consumer.h>

Shouldn't Kconfig be modified as well to select the multiplexer? Am I missing something?

Regards,

	Hans
