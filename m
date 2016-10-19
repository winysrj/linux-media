Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52887 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941981AbcJSO0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:26:20 -0400
Mime-Version: 1.0
Date: Wed, 19 Oct 2016 13:47:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <10715e71c46bda76f6c8654675062f61@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [media] winbond-cir: Move assignments for three variables in
 wbcir_shutdown()
To: "SF Markus Elfring" <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org
Cc: "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Sean Young" <sean@mess.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "Julia Lawall" <julia.lawall@lip6.fr>
In-Reply-To: <3c96d0bf-62fa-6b02-2a2d-2a097709271a@users.sourceforge.net>
References: <3c96d0bf-62fa-6b02-2a2d-2a097709271a@users.sourceforge.net>
 <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
 <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
 <327f6034db9ce0c0a72947e47daf344a@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 19, 2016 3:38 PM, "SF Markus Elfring" <elfring@users.sourceforge.=
net> wrote:=0A>>> Move the setting for the local variables "mask", "match=
" and "rc6_csl"=0A>>> behind the source code for a condition check by thi=
s function=0A>>> at the beginning.=0A>> =0A>> Again, I can't see what the=
 point is?=0A> =0A> * How do you think about to set these variables only =
after the initial=0A> check succeded?=0A=0AI prefer setting variables ear=
ly so that no thinking about whether they're initialized or not is necess=
ary later. =0A=0A> * Do you care for data access locality?=0A=0ANot unles=
s you can show measurable performance improvements?
