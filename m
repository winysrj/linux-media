Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F44AC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 06:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CDF121726
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 06:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="atALjpUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfAWGKH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:10:07 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37308 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAWGKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 01:10:07 -0500
Received: by mail-ot1-f66.google.com with SMTP id s13so954576otq.4
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 22:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FeO1gesXy6KU0wTtnDDJtJcP0TAwXtlCZpvjn7+aHM=;
        b=atALjpUSlb7TCgaZHAqLsdxvdjr2mFnw3ZywEFCay6yGw4aroMpcL/Q/IRBD7z9aBB
         zET+HXG8yBrNOur9CiqIj81Ptho6ThWc/9lHjCH0HwlZgvDUPdP5e1Ct4tgUpPn2hYBn
         fLmI9hkKb98tv5EA34KS8t9vITbvDhBCoCIUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FeO1gesXy6KU0wTtnDDJtJcP0TAwXtlCZpvjn7+aHM=;
        b=DxNUmJ0UucFJvc5BaPUGmcaM038M9Fk1ueb9Jkj3YOYxkmMhGVa17iqPAbMluUPPU/
         ldkvLXZAGhyCnsgi618YszsdGfWCNY44SO63jq4W+VgY5TJHLKY/j/8VdtSCPi4npVCC
         colDLpUJCIPQ09NsNbPzq0w1TQxr1eqt7T8GgTS3L35XlS6CItpX79WxWDgN8f+9+N7e
         EkPSCg39dkqnu4IUYD5fL8JfiQORss/8IOMHrajeGp9XcNEPfYnFbt7e5eU7B+QuNRHE
         nZDeAhRZ7XL+/ndARQxONI+ys6B38v1iQwYZ082ZhnK46tE2QrioKSxyxNSooTMJ5DOj
         OQLg==
X-Gm-Message-State: AJcUukdNaZwn01hndj1dbrBrFDZYHhorm1ctqzkHWyIm3dJkicqIw2W5
        FYqKGWpruDQPFh2CG3fuivWr5CpQF4oiZA==
X-Google-Smtp-Source: ALg8bN7Fb6Apq9YlUNU7RNr2LqdGZFTGsGH0A35bRXi3h3yc0hzdw/VKIaG2YpNRHOu09994vuIKuw==
X-Received: by 2002:a05:6830:120c:: with SMTP id r12mr662580otp.252.1548223806154;
        Tue, 22 Jan 2019 22:10:06 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id h25sm8257054otj.27.2019.01.22.22.10.05
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 22:10:05 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id t204so887369oie.7
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 22:10:05 -0800 (PST)
X-Received: by 2002:aca:ad14:: with SMTP id w20mr576883oie.3.1548223805144;
 Tue, 22 Jan 2019 22:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org> <20190109084616.17162-5-stanimir.varbanov@linaro.org>
In-Reply-To: <20190109084616.17162-5-stanimir.varbanov@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 23 Jan 2019 15:09:53 +0900
X-Gmail-Original-Message-ID: <CAPBb6MWmeV2eUpk5HKOO1HVZ-eszehKfBW49+p4r-eSN1HuY0w@mail.gmail.com>
Message-ID: <CAPBb6MWmeV2eUpk5HKOO1HVZ-eszehKfBW49+p4r-eSN1HuY0w@mail.gmail.com>
Subject: Re: [PATCH 4/4] venus: helpers: drop setting of timestap invalid flag
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

On Wed, Jan 9, 2019 at 5:46 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> The zero timestap is really a valid so not sure why I discarded it. Fix

s/timestap/timestamp, also in patch title.

> that mistake by drop the code which checks for zero timestamp.

s/drop/dropping


>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index e436385bc5ab..5cad601d4c57 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -439,9 +439,6 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
>         fdata.flags = 0;
>         fdata.clnt_data = vbuf->vb2_buf.index;
>
> -       if (!fdata.timestamp)
> -               fdata.flags |= HFI_BUFFERFLAG_TIMESTAMPINVALID;
> -
>         if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>                 fdata.buffer_type = HFI_BUFFER_INPUT;
>                 fdata.filled_len = vb2_get_plane_payload(vb, 0);
> --
> 2.17.1
>
