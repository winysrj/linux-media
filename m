Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:45966 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeAEAXr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:23:47 -0500
Received: by mail-qk0-f195.google.com with SMTP id o126so4107120qke.12
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 16:23:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515110659-20145-5-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc> <1515110659-20145-5-git-send-email-brad@nextdimension.cc>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 4 Jan 2018 19:23:46 -0500
Message-ID: <CAOcJUby+7wFNZTSffsmVNvDoB_nkjQi1A8m_ck7f+ac4+3x9RA@mail.gmail.com>
Subject: Re: [PATCH 4/9] em28xx: Increase max em28xx boards to max dvb adapters
To: Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
> Maximum 4 em28xx boards is too low, this can be maxed out by two devices.
> This allows all the dvb adapters in the system to be em28xx if so desired.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>

:+1

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

> ---
>  drivers/media/usb/em28xx/em28xx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 7be8ac9..3dbcc9d 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -166,7 +166,7 @@
>  #define EM28XX_STOP_AUDIO       0
>
>  /* maximum number of em28xx boards */
> -#define EM28XX_MAXBOARDS 4 /*FIXME: should be bigger */
> +#define EM28XX_MAXBOARDS DVB_MAX_ADAPTERS /* All adapters could be em28xx */
>
>  /* maximum number of frames that can be queued */
>  #define EM28XX_NUM_FRAMES 5
> --
> 2.7.4
>
