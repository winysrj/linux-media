Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:54157 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaBJKa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:30:29 -0500
Message-ID: <52F8AA42.2020409@imgtec.com>
Date: Mon, 10 Feb 2014 10:30:26 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com> <1391861250-26068-1-git-send-email-a.seppala@gmail.com> <1391861250-26068-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1391861250-26068-3-git-send-email-a.seppala@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 08/02/14 12:07, Antti Seppälä wrote:
> The encoding in rc5-sz first inserts a pulse and then simply utilizes the
> generic Manchester encoder available in rc-core.
> 
> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
> ---
>  drivers/media/rc/ir-rc5-sz-decoder.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
> index 984e5b9..0d5e552 100644
> --- a/drivers/media/rc/ir-rc5-sz-decoder.c
> +++ b/drivers/media/rc/ir-rc5-sz-decoder.c
> @@ -127,9 +127,44 @@ out:
>  	return -EINVAL;
>  }
>  
> +static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
> +	.pulse_space_start	= 0,
> +	.clock			= RC5_UNIT,
> +};
> +
> +/*
> + * ir_rc5_sz_encode() - Encode a scancode as a stream of raw events
> + *
> + * @protocols:  allowed protocols
> + * @scancode:   scancode filter describing scancode (helps distinguish between
> + *              protocol subtypes when scancode is ambiguous)
> + * @events:     array of raw ir events to write into
> + * @max:        maximum size of @events
> + *
> + * This function returns -EINVAL if the scancode filter is invalid or matches
> + * multiple scancodes. Otherwise the number of ir_raw_events generated is
> + * returned.
> + */
> +static int ir_rc5_sz_encode(u64 protocols,
> +			    const struct rc_scancode_filter *scancode,
> +			    struct ir_raw_event *events, unsigned int max)
> +{
> +	int ret;
> +	struct ir_raw_event *e = events;

Probably worth checking scancode->mask == 0xfff too?

> +
> +	/* RC5-SZ scancode is raw enough for manchester as it is */
> +	ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings, RC5_SZ_NBITS,
> +				    scancode->data);
> +	if (ret < 0)
> +		return ret;

I suspect it needs some more space at the end too, to be sure that no
more bits afterwards are accepted.

> +
> +	return e - events;
> +}
> +
>  static struct ir_raw_handler rc5_sz_handler = {
>  	.protocols	= RC_BIT_RC5_SZ,
>  	.decode		= ir_rc5_sz_decode,
> +	.encode		= ir_rc5_sz_encode,
>  };
>  
>  static int __init ir_rc5_sz_decode_init(void)
> 

Cheers
James

