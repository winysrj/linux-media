Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:41651 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753957AbeDZHM1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 03:12:27 -0400
Received: by mail-ua0-f172.google.com with SMTP id a3so173532uad.8
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 00:12:27 -0700 (PDT)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com. [209.85.217.170])
        by smtp.gmail.com with ESMTPSA id q186sm5424844vka.15.2018.04.26.00.12.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Apr 2018 00:12:25 -0700 (PDT)
Received: by mail-ua0-f170.google.com with SMTP id c3so16567727uae.2
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 00:12:25 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-11-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-11-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 26 Apr 2018 07:12:14 +0000
Message-ID: <CAAFQd5CGjFsc1Py78_Lmbav0rPqgQOuN-7KXhQB2_MJKAkX55A@mail.gmail.com>
Subject: Re: [PATCH v6 10/12] intel-ipu3: Add css pipeline programming
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
[snip]
> +int ipu3_css_init(struct device *dev, struct ipu3_css *css,
> +                 void __iomem *base, int length)
> +{
> +       int r, p, q, i;
> +
> +       /* Initialize main data structure */
> +       css->dev = dev;
> +       css->base = base;
> +       css->iomem_length = length;
> +       css->current_binary = IPU3_CSS_DEFAULT_BINARY;
> +       css->pipe_id = IPU3_CSS_PIPE_ID_NUM;
> +       css->vf_output_en = IPU3_NODE_VF_DISABLED;
> +       spin_lock_init(&css->qlock);
> +
> +       for (q = 0; q < IPU3_CSS_QUEUES; q++) {
> +               r = ipu3_css_queue_init(&css->queue[q], NULL, 0);
> +               if (r)
> +                       return r;
> +       }
> +
> +       r = ipu3_css_fw_init(css);
> +       if (r)
> +               return r;
> +
> +       /* Allocate and map common structures with imgu hardware */
> +
> +       for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
> +               for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
> +                       if (!ipu3_dmamap_alloc(dev,
> +
  &css->xmem_sp_stage_ptrs[p][i],
> +                                              sizeof(struct
imgu_abi_sp_stage)))

checkpatch reports line over 80 characters here.

> +                               goto error_no_memory;
> +                       if (!ipu3_dmamap_alloc(dev,
> +
  &css->xmem_isp_stage_ptrs[p][i],
> +                                              sizeof(struct
imgu_abi_isp_stage)))

Ditto.

> +                               goto error_no_memory;
> +               }

Best regards,
Tomasz
