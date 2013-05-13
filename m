Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57810 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3EMMTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 08:19:13 -0400
Received: by mail-wi0-f169.google.com with SMTP id hn14so517867wib.2
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 05:19:12 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, prabhakar.csengg@gmail.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
Date: Mon, 13 May 2013 14:19:29 +0200
Message-ID: <44148472.RS4fqJslTV@harkonnen>
In-Reply-To: <CAPgLHd8UFD4p=PAK+Ukno8qvmvaxVxvSrrZw=qpUtERCyP7hpg@mail.gmail.com>
References: <CAPgLHd8UFD4p=PAK+Ukno8qvmvaxVxvSrrZw=qpUtERCyP7hpg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I agree with the content of the patch, but I disagree with the commit message. 
>From the commit message it seems that you fixed a bug about the error code, 
but the aim of this patch is to uniform the code style. I suggest something 
like: "uniform code style in sta2x11_vip_init_one()"

On Monday 13 May 2013 13:59:45 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/pci/sta2x11/sta2x11_vip.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c
> b/drivers/media/pci/sta2x11/sta2x11_vip.c index 7005695..77edc11 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -1047,7 +1047,8 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
>  	ret = sta2x11_vip_init_controls(vip);
>  	if (ret)
>  		goto free_mem;
> -	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
> +	ret = v4l2_device_register(&pdev->dev, &vip->v4l2_dev);
> +	if (ret)
>  		goto free_mem;
> 
>  	dev_dbg(&pdev->dev, "BAR #0 at 0x%lx 0x%lx irq %d\n",
-- 
Federico Vaga
