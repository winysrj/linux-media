Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:40018 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbeGBIvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:51:16 -0400
Received: by mail-io0-f194.google.com with SMTP id t135-v6so14064793iof.7
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:51:16 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id d14-v6sm3874796itc.34.2018.07.02.01.51.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:51:15 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id d185-v6so14058411ioe.0
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:51:03 +0900
Message-ID: <CAPBb6MUBi+Dn5v4PKngxztFgKd6CA7bC1pKvWd1GMY9NJFoyZQ@mail.gmail.com>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 2, 2018 at 4:44 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Exisiting code returns the max of the decoded

s/Exisiting/Existing

Also the lines of your commit message look pretty short - I think the
standard for kernel log messges is 72 chars?

> size and buffer size. It turns out that buffer
> size is always greater due to hardware alignment
> requirement. As a result, payload size given to
> client is incorrect. This change ensures that
> the bytesused is assigned to actual payload size.
>
> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index d079aeb..ada1d2f 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>
>                 vb = &vbuf->vb2_buf;
>                 vb->planes[0].bytesused =
> -                       max_t(unsigned int, opb_sz, bytesused);
> +                       min_t(unsigned int, opb_sz, bytesused);

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
Tested-by: Alexandre Courbot <acourbot@chromium.org>

This indeed reports the correct size to the client. If bytesused were
larger than the size of the buffer we would be having some trouble
anyway.

Actually in my tree I was using the following patch:

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -924,13 +924,12 @@ static void vdec_buf_done(struct venus_inst
*inst, unsigned int buf_type,

               vb = &vbuf->vb2_buf;
               vb->planes[0].bytesused =
-                       max_t(unsigned int, opb_sz, bytesused);
+                       min_t(unsigned int, opb_sz, bytesused);
               vb->planes[0].data_offset = data_offset;
               vb->timestamp = timestamp_us * NSEC_PER_USEC;
               vbuf->sequence = inst->sequence_cap++;
               if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
                       const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
-                       vb->planes[0].bytesused = bytesused;
                       v4l2_event_queue_fh(&inst->fh, &ev);

Given that we are now taking the minimum of these two values, it seems
to me that we don't need to set bytesused again in case we are dealing
with the last buffer? Stanimir, what do you think?
