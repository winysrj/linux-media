Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57332 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2IKKib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:38:31 -0400
Received: by oago6 with SMTP id o6so146986oag.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:38:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-2-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-2-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:38:30 +0200
Message-ID: <CACKLOr2KGum+HnJFMB0wUgqG+8AtCQW3kGjQN1oq00QYmp_P+g@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] media: coda: firmware loading for 64-bit AXI bus width
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 September 2012 17:29, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Add support for loading a raw firmware with 16-bit chars ordered in
> little-endian 64-bit words, corresponding to the memory access pattern
> of CODA7 and above: When writing the boot code into the code download
> register, the chars have to be reordered back.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |   34 ++++++++++++++++++++++------------
>  1 file changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 6908514..d4a5dd0 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1510,7 +1510,7 @@ static char *coda_product_name(int product)
>         }
>  }
>
> -static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
> +static int coda_hw_init(struct coda_dev *dev)
>  {
>         u16 product, major, minor, release;
>         u32 data;
> @@ -1520,21 +1520,27 @@ static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
>         clk_prepare_enable(dev->clk_per);
>         clk_prepare_enable(dev->clk_ahb);
>
> -       /* Copy the whole firmware image to the code buffer */
> -       memcpy(dev->codebuf.vaddr, fw->data, fw->size);
>         /*
>          * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
> -        * This memory seems to be big-endian here, which is weird, since
> -        * the internal ARM processor of the coda is little endian.
> +        * The 16-bit chars in the code buffer are in memory access
> +        * order, re-sort them to CODA order for register download.
>          * Data in this SRAM survives a reboot.
>          */
> -       p = (u16 *)fw->data;
> -       for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
> -               data = CODA_DOWN_ADDRESS_SET(i) |
> -                       CODA_DOWN_DATA_SET(p[i ^ 1]);
> -               coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
> +       p = (u16 *)dev->codebuf.vaddr;
> +       if (dev->devtype->product == CODA_DX6) {
> +               for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
> +                       data = CODA_DOWN_ADDRESS_SET(i) |
> +                               CODA_DOWN_DATA_SET(p[i ^ 1]);
> +                       coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
> +               }
> +       } else {
> +               for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++) {
> +                       data = CODA_DOWN_ADDRESS_SET(i) |
> +                               CODA_DOWN_DATA_SET(p[round_down(i, 4) +
> +                                                       3 - (i % 4)]);
> +                       coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
> +               }
>         }
> -       release_firmware(fw);
>
>         /* Tell the BIT where to find everything it needs */
>         coda_write(dev, dev->workbuf.paddr,
> @@ -1630,7 +1636,11 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>                 return;
>         }
>
> -       ret = coda_hw_init(dev, fw);
> +       /* Copy the whole firmware image to the code buffer */
> +       memcpy(dev->codebuf.vaddr, fw->data, fw->size);
> +       release_firmware(fw);
> +
> +       ret = coda_hw_init(dev);
>         if (ret) {
>                 v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
>                 return;
> --
> 1.7.10.4
>

Tested-by: Javier Martin <javier.martin@vista-silicon.com

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
