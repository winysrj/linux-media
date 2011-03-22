Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1CVVAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 17:00:10 -0400
Received: by wya21 with SMTP id 21so7109117wya.19
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 14:00:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300800137-9142-1-git-send-email-bjorn@mork.no>
References: <1300800137-9142-1-git-send-email-bjorn@mork.no>
Date: Wed, 23 Mar 2011 02:30:08 +0530
Message-ID: <AANLkTikaCFU0b7Lo3DLRaENTDx085DBybxvEirzB11Ph@mail.gmail.com>
Subject: Re: [PATCH] [media] mantis: trivial module parameter documentation fix
From: Manu Abraham <abraham.manu@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/22 Bjørn Mork <bjorn@mork.no>:
> The default for "verbose" is 0.  Update description to match.
>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/media/dvb/mantis/hopper_cards.c |    2 +-
>  drivers/media/dvb/mantis/mantis_cards.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
> index 70e73af..1402062 100644
> --- a/drivers/media/dvb/mantis/hopper_cards.c
> +++ b/drivers/media/dvb/mantis/hopper_cards.c
> @@ -44,7 +44,7 @@
>
>  static unsigned int verbose;
>  module_param(verbose, int, 0644);
> -MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
> +MODULE_PARM_DESC(verbose, "verbose startup messages, default is 0 (no)");
>
>  #define DRIVER_NAME    "Hopper"
>
> diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
> index 40da225..05cbb9d 100644
> --- a/drivers/media/dvb/mantis/mantis_cards.c
> +++ b/drivers/media/dvb/mantis/mantis_cards.c
> @@ -52,7 +52,7 @@
>
>  static unsigned int verbose;
>  module_param(verbose, int, 0644);
> -MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
> +MODULE_PARM_DESC(verbose, "verbose startup messages, default is 0 (no)");
>
>  static int devs;
>
> --
> 1.7.2.5
>
> --

Thanks.

Acked-by: Manu Abraham <manu@linuxtv.org>
