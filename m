Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35247 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbcF1MVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 08:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <20160627174533.16029-2-niklas.soderlund+renesas@ragnatech.se>
References: <20160627174533.16029-1-niklas.soderlund+renesas@ragnatech.se> <20160627174533.16029-2-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Jun 2016 14:21:10 +0200
Message-ID: <CAMuHMdVsXL7vR+-DVgy5N+MkG0C9HYpz7Fmght0KyRvOi9Vv1w@mail.gmail.com>
Subject: Re: [PATCH] [media] rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Mon, Jun 27, 2016 at 7:45 PM, Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> @@ -0,0 +1,79 @@
> +Renesas R-Car MIPI CSI-2 driver (rcar-csi2)
> +-------------------------------------------
> +
> +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-Car
> +family of devices. It is to be used in conjunction with the rcar-vin driver which
> +provides the video input capabilities.
> +
> + - compatible: Must be one or more of the following
> +   - "renesas,csi2-r8a7795" for the R8A7795 device

Please use "renesas,<soctype>-<device>" for new bindings, i.e.
"renesas,r8a7795-csi2".

> +   - "renesas,rcar-gen3-csi2" for a generic R-Car Gen3 compatible device.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
