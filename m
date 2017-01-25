Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33779 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbdAYKJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 05:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <1484990984-16136-1-git-send-email-bhumirks@gmail.com>
References: <1484990984-16136-1-git-send-email-bhumirks@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 25 Jan 2017 10:08:34 +0000
Message-ID: <CA+V-a8scvMreQDdftDsP3B75ENSMu+OaUM0tUD-c1NPSZnznDg@mail.gmail.com>
Subject: Re: [PATCH] media: platform: constify vb2_ops structures
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        minghsiu.tsai@mediatek.com, houlong.wei@mediatek.com,
        andrew-ct.chen@mediatek.com, matthias.bgg@gmail.com,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch.

On Sat, Jan 21, 2017 at 9:29 AM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> Declare vb2_ops structures as const as they are only stored in
> the ops field of a vb2_queue structure. This field is of type
> const, so vb2_ops structures having same properties can be made
> const too.
> Done using Coccinelle:
>
> @r1 disable optional_qualifier@
> identifier i;
> position p;
> @@
> static struct vb2_ops i@p={...};
>
> @ok1@
> identifier r1.i;
> position p;
> struct sta2x11_vip vip;
> struct vb2_queue q;
> @@
> (
> vip.vb_vidq.ops=&i@p
> |
> q.ops=&i@p
> )
>
> @bad@
> position p!={r1.p,ok1.p};
> identifier r1.i;
> @@
> i@p
>
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> +const
> struct vb2_ops i;
>
> Cross compiled the media/platform/blackfin/bfin_capture.o file for
> blackfin architecture.
>
> File size before:
>   text     data     bss     dec     hex filename
>   6776      176       0    6952    1b28 platform/blackfin/bfin_capture.o
>
The description doesnt match the changes. Can you please split the
patches separately one for vpif_capture.c and vpif_display.c,
one for mtk_mdp_m2m.c and lastly for pxa_camera.c .


Cheers,
--Prabhakar Lad
