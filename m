Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36492 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756863AbdELKKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 06:10:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, sre@kernel.org,
        magnus.damm@gmail.com, wsa+renesas@sang-engineering.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: ov772x: Force use of SCCB protocol
Date: Fri, 12 May 2017 13:10:33 +0300
Message-ID: <6204273.WTihKTXbd5@avalon>
In-Reply-To: <1494582763-22385-1-git-send-email-jacopo@jmondi.org>
References: <1494582763-22385-1-git-send-email-jacopo@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Friday 12 May 2017 11:52:43 Jacopo Mondi wrote:
> Force use of Omnivision's SCCB protocol and make sure the I2c adapter
> supports protocol mangling during probe.

How does this patch make sure that the I2C adapter supports protocol mangling 
?

> Testing done on SH4 Migo-R board.
> As commit:
> [e789029761503f0cce03e8767a56ae099b88e1bd]
> "i2c: sh_mobile: don't send a stop condition by default inside transfers"

References to commits are usually formatted as

commit e789029761503f0cce03e8767a56ae099b88e1bd
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Thu Jan 17 10:45:57 2013 +0100

    i2c: sh_mobile: don't send a stop condition by default inside transfers

or

commit e78902976150 ("i2c: sh_mobile: don't send a stop condition by default 
inside transfers")

> makes the i2c adapter emit a stop bit between messages in a single
> transfer only when explicitly required, the ov772x driver fails to
> probe due to i2c transfer timeout without SCCB flag set.
> 
> i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
> ov772x 0-0021: Product ID error 92:92
> 
> With this patch applied:
> 
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> ov772x 0-0021: ov7725 Product ID 77:21 Manufacturer ID 7f:a2

I think you're getting the commit message backwards. It would be easier to 
read if you start by an explanation of why the commit is needed, followed by 
what it does. How about something like this ?

--------
Since commit e78902976150 ("i2c: sh_mobile: don't send a stop condition by 
default inside transfers") the i2c_sh_mobile I2C adapter emits repeated starts 
between messages in a transfer unless explicitly requested with I2C_M_STOP. 
This breaks the ov772x driver in the SH4 Migo-R board as the Omnivision sensor 
uses the I2C-like SCCB protocol that doesn't support repeated starts:

i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
ov772x 0-0021: Product ID error 92:92

Fix it by marking the client as an SCCB client, which will force the I2C 
adapter to emit a stop/start between all messages.

The patch has been tested on SH4 Migo-R board and fixes probing of the ov772x 
driver:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
ov772x 0-0021: ov7725 Product ID 77:21 Manufacturer ID 7f:a2
--------

> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/soc_camera/ov772x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov772x.c
> b/drivers/media/i2c/soc_camera/ov772x.c index 985a367..8a4b29e 100644
> --- a/drivers/media/i2c/soc_camera/ov772x.c
> +++ b/drivers/media/i2c/soc_camera/ov772x.c
> @@ -1067,6 +1067,7 @@ static int ov772x_probe(struct i2c_client *client,
>  			"I2C-Adapter doesn't support 
I2C_FUNC_SMBUS_BYTE_DATA\n");
>  		return -EIO;
>  	}
> +	client->flags |= I2C_CLIENT_SCCB;
> 
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)

-- 
Regards,

Laurent Pinchart
