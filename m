Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:41285 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab2FVOK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 10:10:57 -0400
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: Zhu Sha Zang <zhushazang@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 22 Jun 2012 15:10:44 +0100
Subject: RE: DiBcom adapter problems
Message-ID: <C73E570AC040D442A4DD326F39F0F00E138E9533F9@SAPHIR.xi-lite.lan>
References: <4FDDE29B.9040500@gmail.com>
 <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>,<4FE31AB1.7020706@gmail.com>
 <C73E570AC040D442A4DD326F39F0F00E138E9533EE@SAPHIR.xi-lite.lan>,<4FE461E8.60101@gmail.com>
In-Reply-To: <4FE461E8.60101@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You need to get the source code of your kernel, apply the path and recompile the kernel. There is another solution by compiling the module externally (http://git.linuxtv.org/media_build.git). You will also need to patch it.

regards,
Olivier
________________________________________
From: Zhu Sha Zang [zhushazang@gmail.com]
Sent: Friday, June 22, 2012 2:15 PM
To: linux-media@vger.kernel.org
Cc: Olivier GRENIE
Subject: Re: DiBcom adapter problems

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

