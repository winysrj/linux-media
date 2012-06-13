Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4722 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2FMVcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:32:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 1/3] radio: Add Sanyo LM7000 tuner driver
Date: Wed, 13 Jun 2012 23:32:40 +0200
Cc: linux-media@vger.kernel.org
References: <201206132325.34370.linux@rainbow-software.org>
In-Reply-To: <201206132325.34370.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206132332.40555.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed June 13 2012 23:25:32 Ondrej Zary wrote:
> Add very simple driver for Sanyo LM7000 AM/FM tuner chip. Only FM is supported
> as there is no known HW with AM implemented.
> 
> This will be used by radio-aimslab and radio-sf16fmi.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

For all three patches:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> diff --git a/drivers/media/radio/lm7000.h b/drivers/media/radio/lm7000.h
> new file mode 100644
> index 0000000..139cd6b
> --- /dev/null
> +++ b/drivers/media/radio/lm7000.h
> @@ -0,0 +1,43 @@
> +#ifndef __LM7000_H
> +#define __LM7000_H
> +
> +/* Sanyo LM7000 tuner chip control
> + *
> + * Copyright 2012 Ondrej Zary <linux@rainbow-software.org>
> + * based on radio-aimslab.c by M. Kirkwood
> + * and radio-sf16fmi.c by M. Kirkwood and Petr Vandrovec
> + */
> +
> +#define LM7000_DATA	(1 << 0)
> +#define LM7000_CLK	(1 << 1)
> +#define LM7000_CE	(1 << 2)
> +
> +#define LM7000_FM_100	(0 << 20)
> +#define LM7000_FM_50	(1 << 20)
> +#define LM7000_FM_25	(2 << 20)
> +#define LM7000_BIT_FM	(1 << 23)
> +
> +static inline void lm7000_set_freq(u32 freq, void *handle,
> +				void (*set_pins)(void *handle, u8 pins))
> +{
> +	int i;
> +	u8 data;
> +	u32 val;
> +
> +	freq += 171200;		/* Add 10.7 MHz IF */
> +	freq /= 400;		/* Convert to 25 kHz units */
> +	val = freq | LM7000_FM_25 | LM7000_BIT_FM;
> +	/* write the 24-bit register, starting with LSB */
> +	for (i = 0; i < 24; i++) {
> +		data = val & (1 << i) ? LM7000_DATA : 0;
> +		set_pins(handle, data | LM7000_CE);
> +		udelay(2);
> +		set_pins(handle, data | LM7000_CE | LM7000_CLK);
> +		udelay(2);
> +		set_pins(handle, data | LM7000_CE);
> +		udelay(2);
> +	}
> +	set_pins(handle, 0);
> +}
> +
> +#endif /* __LM7000_H */
> 
> 
> 
> 
