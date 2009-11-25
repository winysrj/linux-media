Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1723 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbZKYTsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 14:48:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 2/4 v8] Definitions for TVP7002 in DM365
Date: Wed, 25 Nov 2009 20:48:06 +0100
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com
References: <1259177948-14878-1-git-send-email-santiago.nunez@ridgerun.com>
In-Reply-To: <1259177948-14878-1-git-send-email-santiago.nunez@ridgerun.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <200911252048.06863.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 November 2009 20:39:08 santiago.nunez@ridgerun.com wrote:
> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> 
> This patch provides the required definitions for the TVP7002 driver
> in DM365.
> 
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  drivers/media/video/tvp7002_reg.h |  150 +++++++++++++++++++++++++++++++++++++
>  include/media/tvp7002.h           |   54 +++++++++++++
>  2 files changed, 204 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tvp7002_reg.h
>  create mode 100644 include/media/tvp7002.h
> 

<cut>

> diff --git a/include/media/tvp7002.h b/include/media/tvp7002.h
> new file mode 100644
> index 0000000..220e833
> --- /dev/null
> +++ b/include/media/tvp7002.h
> @@ -0,0 +1,54 @@
> +/* Texas Instruments Triple 8-/10-BIT 165-/110-MSPS Video and Graphics
> + * Digitizer with Horizontal PLL registers
> + *
> + * Copyright (C) 2009 Texas Instruments Inc
> + * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> + *
> + * This code is partially based upon the TVP5150 driver
> + * written by Mauro Carvalho Chehab (mchehab@infradead.org),
> + * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
> + * and the TVP7002 driver in the TI LSP 2.10.00.14
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +#ifndef _TVP7002_H_
> +#define _TVP7002_H_
> +
> +/* Platform-dependent data
> + *
> + * clk_polarity:
> + * 			0 -> data clocked out on rising edge of DATACLK signal
> + * 			1 -> data clocked out on falling edge of DATACLK signal
> + * hs_polarity:
> + * 			0 -> active low HSYNC output
> + * 			1 -> active high HSYNC output
> + * sog_polarity:
> + * 			0 -> normal operation
> + * 			1 -> operation with polarity inverted
> + * vs_polarity:
> + * 			0 -> active low VSYNC output
> + * 			1 -> active high VSYNC output
> + * fid_polariry:

typo: polariry -> polarity

> + * 			0 -> even field ID output
> + * 			1 -> odd field ID output

This isn't clear to me: what do you mean with 'even field ID output'?

Regards,

	Hans

> + */
> +struct tvp7002_config {
> +	u8 clk_polarity;
> +	u8 hs_polarity;
> +	u8 vs_polarity;
> +	u8 fid_polarity;
> +	u8 sog_polarity;
> +};
> +#endif
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
