Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34018 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbcAKSTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 13:19:44 -0500
MIME-Version: 1.0
In-Reply-To: <1452535211-4869-2-git-send-email-ykaneko0929@gmail.com>
References: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
	<1452535211-4869-2-git-send-email-ykaneko0929@gmail.com>
Date: Mon, 11 Jan 2016 19:19:43 +0100
Message-ID: <CAMuHMdWFFVPRQE9TuqQwkH88utZKXLOo2i9GROb80Oc0QKyhDg@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: soc_camera: rcar_vin: Add rcar fallback
 compatibility string
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

On Mon, Jan 11, 2016 at 7:00 PM, Yoshihiro Kaneko <ykaneko0929@gmail.com> wrote:
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -143,6 +143,7 @@
>  #define RCAR_VIN_BT656                 (1 << 3)
>
>  enum chip_id {
> +       RCAR_GEN3,
>         RCAR_GEN2,
>         RCAR_H1,
>         RCAR_M1,
> @@ -1818,6 +1819,8 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>
>  #ifdef CONFIG_OF
>  static const struct of_device_id rcar_vin_of_table[] = {
> +       { .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
> +       { .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },

Please add the generic compatible values at the end of the list, so SoC-specific
ones take precedence.

>         { .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
>         { .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
>         { .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
