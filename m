Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43759 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0I2MaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 08:30:06 -0400
Received: by eyb6 with SMTP id 6so173871eyb.19
        for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 05:30:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928154700.59362453@pedra>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154700.59362453@pedra>
Date: Wed, 29 Sep 2010 08:30:04 -0400
Message-ID: <AANLkTi=XyF3E+sqoDVOa2sZtuBsT66btphYWg7Fdioe7@mail.gmail.com>
Subject: Re: [PATCH 09/10] V4L/DVB: tda18271: Add debug message with frequency divisor
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 28, 2010 at 2:47 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
> index 195b30e..7ba3ba3 100644
> --- a/drivers/media/common/tuners/tda18271-common.c
> +++ b/drivers/media/common/tuners/tda18271-common.c
> @@ -549,6 +549,13 @@ int tda18271_calc_main_pll(struct dvb_frontend *fe, u32 freq)
>        regs[R_MD1]   = 0x7f & (div >> 16);
>        regs[R_MD2]   = 0xff & (div >> 8);
>        regs[R_MD3]   = 0xff & div;
> +
> +       if (tda18271_debug & DBG_REG) {
> +               tda_reg("MAIN_DIV_BYTE_1    = 0x%02x\n", 0xff & regs[R_MD1]);
> +               tda_reg("MAIN_DIV_BYTE_2    = 0x%02x\n", 0xff & regs[R_MD2]);
> +               tda_reg("MAIN_DIV_BYTE_3    = 0x%02x\n", 0xff & regs[R_MD3]);
> +       }
> +
>  fail:
>        return ret;
>  }
> --
> 1.7.1
>
>
>

Adding the maintainer for the 18271 driver to the CC.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
