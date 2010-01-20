Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46249 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0ATDXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 22:23:37 -0500
MIME-Version: 1.0
In-Reply-To: <4B56685E.9060909@gmail.com>
References: <4B56685E.9060909@gmail.com>
Date: Tue, 19 Jan 2010 22:23:36 -0500
Message-ID: <829197381001191923i5d4e74belabaf6a7d9cbf7988@mail.gmail.com>
Subject: Re: [PATCH] mxl5005s: bad checks of state->Mode
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 19, 2010 at 9:20 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> Regardless of the state->Mode in both cases the same value was
> written.
> If state->Mode wasn't set, it is always 0.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/media/common/tuners/mxl5005s.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> Or were the ones and zeroes in these MXL_ControlWrite in the wrong place?
>
> diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
> index 605e28b..3967412 100644
> --- a/drivers/media/common/tuners/mxl5005s.c
> +++ b/drivers/media/common/tuners/mxl5005s.c
> @@ -1815,9 +1815,8 @@ static u16 MXL_BlockInit(struct dvb_frontend *fe)
>
>        /* Charge Pump Control Dig  Ana */
>        status += MXL_ControlWrite(fe, RFSYN_CHP_GAIN, state->Mode ? 5 : 8);
> -       status += MXL_ControlWrite(fe,
> -               RFSYN_EN_CHP_HIGAIN, state->Mode ? 1 : 1);
> -       status += MXL_ControlWrite(fe, EN_CHP_LIN_B, state->Mode ? 0 : 0);
> +       status += MXL_ControlWrite(fe, RFSYN_EN_CHP_HIGAIN, 1);
> +       status += MXL_ControlWrite(fe, EN_CHP_LIN_B, 0);
>
>        /* AGC TOP Control */
>        if (state->AGC_Mode == 0) /* Dual AGC */ {
> @@ -2161,7 +2160,7 @@ static u16 MXL_IFSynthInit(struct dvb_frontend *fe)
>                }
>        }
>
> -       if (state->Mode || (state->Mode == 0 && state->IF_Mode == 0)) {
> +       if (state->Mode || state->IF_Mode == 0) {
>                if (state->IF_LO == 57000000UL) {
>                        status += MXL_ControlWrite(fe, IF_DIVVAL,   0x10);
>                        status += MXL_ControlWrite(fe, IF_VCO_BIAS, 0x08);

Roel,

Thanks for pointing this out.

This patch should not be applied.

While I agree with Roel's assessment that the logic is incorrect,
removing the conditional logic and forcing the register writes to the
given value is almost certainly the incorrect fix.  I will have to
look at the datasheet and see what the logic is actually supposed to
be.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
