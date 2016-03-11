Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34829 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934358AbcCKIEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 03:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <1457666737-10519-2-git-send-email-horms+renesas@verge.net.au>
References: <1457666737-10519-1-git-send-email-horms+renesas@verge.net.au>
	<1457666737-10519-2-git-send-email-horms+renesas@verge.net.au>
Date: Fri, 11 Mar 2016 09:04:14 +0100
Message-ID: <CAMuHMdUQnY-o220E0EwtiJrWUc1AyyVmp_Kudvt8zWmn+zdu-Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: soc_camera: rcar_vin: add R-Car Gen 2 and 3
 fallback compatibility strings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Kaneko <ykaneko0929@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 11, 2016 at 4:25 AM, Simon Horman
<horms+renesas@verge.net.au> wrote:
> From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>
> Add fallback compatibility string for R-Car Gen 1 and 2.
>
> In the case of Renesas R-Car hardware we know that there are generations of
> SoCs, e.g. Gen 2 and 3. But beyond that its not clear what the relationship
> between IP blocks might be. For example, I believe that r8a7790 is older
> than r8a7791 but that doesn't imply that the latter is a descendant of the
> former or vice versa.
>
> We can, however, by examining the documentation and behaviour of the
> hardware at run-time observe that the current driver implementation appears
> to be compatible with the IP blocks on SoCs within a given generation.
>
> For the above reasons and convenience when enabling new SoCs a
> per-generation fallback compatibility string scheme being adopted for
> drivers for Renesas SoCs.
>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1845,6 +1845,8 @@ static const struct of_device_id rcar_vin_of_table[] = {
>         { .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>         { .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>         { .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +       { .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
> +       { .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },

Your patch is correct, but I would sort gen2 before gen3, though.

>         { },

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
