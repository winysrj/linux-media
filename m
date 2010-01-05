Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:53752 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0AEKNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 05:13:53 -0500
Date: Tue, 5 Jan 2010 11:13:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] media/dvb: add __init/__exit macros to
 drivers/media/dvb/bt8xx/bt878.c
Message-ID: <20100105111348.4a2091bd@hyperion.delvare>
In-Reply-To: <1261471095-24272-1-git-send-email-peterhuewe@gmx.de>
References: <1261471095-24272-1-git-send-email-peterhuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 22 Dec 2009 09:38:14 +0100, peterhuewe@gmx.de wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/media/dvb/bt8xx/bt878.c
> 
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial
> tree.
> 
> Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> but also present in linus tree.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  drivers/media/dvb/bt8xx/bt878.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/bt8xx/bt878.c b/drivers/media/dvb/bt8xx/bt878.c
> index a24c125..2a0886a 100644
> --- a/drivers/media/dvb/bt8xx/bt878.c
> +++ b/drivers/media/dvb/bt8xx/bt878.c
> @@ -582,7 +582,7 @@ static int bt878_pci_driver_registered;
>  /* Module management functions */
>  /*******************************/
>  
> -static int bt878_init_module(void)
> +static int __init bt878_init_module(void)
>  {
>  	bt878_num = 0;
>  	bt878_pci_driver_registered = 0;
> @@ -600,7 +600,7 @@ static int bt878_init_module(void)
>  	return pci_register_driver(&bt878_pci_driver);
>  }
>  
> -static void bt878_cleanup_module(void)
> +static void __exit bt878_cleanup_module(void)
>  {
>  	if (bt878_pci_driver_registered) {
>  		bt878_pci_driver_registered = 0;


-- 
Jean Delvare
