Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44865 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEAW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:22:27 -0500
Received: by mail-qk0-f193.google.com with SMTP id v188so4097949qkh.11
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 16:22:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc> <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 4 Jan 2018 19:22:26 -0500
Message-ID: <CAOcJUbwmCysV7pcCZK6udNpZVsaU+pxfCrJnEGBWcP9ta0Jqrg@mail.gmail.com>
Subject: Re: [PATCH 2/9] em28xx: Bulk transfer implementation fix
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
> Set appropriate bulk/ISOC transfer multiplier on capture start.
> This sets ISOC transfer to 940 bytes (188 * 5)
> This sets bulk transfer to 48128 bytes (188 * 256)
>
> The above values are maximum allowed according to Empia.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>

:+1

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

> ---
>  drivers/media/usb/em28xx/em28xx-core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index ef38e56..67ed6a3 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -638,6 +638,18 @@ int em28xx_capture_start(struct em28xx *dev, int start)
>             dev->chip_id == CHIP_ID_EM28174 ||
>             dev->chip_id == CHIP_ID_EM28178) {
>                 /* The Transport Stream Enable Register moved in em2874 */
> +               if (dev->dvb_xfer_bulk) {
> +                       /* Max Tx Size = 188 * 256 = 48128 - LCM(188,512) * 2 */
> +                       em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
> +                                       EM2874_R5D_TS1_PKT_SIZE :
> +                                       EM2874_R5E_TS2_PKT_SIZE,
> +                                       0xFF);
> +               } else {
> +                       /* TS2 Maximum Transfer Size = 188 * 5 */
> +                       em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
> +                                       EM2874_R5D_TS1_PKT_SIZE :
> +                                       EM2874_R5E_TS2_PKT_SIZE, 0x05);
> +               }
>                 if (dev->ts == PRIMARY_TS)
>                         rc = em28xx_write_reg_bits(dev,
>                                 EM2874_R5F_TS_ENABLE,
> --
> 2.7.4
>
