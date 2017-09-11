Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu-smtp-delivery-150.mimecast.com ([207.82.80.150]:52764 "EHLO
        eu-smtp-delivery-150.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751214AbdIKWiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 18:38:09 -0400
From: Simon Yuan <Simon.Yuan@navico.com>
To: Kieran Bingham <kbingham@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "niklas.soderlund@ragnatech.se" <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] media: i2c: adv748x: Map v4l2_std_id to the internal reg
 value
Date: Mon, 11 Sep 2017 22:38:03 +0000
Message-ID: <1668699.pcEPlNxhTE@siyuan>
References: <1505168813-13529-1-git-send-email-kbingham@kernel.org>
In-Reply-To: <1505168813-13529-1-git-send-email-kbingham@kernel.org>
Content-Language: en-US
Content-ID: <8F5B5599D9AFDC4A8AAFE3B9135BFA80@namprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 12 September 2017 10:26:53 NZST Kieran Bingham wrote:=0A> From:=
 Simon Yuan <simon.yuan@navico.com>=0A>=20=0A> The video standard was not m=
apped to the corresponding value of the=0A> internal video standard in adv7=
48x_afe_querystd, causing the wrong=0A> video standard to be selected.=0A>=
=20=0A> Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")=0A>=
 Signed-off-by: Simon Yuan <simon.yuan@navico.com>=0A> [Kieran: Obtain the =
std from the afe->curr_norm]=0A> Signed-off-by: Kieran Bingham <kieran.bing=
ham+renesas@ideasonboard.com>=0A>=20=0A> ---=0A> Simon,=0A>=20=0A> I've add=
ed your implicit Signed-off-by tag as part of resubmitting this=0A> patch. =
Please confirm your agreement to this!=0A>=20=0A>  drivers/media/i2c/adv748=
x/adv748x-afe.c | 7 ++++++-=0A>  1 file changed, 6 insertions(+), 1 deletio=
n(-)=0A>=20=0A> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c=0A> b/=
drivers/media/i2c/adv748x/adv748x-afe.c index 134d981d69d3..5188178588c9=0A=
> 100644=0A> --- a/drivers/media/i2c/adv748x/adv748x-afe.c=0A> +++ b/driver=
s/media/i2c/adv748x/adv748x-afe.c=0A> @@ -217,6 +217,7 @@ static int adv748=
x_afe_querystd(struct v4l2_subdev *sd,=0A> v4l2_std_id *std) {=0A>  =09stru=
ct adv748x_afe *afe =3D adv748x_sd_to_afe(sd);=0A>  =09struct adv748x_state=
 *state =3D adv748x_afe_to_state(afe);=0A> +=09int afe_std;=0A>  =09int ret=
;=0A>=20=0A>  =09mutex_lock(&state->mutex);=0A> @@ -235,8 +236,12 @@ static=
 int adv748x_afe_querystd(struct v4l2_subdev *sd,=0A> v4l2_std_id *std) /* =
Read detected standard */=0A>  =09ret =3D adv748x_afe_status(afe, NULL, std=
);=0A>=20=0A> +=09afe_std =3D adv748x_afe_std(afe->curr_norm);=0A> +=09if (=
afe_std < 0)=0A> +=09=09goto unlock;=0A> +=0A>  =09/* Restore original stat=
e */=0A> -=09adv748x_afe_set_video_standard(state, afe->curr_norm);=0A> +=
=09adv748x_afe_set_video_standard(state, afe_std);=0A>=20=0A>  unlock:=0A> =
 =09mutex_unlock(&state->mutex);=0A=0AHi Kieran,=0A=0ANo problem from me, p=
lease go ahead.=0A=0ABest regards,=0ASimon=0A
