Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34968 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeFFGem (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 02:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com> <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 6 Jun 2018 08:34:41 +0200
Message-ID: <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree binding
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, Jun 6, 2018 at 1:34 AM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> Provide device tree binding documentation for the MAX9286 Quad GMSL
> deserialiser.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
> @@ -0,0 +1,75 @@
> +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
> +
> +Required Properties:
> + - compatible: Shall be "maxim,max9286"
> +
> +The following required properties are defined externally in
> +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
> + - Standard I2C mux properties.
> + - I2C child bus nodes.
> +
> +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
> +correspond with a maximum of 4 input devices.
> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> +are numbered as follows.
> +
> +      Port        Type
> +    ----------------------
> +       0          sink
> +       1          sink
> +       2          sink
> +       3          sink
> +       4          source

I assume the source and at least one sink are thus mandatory?

Would it make sense to use port 0 for the source?
This would simplify extending the binding to devices with more input
ports later.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
