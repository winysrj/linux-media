Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52956 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943167AbcJSPbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:31:20 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:03:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <ff9593f2d918e13b39ed272e3c74cef8@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 1/5] [media] winbond-cir: Use kmalloc_array() in
 wbcir_tx()
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <74b439c6-fa6f-1f78-424a-ebeb6c8bbb4f@users.sourceforge.net>
References: <74b439c6-fa6f-1f78-424a-ebeb6c8bbb4f@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 14, 2016 1:41 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A> From: Markus Elfring <elfring@users.sourceforge.net>=0A> =
Date: Fri, 14 Oct 2016 07:19:00 +0200=0A> =0A> A multiplication for the s=
ize determination of a memory allocation=0A> indicated that an array data=
 structure should be processed.=0A> Thus use the corresponding function "=
kmalloc_array".=0A> =0A> This issue was detected by using the Coccinelle =
software.=0A> =0A> Signed-off-by: Markus Elfring <elfring@users.sourcefor=
ge.net>=0A=0ASure...why not...=0A=0ASigned-off-by: David H=C3=A4rdeman <d=
avid@hardeman.nu>=0A=0A=0A> ---=0A> drivers/media/rc/winbond-cir.c | 2 +-=
=0A> 1 file changed, 1 insertion(+), 1 deletion(-)=0A> =0A> diff --git a/=
drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c=0A> index=
 95ae60e..59050f5 100644=0A> --- a/drivers/media/rc/winbond-cir.c=0A> +++=
 b/drivers/media/rc/winbond-cir.c=0A> @@ -660,7 +660,7 @@ wbcir_tx(struct=
 rc_dev *dev, unsigned *b, unsigned count)=0A> unsigned i;=0A> unsigned l=
ong flags;=0A> =0A> - buf =3D kmalloc(count * sizeof(*b), GFP_KERNEL);=0A=
> + buf =3D kmalloc_array(count, sizeof(*b), GFP_KERNEL);=0A> if (!buf)=
=0A> return -ENOMEM;=0A> =0A> -- =0A> 2.10.1
