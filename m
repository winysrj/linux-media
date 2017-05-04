Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37680 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdEDLWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 07:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <1493895213-12573-2-git-send-email-Alexandru_Gheorghe@mentor.com>
References: <1493895213-12573-1-git-send-email-Alexandru_Gheorghe@mentor.com> <1493895213-12573-2-git-send-email-Alexandru_Gheorghe@mentor.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 4 May 2017 13:22:52 +0200
Message-ID: <CAMuHMdV81g03TxLKx6gMGV_PqGYE4C1UVg=Z0GV3mYmtSt-Dcw@mail.gmail.com>
Subject: Re: [PATCH 1/2] v4l: vsp1: Add support for colorkey alpha blending
To: agheorghe <Alexandru_Gheorghe@mentor.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 4, 2017 at 12:53 PM, agheorghe
<Alexandru_Gheorghe@mentor.com> wrote:
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -32,6 +32,9 @@ struct vsp1_du_atomic_config {
>         struct v4l2_rect dst;
>         unsigned int alpha;
>         unsigned int zpos;
> +       u32 colorkey;
> +       bool colorkey_en;

Please move this bool down, together with the other bool, to reduce
object size due to alignment.

> +       u32 colorkey_alpha;
>         bool interlaced;
>  };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
