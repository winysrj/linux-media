Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52888 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941830AbcJSO0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:20 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:47:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <db564db599ac11c5b191d6ec3eec32ff@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [media] winbond-cir: Move a variable assignment in wbcir_tx()
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org
Cc: "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <1a68a0e8-6d56-d9c1-058b-cf9cd8122acb@users.sourceforge.net>
References: <1a68a0e8-6d56-d9c1-058b-cf9cd8122acb@users.sourceforge.net>
 <26ee4adb-2637-52c3-ac83-ae121bed5eff@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <78ddb54d61d871ad4b81c986dd9a32d4@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 19, 2016 3:32 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A>>> Move the assignment for the local variable "data" behin=
d the source code=0A>>> for a memory allocation by this function.=0A>> =
=0A>> Sorry, I can't see what the point is?=0A> =0A> * How do you think a=
bout to avoid a variable assignment in case=0A> that this memory allocati=
on failed anyhow?=0A=0AThere is no memory allocation that can fail at thi=
s point.=0A=0A> * Do you care for data access locality?=0A=0ANot unless y=
ou can show measurable performance improvements?
