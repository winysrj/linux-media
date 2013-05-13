Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:36839 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3EMOCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 10:02:05 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so1332815eae.12
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 07:02:03 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, prabhakar.csengg@gmail.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
Date: Mon, 13 May 2013 16:02:21 +0200
Message-ID: <1587030.87unLCKBly@harkonnen>
In-Reply-To: <CAPgLHd8gFagqNM8y3WAfw1F8sddPWzB9TN1U8EOF8VrknOoeOg@mail.gmail.com>
References: <CAPgLHd8gFagqNM8y3WAfw1F8sddPWzB9TN1U8EOF8VrknOoeOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 13 May 2013 22:00:01 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The orig code will release all the resources if v4l2_device_register()
> failed and return 0. But what we need in this case is to return an
> negative error code to let the caller known we are failed.
> So the patch save the return value of v4l2_device_register() to 'ret'
> and return it when error.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Federico Vaga <federico.vaga@gmail.com>

> ---
> v1 -> v2: change the commit message
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
