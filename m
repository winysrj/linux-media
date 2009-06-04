Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZFDSXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 14:23:12 -0400
Message-ID: <4A28114A.6000903@redhat.com>
Date: Thu, 04 Jun 2009 20:24:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [PATCH] Add missing __devexit_p()
References: <20090604160716.6c6718aa@hyperion.delvare>
In-Reply-To: <20090604160716.6c6718aa@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 06/04/2009 04:07 PM, Jean Delvare wrote:
> Add missing __devexit_p() to several drivers. Also add a few missing
> __init, __devinit and __exit markers. These errors could result in
> build failures depending on the kernel configuration.
>
> Signed-off-by: Jean Delvare<khali@linux-fr.org>

Looks good to me.

Regards,

Hans

> ---
>   linux/drivers/media/dvb/bt8xx/bt878.c                 |    8 +-------
>   linux/drivers/media/video/cx88/cx88-alsa.c            |    7 +++----
>   linux/drivers/media/video/mx3_camera.c                |    6 +++---
>   linux/drivers/media/video/pxa_camera.c                |    6 +++---
>   linux/drivers/media/video/soc_camera.c                |    2 +-
>   linux/drivers/media/video/usbvision/usbvision-video.c |    2 +-
>   linux/drivers/media/video/zoran/zoran_card.c          |    2 +-
>   7 files changed, 13 insertions(+), 20 deletions(-)
>
> --- v4l-dvb.orig/linux/drivers/media/dvb/bt8xx/bt878.c	2009-03-01 16:09:08.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/dvb/bt8xx/bt878.c	2009-06-04 14:00:41.000000000 +0200
> @@ -512,12 +512,6 @@ static int __devinit bt878_probe(struct
>   	pci_set_master(dev);
>   	pci_set_drvdata(dev, bt);
>
> -/*        if(init_bt878(btv)<  0) {
> -		bt878_remove(dev);
> -		return -EIO;
> -	}
> -*/
> -
>   	if ((result = bt878_mem_alloc(bt))) {
>   		printk(KERN_ERR "bt878: failed to allocate memory!\n");
>   		goto fail2;
> @@ -583,7 +577,7 @@ static struct pci_driver bt878_pci_drive
>         .name	= "bt878",
>         .id_table = bt878_pci_tbl,
>         .probe	= bt878_probe,
> -      .remove	= bt878_remove,
> +      .remove	= __devexit_p(bt878_remove),
>   };
>
>   static int bt878_pci_driver_registered;
> --- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-alsa.c	2009-04-17 11:22:56.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/cx88/cx88-alsa.c	2009-06-04 14:04:37.000000000 +0200
> @@ -939,7 +939,7 @@ static struct pci_driver cx88_audio_pci_
>   	.name     = "cx88_audio",
>   	.id_table = cx88_audio_pci_tbl,
>   	.probe    = cx88_audio_initdev,
> -	.remove   = cx88_audio_finidev,
> +	.remove   = __devexit_p(cx88_audio_finidev),
>   };
>
>   /****************************************************************************
> @@ -949,7 +949,7 @@ static struct pci_driver cx88_audio_pci_
>   /*
>    * module init
>    */
> -static int cx88_audio_init(void)
> +static int __init cx88_audio_init(void)
>   {
>   	printk(KERN_INFO "cx2388x alsa driver version %d.%d.%d loaded\n",
>   	       (CX88_VERSION_CODE>>  16)&  0xff,
> @@ -965,9 +965,8 @@ static int cx88_audio_init(void)
>   /*
>    * module remove
>    */
> -static void cx88_audio_fini(void)
> +static void __exit cx88_audio_fini(void)
>   {
> -
>   	pci_unregister_driver(&cx88_audio_pci_driver);
>   }
>
> --- v4l-dvb.orig/linux/drivers/media/video/mx3_camera.c	2009-04-29 14:30:29.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/mx3_camera.c	2009-06-04 14:05:25.000000000 +0200
> @@ -1074,7 +1074,7 @@ static struct soc_camera_host_ops mx3_so
>   	.set_bus_param	= mx3_camera_set_bus_param,
>   };
>
> -static int mx3_camera_probe(struct platform_device *pdev)
> +static int __devinit mx3_camera_probe(struct platform_device *pdev)
>   {
>   	struct mx3_camera_dev *mx3_cam;
>   	struct resource *res;
> @@ -1194,11 +1194,11 @@ static struct platform_driver mx3_camera
>   		.name	= MX3_CAM_DRV_NAME,
>   	},
>   	.probe		= mx3_camera_probe,
> -	.remove		= __exit_p(mx3_camera_remove),
> +	.remove		= __devexit_p(mx3_camera_remove),
>   };
>
>
> -static int __devinit mx3_camera_init(void)
> +static int __init mx3_camera_init(void)
>   {
>   	return platform_driver_register(&mx3_camera_driver);
>   }
> --- v4l-dvb.orig/linux/drivers/media/video/pxa_camera.c	2009-06-04 13:45:28.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/pxa_camera.c	2009-06-04 14:03:05.000000000 +0200
> @@ -1541,7 +1541,7 @@ static struct soc_camera_host_ops pxa_so
>   	.set_bus_param	= pxa_camera_set_bus_param,
>   };
>
> -static int pxa_camera_probe(struct platform_device *pdev)
> +static int __devinit pxa_camera_probe(struct platform_device *pdev)
>   {
>   	struct pxa_camera_dev *pcdev;
>   	struct resource *res;
> @@ -1716,11 +1716,11 @@ static struct platform_driver pxa_camera
>   		.name	= PXA_CAM_DRV_NAME,
>   	},
>   	.probe		= pxa_camera_probe,
> -	.remove		= __exit_p(pxa_camera_remove),
> +	.remove		= __devexit_p(pxa_camera_remove),
>   };
>
>
> -static int __devinit pxa_camera_init(void)
> +static int __init pxa_camera_init(void)
>   {
>   	return platform_driver_register(&pxa_camera_driver);
>   }
> --- v4l-dvb.orig/linux/drivers/media/video/soc_camera.c	2009-05-11 11:12:03.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/soc_camera.c	2009-06-04 14:04:58.000000000 +0200
> @@ -1206,7 +1206,7 @@ static int __devexit soc_camera_pdrv_rem
>
>   static struct platform_driver __refdata soc_camera_pdrv = {
>   	.probe	= soc_camera_pdrv_probe,
> -	.remove	= __exit_p(soc_camera_pdrv_remove),
> +	.remove	= __devexit_p(soc_camera_pdrv_remove),
>   	.driver	= {
>   		.name = "soc-camera-pdrv",
>   		.owner = THIS_MODULE,
> --- v4l-dvb.orig/linux/drivers/media/video/usbvision/usbvision-video.c	2009-05-12 10:19:32.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/usbvision/usbvision-video.c	2009-06-04 14:03:58.000000000 +0200
> @@ -1794,7 +1794,7 @@ static struct usb_driver usbvision_drive
>   	.name		= "usbvision",
>   	.id_table	= usbvision_table,
>   	.probe		= usbvision_probe,
> -	.disconnect	= usbvision_disconnect
> +	.disconnect	= __devexit_p(usbvision_disconnect),
>   };
>
>   /*
> --- v4l-dvb.orig/linux/drivers/media/video/zoran/zoran_card.c	2009-05-12 10:19:32.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/zoran/zoran_card.c	2009-06-04 14:05:46.000000000 +0200
> @@ -1478,7 +1478,7 @@ static struct pci_driver zoran_driver =
>   	.name = "zr36067",
>   	.id_table = zr36067_pci_tbl,
>   	.probe = zoran_probe,
> -	.remove = zoran_remove,
> +	.remove = __devexit_p(zoran_remove),
>   };
>
>   static int __init zoran_init(void)
>
>
