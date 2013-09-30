Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55870 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3I3PNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 11:13:18 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so5668592pbb.20
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 08:13:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52480506.6090706@seznam.cz>
References: <524804B3.9090505@seznam.cz>
	<524804DB.7020108@seznam.cz>
	<52480506.6090706@seznam.cz>
Date: Mon, 30 Sep 2013 11:13:18 -0400
Message-ID: <CAOcJUbzMeKOB4K9o5962uAUmXxPeBUdVNKTqEeCRnG56BeAq1g@mail.gmail.com>
Subject: Re: Subject: [PATCH 2/2] [media] r820t: simplify divisor calculation
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

It's difficult to understand a patch like this, let alone merging it,
without any kind of explanation.  At a quick glance, the patch looks
wrong.  If you believe the patch is correct, then please resubmit with
some sort of description and explanation for the change.

Best regards,

Mike Krufky

On Sun, Sep 29, 2013 at 6:46 AM, Jiří Pinkava <j-pi@seznam.cz> wrote:
>
> ---
>  drivers/media/tuners/r820t.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
> index e25c720..36dc63e 100644
> --- a/drivers/media/tuners/r820t.c
> +++ b/drivers/media/tuners/r820t.c
> @@ -596,13 +596,9 @@ static int r820t_set_pll(struct r820t_priv *priv,
> enum v4l2_tuner_type type,
>         while (mix_div <= 64) {
>                 if (((freq * mix_div) >= vco_min) &&
>                    ((freq * mix_div) < vco_max)) {
> -                       div_buf = mix_div;
> -                       while (div_buf > 2) {
> -                               div_buf = div_buf >> 1;
> -                               div_num++;
> -                       }
>                         break;
>                 }
> +               ++div_num;
>                 mix_div = mix_div << 1;
>         }
>
> --
> 1.8.3.2
>
>
