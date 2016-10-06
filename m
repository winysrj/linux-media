Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35353 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcJFIaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 04:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <20161005155532.682258e2@vento.lan>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
 <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm> <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
 <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm> <20161005093417.6e82bd97@vdr>
 <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm> <20161005060450.1b0f2152@vento.lan>
 <20161005182945.nkpphvd6wtk6kq7h@linuxtv.org> <20161005155532.682258e2@vento.lan>
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Thu, 6 Oct 2016 10:30:15 +0200
Message-ID: <CADDKRnCV7YhD5ErkvWSL8P3adymCLqzp5OePYmGp0L=9Dt_=UA@mail.gmail.com>
Subject: Re: Problem with VMAP_STACK=y
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
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

2016-10-05 20:55 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>=
:
> Hi Johannes,
>
> Em Wed, 5 Oct 2016 20:29:45 +0200
> Johannes Stezenbach <js@linuxtv.org> escreveu:
>
>> On Wed, Oct 05, 2016 at 06:04:50AM -0300, Mauro Carvalho Chehab wrote:
>> >  static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
>> >  {
>> > -   char query[] =3D { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
>> > -   char state[3];
>> > +   struct dvb_usb_device *d =3D adap->dev;
>> > +   struct cinergyt2_state *st =3D d->priv;
>> >     int ret;
>> >
>> >     adap->fe_adap[0].fe =3D cinergyt2_fe_attach(adap->dev);
>> >
>> > -   ret =3D dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
>> > -                           sizeof(state), 0);
>>
>> it seems to miss this:
>>
>>       st->data[0] =3D CINERGYT2_EP1_GET_FIRMWARE_VERSION;
>>
>> > +   ret =3D dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
>> >     if (ret < 0) {
>> >             deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
>> >                     "state info\n");
>> > @@ -141,13 +147,14 @@ static int repeatable_keys[] =3D {
>> >  static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, i=
nt *state)
>> >  {
>> >     struct cinergyt2_state *st =3D d->priv;
>> > -   u8 key[5] =3D {0, 0, 0, 0, 0}, cmd =3D CINERGYT2_EP1_GET_RC_EVENTS=
;
>> >     int i;
>> >
>> >     *state =3D REMOTE_NO_KEY_PRESSED;
>> >
>> > -   dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
>> > -   if (key[4] =3D=3D 0xff) {
>> > +   st->data[0] =3D CINERGYT2_EP1_SLEEP_MODE;
>>
>> should probably be
>>
>>       st->data[0] =3D CINERGYT2_EP1_GET_RC_EVENTS;
>>
>> > +
>> > +   dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
>>
>>
>> HTH,
>> Johannes
>
>
> Thanks for the review! Yeah, you're right: both firmware and remote
> controller logic would be broken without the above fixes.
>
> Just sent a version 2 of this patch to the ML with the above fixes.
>
> Regards,
> Mauro

Applied V2 of the patch. Unfortunately no progress.
No video, no error messages.

J=C3=B6rg
