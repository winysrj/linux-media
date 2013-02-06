Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33946 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BFVBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 16:01:42 -0500
Received: by mail-vc0-f180.google.com with SMTP id fo13so1136596vcb.25
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 13:01:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx4niA+UPaWf=sJCOj61iBTdtT7D0aqc7hvWFi-5biD3kg@mail.gmail.com>
References: <CAKdnbx4niA+UPaWf=sJCOj61iBTdtT7D0aqc7hvWFi-5biD3kg@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 6 Feb 2013 21:54:10 +0100
Message-ID: <CAKdnbx7jcroo-u7Z66nsn57a4L6MKcb9AgD0VYMeZSc2aVDz7Q@mail.gmail.com>
Subject: Re: [PATCH] media_build update IS_ENABLED macro
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry ignore my patch.. it's broken

Regards Eddi

On Wed, Feb 6, 2013 at 9:48 PM, Eddi De Pieri <eddi@depieri.net> wrote:
> Fix media_build by updating IS_ENABLED macro
>
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
>
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 8ef90aa..fd0d139 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -1102,7 +1102,7 @@ static inline void i2c_unlock_adapter(struct
> i2c_adapter *adapter)
>  #define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
>  #define ___config_enabled(__ignored, val, ...) val
>  #define IS_ENABLED(option) \
> -               (config_enabled(option) || config_enabled(option##_MODULE))
> +               (defined(__enabled_ ## option) || defined(__enabled_
> ## option ## _MODULE))
>  #endif
>
>  #ifdef NEED_USB_TRANSLATE_ERRORS
