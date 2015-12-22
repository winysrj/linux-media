Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36790 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbbLVRoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 12:44:44 -0500
Received: by mail-lf0-f45.google.com with SMTP id z124so128844578lfa.3
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2015 09:44:43 -0800 (PST)
Subject: Re: [PATCH v2] adv7604: add direct interrupt handling
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1450794087-31153-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56798C04.1030109@cogentembedded.com>
Date: Tue, 22 Dec 2015 20:44:36 +0300
MIME-Version: 1.0
In-Reply-To: <1450794087-31153-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/22/2015 05:21 PM, Ulrich Hecht wrote:

> When probed from device tree, the i2c client driver can handle the
> interrupt on its own.
>
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> This revision implements the suggested style changes and drops the
> IRQF_TRIGGER_LOW flag, which is handled in the device tree.
>
> CU
> Uli
>
>
>   drivers/media/i2c/adv7604.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 5bd81bd..be5980c 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -31,6 +31,7 @@
>   #include <linux/gpio/consumer.h>
>   #include <linux/hdmi.h>
>   #include <linux/i2c.h>
> +#include <linux/interrupt.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/slab.h>
> @@ -1971,6 +1972,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>   	return 0;
>   }
>
> +static irqreturn_t adv76xx_irq_handler(int irq, void *devid)
> +{
> +	struct adv76xx_state *state = devid;
> +	bool handled;
> +
> +	adv76xx_isr(&state->sd, 0, &handled);
> +
> +	return handled ? IRQ_HANDLED : IRQ_NONE;

    Just IRQ_RETVAL(handled), maybe?

[...]

MBR, Sergei

