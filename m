Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32946 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753582AbcJGNum (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 09:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20161006152905.2f9a9b13@vento.lan>
References: <20161005155805.27dc4d33@vento.lan> <CALCETrVg5FczwRaJuRe6G_FxX7yDsPS-L4JnR475UW4TwQWWzg@mail.gmail.com>
 <20161006152905.2f9a9b13@vento.lan>
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Fri, 7 Oct 2016 15:50:40 +0200
Message-ID: <CADDKRnAXgBNFy_csDEB5veA=XXPnu=jY_rTOEun7f-QNyzr4uQ@mail.gmail.com>
Subject: Re: [PATCH v2] cinergyT2-core: don't do DMA on stack
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-10-06 20:29 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>=
:
> Em Thu, 6 Oct 2016 10:27:56 -0700
> Andy Lutomirski <luto@amacapital.net> escreveu:
>
>> On Wed, Oct 5, 2016 at 11:58 AM, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>> > Sorry, forgot to C/C people that are at the "Re: Problem with VMAP_STA=
CK=3Dy"
>> > thread.
>> >
>> > Forwarded message:
>> >
>> > Date: Wed,  5 Oct 2016 15:54:18 -0300
>> > From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> > To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
>> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Mauro Carvalho C=
hehab <mchehab@infradead.org>, Mauro Carvalho Chehab <mchehab@kernel.org>
>> > Subject: [PATCH v2] cinergyT2-core: don't do DMA on stack
>> >
>> >
>> > The USB control messages require DMA to work. We cannot pass
>> > a stack-allocated buffer, as it is not warranted that the
>> > stack would be into a DMA enabled area.
>> >
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> > ---
>> >
>> > Added the fixups made by Johannes Stezenbach
>> >
>> >  drivers/media/usb/dvb-usb/cinergyT2-core.c | 45 ++++++++++++++++++---=
---------
>> >  1 file changed, 27 insertions(+), 18 deletions(-)
>> >
>> > diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/medi=
a/usb/dvb-usb/cinergyT2-core.c
>> > index 9fd1527494eb..8267e3777af6 100644
>> > --- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
>> > +++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
>> > @@ -41,6 +41,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>> >
>> >  struct cinergyt2_state {
>> >         u8 rc_counter;
>> > +       unsigned char data[64];
>> >  };
>> >
>> >  /* We are missing a release hook with usb_device data */
>> > @@ -50,29 +51,36 @@ static struct dvb_usb_device_properties cinergyt2_=
properties;
>> >
>> >  static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int=
 enable)
>> >  {
>> > -       char buf[] =3D { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable=
 ? 1 : 0 };
>> > -       char result[64];
>> > -       return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
>> > -                               sizeof(result), 0);
>> > +       struct dvb_usb_device *d =3D adap->dev;
>> > +       struct cinergyt2_state *st =3D d->priv;
>> > +
>> > +       st->data[0] =3D CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
>> > +       st->data[1] =3D enable ? 1 : 0;
>> > +
>> > +       return dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
>> >  }
>> >
>> >  static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
>> >  {
>>
>> This...
>>
>> > -       char buf[] =3D { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
>> > -       char state[3];
>> > -       return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(s=
tate), 0);
>> > +       struct cinergyt2_state *st =3D d->priv;
>> > +
>> > +       st->data[0] =3D CINERGYT2_EP1_SLEEP_MODE;
>>
>> ...does not match this:
>>
>> > +       st->data[1] =3D enable ? 1 : 0;
>>
>> --Andy
>
> Gah! Yes. This is what happens when coding using cut-and-paste ;)
>
> J=C3=B6rg,
>
> Please test it with the condition reversed with the enclosed patch.
>
> if this doesn't work, you can enable dvb-usb debug at runtime,
> by loading it with debug parameter:
>
> parm:           debug:set debugging level (1=3Dinfo,xfer=3D2,pll=3D4,ts=
=3D8,err=3D16,rc=3D32,fw=3D64,mem=3D128,uxfer=3D256  (or-able)). (debugging=
 is not enabled) (int)
>
> debug=3D2 should show the control messages sent to the device on dmesg.
>
> Regards,
> Mauro
>
>
> [PATCH] cinergyT2-core: don't do DMA on stack
>
> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/u=
sb/dvb-usb/cinergyT2-core.c
> index 9fd1527494eb..91640c927776 100644
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
> @@ -50,29 +51,36 @@ static struct dvb_usb_device_properties cinergyt2_pro=
perties;
>
>  static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int en=
able)
>  {
> -       char buf[] =3D { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? =
1 : 0 };
> -       char result[64];
> -       return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
> -                               sizeof(result), 0);
> +       struct dvb_usb_device *d =3D adap->dev;
> +       struct cinergyt2_state *st =3D d->priv;
> +
> +       st->data[0] =3D CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
> +       st->data[1] =3D enable ? 1 : 0;
> +
> +       return dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
>  }
>
>  static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
>  {
> -       char buf[] =3D { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
> -       char state[3];
> -       return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(stat=
e), 0);
> +       struct cinergyt2_state *st =3D d->priv;
> +
> +       st->data[0] =3D CINERGYT2_EP1_SLEEP_MODE;
> +       st->data[1] =3D enable ? 0 : 1;
> +
> +       return dvb_usb_generic_rw(d, st->data, 2, st->data, 3, 0);
>  }
>
>  static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
>  {
> -       char query[] =3D { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
> -       char state[3];
> +       struct dvb_usb_device *d =3D adap->dev;
> +       struct cinergyt2_state *st =3D d->priv;
>         int ret;
>
>         adap->fe_adap[0].fe =3D cinergyt2_fe_attach(adap->dev);
>
> -       ret =3D dvb_usb_generic_rw(adap->dev, query, sizeof(query), state=
,
> -                               sizeof(state), 0);
> +       st->data[0] =3D CINERGYT2_EP1_GET_FIRMWARE_VERSION;
> +
> +       ret =3D dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
>         if (ret < 0) {
>                 deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
>                         "state info\n");
> @@ -141,13 +149,14 @@ static int repeatable_keys[] =3D {
>  static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int =
*state)
>  {
>         struct cinergyt2_state *st =3D d->priv;
> -       u8 key[5] =3D {0, 0, 0, 0, 0}, cmd =3D CINERGYT2_EP1_GET_RC_EVENT=
S;
>         int i;
>
>         *state =3D REMOTE_NO_KEY_PRESSED;
>
> -       dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
> -       if (key[4] =3D=3D 0xff) {
> +       st->data[0] =3D CINERGYT2_EP1_GET_RC_EVENTS;
> +
> +       dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
> +       if (st->data[4] =3D=3D 0xff) {
>                 /* key repeat */
>                 st->rc_counter++;
>                 if (st->rc_counter > RC_REPEAT_DELAY) {
> @@ -166,13 +175,13 @@ static int cinergyt2_rc_query(struct dvb_usb_device=
 *d, u32 *event, int *state)
>         }
>
>         /* hack to pass checksum on the custom field */
> -       key[2] =3D ~key[1];
> -       dvb_usb_nec_rc_key_to_event(d, key, event, state);
> -       if (key[0] !=3D 0) {
> +       st->data[2] =3D ~st->data[1];
> +       dvb_usb_nec_rc_key_to_event(d, st->data, event, state);
> +       if (st->data[0] !=3D 0) {
>                 if (*event !=3D d->last_event)
>                         st->rc_counter =3D 0;
>
> -               deb_rc("key: %*ph\n", 5, key);
> +               deb_rc("key: %*ph\n", 5, st->data);
>         }
>         return 0;
>  }
>
>
>
> Thanks,
> Mauro

Patch works for me!
Thanks, J=C3=B6rg
