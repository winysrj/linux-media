Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C06C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 05:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC4542081B
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 05:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H+mZThWf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4542081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbeLKFf1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 00:35:27 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36259 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbeLKFf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 00:35:27 -0500
Received: by mail-yb1-f193.google.com with SMTP id 64so3554045ybe.3
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 21:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOzPWrJoHNreLfx8L2F8rw41gMCRyYlpFNhDIaKDDzk=;
        b=H+mZThWft5fG8j31zQfk8WhiLqAFu0EW3m5Og9GmwL3QtbjUr8OF7zRX7k8XAV9K00
         +MmFM3q6C5CGtmDwZWmT8KfC1Ik1Gzra1kkuOO9lUSK36J0xFLuqY/DGRX+WqhsZXlds
         WBrEi7HTI+zyf9JFXQLTTQWcwaHpJAWRjeen0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOzPWrJoHNreLfx8L2F8rw41gMCRyYlpFNhDIaKDDzk=;
        b=gsl56B4zduvmxL+VyAVC0bAU/4QTCG6JNaLYww+CoWlOnXgQd9R13S5rbDg/eSCxnU
         /uo+UneUNLK4dOi42aPmKN1Yw4Po2zZfyNf2die8hhh2B/SoS1mUsz2KTsuBTcFXuksO
         f/XmlWl+cyhffLisD/7mXalgllIdCsFxlqToptEK7DEacnEtMmLJOBVVMJQptCsxDTy+
         RV1eTYh3TmxGMrGDXUrBuWGqd0wBbjlnMr5Ya8PwJUsqu+O89D8F1T58hL8G+4BlYMcV
         GML0nanU2NuL+J4P9/lhFOcHs3kY4vGpsq91j9oy+fy2uJP/Ik/i+6HvH08jHSaBzN/A
         ty5A==
X-Gm-Message-State: AA+aEWaVyDGHrH1ZhDQVncS9O2n6KXqHXVtJ2rOMRAZ51yL+yHqyz6EF
        EOfomoAIa77fd2AzSs41mH+MrvecxMM=
X-Google-Smtp-Source: AFSGD/XGK5ViZDcNq0MFYFBOfN5naID7a63xdQJDqA1hy0qE3HFnjq5GBJECaucNPd4Gk3f4JxwiWg==
X-Received: by 2002:a25:d34c:: with SMTP id e73mr14023290ybf.176.1544506525871;
        Mon, 10 Dec 2018 21:35:25 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id 139sm4374292ywt.78.2018.12.10.21.35.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 21:35:25 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id z2-v6so6235856ybj.2
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 21:35:25 -0800 (PST)
X-Received: by 2002:a25:a44:: with SMTP id 65-v6mr14689190ybk.373.1544506524702;
 Mon, 10 Dec 2018 21:35:24 -0800 (PST)
MIME-Version: 1.0
References: <20181210122202.26558-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20181210122202.26558-1-sakari.ailus@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 11 Dec 2018 14:35:12 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Ab8V=uX7_-ufoPHbPWK=uCr1x7nmZW413YqRfAVCoD2A@mail.gmail.com>
Message-ID: <CAAFQd5Ab8V=uX7_-ufoPHbPWK=uCr1x7nmZW413YqRfAVCoD2A@mail.gmail.com>
Subject: Re: [PATCH 1/1] ipu3-imgu: Fix compiler warnings
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Mon, Dec 10, 2018 at 9:22 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Address a few false positive compiler warnings related to uninitialised
> variables. While at it, use bool where bool is needed and %u to print an
> unsigned integer.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/staging/media/ipu3/ipu3.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
> index b7886edeb01b7..d521b3afb8b1a 100644
> --- a/drivers/staging/media/ipu3/ipu3.c
> +++ b/drivers/staging/media/ipu3/ipu3.c
> @@ -228,7 +228,6 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
>  {
>         unsigned int node;
>         int r = 0;
> -       struct imgu_buffer *ibuf;
>         struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
>
>         if (!ipu3_css_is_streaming(&imgu->css))
> @@ -250,7 +249,8 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
>                 } else if (imgu_pipe->queue_enabled[node]) {
>                         struct ipu3_css_buffer *buf =
>                                 imgu_queue_getbuf(imgu, node, pipe);
> -                       int dummy;
> +                       struct imgu_buffer *ibuf = NULL;
> +                       bool dummy;
>
>                         if (!buf)
>                                 break;
> @@ -263,7 +263,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
>                                 ibuf = container_of(buf, struct imgu_buffer,
>                                                     css_buf);
>                         dev_dbg(&imgu->pci_dev->dev,
> -                               "queue %s %s buffer %d to css da: 0x%08x\n",
> +                               "queue %s %s buffer %u to css da: 0x%08x\n",
>                                 dummy ? "dummy" : "user",
>                                 imgu_node_map[node].name,
>                                 dummy ? 0 : ibuf->vid_buf.vbb.vb2_buf.index,
> @@ -479,7 +479,7 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
>         do {
>                 u64 ns = ktime_get_ns();
>                 struct ipu3_css_buffer *b;
> -               struct imgu_buffer *buf;
> +               struct imgu_buffer *buf = NULL;
>                 unsigned int node, pipe;
>                 bool dummy;

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Both cases look very straightforward, I wonder why they triggered
those false positives...

Best regards,
Tomasz
