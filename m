Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50099 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1HDNLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 09:11:16 -0400
Received: by eyx24 with SMTP id 24so397054eyx.19
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2011 06:11:15 -0700 (PDT)
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
Date: Thu, 04 Aug 2011 15:11:11 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.vzoxkxheyxxkfz@localhost.localdomain>
In-Reply-To: <20110729115732.GA16561@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Uwe,
could you please give me some advice once more? It seems I'm not able to  
make mx2_camera working by myself.
I have tried dma memory allocation in my board file in several ways, but  
nothing seems to work. I use Video capture example for v4l2 for testing.

regards
Jan

mx27ipcam_camera_power: 1
mx27ipcam_camera_reset
mx2-camera mx2-camera.0: Camera driver attached to camera 0
mx2-camera mx2-camera.0: dma_alloc_coherent size 614400 failed
mmap error 12, Cannot allocate memory
mx2-camera mx2-camera.0: Camera driver detached from camera 0
mx27ipcam_camera_power: 0

...
static phys_addr_t mx2_camera_base __initdata;
#define MX2_CAMERA_BUF_SIZE SZ_4M

static int __init mx27ipcam_init_camera(void)
{
	int dma, ret = -ENOMEM;
	struct platform_device *pdev = imx27_alloc_mx2_camera(&mx27ipcam_camera);


	if (IS_ERR(pdev))
		return PTR_ERR(pdev);

	dma = dma_declare_coherent_memory(&pdev->dev,
					mx2_camera_base, mx2_camera_base,
					MX2_CAMERA_BUF_SIZE,
					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
	if (!(dma & DMA_MEMORY_MAP))
		goto err;

	ret = platform_device_add(pdev);
	if (ret)
err:
		platform_device_put(pdev);

	return ret;
}

static void __init mx27ipcam_init(void)
{
	imx27_soc_init();

	mxc_gpio_setup_multiple_pins(mx27ipcam_pins, ARRAY_SIZE(mx27ipcam_pins),
		"mx27ipcam");

	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
	/*imx27_add_mxc_nand(&mx27ipcam_nand_board_info);*/

	imx27_add_imx_uart0(NULL);
	imx27_add_fec(NULL);
	imx27_add_imx2_wdt(NULL);
	imx27_add_imx_i2c(0, &mx27ipcam_i2c1_data);

	mx27ipcam_init_camera();
}

static void __init mx27ipcam_reserve(void)
{
	/* reserve 4 MiB for mx3-camera */
	mx2_camera_base = memblock_alloc(MX2_CAMERA_BUF_SIZE,
			MX2_CAMERA_BUF_SIZE);
	memblock_free(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
	memblock_remove(mx2_camera_base, MX2_CAMERA_BUF_SIZE);
}

MACHINE_START(IMX27IPCAM, "Freescale IMX27IPCAM")
	/* maintainer: Freescale Semiconductor, Inc. */
	.boot_params = MX27_PHYS_OFFSET + 0x100,
	.reserve = mx27ipcam_reserve,
	.map_io = mx27_map_io,
	.init_early = imx27_init_early,
	.init_irq = mx27_init_irq,
	.timer = &mx27ipcam_timer,
	.init_machine = mx27ipcam_init,
MACHINE_END



struct platform_device *__init imx_add_mx2_camera(
		const struct imx_mx2_camera_data *data,
		const struct mx2_camera_platform_data *pdata)
{
	struct resource res[] = {
		{
			.start = data->iobasecsi,
			.end = data->iobasecsi + data->iosizecsi - 1,
			.flags = IORESOURCE_MEM,
		}, {
			.start = data->irqcsi,
			.end = data->irqcsi,
			.flags = IORESOURCE_IRQ,
		}, {
			.start = data->iobaseemmaprp,
			.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
			.flags = IORESOURCE_MEM,
		}, {
			.start = data->irqemmaprp,
			.end = data->irqemmaprp,
			.flags = IORESOURCE_IRQ,
		},
	};
	return imx_add_platform_device_dmamask("mx2-camera", 0,
			res, data->iobaseemmaprp ? 4 : 2,
			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
}

struct platform_device *__init imx_alloc_mx2_camera(
		const struct imx_mx2_camera_data *data,
		const struct mx2_camera_platform_data *pdata)
{
	struct resource res[] = {
			{
					.start = data->iobasecsi,
					.end = data->iobasecsi + data->iosizecsi - 1,
					.flags = IORESOURCE_MEM,
			}, {
					.start = data->irqcsi,
					.end = data->irqcsi,
					.flags = IORESOURCE_IRQ,
			}, {
					.start = data->iobaseemmaprp,
					.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
					.flags = IORESOURCE_MEM,
			}, {
					.start = data->irqemmaprp,
					.end = data->irqemmaprp,
					.flags = IORESOURCE_IRQ,
			},
	};
	int ret = -ENOMEM;
	struct platform_device *pdev;

	pdev = platform_device_alloc("mx2-camera", 0);
	if (!pdev)
		goto err;

	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
	if (!pdev->dev.dma_mask)
		goto err;

	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);

	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
	if (ret)
		goto err;

	if (pdata) {

		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
		if (ret) {
err:
			kfree(pdev->dev.dma_mask);
			platform_device_put(pdev);
			return ERR_PTR(-ENODEV);
		}
	}

	return pdev;
}


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
