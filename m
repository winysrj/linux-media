Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A23C282C6
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1DA0218DE
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fnGKJpAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfAYFg6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:36:58 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37377 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfAYFg5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 00:36:57 -0500
Received: by mail-ot1-f67.google.com with SMTP id s13so7514584otq.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSGOWldl7QkaG5faKqBMKqlpyKWAGBfLsQgLSNcpWLs=;
        b=fnGKJpAmwwVU0Y5dKlG5+zbGsBMKo+LWAV3ustCc4VOFEm+PkgRBMvsQYgYzCb9Cze
         XeICRuXp61hMZ0AQj/5iYRKWmiWwOVU1MhYMrz1cLLjGVYvWfDVBiz3K8S261IHlfScf
         6BL6oSXeiV/k42yBNZr/8FnHAb8obdb2cbU9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSGOWldl7QkaG5faKqBMKqlpyKWAGBfLsQgLSNcpWLs=;
        b=Ty9VWNjYMaOWWXX085K5Ou2wvDAuH66CTKSOCWTImjnz9m+s4tvO7KC0y1WhrMWaq9
         IBg+iGrToBKyCrwKBCo77vRaHdM/syrCre6nZRE87MbVU1UhKRx3xu5GyEmfmVDDjW3t
         LKSIvkBLEIfqpzyLSYw3SmdrrG+QH1HFVsqKgle8wVFbjqATa4WSOGPAXc2zUXS5aie8
         wOtzTnQAp5dk60tPAFgc7ayYmNeEPFwk4f8fflJDy/M+C3DvS0J2v8x3/Hsh/RDXl1Vu
         pw7cIN90xv1u+ZFTGrPQPGwShvRCVB4FzQ28n+VPBm/o3YrIJgvptVwge9PvP6t3BczP
         lj2g==
X-Gm-Message-State: AJcUukdIQrjHe7RBW+gPYFaLTYwVtNVUlvD1Y33pzh/KmsLSwaDPFPjB
        C1bWIutQHU8L9xclOyE7z4LXjBh/nai6dg==
X-Google-Smtp-Source: ALg8bN790p7FRM95f8R0DZ17m5irwLW+o0dK9tl8d90Q3434QPEBkXFERbOxXVvhP0SNEAETuJL/EA==
X-Received: by 2002:a9d:f44:: with SMTP id 62mr6895980ott.182.1548394616448;
        Thu, 24 Jan 2019 21:36:56 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id i12sm769782otr.74.2019.01.24.21.36.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 21:36:55 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id x23so6878609oix.3
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:36:55 -0800 (PST)
X-Received: by 2002:aca:af53:: with SMTP id y80mr461402oie.170.1548394614764;
 Thu, 24 Jan 2019 21:36:54 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-10-stanimir.varbanov@linaro.org> <CAPBb6MUumC2BmWar3yUmVT8vz8x-Nr_tuMc=1VSJvmQYGdPudw@mail.gmail.com>
 <580839ce-c98b-8b88-8868-e5df8171923b@linaro.org>
In-Reply-To: <580839ce-c98b-8b88-8868-e5df8171923b@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Fri, 25 Jan 2019 14:36:43 +0900
X-Gmail-Original-Message-ID: <CAPBb6MXLJnoT5=WkJQb7fmT8wznnth65_Gia04QuG_1-hKAmbg@mail.gmail.com>
Message-ID: <CAPBb6MXLJnoT5=WkJQb7fmT8wznnth65_Gia04QuG_1-hKAmbg@mail.gmail.com>
Subject: Re: [PATCH 09/10] venus: vdec: allow bigger sizeimage set by clients
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

On Thu, Jan 24, 2019 at 7:05 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> Thanks for the comments!
>
> On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> > On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> In most of the cases the client will know better what could be
> >> the maximum size for compressed data buffers. Change the driver
> >> to permit the user to set bigger size for the compressed buffer
> >> but make reasonable sanitation.
> >>
> >> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >> ---
> >>  drivers/media/platform/qcom/venus/vdec.c | 18 +++++++++++++-----
> >>  1 file changed, 13 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> >> index 282de21cf2e1..7a9370df7515 100644
> >> --- a/drivers/media/platform/qcom/venus/vdec.c
> >> +++ b/drivers/media/platform/qcom/venus/vdec.c
> >> @@ -142,6 +142,7 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
> >>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> >>         struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
> >>         const struct venus_format *fmt;
> >> +       u32 szimage;
> >>
> >>         memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
> >>         memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> >> @@ -170,14 +171,18 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
> >>         pixmp->num_planes = fmt->num_planes;
> >>         pixmp->flags = 0;
> >>
> >> -       pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
> >> -                                                    pixmp->width,
> >> -                                                    pixmp->height);
> >> +       szimage = venus_helper_get_framesz(pixmp->pixelformat, pixmp->width,
> >> +                                          pixmp->height);
> >>
> >> -       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> >> +               pfmt[0].sizeimage = szimage;
> >>                 pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
> >> -       else
> >> +       } else {
> >> +               pfmt[0].sizeimage = clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M);
> >> +               if (szimage > pfmt[0].sizeimage)
> >> +                       pfmt[0].sizeimage = szimage;
> >
> > pfmt[0].sizeimage = max(clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M),
> >                                         szimage)?
>
> I'm not a big fan to that calling of macro from macro :)
>
> What about this:
>
>         pfmt[0].sizeimage = clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M);
>         pfmt[0].sizeimage = max(pfmt[0].sizeimage, szimage);

Looks fine, I just wanted to make sure that we use the more expressive
"max" instead of an if statement.

>
> >
> >>                 pfmt[0].bytesperline = 0;
> >> +       }
> >>
> >>         return fmt;
> >>  }
> >> @@ -275,6 +280,7 @@ static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> >>                 inst->ycbcr_enc = pixmp->ycbcr_enc;
> >>                 inst->quantization = pixmp->quantization;
> >>                 inst->xfer_func = pixmp->xfer_func;
> >> +               inst->input_buf_size = pixmp->plane_fmt[0].sizeimage;
> >>         }
> >>
> >>         memset(&format, 0, sizeof(format));
> >> @@ -737,6 +743,8 @@ static int vdec_queue_setup(struct vb2_queue *q,
> >>                 sizes[0] = venus_helper_get_framesz(inst->fmt_out->pixfmt,
> >>                                                     inst->out_width,
> >>                                                     inst->out_height);
> >> +               if (inst->input_buf_size > sizes[0])
> >> +                       sizes[0] = inst->input_buf_size;
> >
> >                sizes[0] = max(venus_helper_get_framesz(inst->fmt_out->pixfmt,
> >                                                    inst->out_width,
> >                                                  inst->out_height),
> >                                       inst->input_buf_size)?
>
> I think it'd be more readable that way:
>
>                 sizes[0] = max(sizes[0], inst->input_buf_size);

Ditto.
