Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52891 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941606AbcJSO0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:23 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:10:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <ecd1ac487c0cfe2080c9477408258e25@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 5/5] [media] winbond-cir: Move a variable assignment
 in two functions
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <0b6de919-35a0-8ee3-9ea7-907c9b9a36f2@users.sourceforge.net>
References: <0b6de919-35a0-8ee3-9ea7-907c9b9a36f2@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 14, 2016 1:45 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A> From: Markus Elfring <elfring@users.sourceforge.net>=0A> =
Date: Fri, 14 Oct 2016 13:13:11 +0200=0A> =0A> Move the assignment for th=
e local variable "data" behind the source code=0A> for condition checks b=
y these functions.=0A=0AWhy?=0A=0A> Signed-off-by: Markus Elfring <elfrin=
g@users.sourceforge.net>=0A> ---=0A> drivers/media/rc/winbond-cir.c | 6 +=
+++--=0A> 1 file changed, 4 insertions(+), 2 deletions(-)=0A> =0A> diff -=
-git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c=0A=
> index 3d286b9..716b1fe 100644=0A> --- a/drivers/media/rc/winbond-cir.c=
=0A> +++ b/drivers/media/rc/winbond-cir.c=0A> @@ -566,7 +566,7 @@ wbcir_s=
et_carrier_report(struct rc_dev *dev, int enable)=0A> static int=0A> wbci=
r_txcarrier(struct rc_dev *dev, u32 carrier)=0A> {=0A> - struct wbcir_dat=
a *data =3D dev->priv;=0A> + struct wbcir_data *data;=0A> unsigned long f=
lags;=0A> u8 val;=0A> u32 freq;=0A> @@ -592,6 +592,7 @@ wbcir_txcarrier(s=
truct rc_dev *dev, u32 carrier)=0A> break;=0A> }=0A> =0A> + data =3D dev-=
>priv;=0A> spin_lock_irqsave(&data->spinlock, flags);=0A> if (data->txsta=
te !=3D WBCIR_TXSTATE_INACTIVE) {=0A> spin_unlock_irqrestore(&data->spinl=
ock, flags);=0A> @@ -611,7 +612,7 @@ wbcir_txcarrier(struct rc_dev *dev, =
u32 carrier)=0A> static int=0A> wbcir_txmask(struct rc_dev *dev, u32 mask=
)=0A> {=0A> - struct wbcir_data *data =3D dev->priv;=0A> + struct wbcir_d=
ata *data;=0A> unsigned long flags;=0A> u8 val;=0A> =0A> @@ -637,6 +638,7=
 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)=0A> return -EINVAL;=0A> }=
=0A> =0A> + data =3D dev->priv;=0A> spin_lock_irqsave(&data->spinlock, fl=
ags);=0A> if (data->txstate !=3D WBCIR_TXSTATE_INACTIVE) {=0A> spin_unloc=
k_irqrestore(&data->spinlock, flags);=0A> -- =0A> 2.10.1
