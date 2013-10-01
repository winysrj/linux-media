Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1177 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3JAGjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 02:39:43 -0400
Message-ID: <524A6E1D.6040700@xs4all.nl>
Date: Tue, 01 Oct 2013 08:39:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 1/3] [media] pci: cx88-alsa: Use module_pci_driver
References: <1379665927-18497-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1379665927-18497-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2013 10:32 AM, Sachin Kamat wrote:
> module_pci_driver removes some boilerplate and makes code simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

For this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/pci/cx88/cx88-alsa.c |   25 +------------------------
>  1 file changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
> index 05428bf..11d0692 100644
> --- a/drivers/media/pci/cx88/cx88-alsa.c
> +++ b/drivers/media/pci/cx88/cx88-alsa.c
> @@ -949,27 +949,4 @@ static struct pci_driver cx88_audio_pci_driver = {
>  	.remove   = cx88_audio_finidev,
>  };
>  
> -/****************************************************************************
> -				LINUX MODULE INIT
> - ****************************************************************************/
> -
> -/*
> - * module init
> - */
> -static int __init cx88_audio_init(void)
> -{
> -	printk(KERN_INFO "cx2388x alsa driver version %s loaded\n",
> -	       CX88_VERSION);
> -	return pci_register_driver(&cx88_audio_pci_driver);
> -}
> -
> -/*
> - * module remove
> - */
> -static void __exit cx88_audio_fini(void)
> -{
> -	pci_unregister_driver(&cx88_audio_pci_driver);
> -}
> -
> -module_init(cx88_audio_init);
> -module_exit(cx88_audio_fini);
> +module_pci_driver(cx88_audio_pci_driver);
> 

