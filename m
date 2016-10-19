Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52890 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941835AbcJSO0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:21 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:07:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <327f6034db9ce0c0a72947e47daf344a@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 3/5] [media] winbond-cir: Move assignments for three
 variables in wbcir_shutdown()
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
References: <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 14, 2016 1:43 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A> From: Markus Elfring <elfring@users.sourceforge.net>=0A> =
Date: Fri, 14 Oct 2016 10:40:12 +0200=0A> =0A> Move the setting for the l=
ocal variables "mask", "match" and "rc6_csl"=0A> behind the source code f=
or a condition check by this function=0A> at the beginning.=0A =0AAgain, =
I can't see what the point is?=0A=0A> Signed-off-by: Markus Elfring <elfr=
ing@users.sourceforge.net>=0A> ---=0A> drivers/media/rc/winbond-cir.c | 8=
 ++++----=0A> 1 file changed, 4 insertions(+), 4 deletions(-)=0A> =0A> di=
ff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.=
c=0A> index fd997f0..9d05e17 100644=0A> --- a/drivers/media/rc/winbond-ci=
r.c=0A> +++ b/drivers/media/rc/winbond-cir.c=0A> @@ -702,17 +702,17 @@ wb=
cir_shutdown(struct pnp_dev *device)=0A> bool do_wake =3D true;=0A> u8 ma=
tch[11];=0A> u8 mask[11];=0A> - u8 rc6_csl =3D 0;=0A> + u8 rc6_csl;=0A> i=
nt i;=0A> =0A> - memset(match, 0, sizeof(match));=0A> - memset(mask, 0, s=
izeof(mask));=0A> -=0A> if (wake_sc =3D=3D INVALID_SCANCODE || !device_ma=
y_wakeup(dev)) {=0A> do_wake =3D false;=0A> goto finish;=0A> }=0A> =0A> +=
 rc6_csl =3D 0;=0A> + memset(match, 0, sizeof(match));=0A> + memset(mask,=
 0, sizeof(mask));=0A> switch (protocol) {=0A> case IR_PROTOCOL_RC5:=0A> =
if (wake_sc > 0xFFF) {=0A> -- =0A> 2.10.1
