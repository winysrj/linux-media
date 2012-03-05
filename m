Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41962 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2CEUEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 15:04:30 -0500
Received: by pbcun15 with SMTP id un15so3160164pbc.19
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2012 12:04:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329819211-8359-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1329819211-8359-1-git-send-email-santoshprasadnayak@gmail.com>
Date: Tue, 6 Mar 2012 01:34:30 +0530
Message-ID: <CAOD=uF72jkiqSo8x0W7iNf7g151Ee13LaH-oKZcS=9t+d98vCg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Driver: video: Use the macro DMA_BIT_MASK().
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: awalls@md.metrocast.net
Cc: mchehab@infradead.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can you please comment on it ?

Regards
Santosh

On Tue, Feb 21, 2012 at 3:43 PM, santosh nayak
<santoshprasadnayak@gmail.com> wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>
> Use the macro DMA_BIT_MASK instead of the constant  0xffffffff.
>
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  drivers/media/video/cx18/cx18-driver.c |    4 ++--
>  drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 349bd9c..08118e5 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -38,7 +38,7 @@
>  #include "cx18-ioctl.h"
>  #include "cx18-controls.h"
>  #include "tuner-xc2028.h"
> -
> +#include <linux/dma-mapping.h>
>  #include <media/tveeprom.h>
>
>  /* If you have already X v4l cards, then set this to X. This way
> @@ -812,7 +812,7 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
>                CX18_ERR("Can't enable device %d!\n", cx->instance);
>                return -EIO;
>        }
> -       if (pci_set_dma_mask(pci_dev, 0xffffffff)) {
> +       if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
>                CX18_ERR("No suitable DMA available, card %d\n", cx->instance);
>                return -EIO;
>        }
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 107e9e6..d84e5df 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -55,7 +55,7 @@
>  #include "ivtv-routing.h"
>  #include "ivtv-controls.h"
>  #include "ivtv-gpio.h"
> -
> +#include <linux/dma-mapping.h>
>  #include <media/tveeprom.h>
>  #include <media/saa7115.h>
>  #include <media/v4l2-chip-ident.h>
> @@ -813,7 +813,7 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
>                IVTV_ERR("Can't enable device!\n");
>                return -EIO;
>        }
> -       if (pci_set_dma_mask(pdev, 0xffffffff)) {
> +       if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
>                IVTV_ERR("No suitable DMA available.\n");
>                return -EIO;
>        }
> --
> 1.7.4.4
>
