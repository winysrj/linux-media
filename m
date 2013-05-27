Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:32228 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3E0JdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 05:33:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Libo Chen <libo.chen@huawei.com>
Subject: Re: [PATCH 22/24] drivers/media/radio/radio-maxiradio: Convert to module_pci_driver
Date: Mon, 27 May 2013 11:32:57 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, lizefan@huawei.com,
	gregkh@linuxfoundation.org
References: <1369621919-12800-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369621919-12800-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271132.57946.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 27 May 2013 04:31:59 Libo Chen wrote:
> use module_pci_driver instead of init/exit, make code clean
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/radio/radio-maxiradio.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
> index bd4d3a7..1d1c9e1 100644
> --- a/drivers/media/radio/radio-maxiradio.c
> +++ b/drivers/media/radio/radio-maxiradio.c
> @@ -200,15 +200,4 @@ static struct pci_driver maxiradio_driver = {
>  	.remove		= maxiradio_remove,
>  };
>  
> -static int __init maxiradio_init(void)
> -{
> -	return pci_register_driver(&maxiradio_driver);
> -}
> -
> -static void __exit maxiradio_exit(void)
> -{
> -	pci_unregister_driver(&maxiradio_driver);
> -}
> -
> -module_init(maxiradio_init);
> -module_exit(maxiradio_exit);
> +module_pci_driver(maxiradio_driver);
> 
