Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab2CKNu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 09:50:27 -0400
Message-ID: <4F5CAD9A.5090000@redhat.com>
Date: Sun, 11 Mar 2012 10:50:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Regel <andreas.regel@gmx.de>
CC: abraham.manu@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] stv090x: Fix typo in register macros
References: <4F4BEAAB.3000603@gmx.de>
In-Reply-To: <4F4BEAAB.3000603@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-02-2012 17:42, Andreas Regel escreveu:
> Fix typo in register macros of ERRCNT2.

Patch is line-wrapped:

patch -p1 -i patches/lmml_10078_1_3_stv090x_fix_typo_in_register_macros.patch --dry-run -t -N
patching file drivers/media/dvb/frontends/stv090x.c
patch: **** malformed patch at line 33: *fe, u32 *per)

Patch may be line wrapped
patching file drivers/media/dvb/frontends/stv090x.c
Hunk #1 FAILED at 3526.
patch: **** malformed patch at line 34:  

But, even fixing it, it still doesn't apply:

patch -p1 -i patches/lmml_10078_1_3_stv090x_fix_typo_in_register_macros.patch --dry-run -t -N
patching file drivers/media/dvb/frontends/stv090x.c
Hunk #1 FAILED at 3526.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/dvb/frontends/stv090x.c.rej
patching file drivers/media/dvb/frontends/stv090x_reg.h
Hunk #1 FAILED at 2232.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/dvb/frontends/stv090x_reg.h.rej


> 
> Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
> ---
>  drivers/media/dvb/frontends/stv090x.c     |    2 +-
>  drivers/media/dvb/frontends/stv090x_reg.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
> index 4aef187..6c3c095 100644
> --- a/drivers/media/dvb/frontends/stv090x.c
> +++ b/drivers/media/dvb/frontends/stv090x.c
> @@ -3526,7 +3526,7 @@ static int stv090x_read_per(struct dvb_frontend *fe, u32 *per)
>      } else {
>          /* Counter 2 */
>          reg = STV090x_READ_DEMOD(state, ERRCNT22);
> -        h = STV090x_GETFIELD_Px(reg, ERR_CNT2_FIELD);
> +        h = STV090x_GETFIELD_Px(reg, ERR_CNT22_FIELD);
>           reg = STV090x_READ_DEMOD(state, ERRCNT21);
>          m = STV090x_GETFIELD_Px(reg, ERR_CNT21_FIELD);
> diff --git a/drivers/media/dvb/frontends/stv090x_reg.h b/drivers/media/dvb/frontends/stv090x_reg.h
> index 93741ee..26c8885 100644
> --- a/drivers/media/dvb/frontends/stv090x_reg.h
> +++ b/drivers/media/dvb/frontends/stv090x_reg.h
> @@ -2232,8 +2232,8 @@
>  #define STV090x_P2_ERRCNT22                STV090x_Px_ERRCNT22(2)
>  #define STV090x_OFFST_Px_ERRCNT2_OLDVALUE_FIELD        7
>  #define STV090x_WIDTH_Px_ERRCNT2_OLDVALUE_FIELD        1
> -#define STV090x_OFFST_Px_ERR_CNT2_FIELD            0
> -#define STV090x_WIDTH_Px_ERR_CNT2_FIELD            7
> +#define STV090x_OFFST_Px_ERR_CNT22_FIELD        0
> +#define STV090x_WIDTH_Px_ERR_CNT22_FIELD        7
>   #define STV090x_Px_ERRCNT21(__x)            (0xF59E - (__x - 1) * 0x200)
>  #define STV090x_P1_ERRCNT21                STV090x_Px_ERRCNT21(1)

