Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:60251 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaCPIed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 04:34:33 -0400
Received: by mail-qa0-f50.google.com with SMTP id o15so4248564qap.9
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 01:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394838259-14260-7-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
	<1394838259-14260-7-git-send-email-james@albanarts.com>
Date: Sun, 16 Mar 2014 10:34:31 +0200
Message-ID: <CAKv9HNYgfoAnTHfivgo8tov4nkSZHZ2+qJ=1BJzXUHXDmDSm2w@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 March 2014 01:04, James Hogan <james@albanarts.com> wrote:
> From: Antti Seppälä <a.seppala@gmail.com>
>
> The encoding in rc5-sz first inserts a pulse and then simply utilizes the
> generic Manchester encoder available in rc-core.
>
> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
> Signed-off-by: James Hogan <james@albanarts.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: David Härdeman <david@hardeman.nu>
> ---
> Changes in v2 (James Hogan):
>  - Turn ir_rc5_sz_encode() comment into kerneldoc and update to reflect
>    new API, with the -ENOBUFS return value for when the buffer is full
>    and only a partial message was encoded.
>  - Be more flexible around accepted scancode masks, as long as all the
>    important bits are set (0x2fff) and none of the unimportant bits are
>    set in the data. Also mask off the unimportant bits before passing to
>    ir_raw_gen_manchester().
>  - Explicitly enable leader bit in Manchester modulation timings.
> ---
>  drivers/media/rc/ir-rc5-sz-decoder.c | 45 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
> index dc18b74..a342a4f 100644
> --- a/drivers/media/rc/ir-rc5-sz-decoder.c
> +++ b/drivers/media/rc/ir-rc5-sz-decoder.c
> @@ -127,9 +127,54 @@ out:
>         return -EINVAL;
>  }
>
> +static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
> +       .leader                 = 1,
> +       .pulse_space_start      = 0,
> +       .clock                  = RC5_UNIT,
> +       .trailer_space          = RC5_UNIT * 10,
> +};
> +
> +/**
> + * ir_rc5_sz_encode() - Encode a scancode as a stream of raw events
> + *
> + * @protocols: allowed protocols
> + * @scancode:  scancode filter describing scancode (helps distinguish between
> + *             protocol subtypes when scancode is ambiguous)
> + * @events:    array of raw ir events to write into
> + * @max:       maximum size of @events
> + *
> + * Returns:    The number of events written.
> + *             -ENOBUFS if there isn't enough space in the array to fit the
> + *             encoding. In this case all @max events will have been written.
> + *             -EINVAL if the scancode is ambiguous or invalid.
> + */
> +static int ir_rc5_sz_encode(u64 protocols,
> +                           const struct rc_scancode_filter *scancode,
> +                           struct ir_raw_event *events, unsigned int max)
> +{
> +       int ret;
> +       struct ir_raw_event *e = events;
> +
> +       /* all important bits of scancode should be set in mask */
> +       if (~scancode->mask & 0x2fff)

Do we want to be so restrictive here? In my opinion it's quite nice to
be able to encode also the toggle bit if needed. Therefore a check
against 0x3fff would be a better choice.

I think the ability to encode toggle bit might also be nice to have
for rc-5(x) also.

> +               return -EINVAL;
> +       /* extra bits in mask should be zero in data */
> +       if (scancode->mask & scancode->data & ~0x2fff)
> +               return -EINVAL;
> +
> +       /* RC5-SZ scancode is raw enough for Manchester as it is */
> +       ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings, RC5_SZ_NBITS,
> +                                   scancode->data & 0x2fff);

I'm not sure that the & 0x2fff is necessary. It has the ill effect of
eventually writing something else to hardware while still committing
the filter as unmodified original value. This will result in
difference between what sysfs states was written when read back and
what was actually written.

I think checks above are good enough to restrict the values and as
little modification as possible of the data should be done after that.

> +       if (ret < 0)
> +               return ret;
> +
> +       return e - events;
> +}
> +
>  static struct ir_raw_handler rc5_sz_handler = {
>         .protocols      = RC_BIT_RC5_SZ,
>         .decode         = ir_rc5_sz_decode,
> +       .encode         = ir_rc5_sz_encode,
>  };
>
>  static int __init ir_rc5_sz_decode_init(void)
> --
> 1.8.3.2
>
