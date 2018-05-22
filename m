Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:45552 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbeEVRSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 13:18:17 -0400
Received: by mail-ua0-f193.google.com with SMTP id j5-v6so12812190uak.12
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 10:18:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180522170922.GA30834@embeddedor.com>
References: <20180522170922.GA30834@embeddedor.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 22 May 2018 13:18:15 -0400
Message-ID: <CAGoCfizfW1qqDFTbrCM4HaRQBP3esLiiSxNGBongRxamSvpMZA@mail.gmail.com>
Subject: Re: [PATCH] au8522: remove duplicate code
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

Devin

On Tue, May 22, 2018 at 1:09 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> This code has been there for nine years now, and it has been
> working "good enough" since then [1].
>
> Remove duplicate code by getting rid of the if-else statement.
>
> [1] https://marc.info/?l=linux-kernel&m=152693550225081&w=2
>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/media/dvb-frontends/au8522_decoder.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
> index 343dc92..f285096 100644
> --- a/drivers/media/dvb-frontends/au8522_decoder.c
> +++ b/drivers/media/dvb-frontends/au8522_decoder.c
> @@ -280,14 +280,12 @@ static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
>                         AU8522_TOREGAAGC_REG0E5H_CVBS);
>         au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
>
> -       if (is_svideo) {
> -               /* Despite what the table says, for the HVR-950q we still need
> -                  to be in CVBS mode for the S-Video input (reason unknown). */
> -               /* filter_coef_type = 3; */
> -               filter_coef_type = 5;
> -       } else {
> -               filter_coef_type = 5;
> -       }
> +       /*
> +        * Despite what the table says, for the HVR-950q we still need
> +        * to be in CVBS mode for the S-Video input (reason unknown).
> +        */
> +       /* filter_coef_type = 3; */
> +       filter_coef_type = 5;
>
>         /* Load the Video Decoder Filter Coefficients */
>         for (i = 0; i < NUM_FILTER_COEF; i++) {
> --
> 2.7.4
>



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
