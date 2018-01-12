Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:45049 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754495AbeALIT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 03:19:27 -0500
Received: by mail-ua0-f193.google.com with SMTP id x16so3493461uaj.11
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 00:19:27 -0800 (PST)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com. [209.85.217.169])
        by smtp.gmail.com with ESMTPSA id 66sm3190455vkc.53.2018.01.12.00.19.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jan 2018 00:19:25 -0800 (PST)
Received: by mail-ua0-f169.google.com with SMTP id t7so202336uae.5
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 00:19:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515034637-3517-2-git-send-email-yong.zhi@intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com> <1515034637-3517-2-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 12 Jan 2018 17:19:04 +0900
Message-ID: <CAAFQd5AaOSQ_wcA_w5vBufVk5FfLPe6x9BnS=hcShv_asf3Cyw@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: intel-ipu3: cio2: fix for wrong vb2buf state warnings
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 11:57 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> cio2 driver should release buffer with QUEUED state
> when start_stream op failed, wrong buffer state will
> cause vb2 core throw a warning.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 949f43d206ad..106d04306372 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -785,7 +785,8 @@ static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
>
>  /**************** Videobuf2 interface ****************/
>
> -static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
> +static void cio2_vb2_return_all_buffers(struct cio2_queue *q,
> +                                       enum vb2_buffer_state state)
>  {
>         unsigned int i;
>
> @@ -793,7 +794,7 @@ static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
>                 if (q->bufs[i]) {
>                         atomic_dec(&q->bufs_queued);
>                         vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
> -                                       VB2_BUF_STATE_ERROR);
> +                                       state);

nit: Does it really exceed 80 characters after folding into previous line?

With the nit fixed:
Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
