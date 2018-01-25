Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:44272 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeAYH7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 02:59:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180125003430.18558-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180125003430.18558-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 25 Jan 2018 08:59:35 +0100
Message-ID: <CAMuHMdVH8vHN3Q0zCKRn_KnfKf8P7yhqSSKjASp=u6qCZHzkNg@mail.gmail.com>
Subject: Re: [PATCH] v4l2-dev.h: fix symbol collision in media_entity_to_video_device()
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, Jan 25, 2018 at 1:34 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> A recent change to the media_entity_to_video_device() macro breaks some
> use-cases for the macro due to a symbol collision. Before the change
> this worked:
>
>     vdev =3D media_entity_to_video_device(link->sink->entity);
>
> While after the change it results in a compiler error "error: 'struct
> video_device' has no member named 'link'; did you mean 'lock'?". While
> the following still works after the change.
>
>     struct media_entity *entity =3D link->sink->entity;
>     vdev =3D media_entity_to_video_device(entity);
>
> Fix the collision by renaming the macro argument to 'media_entity'.

Thanks!
Given there also exists a "struct media_entity", using "_media_entity" seem=
s
safe to me.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
