Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu-smtp-delivery-150.mimecast.com ([207.82.80.150]:59018 "EHLO
        eu-smtp-delivery-150.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751443AbdIKTzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 15:55:08 -0400
From: Simon Yuan <Simon.Yuan@navico.com>
To: "kieran.bingham@ideasonboard.com" <kieran.bingham@ideasonboard.com>
CC: =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: A patch for a bug in adv748x
Date: Mon, 11 Sep 2017 19:39:19 +0000
Message-ID: <4015601.NSiynKSO5y@siyuan>
References: <2665746.VTkvgi0PVy@siyuan>
 <30d192d5-adeb-e7b8-2e9c-7ce9a06eb525@ideasonboard.com>
In-Reply-To: <30d192d5-adeb-e7b8-2e9c-7ce9a06eb525@ideasonboard.com>
Content-Language: en-US
Content-ID: <B3F64C7221E43A46A77F526C7067B784@namprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 12 September 2017 07:00:33 NZST Kieran Bingham wrote:=0A> Hi Si=
mon,=0A>=20=0A> On 11/09/17 05:30, Simon Yuan wrote:=0A> > Hi Niklas,=0A> >=
=20=0A> > How are you doing? I've picked you as my contact since I met you =
earlier=0A> > this year at ELC2017. Not sure if you still remember, but we =
had a very=0A> > brief chat about the status of the adv748x driver.=0A>=20=
=0A> I'll let Niklas reply to this bit :D=0A>=20=0A> > Anyway, the real rea=
son for this email is due to a bug I found in the=0A> > driver while integr=
ating it into our product. I've attached a patch which=0A> > should be self=
 explanatory. If you are the wrong person to contact, feel=0A> > free to fo=
rward this email to the right person, or let me know who I=0A> > should con=
tact.=0A> Thanks for trying out the driver!=0A>=20=0A> You're right, I thin=
k you have indeed found a bug - but I'm not certain the=0A> fix is correct.=
..=0A>=20=0A> Comment inline on the patch below...=0A>=20=0A> > I've also m=
ade significant changes to the driver in order to satisfy our=0A> > video p=
ath requirements. We need to be able to dynamically switch between=0A> > HD=
MI/ composite input connected to TXA.=0A> >=20=0A> > Is there a plan to mak=
e the current driver more flexible? The way I worked=0A> > around the curre=
nt limitations is by introducing a media_entity for each=0A> > connector (e=
.g. HDMI and 18 types of analog input) physically connected to=0A> > the vi=
deo decoder, and dynamically change the internal routing based on=0A> > the=
 user selected connector linked to CP/SDP.=0A>=20=0A> We did try to design =
the driver such that we could extend the flexibility=0A> later, but have pu=
shed the driver upstream as the current version.=0A>=20=0A> I hope to add C=
EC, and hotplug support later ... but I don't know when that=0A> work will =
be scheduled yet. - Of course - I'm happy to review patches :D=0A> > I'm no=
t entirely satisfied with my workaround, so I won't embarrass myself=0A> > =
by sending a patch for the modified routing scheme.=0A>=20=0A> I would be i=
nterested in seeing your implementation, feel free to send off=0A> lists if=
 you prefer :D - I won't judge!=0A>=20=0A> Regards=0A>=20=0A> Kieran=0A>=20=
=0A> > From 35eea62811d15c096341221c02abab3daadb9a19 Mon Sep 17 00:00:00 20=
01=0A> > From: Simon Yuan <simon.yuan@navico.com>=0A> > Date: Mon, 11 Sep 2=
017 16:07:40 +1200=0A> > Subject: [PATCH] media: i2c: adv748x: Map v4l2_std=
_id to the internal reg=0A> >=20=0A> >  value=0A> >=20=0A> > The video stan=
dard was not mapped to the corresponding value of the=0A> > internal video =
standard in adv748x_afe_querystd, causing the wrong=0A> > video standard to=
 be selected.=0A> > ---=0A> >=20=0A> >  drivers/media/i2c/adv748x/adv748x-a=
fe.c | 7 ++++++-=0A> >  1 file changed, 6 insertions(+), 1 deletion(-)=0A> =
>=20=0A> > diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c=0A> > b/dri=
vers/media/i2c/adv748x/adv748x-afe.c index=0A> > b33ccfc08708..9692e9ea2b70=
 100644=0A> > --- a/drivers/media/i2c/adv748x/adv748x-afe.c=0A> > +++ b/dri=
vers/media/i2c/adv748x/adv748x-afe.c=0A> > @@ -217,6 +217,7 @@ static int a=
dv748x_afe_querystd(struct v4l2_subdev=0A> > *sd, v4l2_std_id *std)>=20=0A>=
 >  {=0A> > =20=0A> >  =09struct adv748x_afe *afe =3D adv748x_sd_to_afe(sd)=
;=0A> >  =09struct adv748x_state *state =3D adv748x_afe_to_state(afe);=0A> =
>=20=0A> > +=09int afe_std;=0A> >=20=0A> >  =09int ret;=0A> >  =09=0A> >  =
=09mutex_lock(&state->mutex);=0A> >=20=0A> > @@ -235,8 +236,12 @@ static in=
t adv748x_afe_querystd(struct v4l2_subdev=0A> > *sd, v4l2_std_id *std)>=20=
=0A> >  =09/* Read detected standard */=0A> >  =09ret =3D adv748x_afe_statu=
s(afe, NULL, std);=0A> >=20=0A> > +=09afe_std =3D adv748x_afe_std(std);=0A>=
=20=0A> I think this should get the afe_std for the afe->curr_norm. This fu=
nction=0A> should leave the hardware in the configured state (not the detec=
ted state).=0A>=20=0A> If you agree, I'll update the patch and send to the =
mailinglists for=0A> integration.=0A> > +=09if (afe_std < 0)=0A> > +=09=09g=
oto unlock;=0A> > +=0A> >=20=0A> >  =09/* Restore original state */=0A> >=
=20=0A> > -=09adv748x_afe_set_video_standard(state, afe->curr_norm);=0A> > =
+=09adv748x_afe_set_video_standard(state, afe_std);=0A> >=20=0A> >  unlock:=
=0A> >  =09mutex_unlock(&state->mutex);=0A> >=20=0A> > Best regards,=0A> > =
Simon=0A=0AHi Kieran,=0A=0AYou are correct, I wasn't thinking straight. I'v=
e indeed introduced a bug=20=0Awithin a bug :)=0A=0AYou are more than welco=
me to modify the patch and send it off for integration.=0A=0AAs for my impl=
ementation of the internal routing, I can certainly send it to=20=0Ayou lat=
er once the implementation matures a bit.=0A=0ABest regards,=0ASimon=0A
