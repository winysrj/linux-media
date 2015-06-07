Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34302 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbbFGMl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2015 08:41:26 -0400
Received: by lbcmx3 with SMTP id mx3so66312781lbc.1
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2015 05:41:25 -0700 (PDT)
Message-ID: <55743BF3.1080301@cogentembedded.com>
Date: Sun, 07 Jun 2015 15:41:23 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 08/11] sh-vou: add support for log_status
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl> <1433667485-35711-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-9-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 6/7/2015 11:58 AM, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Dump the VOU registers in log_status.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/platform/sh_vou.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)

> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 9479c44..cbee361 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -949,6 +949,34 @@ static int sh_vou_g_std(struct file *file, void *priv, v4l2_std_id *std)
>   	return 0;
>   }
>
> +static int sh_vou_log_status(struct file *file, void *priv)
> +{
> +	struct sh_vou_device *vou_dev = video_drvdata(file);
> +
> +	pr_info("PSELA:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUER));

    You forgot to remove this line. :-(

> +	pr_info("VOUER:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUER));
> +	pr_info("VOUCR:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUCR));
> +	pr_info("VOUSTR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSTR));
> +	pr_info("VOUVCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUVCR));
> +	pr_info("VOUISR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUISR));
> +	pr_info("VOUBCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUBCR));
> +	pr_info("VOUDPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDPR));
> +	pr_info("VOUDSR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDSR));
> +	pr_info("VOUVPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUVPR));
> +	pr_info("VOUIR:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUIR));
> +	pr_info("VOUSRR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSRR));
> +	pr_info("VOUMSR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUMSR));
> +	pr_info("VOUHIR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUHIR));
> +	pr_info("VOUDFR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDFR));
> +	pr_info("VOUAD1R: 0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAD1R));
> +	pr_info("VOUAD2R: 0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAD2R));
> +	pr_info("VOUAIR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAIR));
> +	pr_info("VOUSWR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSWR));
> +	pr_info("VOURCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOURCR));
> +	pr_info("VOURPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOURPR));
> +	return 0;
> +}
> +
>   static int sh_vou_g_selection(struct file *file, void *fh,
>   			      struct v4l2_selection *sel)
>   {
[...]

WBR, Sergei

