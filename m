Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33116 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3IEDFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Sep 2013 23:05:05 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so95248veb.25
        for <linux-media@vger.kernel.org>; Wed, 04 Sep 2013 20:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378348275.27597.15.camel@deadeye.wl.decadent.org.uk>
References: <1378348215.27597.14.camel@deadeye.wl.decadent.org.uk>
	<1378348275.27597.15.camel@deadeye.wl.decadent.org.uk>
Date: Thu, 5 Sep 2013 00:05:03 -0300
Message-ID: <CAOMZO5C0n5vP1Tb8Kx=jWjN9NQ7_8S3y28vE6Jby-fugHC=Tjw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] [media] lirc_bt829: Fix physical address type
From: Fabio Estevam <festevam@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 4, 2013 at 11:31 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Use phys_addr_t and log format %pa.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/staging/media/lirc/lirc_bt829.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
> index fa31ee7..9c7be55 100644
> --- a/drivers/staging/media/lirc/lirc_bt829.c
> +++ b/drivers/staging/media/lirc/lirc_bt829.c
> @@ -63,7 +63,7 @@ static bool debug;
>         } while (0)
>
>  static int atir_minor;
> -static unsigned long pci_addr_phys;
> +static phys_addr_t pci_addr_phys;
>  static unsigned char *pci_addr_lin;
>
>  static struct lirc_driver atir_driver;
> @@ -78,8 +78,7 @@ static struct pci_dev *do_pci_probe(void)
>                 pci_addr_phys = 0;
>                 if (my_dev->resource[0].flags & IORESOURCE_MEM) {
>                         pci_addr_phys = my_dev->resource[0].start;
> -                       pr_info("memory at 0x%08X\n",
> -                              (unsigned int)pci_addr_phys);
> +                       pr_info("memory at %pa\n", &pci_addr_phys);

Looks much better :-)

Reviewed-by: Fabio Estevam <fabio.estevam@freescale.com>
