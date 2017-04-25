Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36548 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943125AbdDYHu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 03:50:58 -0400
Mime-Version: 1.0
Date: Tue, 25 Apr 2017 07:50:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <60428f37cb2a703756979def23a281db@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH] rc-core: use the full 32 bits for NEC scancodes in
 wakefilters
To: "Sean Young" <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
In-Reply-To: <20170424160153.GB12437@gofer.mess.org>
References: <20170424160153.GB12437@gofer.mess.org>
 <149254746451.9595.15629164506779251309.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

April 24, 2017 6:02 PM, "Sean Young" <sean@mess.org> wrote:=0A=0A> On Tue=
, Apr 18, 2017 at 10:31:04PM +0200, David H=C3=A4rdeman wrote:=0A> =0A>> =
The new sysfs wakefilter API will expose the difference between the NEC=
=0A>> protocols to userspace for no good reason and once exposed, it will=
 be much=0A>> more difficult to change the logic.=0A>> =0A>> By only allo=
wing full NEC32 scancodes to be set, any heuristics in the kernel=0A>> ca=
n be avoided.=0A> =0A> No heuristics are being removed in this patch or t=
he other patch for nec32,=0A> if anything it gets worse.=0A=0AIt avoids h=
aving to add heuristics in the future if we move to always use nec32 in t=
he kernel<->userspace API. That, IMHO, is the only sane default. Explicit=
ly differentiating between NEC16/24/32 in the API provides no benefits wh=
atsoever.=0A=0A> This patch depends on the other patch, which needs work.=
=0A=0AIt's a minimal version of the other patch, not dependent on it. It =
just makes sure that the wakeup logic only supports nec32 before that API=
 becomes official. =0A=0A>> This is the minimalistic version of the full =
NEC32 patch posted here:=0A>> http://www.spinics.net/lists/linux-media/ms=
g114603.html=0A>> =0A>> Signed-off-by: David H=C3=A4rdeman <david@hardema=
n.nu>=0A>> ---=0A>> drivers/media/rc/rc-main.c | 17 ++++-------------=0A>=
> drivers/media/rc/winbond-cir.c | 32 ++------------------------------=0A=
>> 2 files changed, 6 insertions(+), 43 deletions(-)=0A>> =0A>> diff --gi=
t a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c=0A>> index 6e=
c73357fa47..8a2a2973e718 100644=0A>> --- a/drivers/media/rc/rc-main.c=0A>=
> +++ b/drivers/media/rc/rc-main.c=0A>> @@ -742,8 +742,6 @@ static int rc=
_validate_filter(struct rc_dev *dev,=0A>> [RC_TYPE_SONY15] =3D 0xff007f,=
=0A>> [RC_TYPE_SONY20] =3D 0x1fff7f,=0A>> [RC_TYPE_JVC] =3D 0xffff,=0A>> =
- [RC_TYPE_NEC] =3D 0xffff,=0A>> - [RC_TYPE_NECX] =3D 0xffffff,=0A>> [RC_=
TYPE_NEC32] =3D 0xffffffff,=0A>> [RC_TYPE_SANYO] =3D 0x1fffff,=0A>> [RC_T=
YPE_MCIR2_KBD] =3D 0xffff,=0A>> @@ -759,14 +757,9 @@ static int rc_valida=
te_filter(struct rc_dev *dev,=0A>> enum rc_type protocol =3D dev->wakeup_=
protocol;=0A>> =0A>> switch (protocol) {=0A>> + case RC_TYPE_NEC:=0A>> ca=
se RC_TYPE_NECX:=0A>> - if ((((s >> 16) ^ ~(s >> 8)) & 0xff) =3D=3D 0)=0A=
>> - return -EINVAL;=0A>> - break;=0A>> - case RC_TYPE_NEC32:=0A>> - if (=
(((s >> 24) ^ ~(s >> 16)) & 0xff) =3D=3D 0)=0A>> - return -EINVAL;=0A>> -=
 break;=0A>> + return -EINVAL;=0A>> case RC_TYPE_RC6_MCE:=0A>> if ((s & 0=
xffff0000) !=3D 0x800f0000)=0A>> return -EINVAL;=0A>> @@ -1330,7 +1323,7 =
@@ static ssize_t store_filter(struct device *device,=0A>> /*=0A>> * This=
 is the list of all variants of all protocols, which is used by=0A>> * th=
e wakeup_protocols sysfs entry. In the protocols sysfs entry some=0A>> - =
* some protocols are grouped together (e.g. nec =3D nec + necx + nec32).=
=0A>> + * some protocols are grouped together.=0A>> *=0A>> * For wakeup w=
e need to know the exact protocol variant so the hardware=0A>> * can be p=
rogrammed exactly what to expect.=0A>> @@ -1345,9 +1338,7 @@ static const=
 char * const proto_variant_names[] =3D {=0A>> [RC_TYPE_SONY12] =3D "sony=
-12",=0A>> [RC_TYPE_SONY15] =3D "sony-15",=0A>> [RC_TYPE_SONY20] =3D "son=
y-20",=0A>> - [RC_TYPE_NEC] =3D "nec",=0A>> - [RC_TYPE_NECX] =3D "nec-x",=
=0A>> - [RC_TYPE_NEC32] =3D "nec-32",=0A>> + [RC_TYPE_NEC32] =3D "nec",=
=0A>> [RC_TYPE_SANYO] =3D "sanyo",=0A>> [RC_TYPE_MCIR2_KBD] =3D "mcir2-kb=
d",=0A>> [RC_TYPE_MCIR2_MSE] =3D "mcir2-mse",=0A>> diff --git a/drivers/m=
edia/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c=0A>> index 5a4d4a6=
11197..6ef0e7232356 100644=0A>> --- a/drivers/media/rc/winbond-cir.c=0A>>=
 +++ b/drivers/media/rc/winbond-cir.c=0A>> @@ -714,34 +714,6 @@ wbcir_shu=
tdown(struct pnp_dev *device)=0A>> proto =3D IR_PROTOCOL_RC5;=0A>> break;=
=0A>> =0A>> - case RC_TYPE_NEC:=0A>> - mask[1] =3D bitrev8(mask_sc);=0A>>=
 - mask[0] =3D mask[1];=0A>> - mask[3] =3D bitrev8(mask_sc >> 8);=0A>> - =
mask[2] =3D mask[3];=0A>> -=0A>> - match[1] =3D bitrev8(wake_sc);=0A>> - =
match[0] =3D ~match[1];=0A>> - match[3] =3D bitrev8(wake_sc >> 8);=0A>> -=
 match[2] =3D ~match[3];=0A>> -=0A>> - proto =3D IR_PROTOCOL_NEC;=0A>> - =
break;=0A>> -=0A>> - case RC_TYPE_NECX:=0A>> - mask[1] =3D bitrev8(mask_s=
c);=0A>> - mask[0] =3D mask[1];=0A>> - mask[2] =3D bitrev8(mask_sc >> 8);=
=0A>> - mask[3] =3D bitrev8(mask_sc >> 16);=0A>> -=0A>> - match[1] =3D bi=
trev8(wake_sc);=0A>> - match[0] =3D ~match[1];=0A>> - match[2] =3D bitrev=
8(wake_sc >> 8);=0A>> - match[3] =3D bitrev8(wake_sc >> 16);=0A>> -=0A>> =
- proto =3D IR_PROTOCOL_NEC;=0A>> - break;=0A>> -=0A>> case RC_TYPE_NEC32=
:=0A>> mask[0] =3D bitrev8(mask_sc);=0A>> mask[1] =3D bitrev8(mask_sc >> =
8);=0A>> @@ -1087,8 +1059,8 @@ wbcir_probe(struct pnp_dev *device, const =
struct pnp_device_id *dev_id)=0A>> data->dev->max_timeout =3D 10 * IR_DEF=
AULT_TIMEOUT;=0A>> data->dev->rx_resolution =3D US_TO_NS(2);=0A>> data->d=
ev->allowed_protocols =3D RC_BIT_ALL_IR_DECODER;=0A>> - data->dev->allowe=
d_wakeup_protocols =3D RC_BIT_NEC | RC_BIT_NECX |=0A>> - RC_BIT_NEC32 | R=
C_BIT_RC5 | RC_BIT_RC6_0 |=0A>> + data->dev->allowed_wakeup_protocols =3D=
=0A>> + RC_BIT_NEC | RC_BIT_RC5 | RC_BIT_RC6_0 |=0A>> RC_BIT_RC6_6A_20 | =
RC_BIT_RC6_6A_24 |=0A>> RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE;=0A>> data->dev=
->wakeup_protocol =3D RC_TYPE_RC6_MCE;
