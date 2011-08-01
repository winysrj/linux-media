Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1HAG6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 02:58:31 -0400
Received: by fxh19 with SMTP id 19so4255488fxh.19
        for <linux-media@vger.kernel.org>; Sun, 31 Jul 2011 23:58:29 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
 <20110729092311.GY16561@pengutronix.de>
 <op.vzdldvr1yxxkfz@localhost.localdomain>
 <20110729115732.GA16561@pengutronix.de>
Date: Mon, 01 Aug 2011 08:58:26 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.vziwbowpyxxkfz@localhost.localdomain>
In-Reply-To: <20110729115732.GA16561@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Uwe,

thank you for the answer again, but I'm still in troubles...
Here is the code from my mach-imx27ipcam.c regarding camera initialization  
and DMESG messages I got. The initialization is almost the same as in  
pcm037 as you adviced.

static int mx27ipcam_camera_power(struct device *dev, int on)
{
     /* set clock*/

	/* set standby pin */
     gpio_set_value(CAM_STDBY, !on);

     printk("%s: %d\n", __func__, (!(!on)));
	return 0;
}

static int mx27ipcam_camera_reset(struct device *dev)
{
	gpio_set_value(CAM_RESET, 0);
	udelay(100);
	gpio_set_value(CAM_RESET, 1);

     printk("%s\n", __func__);
     return 0;
}

static struct soc_camera_link iclink_mt9d131 = {
	.bus_id		= 0,		/* Must match with the camera ID */
	.board_info	= &mx27ipcam_i2c_camera[0],
	.i2c_adapter_id	= 0,
	.power = mx27ipcam_camera_power,
	.reset = mx27ipcam_camera_reset,
};


static struct platform_device mx27ipcam_mt9d131 = {
	.name	= "soc-camera-pdrv",
	.id	= 0,
	.dev	= {
		.platform_data = &iclink_mt9d131,
	},
};

static struct platform_device *platform_devices[] __initdata = {
	&ipcam_nor_mtd_device,
	&mx27ipcam_mt9d131,
};


static struct mx2_camera_platform_data mx27ipcam_camera = {
	.flags = 0,
	.clk = 100000,
};


static phys_addr_t mx2_camera_base __initdata;
#define MX2_CAMERA_BUF_SIZE SZ_4M

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

static void __init mx27ipcam_init(void)
{
...
	imx27_add_imx_i2c(0, &mx27ipcam_i2c1_data);
	mx27ipcam_camera_init();
...
}

...

static void __init imx27ipcam_reserve(void)
{
	/* reserve 4 MiB for mx2-camera */
	mx2_camera_base = memblock_alloc(MX2_CAMERA_BUF_SIZE,
			MX2_CAMERA_BUF_SIZE);
	memblock_free(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
	memblock_remove(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
}

MACHINE_START(IMX27IPCAM, "Freescale IMX27IPCAM")
	/* maintainer: Freescale Semiconductor, Inc. */
	.boot_params = MX27_PHYS_OFFSET + 0x100,
	.reserve = imx27ipcam_reserve,
	.map_io = mx27_map_io,
	.init_early = imx27_init_early,
	.init_irq = mx27_init_irq,
	.timer = &mx27ipcam_timer,
	.init_machine = mx27ipcam_init,
MACHINE_END




MX2 camera initialization.
------------[ cut here ]------------
WARNING: at /home/honza/_dev/kernel/linux-2.6.39.y/kernel/resource.c:491  
__insert_resource+0x13c/0
x148()
Modules linked in:
[<c00329e0>] (unwind_backtrace+0x0/0xf0) from [<c0042b00>]  
(warn_slowpath_common+0x4c/0x64)
[<c0042b00>] (warn_slowpath_common+0x4c/0x64) from [<c0042b34>]  
(warn_slowpath_null+0x1c/0x24)
[<c0042b34>] (warn_slowpath_null+0x1c/0x24) from [<c004960c>]  
(__insert_resource+0x13c/0x148)
[<c004960c>] (__insert_resource+0x13c/0x148) from [<c0049e6c>]  
(insert_resource_conflict+0x20/0x54
)
[<c0049e6c>] (insert_resource_conflict+0x20/0x54) from [<c0049ea8>]  
(insert_resource+0x8/0x14)
[<c0049ea8>] (insert_resource+0x8/0x14) from [<c01bf11c>]  
(platform_device_add+0x70/0x238)
[<c01bf11c>] (platform_device_add+0x70/0x238) from [<c000bc54>]  
(mx27ipcam_init+0xc0/0x120)
[<c000bc54>] (mx27ipcam_init+0xc0/0x120) from [<c0009558>]  
(customize_machine+0x1c/0x28)
[<c0009558>] (customize_machine+0x1c/0x28) from [<c002248c>]  
(do_one_initcall+0x30/0x16c)
[<c002248c>] (do_one_initcall+0x30/0x16c) from [<c000891c>]  
(kernel_init+0x90/0x13c)
[<c000891c>] (kernel_init+0x90/0x13c) from [<c002dfc0>]  
(kernel_thread_exit+0x0/0x8)
---[ end trace 1b75b31a2719ed1c ]---
mx2-camera.0: failed to claim resource 0
platform_device_add error


I have also another question if you are able to answer it. I would like to  
have some kind of kernel debugging working (JTAG or KGDB). We own j-link  
probe from segger, but their gdbserver cannot attach running application.  
It resets the board and I'm not able to boot linux again with probe  
connected. According to this I have tried also KGDB, but it does not work  
either. I have found this link  
http://www.imxdev.org/wiki/index.php?title=Mxuart_patch - it seems that  
polling routines are still not implemented in current driver. Is that true?

with best regards
Jan




Dne Fri, 29 Jul 2011 13:57:32 +0200 Uwe Kleine-König  
<u.kleine-koenig@pengutronix.de> napsal(a):

> Hello Jan,
>
> On Fri, Jul 29, 2011 at 12:14:09PM +0200, Jan Pohanka wrote:
>> which repository should I search
>> 90026c8c823bff54172eab33a5e7fcecfd3df635 in? I have not found it in
>> git.pengutronix.de/git/imx/linux-2.6.git nor in vanilla sources.
> Seems my copy'n'paste foo isn't optimal.  Commit
> dca7c0b4293a06d1ed9387e729a4882896abccc2 is the relevant, it's in
> vanilla.
>
> http://git.kernel.org/linus/dca7c0b4293a06d1ed9387e729a4882896abccc2
>
> Best regards
> Uwe
>


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/

Dne Fri, 29 Jul 2011 13:57:32 +0200 Uwe Kleine-König  
<u.kleine-koenig@pengutronix.de> napsal(a):

> Hello Jan,
>
> On Fri, Jul 29, 2011 at 12:14:09PM +0200, Jan Pohanka wrote:
>> which repository should I search
>> 90026c8c823bff54172eab33a5e7fcecfd3df635 in? I have not found it in
>> git.pengutronix.de/git/imx/linux-2.6.git nor in vanilla sources.
> Seems my copy'n'paste foo isn't optimal.  Commit
> dca7c0b4293a06d1ed9387e729a4882896abccc2 is the relevant, it's in
> vanilla.
>
> http://git.kernel.org/linus/dca7c0b4293a06d1ed9387e729a4882896abccc2
>
> Best regards
> Uwe
>


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
