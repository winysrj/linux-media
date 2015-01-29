Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:41957 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbbA2UTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:19:40 -0500
Received: by mail-oi0-f47.google.com with SMTP id a141so30742398oig.6
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 12:19:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422548388-28861-2-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-2-git-send-email-william.towle@codethink.co.uk>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 29 Jan 2015 21:19:24 +0100
Message-ID: <CAL8zT=jiw_JJVzemnnBTo_ys7Vc+-g+idnuiPkqyiMtdJZiJPg@mail.gmail.com>
Subject: Re: [PATCH 1/8] Add ability to read default input port from DT
To: William Towle <william.towle@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-01-29 17:19 GMT+01:00 William Towle <william.towle@codethink.co.uk>:
> From: Ian Molton <ian.molton@codethink.co.uk>
>
> ---
>  Documentation/devicetree/bindings/media/i2c/adv7604.txt |    3 +++
>  drivers/media/i2c/adv7604.c                             |    8 +++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)

Is this really passing through checkpatch ? Without a proper signed-off-by ?

> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index c27cede..bc50da2 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -33,6 +33,9 @@ Optional Properties:
>
>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
>
> +  - default-input: Reference to the chip's default input port. This value
> +    should match the pad number for the intended device
> +
>  Optional Endpoint Properties:
>
>    The following three properties are defined in video-interfaces.txt and are
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index e43dd2e..6666803 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2686,6 +2686,7 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>         struct device_node *endpoint;
>         struct device_node *np;
>         unsigned int flags;
> +       u32 v;

Could be named default_input ?

>         np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
>
> @@ -2695,6 +2696,12 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>                 return -EINVAL;
>
>         v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +
> +       if (!of_property_read_u32(endpoint, "default-input", &v))
> +               state->pdata.default_input = v;
> +       else
> +               state->pdata.default_input = -1;
> +

OK, so, whatever the value I put in DT, it will be put in the pdata ?
No test against max_port ?

>         of_node_put(endpoint);
>
>         flags = bus_cfg.bus.parallel.flags;
> @@ -2733,7 +2740,6 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>         /* Hardcode the remaining platform data fields. */
>         state->pdata.disable_pwrdnb = 0;
>         state->pdata.disable_cable_det_rst = 0;
> -       state->pdata.default_input = -1;
>         state->pdata.blank_data = 1;
>         state->pdata.alt_data_sat = 1;
>         state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

JM
