Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62237 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2JBT5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 15:57:43 -0400
Received: by eekb15 with SMTP id b15so3428827eek.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 12:57:41 -0700 (PDT)
Message-ID: <506B4733.3070505@gmail.com>
Date: Tue, 02 Oct 2012 21:57:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arun Kumar K <arun.kk@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [GIT PULL FOR 3.7] Samsung Exynos MFC driver update
References: <506B1D47.8040602@samsung.com> <20121002150603.31b6b72d@redhat.com>
In-Reply-To: <20121002150603.31b6b72d@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2012 08:06 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 02 Oct 2012 18:58:47 +0200
> Sylwester Nawrocki<s.nawrocki@samsung.com>  escreveu:
> 
>> Hi Mauro,
>>
>> The following changes since commit 34a6b7d093d8fe738ada191b36648d00bc18b7eb:
>>
>>    [media] v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler
>> (2012-10-01 17:07:07 -0300)
>>
>> are available in the git repository at:
>>
>>    git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_mfc_for_mauro
>>
>> for you to fetch changes up to 8312d9d2d254ab289a322fcfdba1d1ecf5e36256:
>>
>>    s5p-mfc: Update MFC v4l2 driver to support MFC6.x (2012-10-02 15:28:42 +0200)
>>
>> This is an update of the s5p-mfc driver and related V4L2 API additions
>> to support the Multi Format Codec device on the Exynos5 SoC series.
>>
>> ----------------------------------------------------------------
>> Arun Kumar K (4):
>>        v4l: Add fourcc definitions for new formats
>>        v4l: Add control definitions for new H264 encoder features
> 
> OK.
> 
>>        s5p-mfc: Update MFCv5 driver for callback based architecture
> 
> This one doesn't apply:
> 
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@@ -496,11 -499,14 +498,20 @@@ static int vidioc_reqbufs(struct file *
>                          s5p_mfc_clock_off();
>                          return -ENOMEM;
>                  }
> ++<<<<<<<  HEAD
>   +          if (s5p_mfc_ctx_ready(ctx))
>   +                  set_work_bit_irqsave(ctx);
>   +          s5p_mfc_try_run(dev);
> ++=======
> +           if (s5p_mfc_ctx_ready(ctx)) {
> +                   spin_lock_irqsave(&dev->condlock, flags);
> +                   set_bit(ctx->num,&dev->ctx_work_bits);
> +                   spin_unlock_irqrestore(&dev->condlock, flags);
> +           }
> +           s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> ++>>>>>>>  e67ff71... s5p-mfc: Update MFCv5 driver for callback based architecture
> ...
> 
> @@@ -582,18 -589,24 +593,30 @@@ static int vidioc_streamon(struct file
>                          ctx->src_bufs_cnt = 0;
>                          ctx->capture_state = QUEUE_FREE;
>                          ctx->output_state = QUEUE_FREE;
> ++<<<<<<<  HEAD
>   +                  s5p_mfc_alloc_instance_buffer(ctx);
>   +                  s5p_mfc_alloc_dec_temp_buffers(ctx);
>   +                  set_work_bit_irqsave(ctx);
> ++=======
> +                   s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer,
> +                                   ctx);
> +                   s5p_mfc_hw_call(dev->mfc_ops, alloc_dec_temp_buffers,
> +                                   ctx);
> +                   spin_lock_irqsave(&dev->condlock, flags);
> +                   set_bit(ctx->num,&dev->ctx_work_bits);
> +                   spin_unlock_irqrestore(&dev->condlock, flags);
> ++>>>>>>>  e67ff71... s5p-mfc: Update MFCv5 driver for callback based architecture
> 
> and more...

Sorry, my bad :/ Should have better coordinated those patches from multiple
developers.

> Also, there are too many changes on this patch, making it harder for
> review, especially since there are also some code renames and function
> rearrangements.
> 
> The better is to split it into smaller and more logical changes, instead
> of what it sounds like a driver replacement.

Indeed it looks like big blob patch. I think this reflects how these patches 
were created, were one person creates practically new driver for new device 
revision, with not much care about the old one, and then somebody else is 
trying to make it a step by step process and ensuring support for all H/W
revisions is properly maintained.

Anyway, Arun, can you please rebase your patch series onto latest linuxtv 
for_v3.7 branch and try to split this above patch. AFAICS there are following
things done there that could be separated:

1. Move contents of file s5p_mfc_opr.c to new file s5p_mfc_opr_v5.c
2. Rename functions in s5p_mfc_opr_v5.c
3. Use s5p_mfc_hw_call for H/W specific function calls
4. Do S5P_FIMV/S5P_MFC whatever magic.

Also I've noticed some patches do break compilation. There are some definitions 
used there which are added only in subsequent patches. Arun, can you please make 
sure there is no build break after each single patch is applied ?

Thanks,
Sylwester
