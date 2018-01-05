Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:44927 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEAXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:23:13 -0500
Received: by mail-qk0-f196.google.com with SMTP id v188so4099552qkh.11
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 16:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515110659-20145-4-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc> <1515110659-20145-4-git-send-email-brad@nextdimension.cc>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 4 Jan 2018 19:23:12 -0500
Message-ID: <CAOcJUbyBXOxpvMoH0Z2b7bunARC-0Jy5xwyqHsG_Q+LvKwjGgQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] em28xx: USB bulk packet size fix
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
> Hauppauge em28xx bulk devices exhibit continuity errors and corrupted
> packets, when run in VMWare virtual machines. Unknown if other
> manufacturers bulk models exhibit the same issue. KVM/Qemu is unaffected.
>
> According to documentation the maximum packet multiplier for em28xx in bulk
> transfer mode is 256 * 188 bytes. This changes the size of bulk transfers
> to maximum supported value and have a bonus beneficial alignment.
>
> Before:
> # 512 * 384 = 196608
> ## 196608 % 188 != 0
>
> After:
> # 512 * 47 * 2 = 48128    (188 * 128 * 2)
> ## 48128 % 188 = 0
>
> This sets up USB to expect just as many bytes as the em28xx is set to emit.
>
> Successful usage under load afterwards natively and in both VMWare
> and KVM/Qemu virtual machines.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>

:+1

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

> ---
>  drivers/media/usb/em28xx/em28xx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index c85292c..7be8ac9 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -191,7 +191,7 @@
>     USB 2.0 spec says bulk packet size is always 512 bytes
>   */
>  #define EM28XX_BULK_PACKET_MULTIPLIER 384
> -#define EM28XX_DVB_BULK_PACKET_MULTIPLIER 384
> +#define EM28XX_DVB_BULK_PACKET_MULTIPLIER 94
>
>  #define EM28XX_INTERLACED_DEFAULT 1
>
> --
> 2.7.4
>
