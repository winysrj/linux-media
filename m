Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40092 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0I3TDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 15:03:09 -0400
Received: by bwz11 with SMTP id 11so1658026bwz.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 12:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928154700.59362453@pedra>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154700.59362453@pedra>
Date: Thu, 30 Sep 2010 15:03:07 -0400
Message-ID: <AANLkTi=8xbFTz5edMjJRXGD7UD6j4jzyOJibgZomKCCB@mail.gmail.com>
Subject: Re: [PATCH 09/10] V4L/DVB: tda18271: Add debug message with frequency divisor
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
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


I would actually prefer NOT to merge this - it is redundant.  When
DBG_REG is enabled, the driver will dump the contents of all
registers, including MD1, MD2 and MD3.  With this patch applied, it
would dump this data twice.  I do not believe this is useful at all.

Regards,

Mike Krufky
