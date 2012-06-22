Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33600 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab2FVMPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:15:48 -0400
Received: by ghrr11 with SMTP id r11so1439108ghr.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 05:15:48 -0700 (PDT)
Message-ID: <4FE461E8.60101@gmail.com>
Date: Fri, 22 Jun 2012 09:15:36 -0300
From: Zhu Sha Zang <zhushazang@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Olivier GRENIE <olivier.grenie@parrot.com>
Subject: Re: DiBcom adapter problems
References: <4FDDE29B.9040500@gmail.com> <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>,<4FE31AB1.7020706@gmail.com> <C73E570AC040D442A4DD326F39F0F00E138E9533EE@SAPHIR.xi-lite.lan>
In-Reply-To: <C73E570AC040D442A4DD326F39F0F00E138E9533EE@SAPHIR.xi-lite.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Excuse me, dumb question, but where and how can i apply this patch?

Thanks again!

Em 21-06-2012 14:07, Olivier GRENIE escreveu:
> Hello,
> can you test the following patch.
>
> regards,
> Olivier
>
> From: Olivier Grenie <olivier.grenie@parrot.com>
> Date: Thu, 21 Jun 2012 18:57:14 +0200
> Subject: [PATCH] [media] dvb frontend core: tuning in ISDB-T using DVB API v3
>   The intend of this patch is to be able to tune ISDB-T using
>   the DVB API v3
>
> Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index aebcdf2..ee1cc10 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1531,6 +1531,13 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
>                                  delsys = desired_system;
>                                  break;
>                          }
> +
> +                       /* check if the fe delivery system corresponds
> +                          to the delivery system in cache */
> +                       if (fe->ops.delsys[ncaps] == c->delivery_system) {
> +                               delsys = c->delivery_system;
> +                               break;
> +                       }
>                          ncaps++;
>                  }
>                  if (delsys == SYS_UNDEFINED) {
>


-- 

---
Rodolfo Timóteo da Silva
Linux Counter: 359362
msn: zhushazang@gmail.com
skype: zhushazang

Ribeirão Preto - SP


