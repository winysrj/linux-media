Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:42465 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab1CQK2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 06:28:14 -0400
Date: Thu, 17 Mar 2011 11:28:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Patrice Chotard <patrice.chotard@sfr.fr>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH]  New Jeilin dual-mode camera support
Message-ID: <20110317112835.2247810d@tele>
In-Reply-To: <4D811835.5060303@sfr.fr>
References: <4D811835.5060303@sfr.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 16 Mar 2011 21:06:13 +0100
Patrice Chotard <patrice.chotard@sfr.fr> wrote:

> This patch add a new jeilin dual mode camera support and some
> specific controls settings.

Hi Patrice and Theodore,

Here are somme comments about Patrice's patch.

>  #include <linux/workqueue.h>
> +#include <linux/delay.h>
>  #include <linux/slab.h>

It is not a good idea to use mdelay(): it is a loop. Better use
msleep().

> -	u8 quality;			/* image quality */
> -	u8 jpegqual;			/* webcam quality */
> +	u8 camquality;			/* webcam quality */
> +	u8 jpegquality;			/* jpeg quality */

The webcam (encoding) quality and the jpeg (decoding) quality must be
the same. Then, looking carefully, jpegquality is not used!

> +	u8 freq;
> +	u8 type;
> +	/* below variables are only used for SPORTSCAM_DV15 */
> +	u8 autogain;
> +	u8 cyan;
> +	u8 magenta;
> +	u8 yellow;

You should use the new control mechanism (see stk014, sonixj, zc3xx...).

> +#define V4L2_CID_CAMQUALITY (V4L2_CID_USER_BASE + 1)
> +		.id      = V4L2_CID_CAMQUALITY,
> +		.type    = V4L2_CTRL_TYPE_INTEGER,
> +		.name    = "Image quality",

The JPEG quality must be get/set by the VIDIOC_G_JPEGCOMP /
VIDIOC_S_JPEGCOMP ioctl's.

> +#define V4L2_CID_CYAN_BALANCE (V4L2_CID_USER_BASE + 2)
	[snip]
> +#define V4L2_CID_MAGENTA_BALANCE (V4L2_CID_USER_BASE + 3)
	[snip]
> +#define V4L2_CID_YELLOW_BALANCE (V4L2_CID_USER_BASE + 4)

These values redefine V4L2_CID_SATURATION and V4L2_CID_HUE (user_base +
4 is no more defined). You should use V4L2_CID_RED_BALANCE,
V4L2_CID_BLUE_BALANCE and V4L2_CID_GAIN to set these controls.

> +	if (sd->type == SPORTSCAM_DV15)
> +		start_commands_size = 9;
> +	else
> +		start_commands_size = ARRAY_SIZE(start_commands);

Don't use magic values ('9').

> +			mdelay(start_commands[i].delay);

See above.

BTW, Theodore, as there is no USB command in the loop, there is no need
to have a work queue (look at the SENSOR_OV772x in ov534).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
