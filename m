Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:32796 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbCPIGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 04:06:23 -0400
MIME-Version: 1.0
In-Reply-To: <1426430018-3172-1-git-send-email-ykaneko0929@gmail.com>
References: <1426430018-3172-1-git-send-email-ykaneko0929@gmail.com>
Date: Mon, 16 Mar 2015 09:06:22 +0100
Message-ID: <CAMuHMdVKmWgcSqLxfgOUFXd2mu-dacvQxLJr7xLaQ=S8Mt0gnw@mail.gmail.com>
Subject: Re: [PATCH/RFC] v4l: vsp1: Change VSP1 LIF linebuffer FIFO
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san, Hosoya-san,

On Sun, Mar 15, 2015 at 3:33 PM, Yoshihiro Kaneko <ykaneko0929@gmail.com> wrote:
> From: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
>
> Change to VSPD hardware recommended value.
> Purpose is highest pixel clock without underruns.
> In the default R-Car Linux BSP config this value is
> wrong and therefore there are many underruns.
>
> Here are the original settings:
> HBTH = 1300 (VSPD stops when 1300 pixels are buffered)
> LBTH = 200 (VSPD resumes when buffer level has decreased
>             below 200 pixels)
>
> The display underruns can be eliminated
> by applying the following settings:
> HBTH = 1504
> LBTH = 1248

> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -44,9 +44,9 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
>  {
>         const struct v4l2_mbus_framefmt *format;
>         struct vsp1_lif *lif = to_lif(subdev);
> -       unsigned int hbth = 1300;
> -       unsigned int obth = 400;
> -       unsigned int lbth = 200;
> +       unsigned int hbth = 1536;
> +       unsigned int obth = 128;
> +       unsigned int lbth = 1520;

These values don't match the patch description?

BTW, what's the significance of changing obth?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
