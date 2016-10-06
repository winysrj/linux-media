Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:36198 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcJFR2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 13:28:18 -0400
Received: by mail-ua0-f175.google.com with SMTP id r64so24008238uar.3
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2016 10:28:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161005155805.27dc4d33@vento.lan>
References: <20161005155805.27dc4d33@vento.lan>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 6 Oct 2016 10:27:56 -0700
Message-ID: <CALCETrVg5FczwRaJuRe6G_FxX7yDsPS-L4JnR475UW4TwQWWzg@mail.gmail.com>
Subject: Re: Fw: [PATCH v2] cinergyT2-core: don't do DMA on stack
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        <"Subject:Re:Problem"@s-opensource.com>, with@s-opensource.com,
        VMAP_STACK=y@s-opensource.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 5, 2016 at 11:58 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Sorry, forgot to C/C people that are at the "Re: Problem with VMAP_STACK=y"
> thread.
>
> Forwarded message:
>
> Date: Wed,  5 Oct 2016 15:54:18 -0300
> From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Mauro Carvalho Chehab <mchehab@kernel.org>
> Subject: [PATCH v2] cinergyT2-core: don't do DMA on stack
>
>
> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>
> Added the fixups made by Johannes Stezenbach
>
>  drivers/media/usb/dvb-usb/cinergyT2-core.c | 45 ++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> index 9fd1527494eb..8267e3777af6 100644
> --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
> +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
> @@ -41,6 +41,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
>  struct cinergyt2_state {
>         u8 rc_counter;
> +       unsigned char data[64];
>  };
>
>  /* We are missing a release hook with usb_device data */
> @@ -50,29 +51,36 @@ static struct dvb_usb_device_properties cinergyt2_properties;
>
>  static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int enable)
>  {
> -       char buf[] = { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0 };
> -       char result[64];
> -       return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
> -                               sizeof(result), 0);
> +       struct dvb_usb_device *d = adap->dev;
> +       struct cinergyt2_state *st = d->priv;
> +
> +       st->data[0] = CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
> +       st->data[1] = enable ? 1 : 0;
> +
> +       return dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
>  }
>
>  static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
>  {

This...

> -       char buf[] = { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
> -       char state[3];
> -       return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(state), 0);
> +       struct cinergyt2_state *st = d->priv;
> +
> +       st->data[0] = CINERGYT2_EP1_SLEEP_MODE;

...does not match this:

> +       st->data[1] = enable ? 1 : 0;

--Andy
