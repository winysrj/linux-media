Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52886 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941831AbcJSO0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:20 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <403be317930e0915cbe98c15cd6adf66@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 4/5] [media] winbond-cir: One variable and its check
 less in wbcir_shutdown() after error detection
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        "Sean Young" <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <7fe65702-ac76-39f2-edea-eba007a3ee96@users.sourceforge.net>
References: <7fe65702-ac76-39f2-edea-eba007a3ee96@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <84757ae3-24d2-cf9b-2217-fd9793b86078@users.sourceforge.net>
 <20161015132956.GA3393@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 15, 2016 6:42 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A>>> + /* Set CEIR_EN */=0A>>> + wbcir_set_bits(data->wbase =
+ WBCIR_REG_WCEIR_CTL, 0x01, 0x01);=0A>>> +set_irqmask:=0A>>> /*=0A>>> * =
ACPI will set the HW disable bit for SP3 which means that the=0A>>> * out=
put signals are left in an undefined state which may cause=0A>>> @@ -876,=
6 +858,14 @@ wbcir_shutdown(struct pnp_dev *device)=0A>>> */=0A>>> wbcir_=
set_irqmask(data, WBCIR_IRQ_NONE);=0A>>> disable_irq(data->irq);=0A>>> + =
return;=0A>>> +clear_bits:=0A>>> + /* Clear BUFF_EN, Clear END_EN, Clear =
MATCH_EN */=0A>>> + wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0=
x00, 0x07);=0A>>> +=0A>>> + /* Clear CEIR_EN */=0A>>> + wbcir_set_bits(da=
ta->wbase + WBCIR_REG_WCEIR_CTL, 0x00, 0x01);=0A>>> + goto set_irqmask;=
=0A>> =0A>> I'm not convinced that adding a goto which goes backwards is =
making this=0A>> code any more readible, just so that a local variable ca=
n be dropped.=0A> =0A> Thanks for your feedback.=0A> =0A> Is such a "back=
ward jump" usual and finally required when you would like=0A> to move a b=
it of common error handling code to the end without using extra=0A> local=
 variables and a few statements should still be performed after it?=0A> =
=0A=0AI'm sorry, I can't parse this.
