Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41074 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 16:49:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1820000wgb.1
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 13:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349469857-21396-1-git-send-email-crope@iki.fi>
References: <1349469857-21396-1-git-send-email-crope@iki.fi>
Date: Fri, 5 Oct 2012 16:49:51 -0400
Message-ID: <CAOcJUby_4x_bqOE_YGLPQR7FfDXGidt+r-QVqKe14eAypzcGuQ@mail.gmail.com>
Subject: Re: [PATCH] mxl111sf: revert patch: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 5, 2012 at 4:44 PM, Antti Palosaari <crope@iki.fi> wrote:
> This reverts commits:
> 3fd7e4341e04f80e2605f56bbd8cb1e8b027901a
> [media] mxl111sf: remove an unused variable
> 3be5bb71fbf18f83cb88b54a62a78e03e5a4f30a
> [media] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
>
> ...as bug behind these is fixed by the DVB USB v2.
>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index efdcb15..fcfe124 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -343,6 +343,7 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>         struct mxl111sf_state *state = fe_to_priv(fe);
>         struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
>         int ret = 0;
> +       u8 tmp;
>
>         deb_info("%s(%d)\n", __func__, onoff);
>
> @@ -353,13 +354,15 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>                                               adap_state->ep6_clockphase,
>                                               0, 0);
>                 mxl_fail(ret);
> -#if 0
>         } else {
>                 ret = mxl111sf_disable_656_port(state);
>                 mxl_fail(ret);
> -#endif
>         }
>
> +       mxl111sf_read_reg(state, 0x12, &tmp);
> +       tmp &= ~0x04;
> +       mxl111sf_write_reg(state, 0x12, tmp);
> +
>         return ret;
>  }
>


I disabled that code on purpose - its redundant.  please do not apply
this patch.

-Mike
