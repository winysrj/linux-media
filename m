Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1FAC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 14:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98590205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547648657;
	bh=+kXBsHCMjAMP9PfWKGyPgTjGMU/e/Zt8vmAvdeNV81Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=2OPAj6N+KCM8CLjQjhh+GSWiRlxzNWI4SdmvGH9Y6KfqsD3P9GUMgg95uRy+nLtYn
	 5Syr5cQZLQPoHDg6+hwfRMxtgEYQpA2KWEaSEs+7KMetnyZtD1PeU96AF92zawF4Xk
	 Z9Hzex5ZNUJrfz23QzofrRju6yCy1E8NxLXmvFfc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbfAPOYR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:24:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:48488 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbfAPOYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 09:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P1YOiWJj3kuUIuUQL+kJvnCchdTbjVhf2Fuxil8Xz1k=; b=h+n+h4wqyao0BuHgIJa+INwQ5x
        7npsfJooZKWuyIvU4UueQOMoMInWTaKswWLLchlmRmJO06ZWs3o7k7LKG1GU5WVuOlvt+q3bZzMoC
        s6lA9G7lnGiwKtWh3QOvFjLB5qeBptsHJHa3X/a0LIM/1xoHzst1w3uoliik7BUGGKnkTd+on6g52
        9wx4bOklKV6/Zx6E+WEOfYbhKb/JrHMRBjd/edSZV4EWmLvpTnLvQhvpJ50t0B5fuNjATt43LxuLV
        hhy2fgL7//nmvFHB6XPnFLuBu79t1z3R7yUv14taJNhjGT/lM4zQxf4fdakcTTjxMxYVeWFR6x18c
        P0MeRd8g==;
Received: from [186.213.247.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjm73-0000Fu-U3; Wed, 16 Jan 2019 14:24:14 +0000
Date:   Wed, 16 Jan 2019 12:24:09 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     james.hilliard1@gmail.com
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH zbar 1/1] v4l2: add fallback for systems without
 V4L2_CTRL_WHICH_CUR_VAL
Message-ID: <20190116122409.0968a154@coco.lan>
In-Reply-To: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com>
References: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 16 Jan 2019 13:23:10 +0800
james.hilliard1@gmail.com escreveu:

> From: James Hilliard <james.hilliard1@gmail.com>
> 
> Some older systems don't seem to have V4L2_CTRL_WHICH_CUR_VAL so add a
> fallback.

Nice catch.

> 
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
>  zbar/video/v4l2.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
> index 0147cb1..b883ecc 100644
> --- a/zbar/video/v4l2.c
> +++ b/zbar/video/v4l2.c
> @@ -866,7 +866,11 @@ static int v4l2_s_control(zbar_video_t *vdo,
>  
>      memset(&ctrls, 0, sizeof(ctrls));
>      ctrls.count = 1;
> +#ifdef V4L2_CTRL_WHICH_CUR_VAL
>      ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> +#else
> +    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
> +#endif
>      ctrls.controls = &c;
>  
>      memset(&c, 0, sizeof(c));
> @@ -914,7 +918,11 @@ static int v4l2_g_control(zbar_video_t *vdo,
>  
>      memset(&ctrls, 0, sizeof(ctrls));
>      ctrls.count = 1;
> +#ifdef V4L2_CTRL_WHICH_CUR_VAL
>      ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
> +#else
> +    ctrls.ctrl_class = V4L2_CTRL_CLASS_USER;
> +#endif
>      ctrls.controls = &c;
>  
>      memset(&c, 0, sizeof(c));

Hmm... This won't work if the control doesn't belong to V4L2_CTRL_CLASS_USER. 
Depending on the device, it may have some controls on different classes.

So, it would be better to get the control class from its ID.

Also, there's still a risk that someone would build zbar against
a Kernel > 4.4, and run it with an older Kernel.

So, IMHO, the best is to also fill ctrls.which from the control
ID. There is a macro for such purpose.

As the Kernel keeps backward-compatibility, with this approach,
it should work with any Kernel, even if someone, for example, builds it
on 4.20 and tries to run on a 2.6.x Kernel.

See the enclosed patch. I tested it here with Kernel 4.20 and works
fine.

Thanks,
Mauro

v4l2: add fallback for systems without v4l2_ext_controls which field

The v4l2_ext_controls.which field was introduced on Kernel 4.4,
in order to solve some ambiguities and make easier to handle
controls.

Yet, there are several systems running older Kernels. As the
newer Linux Kernels are backward-compatible with the old way,
we can change the logic in a way that would allow someone to
build it against a kernel > 4.4, while letting it to keep running
with legacy Kernels.

Reported-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
index 0147cb18d499..0d180947945f 100644
--- a/zbar/video/v4l2.c
+++ b/zbar/video/v4l2.c
@@ -866,7 +866,11 @@ static int v4l2_s_control(zbar_video_t *vdo,
 
     memset(&ctrls, 0, sizeof(ctrls));
     ctrls.count = 1;
-    ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
+#ifdef V4L2_CTRL_ID2WHICH
+    ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
+#else
+    ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+#endif
     ctrls.controls = &c;
 
     memset(&c, 0, sizeof(c));
@@ -914,7 +918,11 @@ static int v4l2_g_control(zbar_video_t *vdo,
 
     memset(&ctrls, 0, sizeof(ctrls));
     ctrls.count = 1;
-    ctrls.which = V4L2_CTRL_WHICH_CUR_VAL;
+#ifdef V4L2_CTRL_ID2WHICH
+    ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
+#else
+    ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+#endif
     ctrls.controls = &c;
 
     memset(&c, 0, sizeof(c));
