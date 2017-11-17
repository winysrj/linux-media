Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55696 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932915AbdKQEme (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 23:42:34 -0500
Date: Fri, 17 Nov 2017 06:42:29 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Dan Gopstein <dgopstein@nyu.edu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] media: ABS macro parameter parenthesization
Message-ID: <20171117044229.qxhllojkghxcgd7i@tarshish>
References: <CAAqN1Z6YN2y3kvKu+SOsSh8EozY1+J_k3XHnH9F0F5z8bB402g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAqN1Z6YN2y3kvKu+SOsSh8EozY1+J_k3XHnH9F0F5z8bB402g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Thu, Nov 16, 2017 at 06:09:20PM -0500, Dan Gopstein wrote:
> From: Dan Gopstein <dgopstein@nyu.edu>
> 
> Two definitions of the ABS (absolute value) macro fail to parenthesize their
> parameter properly. This can lead to a bad expansion for low-precedence
> expression arguments. Add parens to protect against troublesome arguments.
> 
> Signed-off-by: Dan Gopstein <dgopstein@nyu.edu>
> ---
> See an example bad usage in
> drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
> on line 1204:
> 
> ABS(prev_swp_freq[j] - swp_freq)
>
> For example: ABS(1-2) currently expands to ((1-2) < 0 ? (-1-2) : (1-2)) which
> evaluates to -3. But the correct expansion would be ((1-2) < 0 ? -(1-2) : (1-2))
> which evaluates to 1.

This example would be nice to have in the commit log.

> I found this issue as part of the "Atoms of Confusion" research at NYU's Secure
> Systems Lab. As the work continues, hopefully we'll be able to find more issues
> like this one.
> 
> diff --git a/drivers/media/dvb-frontends/dibx000_common.h
> b/drivers/media/dvb-frontends/dibx000_common.h

Unfortunately, your email client (gmail?) mangled the patch by splitting lines 
like the above. So 'git am', or the 'patch' utility can't apply your patch as 
is.

I suggest you to use 'git send-email' to send patches. You can find gmail 
specific setup instructions in the git-send-email man page[1] under EXAMPLE.

[1] https://git-scm.com/docs/git-send-email

baruch

> index 8784af9..ae60f5d 100644
> --- a/drivers/media/dvb-frontends/dibx000_common.h
> +++ b/drivers/media/dvb-frontends/dibx000_common.h
> @@ -223,7 +223,7 @@ struct dvb_frontend_parametersContext {
> 
> #define FE_CALLBACK_TIME_NEVER 0xffffffff
> 
> -#define ABS(x) ((x < 0) ? (-x) : (x))
> +#define ABS(x) (((x) < 0) ? -(x) : (x))
> 
> #define DATA_BUS_ACCESS_MODE_8BIT                 0x01
> #define DATA_BUS_ACCESS_MODE_16BIT                0x02
> diff --git a/drivers/media/dvb-frontends/mb86a16.c
> b/drivers/media/dvb-frontends/mb86a16.c
> index dfe322e..2d921c7 100644
> --- a/drivers/media/dvb-frontends/mb86a16.c
> +++ b/drivers/media/dvb-frontends/mb86a16.c
> @@ -31,7 +31,7 @@
> static unsigned int verbose = 5;
> module_param(verbose, int, 0644);
> 
> -#define ABS(x)         ((x) < 0 ? (-x) : (x))
> +#define ABS(x)         ((x) < 0 ? -(x) : (x))
> 
> struct mb86a16_state {
>         struct i2c_adapter              *i2c_adap;

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
