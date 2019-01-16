Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764A0C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 20:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2B2206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 20:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYkg3csA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbfAPUeo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 15:34:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36141 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfAPUeo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 15:34:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id u4so8525315wrp.3
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 12:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amvamAtj1IE8zjapOaIIYPiTgSoe6uIIMyhckjmh/7o=;
        b=GYkg3csAJaDvvn9ICI8XIyIDM4H1fQsRzLKJPaPbCNitIL4+XAVQKQ8AFwptZrUE74
         FcH8+uyKWmBSMML6fY9x0Ly21gzXBTGN0Ldnh+ipWROTOfGZZA4Uc1V2em6cgDolGRv5
         v6COrxhKYRKv8k9fPxY8IF8urf/KsziifDkQ5CLCrzx21BDE7PQk1u1YUq2a2+F67B5/
         E5xsvlJy+Qn2tFgYkK6pUj3NJGayt0CpYyBOOwqBUJ3JvUvap89PpH9q1TtJkfQQv27n
         d9z8Wyg1cQZbItmB54F6IM0uYRufzW+JNxyynNSNEd1ijv3QEPiS/natc5nRe6KySVRW
         b/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amvamAtj1IE8zjapOaIIYPiTgSoe6uIIMyhckjmh/7o=;
        b=XxcpcQnivH3D1yiugjyOizu7FaAE17ccYi6LylMCNtXJVafiF+bNj3iMoBs+lcrxGn
         EbbMgrlRYG1Q12Y1LuKv0CsKOsGElr1PBDRW8W8P56hR2TLgHKxtH4XrdMv5SuhXl0MS
         542lE2jjql+e5DN2O4GpTLl729ucy+5gWg+iC2OU6HKp12WNahre0TrCeRQIqulT68OQ
         /kwg4tbbQy2jNSEfE9yKPfaL3QNK5z3IfmwLdvPf7b0jSODDvqwVjLtx29HvBZud5Fia
         1/qpz2pie0AXfc9otYmzG0flDCkwvjZ+QxIpD1LMNx4zkBZhIh8HrZ48c0vfwtYi+Cat
         45Rw==
X-Gm-Message-State: AJcUukdXLkjJBqiX/iwkhbNYuUizrhARQopck/1qEVhJuwe21p2iRz4v
        1njqW4r+Kpe98VaJGKXQrzBB5VY9wJCFBoPwiyQ=
X-Google-Smtp-Source: ALg8bN6lpsJRd0T08Dq61eOyUEGVt7jCzQ/M8yhCwKVELn4iXeo6yq6AEhp4Di7gqH5QJfTcfMhPawVHPviytqIedkE=
X-Received: by 2002:a5d:6808:: with SMTP id w8mr8760830wru.270.1547670882011;
 Wed, 16 Jan 2019 12:34:42 -0800 (PST)
MIME-Version: 1.0
References: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com> <20190116122409.0968a154@coco.lan>
In-Reply-To: <20190116122409.0968a154@coco.lan>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Wed, 16 Jan 2019 13:34:29 -0700
Message-ID: <CADvTj4q=6mYR0Fo3e2Met9yNxmyy8z_a7bbzxfgPMY63ZF4g1A@mail.gmail.com>
Subject: Re: [PATCH zbar 1/1] v4l2: add fallback for systems without V4L2_CTRL_WHICH_CUR_VAL
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 7:24 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Wed, 16 Jan 2019 13:23:10 +0800
> james.hilliard1@gmail.com escreveu:
>
> > From: James Hilliard <james.hilliard1@gmail.com>
> >
> > Some older systems don't seem to have V4L2_CTRL_WHICH_CUR_VAL so add a
> > fallback.
>
> Nice catch.
>
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> >  zbar/video/v4l2.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
> > index 0147cb1..b883ecc 100644
> > --- a/zbar/video/v4l2.c
> > +++ b/zbar/video/v4l2.c
> > @@ -866,7 +866,11 @@ static int v4l2_s_control(zbar_video_t *vdo,
> >
> >      memset(&ctrls, 0, sizeof(ctrls));
> >      ctrls.count = 1;
> > +#ifdef V4L2_CTRL_WHICH_CUR_VAL
> >      ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> > +#else
> > +    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
> > +#endif
> >      ctrls.controls = &c;
> >
> >      memset(&c, 0, sizeof(c));
> > @@ -914,7 +918,11 @@ static int v4l2_g_control(zbar_video_t *vdo,
> >
> >      memset(&ctrls, 0, sizeof(ctrls));
> >      ctrls.count = 1;
> > +#ifdef V4L2_CTRL_WHICH_CUR_VAL
> >      ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> > +#else
> > +    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
> > +#endif
> >      ctrls.controls = &c;
> >
> >      memset(&c, 0, sizeof(c));
>
> Hmm... This won't work if the control doesn't belong to V4L2_CTRL_CLASS_USER.
> Depending on the device, it may have some controls on different classes.
Yeah, I wasn't sure my fix was correct.
>
> So, it would be better to get the control class from its ID.
>
> Also, there's still a risk that someone would build zbar against
> a Kernel > 4.4, and run it with an older Kernel.
>
> So, IMHO, the best is to also fill ctrls.which from the control
> ID. There is a macro for such purpose.
>
> As the Kernel keeps backward-compatibility, with this approach,
> it should work with any Kernel, even if someone, for example, builds it
> on 4.20 and tries to run on a 2.6.x Kernel.
>
> See the enclosed patch. I tested it here with Kernel 4.20 and works
> fine.
I'll test it on the system I had which needed the fallback.
>
> Thanks,
> Mauro
>
> v4l2: add fallback for systems without v4l2_ext_controls which field
>
> The v4l2_ext_controls.which field was introduced on Kernel 4.4,
> in order to solve some ambiguities and make easier to handle
> controls.
>
> Yet, there are several systems running older Kernels. As the
> newer Linux Kernels are backward-compatible with the old way,
> we can change the logic in a way that would allow someone to
> build it against a kernel > 4.4, while letting it to keep running
> with legacy Kernels.
I needed the fix for a 4.4.0 kernel(ubuntu 16.04).
>
> Reported-by: James Hilliard <james.hilliard1@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>
> diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
> index 0147cb18d499..0d180947945f 100644
> --- a/zbar/video/v4l2.c
> +++ b/zbar/video/v4l2.c
> @@ -866,7 +866,11 @@ static int v4l2_s_control(zbar_video_t *vdo,
>
>      memset(&ctrls, 0, sizeof(ctrls));
>      ctrls.count = 1;
> -    ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> +#ifdef V4L2_CTRL_ID2WHICH
> +    ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
> +#else
> +    ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
> +#endif
>      ctrls.controls = &c;
>
>      memset(&c, 0, sizeof(c));
> @@ -914,7 +918,11 @@ static int v4l2_g_control(zbar_video_t *vdo,
>
>      memset(&ctrls, 0, sizeof(ctrls));
>      ctrls.count = 1;
> -    ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> +#ifdef V4L2_CTRL_ID2WHICH
> +    ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
> +#else
> +    ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
> +#endif
>      ctrls.controls = &c;
>
>      memset(&c, 0, sizeof(c));
