Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65071 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1G2I77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 04:59:59 -0400
Received: by fxh19 with SMTP id 19so2088237fxh.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 01:59:58 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
Date: Fri, 29 Jul 2011 10:59:55 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.vzdhx5ucyxxkfz@localhost.localdomain>
In-Reply-To: <20110729075143.GX16561@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uwe,

thank you for answer. You are right I give no memory to camera device in  
mach-imx27ipcam.c. I have tried to do it in same way as it is in  
mach-pcm037.c but no success. Here is my init function

static int __init mx27ipcam_camera_init(void) {
	int dma, ret = -ENOMEM;
	struct platform_device *pdev;

	printk("MX2 camera initialization.\n");

	pdev = imx27_add_mx2_camera(&mx27ipcam_camera);

	if (IS_ERR(pdev)) {
		printk("pdev error\n");
		return PTR_ERR(pdev);
	}

	dma = dma_declare_coherent_memory(&pdev->dev,
					mx2_camera_base, mx2_camera_base,
					MX2_CAMERA_BUF_SIZE,
					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
	if (!(dma & DMA_MEMORY_MAP))
		goto err;


	ret = platform_device_add(pdev);
	if (ret) {
		printk("platform_device_add error\n");

err:
		platform_device_put(pdev);
	}

	return ret;
}


I do not understand fully this business around allocation so it may be  
wrong.

regards
Jan

Dne Fri, 29 Jul 2011 09:51:43 +0200 Uwe Kleine-König  
<u.kleine-koenig@pengutronix.de> napsal(a):

> Hello,
>
> On Fri, Jul 29, 2011 at 09:31:28AM +0200, Jan Pohanka wrote:
>> I'm playing with imx27ipcam reference design and I would like to use
>> more recent (or actual) kernel than the one in BSP (2.6.19). I had
>> no problems with running 2.6.39 version from mainline, and now I
>> want to get some signal from CMOS chip. As there is no driver for
>> mt9d131 yet I modified the mt9m111 driver to communicate wit it.
>> Driver gets correctly initialized
>>
>> mx2-camera mx2-camera.0: initialising
>> mx2-camera mx2-camera.0: Camera clock frequency: 6250000
>> mx2-camera mx2-camera.0: Using EMMA
>> camera 0-0: Probing 0-0
>> mx27ipcam_camera_power: 1
>> mx27ipcam_camera_reset
>> mx2-camera mx2-camera.0: Camera driver attached to camera 0
>> mt9m111 0-0048: read  reg.000 -> 1519
>> mt9m111 0-0048: Detected a MT9D131 chip ID 1519
>> camera 0-0: Found 8 supported formats.
>> mx2-camera mx2-camera.0: Camera driver detached from camera 0
>> mx27ipcam_camera_power: 0
>> mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock
>> frequency: 6250000
>>
>> For example this command should capture several frames
>> ffmpeg -s qvga -r 30 -t 2 -pix_fmt yuyv422 -f video4linux2 -i
>> /dev/video0 temp_vid.h263
>>
>> however there is some problems with dma_contig allocation
>> mx2-camera mx2-camera.0: dma_alloc_coherent size 155648 failed
>> [video4linux2 @ 0xfa8c50]mmap: Cannot allocate memory
>> /dev/video0: Input/output error
>>
>> ...
>> camera 0-0: mmap called, vma=0xc397fd30
>> camera 0-0: vma start=0x4014c000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fcd8
>> camera 0-0: vma start=0x40ee8000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fc80
>> camera 0-0: vma start=0x40fa4000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fc28
>> camera 0-0: vma start=0x4109a000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fbd0
>> camera 0-0: vma start=0x41124000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fb78
>> camera 0-0: vma start=0x4118a000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fb20
>> camera 0-0: vma start=0x41241000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fac8
>> camera 0-0: vma start=0x41277000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fa70
>> camera 0-0: vma start=0x412c3000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397fa18
>> camera 0-0: vma start=0x41377000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f9c0
>> camera 0-0: vma start=0x41416000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f968
>> camera 0-0: vma start=0x4147f000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f910
>> camera 0-0: vma start=0x414a5000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f8b8
>> camera 0-0: vma start=0x41542000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f860
>> camera 0-0: vma start=0x415ba000, size=155648, ret=0
>> camera 0-0: mmap called, vma=0xc397f808
>> mx2-camera mx2-camera.0: dma_alloc_coherent size 155648 failed
>> camera 0-0: vma start=0x41667000, size=155648, ret=-12
>> mx2-camera mx2-camera.0: Camera driver detached from camera 0
>> mx27ipcam_camera_power: 0
>> camera 0-0: camera device close
> Check out what arch/arm/mach-imx/mach-pcm037.c does to give some memory
> to the camera device.
>
> Best regards
> Uwe
>


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
