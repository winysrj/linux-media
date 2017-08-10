Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:32887 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdHJNiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 09:38:51 -0400
Received: by mail-wr0-f173.google.com with SMTP id v105so3328059wrb.0
        for <linux-media@vger.kernel.org>; Thu, 10 Aug 2017 06:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502007921-22968-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1502007921-22968-1-git-send-email-Julia.Lawall@lip6.fr> <1502007921-22968-5-git-send-email-Julia.Lawall@lip6.fr>
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Date: Thu, 10 Aug 2017 16:38:49 +0300
Message-ID: <CALi4nhp_xQodYy9Y=Cma4NSJh5wwPKhSksfj+HAtJ4jnCMHrxg@mail.gmail.com>
Subject: Re: [PATCH 04/12] [media] V4L2: platform: rcar_jpu: constify
 v4l2_m2m_ops structures
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 6, 2017 at 11:25 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> The v4l2_m2m_ops structures are only passed as the only
> argument to v4l2_m2m_init, which is declared as const.
> Thus the v4l2_m2m_ops structures themselves can be const.
>
> Done with the help of Coccinelle.
>
> // <smpl>
> @r disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct v4l2_m2m_ops i@p = { ... };
>
> @ok1@
> identifier r.i;
> position p;
> @@
> v4l2_m2m_init(&i@p)
>
> @bad@
> position p != {r.p,ok1.p};
> identifier r.i;
> struct v4l2_m2m_ops e;
> @@
> e@i@p
>
> @depends on !bad disable optional_qualifier@
> identifier r.i;
> @@
> static
> +const
>  struct v4l2_m2m_ops i = { ... };
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Ulyanov Mikhail <mikhail.ulyanov@cogentembedded.com>
