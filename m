Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABED0C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF3220855
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 10:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfARKpa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 05:45:30 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34017 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfARKp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 05:45:29 -0500
Received: by mail-vs1-f65.google.com with SMTP id y27so8171049vsi.1;
        Fri, 18 Jan 2019 02:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HSG1QvBH8swTMrQFUGLxYHSbTKD74aRNkUnjPheiP4=;
        b=ievL0N8WBfKIE4zY1dXyo8r9qkjIUnK4iidJVU0lnQVpr1XVigspO4Tm3Nht3cKErB
         09/XZ9Q7qLoS5t9qJiPTu3ZG4Qd4aaTJBmoovJxoKGO9+v4DkdiC2pcHmDpxpmKjHhkd
         DyB5Gx/GZXMgLNnVB6UKSUWn5qpRsZKhxgU0fjIccXujiSPt29SeStXN0ZQLugaEK5/9
         0L9hVV6GQif91jFbXrJ/pcz+8e9GlqD/cjaRw58Yp6WwUOrniJsoxFZqhHhgay+mTB96
         +tn8CeoKSSRQh1TnhwUpXfoq7FMplps5SkRY+6GO0ZrFq5uLlg4ta9mI5nK1GRsjrrFx
         hBhw==
X-Gm-Message-State: AJcUukcUSQqXGYvQo4XHzYcqfeAitgsLhtTSBRTHFErQKAgWZlMzuLwZ
        iAeOaOozqSpbS6Ap27AaxqbQeXqIPYSEbzth2Pc=
X-Google-Smtp-Source: ALg8bN6hL4SzkHb5BGXRCV37soMLeXV6KhiU+8hzbyqh+L0MOJI1dI19+XuGMR4M+dVrbwfE28alYaufT76Ee/VB8oc=
X-Received: by 2002:a67:b60d:: with SMTP id d13mr7666621vsm.152.1547808328333;
 Fri, 18 Jan 2019 02:45:28 -0800 (PST)
MIME-Version: 1.0
References: <1528451328-21316-1-git-send-email-geert@linux-m68k.org>
 <5948eb0d-410d-5bc6-a0f3-ffcaa4b3f975@xs4all.nl> <d30d5bcd-8719-ac59-adf5-08c9576be759@xs4all.nl>
In-Reply-To: <d30d5bcd-8719-ac59-adf5-08c9576be759@xs4all.nl>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jan 2019 11:45:16 +0100
Message-ID: <CAMuHMdUKePx7WWAAB3LCFWd29yis1zC2oCPrgmdH2n8fOhKyMQ@mail.gmail.com>
Subject: Re: [PATCH] media: fsl-viu: Use proper check for presence of {out,in}_be32()
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Jan 18, 2019 at 11:08 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This patch is still in my patchwork todo list, and I wonder who will pick this up,
> especially the change to arch/powerpc/include/asm/io.h.

I think the powerpc tree makes most sense.

> Wouldn't it be easier to just fix this in fsl-viu.c only by doing this:
>
> #ifndef CONFIG_PPC
> #ifndef out_be32
> #define out_be32(v, a)  iowrite32be(a, (void __iomem *)v)
> #endif
> #ifndef in_be32
> #define in_be32(a)      ioread32be((void __iomem *)a)
> #endif
> #endif
>
> Basically just your patch, but without removing #ifndef CONFIG_PPC.
>
> That way there is no need to touch arch/powerpc/include/asm/io.h.

While I agree that avoids touching the powerpc tree, it doesn't solve
the problem
in the long run.
All drivers using e.g. out_be32() would need an extra check for CONFIG_PPC
to enable compile-testing.  The same is true when handling this in asm-generic.

> On 6/15/18 10:10 AM, Hans Verkuil wrote:
> > On 08/06/18 11:48, Geert Uytterhoeven wrote:
> >> When compile-testing on m68k or microblaze:
> >>
> >>     drivers/media/platform/fsl-viu.c:41:1: warning: "out_be32" redefined
> >>     drivers/media/platform/fsl-viu.c:42:1: warning: "in_be32" redefined
> >>
> >> Fix this by replacing the check for PowerPC by checks for the presence
> >> of {out,in}_be32().
> >>
> >> As PowerPC implements the be32 accessors using inline functions instead
> >> of macros, identity definions are added for all accessors to make the
> >> above checks work.
> >>
> >> Fixes: 29d750686331a1a9 ("media: fsl-viu: allow building it with COMPILE_TEST")
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Should this go through the media tree or powerpc tree? Either way works for me.
> >
> > Regards,
> >
> >       Hans
> >
> >> ---
> >> Compile-tested on m68k, microblaze, and powerpc.
> >> Assembler output before/after compared for powerpc.
> >> ---
> >>  arch/powerpc/include/asm/io.h    | 14 ++++++++++++++
> >>  drivers/media/platform/fsl-viu.c |  4 +++-
> >>  2 files changed, 17 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> >> index e0331e7545685c5f..3741183ae09349f1 100644
> >> --- a/arch/powerpc/include/asm/io.h
> >> +++ b/arch/powerpc/include/asm/io.h
> >> @@ -222,6 +222,20 @@ static inline void out_be64(volatile u64 __iomem *addr, u64 val)
> >>  #endif
> >>  #endif /* __powerpc64__ */
> >>
> >> +#define in_be16 in_be16
> >> +#define in_be32 in_be32
> >> +#define in_be64 in_be64
> >> +#define in_le16 in_le16
> >> +#define in_le32 in_le32
> >> +#define in_le64 in_le64
> >> +
> >> +#define out_be16 out_be16
> >> +#define out_be32 out_be32
> >> +#define out_be64 out_be64
> >> +#define out_le16 out_le16
> >> +#define out_le32 out_le32
> >> +#define out_le64 out_le64
> >> +
> >>  /*
> >>   * Low level IO stream instructions are defined out of line for now
> >>   */
> >> diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
> >> index e41510ce69a40815..5d5e030c9c980647 100644
> >> --- a/drivers/media/platform/fsl-viu.c
> >> +++ b/drivers/media/platform/fsl-viu.c
> >> @@ -37,8 +37,10 @@
> >>  #define VIU_VERSION         "0.5.1"
> >>
> >>  /* Allow building this driver with COMPILE_TEST */
> >> -#ifndef CONFIG_PPC
> >> +#ifndef out_be32
> >>  #define out_be32(v, a)      iowrite32be(a, (void __iomem *)v)
> >> +#endif
> >> +#ifndef in_be32
> >>  #define in_be32(a)  ioread32be((void __iomem *)a)
> >>  #endif

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
