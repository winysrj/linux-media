Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED2BC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FD97218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aZexlr0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfAXInm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:43:42 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40949 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbfAXInm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:43:42 -0500
Received: by mail-ot1-f66.google.com with SMTP id s5so4542945oth.7
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ubufKBDUBrGmg37+ox2VVswr1sZmB/KKaxi8VgKVCLg=;
        b=aZexlr0gKprhmeni93G0ze+OooktnLIlR8ePBrlhkEOlsqRgcQbqm8ZES2bxOWCfs9
         FUAa1rFOVwEhJ4vuqOi44nGU4TP4SEbVbuR4BhvGMTFhLqLZA/JdY3QsImyCFXIO823N
         l/xMO2140vBA83/npx384f5ztcK9a/gziuswU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ubufKBDUBrGmg37+ox2VVswr1sZmB/KKaxi8VgKVCLg=;
        b=HGoM4nWoOJnti1eA2hOWFaaPf3BaLcBejUB13f+1MkIjK01WMWq0V+2O55X9H96Mp/
         D0sRsUEuglBnmoT88TjmXMzNkOTjq4MAjjXqQ6h6QIaFNQF3ZFh2jUdkEShtBHGm+IsF
         7TJ7ZgJNucaOyjyPRZfMMcoC3/BDYayG5v+lXxipb2Fdm3JAKm5LlxTOBNJIMNH2t48J
         +AphiKenBVJmIKeoy7j3lE2UAzxrMY7E/4/fhU0PHeWfJ5UBJS7gmD45GCjfAtoUwroo
         Y9qGhy4aHFrb9oNZQGX6DcgZj9SJNJLBT5agI/QyCVtdSjx6ZvyXAg6c3o4ZO31p44eI
         bXGw==
X-Gm-Message-State: AJcUukda2rTCuB9YRjfLOKu6Ll7M+KV4R79LmRYKcLIh6pQMm468+/4E
        Wk925d1tV5yK8TiY7QTdvEQN4o2W3Xw=
X-Google-Smtp-Source: ALg8bN5/Y3hiuKn0SUfVVitj3EP5m01scKd8CYNSURF+BWFRqNtUsBnqYZxX8hFWZR4OKsz/4RvnLw==
X-Received: by 2002:a9d:7dd2:: with SMTP id k18mr856546otn.232.1548319420273;
        Thu, 24 Jan 2019 00:43:40 -0800 (PST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id q10sm9037308otl.15.2019.01.24.00.43.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:43:39 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id j21so4194524oii.8
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:43:39 -0800 (PST)
X-Received: by 2002:aca:ad14:: with SMTP id w20mr532308oie.3.1548319419319;
 Thu, 24 Jan 2019 00:43:39 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org> <20190117162008.25217-9-stanimir.varbanov@linaro.org>
In-Reply-To: <20190117162008.25217-9-stanimir.varbanov@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Thu, 24 Jan 2019 17:43:28 +0900
X-Gmail-Original-Message-ID: <CAPBb6MWJXWLcGh3dbejiYzyqT6OB1_FN6zrcZFO5DbxqXSAWjQ@mail.gmail.com>
Message-ID: <CAPBb6MWJXWLcGh3dbejiYzyqT6OB1_FN6zrcZFO5DbxqXSAWjQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] venus: vdec_ctrls: get real minimum buffers for capture
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Until now we returned num_output_bufs set during reqbuf but
> that could be wrong when we implement stateful Codec API. So
> get the minimum buffers for capture from HFI. This is supposed
> to be called after stream header parsing, i.e. after dequeue
> v4l2 event for change resolution.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/vdec_ctrls.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/qcom/venus/vdec_ctrls.c b/drivers/media/platform/qcom/venus/vdec_ctrls.c
> index f4604b0cd57e..e1da87bf52bc 100644
> --- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
> +++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
> @@ -16,6 +16,7 @@
>  #include <media/v4l2-ctrls.h>
>
>  #include "core.h"
> +#include "helpers.h"
>  #include "vdec.h"
>
>  static int vdec_op_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -47,7 +48,9 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>  {
>         struct venus_inst *inst = ctrl_to_inst(ctrl);
>         struct vdec_controls *ctr = &inst->controls.dec;
> +       struct hfi_buffer_requirements bufreq;
>         union hfi_get_property hprop;
> +       enum hfi_version ver = inst->core->res->hfi_version;
>         u32 ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
>         int ret;
>
> @@ -71,7 +74,9 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>                 ctrl->val = ctr->post_loop_deb_mode;
>                 break;
>         case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> -               ctrl->val = inst->num_output_bufs;
> +               ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
> +               if (!ret)
> +                       ctrl->val = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);

What happens if venus_helper_get_bufreq() returns an error? It seems
that we just happily continue with whatever the previous value of
ctrl->val was. It seems like we do the same with other controls as
well.

I think you can fix this globally by initializing ret to 0 at the
beginning of the function, and then returning ret instead of 0 at the
end. That way all errors would be propagated. Of course please check
that this is relevant for other controls following this scheme before
doing so. :)
