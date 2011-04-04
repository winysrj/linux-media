Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57376 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1DDQv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 12:51:56 -0400
Received: by eyx24 with SMTP id 24so1772620eyx.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 09:51:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104041824.43562.smueller@chronox.de>
References: <201104041824.43562.smueller@chronox.de>
Date: Mon, 4 Apr 2011 12:51:54 -0400
Message-ID: <BANLkTin87-qq69fgGC_05jvOr7_1p3Q4hg@mail.gmail.com>
Subject: Re: [PATCH] cx231xx Hauppauge WinTV 950HD
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 4, 2011 at 12:24 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Hi,
>
> please apply the attached patch to make the 950HD USB card working.
>
> Ciao
> Stephan
>
> ---
>
> Hauppauge WinTV 950HD
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
> --- drivers/media/video/cx231xx/cx231xx-cards.c.orig    2011-04-04 18:17:55.245769669 +0200
> +++ drivers/media/video/cx231xx/cx231xx-cards.c 2011-04-04 15:48:37.257376578 +0200
> @@ -458,6 +458,8 @@
>         .driver_info = CX231XX_BOARD_CNXT_RDU_250},
>        {USB_DEVICE(0x2040, 0xb120),
>         .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
> +       {USB_DEVICE(0x2040, 0xb138),
> +        .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
>        {USB_DEVICE(0x2040, 0xb140),
>         .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
>        {USB_DEVICE(0x2040, 0xc200),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

NACK

The 2040:b138 is the new variant of the HVR-900, which is a DVB-T
device that uses a different demodulator (for which there is no driver
currently).  It needs its own board profile defined, since the
HAUPPAUGE_EXETER board profile is configured for the lgdt3305 demod.

You can submit a patch which defines a new board profile, sets the
product name properly, and only supports analog mode (since there is
no demod driver to reference).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
