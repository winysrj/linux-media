Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52889 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942315AbcJSO0Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:25 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:10:05 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <19c2ed0f7c2ab3c641d681f5c4e671d9@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 4/5] [media] winbond-cir: One variable and its check
 less in wbcir_shutdown() after error detection
To: "Sean Young" <sean@mess.org>,
        "SF Markus Elfring" <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <20161015132956.GA3393@gofer.mess.org>
References: <20161015132956.GA3393@gofer.mess.org>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <84757ae3-24d2-cf9b-2217-fd9793b86078@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 15, 2016 3:30 PM, "Sean Young" <sean@mess.org> wrote:=0A> On Fri,=
 Oct 14, 2016 at 01:44:02PM +0200, SF Markus Elfring wrote:=0A> =0A>> Fro=
m: Markus Elfring <elfring@users.sourceforge.net>=0A>> Date: Fri, 14 Oct =
2016 12:48:41 +0200=0A>> =0A>> The local variable "do_wake" was set to "f=
alse" after an invalid system=0A>> setting was detected so that a bit of =
error handling was triggered.=0A>> =0A>> * Replace these assignments by d=
irect jumps to the source code with the=0A>> desired exception handling.=
=0A>> =0A>> * Delete this status variable and a corresponding check which=
 became=0A>> unnecessary with this refactoring.=0A>> =0A>> Signed-off-by:=
 Markus Elfring <elfring@users.sourceforge.net>=0A>> ---=0A>> drivers/med=
ia/rc/winbond-cir.c | 78 ++++++++++++++++++------------------------=0A>> =
1 file changed, 34 insertions(+), 44 deletions(-)=0A>> =0A>> diff --git a=
/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c=0A>> ind=
ex 9d05e17..3d286b9 100644=0A>> --- a/drivers/media/rc/winbond-cir.c=0A>>=
 +++ b/drivers/media/rc/winbond-cir.c=0A>> @@ -699,16 +699,13 @@ wbcir_sh=
utdown(struct pnp_dev *device)=0A>> {=0A>> struct device *dev =3D &device=
->dev;=0A>> struct wbcir_data *data =3D pnp_get_drvdata(device);=0A>> - b=
ool do_wake =3D true;=0A>> u8 match[11];=0A>> u8 mask[11];=0A>> u8 rc6_cs=
l;=0A>> int i;=0A>> =0A>> - if (wake_sc =3D=3D INVALID_SCANCODE || !devic=
e_may_wakeup(dev)) {=0A>> - do_wake =3D false;=0A>> - goto finish;=0A>> -=
 }=0A>> + if (wake_sc =3D=3D INVALID_SCANCODE || !device_may_wakeup(dev))=
=0A>> + goto clear_bits;=0A>> =0A>> rc6_csl =3D 0;=0A>> memset(match, 0, =
sizeof(match));=0A>> @@ -716,9 +713,8 @@ wbcir_shutdown(struct pnp_dev *d=
evice)=0A>> switch (protocol) {=0A>> case IR_PROTOCOL_RC5:=0A>> if (wake_=
sc > 0xFFF) {=0A>> - do_wake =3D false;=0A>> dev_err(dev, "RC5 - Invalid =
wake scancode\n");=0A>> - break;=0A>> + goto clear_bits;=0A>> }=0A>> =0A>=
> /* Mask =3D 13 bits, ex toggle */=0A>> @@ -735,9 +731,8 @@ wbcir_shutdo=
wn(struct pnp_dev *device)=0A>> =0A>> case IR_PROTOCOL_NEC:=0A>> if (wake=
_sc > 0xFFFFFF) {=0A>> - do_wake =3D false;=0A>> dev_err(dev, "NEC - Inva=
lid wake scancode\n");=0A>> - break;=0A>> + goto clear_bits;=0A>> }=0A>> =
=0A>> mask[0] =3D mask[1] =3D mask[2] =3D mask[3] =3D 0xFF;=0A>> @@ -757,=
9 +752,8 @@ wbcir_shutdown(struct pnp_dev *device)=0A>> =0A>> if (wake_rc=
6mode =3D=3D 0) {=0A>> if (wake_sc > 0xFFFF) {=0A>> - do_wake =3D false;=
=0A>> dev_err(dev, "RC6 - Invalid wake scancode\n");=0A>> - break;=0A>> +=
 goto clear_bits;=0A>> }=0A>> =0A>> /* Command */=0A>> @@ -813,9 +807,8 @=
@ wbcir_shutdown(struct pnp_dev *device)=0A>> } else if (wake_sc <=3D 0x0=
07FFFFF) {=0A>> rc6_csl =3D 60;=0A>> } else {=0A>> - do_wake =3D false;=
=0A>> dev_err(dev, "RC6 - Invalid wake scancode\n");=0A>> - break;=0A>> +=
 goto clear_bits;=0A>> }=0A>> =0A>> /* Header */=0A>> @@ -825,49 +818,38 =
@@ wbcir_shutdown(struct pnp_dev *device)=0A>> mask[i++] =3D 0x0F;=0A>> =
=0A>> } else {=0A>> - do_wake =3D false;=0A>> dev_err(dev, "RC6 - Invalid=
 wake mode\n");=0A>> + goto clear_bits;=0A>> }=0A>> =0A>> break;=0A>> =0A=
>> default:=0A>> - do_wake =3D false;=0A>> - break;=0A>> + goto clear_bit=
s;=0A>> }=0A>> =0A>> -finish:=0A>> - if (do_wake) {=0A>> - /* Set compare=
 and compare mask */=0A>> - wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_=
INDEX,=0A>> - WBCIR_REGSEL_COMPARE | WBCIR_REG_ADDR0,=0A>> - 0x3F);=0A>> =
- outsb(data->wbase + WBCIR_REG_WCEIR_DATA, match, 11);=0A>> - wbcir_set_=
bits(data->wbase + WBCIR_REG_WCEIR_INDEX,=0A>> - WBCIR_REGSEL_MASK | WBCI=
R_REG_ADDR0,=0A>> - 0x3F);=0A>> - outsb(data->wbase + WBCIR_REG_WCEIR_DAT=
A, mask, 11);=0A>> -=0A>> - /* RC6 Compare String Len */=0A>> - outb(rc6_=
csl, data->wbase + WBCIR_REG_WCEIR_CSL);=0A>> -=0A>> - /* Clear status bi=
ts NEC_REP, BUFF, MSG_END, MATCH */=0A>> - wbcir_set_bits(data->wbase + W=
BCIR_REG_WCEIR_STS, 0x17, 0x17);=0A>> + /* Set compare and compare mask *=
/=0A>> + wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_INDEX,=0A>> + WBCIR=
_REGSEL_COMPARE | WBCIR_REG_ADDR0,=0A>> + 0x3F);=0A>> + outsb(data->wbase=
 + WBCIR_REG_WCEIR_DATA, match, 11);=0A>> + wbcir_set_bits(data->wbase + =
WBCIR_REG_WCEIR_INDEX,=0A>> + WBCIR_REGSEL_MASK | WBCIR_REG_ADDR0,=0A>> +=
 0x3F);=0A>> + outsb(data->wbase + WBCIR_REG_WCEIR_DATA, mask, 11);=0A>> =
=0A>> - /* Clear BUFF_EN, Clear END_EN, Set MATCH_EN */=0A>> - wbcir_set_=
bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);=0A>> + /* RC6 Comp=
are String Len */=0A>> + outb(rc6_csl, data->wbase + WBCIR_REG_WCEIR_CSL)=
;=0A>> =0A>> - /* Set CEIR_EN */=0A>> - wbcir_set_bits(data->wbase + WBCI=
R_REG_WCEIR_CTL, 0x01, 0x01);=0A>> -=0A>> - } else {=0A>> - /* Clear BUFF=
_EN, Clear END_EN, Clear MATCH_EN */=0A>> - wbcir_set_bits(data->wbase + =
WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);=0A>> + /* Clear status bits NEC_REP, =
BUFF, MSG_END, MATCH */=0A>> + wbcir_set_bits(data->wbase + WBCIR_REG_WCE=
IR_STS, 0x17, 0x17);=0A>> =0A>> - /* Clear CEIR_EN */=0A>> - wbcir_set_bi=
ts(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);=0A>> - }=0A>> + /* Cle=
ar BUFF_EN, Clear END_EN, Set MATCH_EN */=0A>> + wbcir_set_bits(data->wba=
se + WBCIR_REG_WCEIR_EV_EN, 0x01, 0x07);=0A>> =0A>> + /* Set CEIR_EN */=
=0A>> + wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x01, 0x01);=0A=
>> +set_irqmask:=0A>> /*=0A>> * ACPI will set the HW disable bit for SP3 =
which means that the=0A>> * output signals are left in an undefined state=
 which may cause=0A>> @@ -876,6 +858,14 @@ wbcir_shutdown(struct pnp_dev =
*device)=0A>> */=0A>> wbcir_set_irqmask(data, WBCIR_IRQ_NONE);=0A>> disab=
le_irq(data->irq);=0A>> + return;=0A>> +clear_bits:=0A>> + /* Clear BUFF_=
EN, Clear END_EN, Clear MATCH_EN */=0A>> + wbcir_set_bits(data->wbase + W=
BCIR_REG_WCEIR_EV_EN, 0x00, 0x07);=0A>> +=0A>> + /* Clear CEIR_EN */=0A>>=
 + wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);=0A>> + =
goto set_irqmask;=0A> =0A> I'm not convinced that adding a goto which goe=
s backwards is making this=0A> code any more readible, just so that a loc=
al variable can be dropped.=0A> =0A=0AAgreed.
