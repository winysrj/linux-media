Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD771C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6C6218A6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="PIpm1oQw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfAXKFR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:05:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44261 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfAXKFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:05:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id z5so5746003wrt.11
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 02:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QAPHQPCNfLb16lyoGdiMrr4PvrUtI4vmLTnDYhA4gvg=;
        b=PIpm1oQwmFSOTlRI3NN/pysAGQdyqEOzYsk6OTCh06kd9So62WhSkGDu9qPjgJRDN2
         ZAJFdGg5bKIiaD2LSNo2bRpNjy11TRhS0aR0lwu80AzhK93uZyeZOwFJlZmC2GG21g4x
         Nkq0IdlbVro73GL6Fm/tqSF4o/+Sjg1vVoUVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QAPHQPCNfLb16lyoGdiMrr4PvrUtI4vmLTnDYhA4gvg=;
        b=iYpYdsYDwVmyUSZCAgSGyi11FuUFDoFbeoA0IHTBAxfoj3bktnzRWfDCuet5F8qT8U
         CPSp98iz3A6EqI9lazfLmrGg3m6twmvHn/1v2U9gmwRAz6U1UCDboQGuY9ucF4B2W7rR
         ca4oG26H7MiKUkGJ6QJqL9uX7TNJNMMJ7QMrYUtLZ3K5amu2cWgOAB5DIstqhg0xK9HD
         LN4l869l4jhYFOj3B6NqcXHQSctsfTtwWgYD3xBjIKPcBVtHKG19DZU9C1Dw+/jjw8wb
         Yux6Is/9eMCpxsio1Eh4EQZ/4hfUEdgtkIGVcOwpV/mZbopEBmJfhR68XCQgktrwJB+i
         1VXA==
X-Gm-Message-State: AJcUukccSwSFBd6T8AZQ5Rsr+8kJVp2lyn7qudDxx1JLfazFLWXq75t4
        w+ZEi2TdSyLKHmQuFzgRniYQ8Q==
X-Google-Smtp-Source: ALg8bN58AW23o30Q0GU2u8AzXS+4LPCMbm1yDVhDMz2ORVOmeooKBuu6cRASSQafDDhI0sq0GBC9hw==
X-Received: by 2002:adf:891a:: with SMTP id s26mr6436027wrs.44.1548324315099;
        Thu, 24 Jan 2019 02:05:15 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id a8sm32941117wme.23.2019.01.24.02.05.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:05:14 -0800 (PST)
Subject: Re: [PATCH 09/10] venus: vdec: allow bigger sizeimage set by clients
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-10-stanimir.varbanov@linaro.org>
 <CAPBb6MUumC2BmWar3yUmVT8vz8x-Nr_tuMc=1VSJvmQYGdPudw@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <580839ce-c98b-8b88-8868-e5df8171923b@linaro.org>
Date:   Thu, 24 Jan 2019 12:05:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUumC2BmWar3yUmVT8vz8x-Nr_tuMc=1VSJvmQYGdPudw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thanks for the comments!

On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> In most of the cases the client will know better what could be
>> the maximum size for compressed data buffers. Change the driver
>> to permit the user to set bigger size for the compressed buffer
>> but make reasonable sanitation.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/vdec.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>> index 282de21cf2e1..7a9370df7515 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -142,6 +142,7 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
>>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>>         struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
>>         const struct venus_format *fmt;
>> +       u32 szimage;
>>
>>         memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
>>         memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
>> @@ -170,14 +171,18 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
>>         pixmp->num_planes = fmt->num_planes;
>>         pixmp->flags = 0;
>>
>> -       pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
>> -                                                    pixmp->width,
>> -                                                    pixmp->height);
>> +       szimage = venus_helper_get_framesz(pixmp->pixelformat, pixmp->width,
>> +                                          pixmp->height);
>>
>> -       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +               pfmt[0].sizeimage = szimage;
>>                 pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
>> -       else
>> +       } else {
>> +               pfmt[0].sizeimage = clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M);
>> +               if (szimage > pfmt[0].sizeimage)
>> +                       pfmt[0].sizeimage = szimage;
> 
> pfmt[0].sizeimage = max(clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M),
>                                         szimage)?

I'm not a big fan to that calling of macro from macro :)

What about this:

	pfmt[0].sizeimage = clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M);
	pfmt[0].sizeimage = max(pfmt[0].sizeimage, szimage);

> 
>>                 pfmt[0].bytesperline = 0;
>> +       }
>>
>>         return fmt;
>>  }
>> @@ -275,6 +280,7 @@ static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>>                 inst->ycbcr_enc = pixmp->ycbcr_enc;
>>                 inst->quantization = pixmp->quantization;
>>                 inst->xfer_func = pixmp->xfer_func;
>> +               inst->input_buf_size = pixmp->plane_fmt[0].sizeimage;
>>         }
>>
>>         memset(&format, 0, sizeof(format));
>> @@ -737,6 +743,8 @@ static int vdec_queue_setup(struct vb2_queue *q,
>>                 sizes[0] = venus_helper_get_framesz(inst->fmt_out->pixfmt,
>>                                                     inst->out_width,
>>                                                     inst->out_height);
>> +               if (inst->input_buf_size > sizes[0])
>> +                       sizes[0] = inst->input_buf_size;
> 
>                sizes[0] = max(venus_helper_get_framesz(inst->fmt_out->pixfmt,
>                                                    inst->out_width,
>                                                  inst->out_height),
>                                       inst->input_buf_size)?

I think it'd be more readable that way:

		sizes[0] = max(sizes[0], inst->input_buf_size);

> 
> 
> 
>>                 inst->input_buf_size = sizes[0];
>>                 *num_buffers = max(*num_buffers, in_num);
>>                 inst->num_input_bufs = *num_buffers;
>> --
>> 2.17.1
>>

-- 
regards,
Stan
