Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35833 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752548AbdEQOZ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 10:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 May 2017 16:25:56 +0200
Message-ID: <CAMuHMdU8Pz=pApw4x0j+iVc0jHagQbv02UCphidmLMNb5tAGFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
To: Kieran Bingham <kbingham@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, May 17, 2017 at 4:13 PM, Kieran Bingham <kbingham@kernel.org> wrote:
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -829,7 +829,7 @@ struct v4l2_subdev {
>  };
>
>  #define media_entity_to_v4l2_subdev(ent) \
> -       container_of(ent, struct v4l2_subdev, entity)
> +       ent ? container_of(ent, struct v4l2_subdev, entity) : NULL

Due to the low precedence level of the ternary operator, you want
to enclose this in parentheses.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
