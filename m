Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52955 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942983AbcJSPbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:31:20 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:04:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <78ddb54d61d871ad4b81c986dd9a32d4@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 2/5] [media] winbond-cir: Move a variable assignment
 in wbcir_tx()
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <26ee4adb-2637-52c3-ac83-ae121bed5eff@users.sourceforge.net>
References: <26ee4adb-2637-52c3-ac83-ae121bed5eff@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 14, 2016 1:42 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A> From: Markus Elfring <elfring@users.sourceforge.net>=0A> =
Date: Fri, 14 Oct 2016 07:34:46 +0200=0A> =0A> Move the assignment for th=
e local variable "data" behind the source code=0A> for a memory allocatio=
n by this function.=0A=0ASorry, I can't see what the point is?=0A=0A=0A> =
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>=0A> ---=0A>=
 drivers/media/rc/winbond-cir.c | 3 ++-=0A> 1 file changed, 2 insertions(=
+), 1 deletion(-)=0A> =0A> diff --git a/drivers/media/rc/winbond-cir.c b/=
drivers/media/rc/winbond-cir.c=0A> index 59050f5..fd997f0 100644=0A> --- =
a/drivers/media/rc/winbond-cir.c=0A> +++ b/drivers/media/rc/winbond-cir.c=
=0A> @@ -655,7 +655,7 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)=0A> s=
tatic int=0A> wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)=
=0A> {=0A> - struct wbcir_data *data =3D dev->priv;=0A> + struct wbcir_da=
ta *data;=0A> unsigned *buf;=0A> unsigned i;=0A> unsigned long flags;=0A>=
 @@ -668,6 +668,7 @@ wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned c=
ount)=0A> for (i =3D 0; i < count; i++)=0A> buf[i] =3D DIV_ROUND_CLOSEST(=
b[i], 10);=0A> =0A> + data =3D dev->priv;=0A> /* Not sure if this is poss=
ible, but better safe than sorry */=0A> spin_lock_irqsave(&data->spinlock=
, flags);=0A> if (data->txstate !=3D WBCIR_TXSTATE_INACTIVE) {=0A> -- =0A=
> 2.10.1
