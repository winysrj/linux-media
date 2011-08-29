Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm10-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.170]:43904 "HELO
	nm10-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754293Ab1H2Q51 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 12:57:27 -0400
Message-ID: <1314637046.40286.YahooMailClassic@web121807.mail.ne1.yahoo.com>
Date: Mon, 29 Aug 2011 09:57:26 -0700 (PDT)
From: Luiz Ramos <lramos.prof@yahoo.com.br>
Subject: Re: [git:v4l-dvb/for_v3.2] [media] Fix wrong register mask in gspca/sonixj.c
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: =?iso-8859-1?Q?Jean-Fran=E7ois_Moine?= <moinejf@free.fr>
In-Reply-To: <E1QxHW0-0002rG-Ur@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro:

To be fair, this patch itself isn't sufficient to solve the problem described in the text provided. One other patch is necessary to get this goal accomplished, named, one published in this same thread in 2011-07-18.

This later fix is now embedded in a wider patch provided by Jean-François Moine in 2011-08-10.

I'd suggest to change the text below, if possible, mentioning only something like "fix wrong register masking".

Thanks,

Luiz


--- Em dom, 7/8/11, Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> De: Mauro Carvalho Chehab <mchehab@redhat.com>
> Assunto: [git:v4l-dvb/for_v3.2] [media] Fix wrong register mask in gspca/sonixj.c
> Para: linuxtv-commits@linuxtv.org
> Cc: "Jean-François Moine" <moinejf@free.fr>, "Luiz Carlos Ramos" <lramos.prof@yahoo.com.br>
> Data: Domingo, 7 de Agosto de 2011, 9:03
> This is an automatic generated email
> to let you know that the following patch were queued at the
> 
> http://git.linuxtv.org/media_tree.git
> tree:
> 
> Subject: [media] Fix wrong register mask in gspca/sonixj.c
> Author:  Luiz Ramos <luizzramos@yahoo.com.br>
> Date:    Thu Jul 14 23:08:39 2011 -0300
> 
> Hello,
> 
> When migrating from Slackware 13.1 to 13.37 (kernel
> 2.6.33.x to
> 2.6.37.6), there was some sort of regression with the
> external webcam
> installed at the notebook (0x45:6128, SN9C325+OM6802).
> 
> In the version 2.6.37.6, the images got *very* dark, making
> the webcam
> almost unusable, unless if used with direct sunlight.
> 
> Tracing back what happened, I concluded that changeset
> 0e4d413af
> caused some sort of odd effects - including this - to this
> specific model.
> 
> Signed-off-by: Luiz Carlos Ramos <lramos.prof@yahoo.com.br>
> Acked-by: Jean-François Moine <moinejf@free.fr>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/gspca/sonixj.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d1520c58eb84ad1ec973a257cd835c948215aab5
> 
> diff --git a/drivers/media/video/gspca/sonixj.c
> b/drivers/media/video/gspca/sonixj.c
> index 81b8a60..2ad757d 100644
> --- a/drivers/media/video/gspca/sonixj.c
> +++ b/drivers/media/video/gspca/sonixj.c
> @@ -2386,7 +2386,7 @@ static int sd_start(struct gspca_dev
> *gspca_dev)
>          reg_w1(gspca_dev,
> 0x01, 0x22);
>          msleep(100);
>          reg01 = SCL_SEL_OD |
> S_PDN_INV;
> -        reg17 &=
> MCK_SIZE_MASK;
> +        reg17 &=
> ~MCK_SIZE_MASK;
>          reg17 |=
> 0x04;        /* clock / 4 */
>          break;
>      }
> 
