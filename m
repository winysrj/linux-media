Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61686 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3FFGST (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 02:18:19 -0400
Received: by mail-oa0-f48.google.com with SMTP id i4so1866436oah.21
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 23:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370005408-10853-7-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-7-git-send-email-arun.kk@samsung.com>
Date: Thu, 6 Jun 2013 11:48:18 +0530
Message-ID: <CAK9yfHzi4Jdi9xO0eNuWe8U2303Qr+5erhN26P5ahfP0JvqTcw@mail.gmail.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
> fimc-is driver takes video data input from the ISP video node
> which is added in this patch. This node accepts Bayer input
> buffers which is given from the IS sensors.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---
[snip]


> +static int isp_video_output_open(struct file *file)
> +{
> +       struct fimc_is_isp *isp = video_drvdata(file);
> +       int ret = 0;
> +
> +       /* Check if opened before */
> +       if (isp->refcount >= FIMC_IS_MAX_INSTANCES) {
> +               pr_err("All instances are in use.\n");
> +               return -EBUSY;
> +       }
> +
> +       INIT_LIST_HEAD(&isp->wait_queue);
> +       isp->wait_queue_cnt = 0;
> +       INIT_LIST_HEAD(&isp->run_queue);
> +       isp->run_queue_cnt = 0;
> +
> +       isp->refcount++;
> +       return ret;

You can directly return 0 here instead of creating a local variable
'ret' which is not used anywhere else.

> +}
> +
> +static int isp_video_output_close(struct file *file)
> +{
> +       struct fimc_is_isp *isp = video_drvdata(file);
> +       int ret = 0;
> +
> +       isp->refcount--;
> +       isp->output_state = 0;
> +       vb2_fop_release(file);
> +       return ret;

ditto

> +}
> +
> +static const struct v4l2_file_operations isp_video_output_fops = {
> +       .owner          = THIS_MODULE,
> +       .open           = isp_video_output_open,
> +       .release        = isp_video_output_close,
> +       .poll           = vb2_fop_poll,
> +       .unlocked_ioctl = video_ioctl2,
> +       .mmap           = vb2_fop_mmap,
> +};
> +

nit: Please consider changing "Adds" to "Add" in the patch titles of
this series during the next spin.

-- 
With warm regards,
Sachin
