Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50078 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3I3PHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 11:07:46 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so6043045pad.9
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 08:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524804DB.7020108@seznam.cz>
References: <524804B3.9090505@seznam.cz>
	<524804DB.7020108@seznam.cz>
Date: Mon, 30 Sep 2013 11:07:46 -0400
Message-ID: <CAOcJUbyVx=fqHwVeM9K3SKUTk3g7vNqsWf0xokX5nO_DdQenYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] r820t: fix nint range check
From: Michael Krufky <mkrufky@linuxtv.org>
To: =?UTF-8?B?SmnFmcOtIFBpbmthdmE=?= <j-pi@seznam.cz>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jiří,

Do you have any documentation that supports this value change?
Changing this value affects the algorithm, and we'd be happier making
this change if the patch included some better description and perhaps
a reference explaining why the new value is correct.

Regards,

Mike Krufky

On Sun, Sep 29, 2013 at 6:45 AM, Jiří Pinkava <j-pi@seznam.cz> wrote:
>
>
> Use full range of VCO parameters, fixes tunning for some frequencies.
> ---
>  drivers/media/tuners/r820t.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
> index 1c23666..e25c720 100644
> --- a/drivers/media/tuners/r820t.c
> +++ b/drivers/media/tuners/r820t.c
> @@ -637,7 +637,7 @@ static int r820t_set_pll(struct r820t_priv *priv,
> enum v4l2_tuner_type type,
>                 vco_fra = pll_ref * 129 / 128;
>         }
>
> -       if (nint > 63) {
> +       if (nint > 76) {
>                 tuner_info("No valid PLL values for %u kHz!\n", freq);
>                 return -EINVAL;
>         }
> --
> 1.8.3.2
>
>
