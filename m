Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34220 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752634AbdLMMMe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 07:12:34 -0500
Date: Wed, 13 Dec 2017 10:12:28 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: dgopstein@nyu.edu
Cc: linux-media@vger.kernel.org, baruch@tkos.co.il
Subject: Re: [PATCH v2] media: ABS macro parameter parenthesization
Message-ID: <20171213101228.56b9ba62@vento.lan>
In-Reply-To: <1510930544-2177-1-git-send-email-dgopstein@nyu.edu>
References: <1510930544-2177-1-git-send-email-dgopstein@nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Nov 2017 09:55:44 -0500
dgopstein@nyu.edu escreveu:

> From: Dan Gopstein <dgopstein@nyu.edu>
> 
> Two definitions of the ABS (absolute value) macro fail to parenthesize
> their parameter properly. This can lead to a bad expansion for
> low-precedence expression arguments. Add parens to protect against
> troublesome arguments.
> 
> For example: ABS(1-2) currently expands to ((1-2) < 0 ? (-1-2) : (1-2))
> which evaluates to -3. But the correct expansion would be
> ((1-2) < 0 ? -(1-2) : (1-2)) which evaluates to 1.
> 
> Signed-off-by: Dan Gopstein <dgopstein@nyu.edu>
> ---
> v1->v2:
> * unmangled the patch
> * added example to commit text
> 
>  drivers/media/dvb-frontends/dibx000_common.h | 2 +-
>  drivers/media/dvb-frontends/mb86a16.c        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
> index 8784af9..ae60f5d 100644
> --- a/drivers/media/dvb-frontends/dibx000_common.h
> +++ b/drivers/media/dvb-frontends/dibx000_common.h
> @@ -223,7 +223,7 @@ struct dvb_frontend_parametersContext {
>  
>  #define FE_CALLBACK_TIME_NEVER 0xffffffff
>  
> -#define ABS(x) ((x < 0) ? (-x) : (x))
> +#define ABS(x) (((x) < 0) ? -(x) : (x))
>  
>  #define DATA_BUS_ACCESS_MODE_8BIT                 0x01
>  #define DATA_BUS_ACCESS_MODE_16BIT                0x02
> diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
> index dfe322e..2d921c7 100644
> --- a/drivers/media/dvb-frontends/mb86a16.c
> +++ b/drivers/media/dvb-frontends/mb86a16.c
> @@ -31,7 +31,7 @@
>  static unsigned int verbose = 5;
>  module_param(verbose, int, 0644);
>  
> -#define ABS(x)		((x) < 0 ? (-x) : (x))
> +#define ABS(x)		((x) < 0 ? -(x) : (x))
>  
>  struct mb86a16_state {
>  	struct i2c_adapter		*i2c_adap;

Actually, the Kernel has already a macro for that, called abs().

So, the better would be to just remove those macros,
replacing ABS(foo) by abs(foo).

Thanks,
Mauro
