Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57853 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1G2KON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:14:13 -0400
Received: by eye22 with SMTP id 22so3202022eye.2
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 03:14:12 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
 <20110729092311.GY16561@pengutronix.de>
Date: Fri, 29 Jul 2011 12:14:09 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.vzdldvr1yxxkfz@localhost.localdomain>
In-Reply-To: <20110729092311.GY16561@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Uwe,
which repository should I search 90026c8c823bff54172eab33a5e7fcecfd3df635  
in? I have not found it in git.pengutronix.de/git/imx/linux-2.6.git nor in  
vanilla sources.

regards Jan

Dne Fri, 29 Jul 2011 11:23:12 +0200 Uwe Kleine-König  
<u.kleine-koenig@pengutronix.de> napsal(a):

> Hi Jan,
>
> On Fri, Jul 29, 2011 at 10:59:55AM +0200, Jan Pohanka wrote:
>> thank you for answer. You are right I give no memory to camera
>> device in mach-imx27ipcam.c. I have tried to do it in same way as it
>> is in mach-pcm037.c but no success. Here is my init function
>>
>> static int __init mx27ipcam_camera_init(void) {
>> 	int dma, ret = -ENOMEM;
>> 	struct platform_device *pdev;
>>
>> 	printk("MX2 camera initialization.\n");
>>
>> 	pdev = imx27_add_mx2_camera(&mx27ipcam_camera);
>>
>> 	if (IS_ERR(pdev)) {
>> 		printk("pdev error\n");
>> 		return PTR_ERR(pdev);
>> 	}
>>
>> 	dma = dma_declare_coherent_memory(&pdev->dev,
>> 					mx2_camera_base, mx2_camera_base,
>> 					MX2_CAMERA_BUF_SIZE,
>> 					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
>> 	if (!(dma & DMA_MEMORY_MAP))
>> 		goto err;
>>
>>
>> 	ret = platform_device_add(pdev);
>> 	if (ret) {
>> 		printk("platform_device_add error\n");
>>
>> err:
>> 		platform_device_put(pdev);
>> 	}
>>
>> 	return ret;
>> }
> and you also have a reserve callback? See commit
> 90026c8c823bff54172eab33a5e7fcecfd3df635 for all details.
>
> Best regards
> Uwe
>


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
