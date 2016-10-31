Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:38770 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943394AbcJaObz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 10:31:55 -0400
Mime-Version: 1.0
Date: Mon, 31 Oct 2016 14:31:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <7e2f88ed83c4044c30bc03aaea9f09e1@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any
 transmitting time for tx only devices
To: "Sean Young" <sean@mess.org>, "Andi Shyti" <andi.shyti@samsung.com>
Cc: "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andi Shyti" <andi@etezian.org>
In-Reply-To: <20161027143601.GA5103@gofer.mess.org>
References: <20161027143601.GA5103@gofer.mess.org>
 <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
 <CGME20160902084206epcas1p26e535506ec1c418ede9ba230d40f0656@epcas1p2.samsung.com>
 <20160902084158.GA25342@gofer.mess.org>
 <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 27, 2016 4:36 PM, "Sean Young" <sean@mess.org> wrote:=0A> Since w=
e have to be able to switch between waiting and not waiting,=0A> we need =
some sort of ABI for this. I think this warrants a new ioctl;=0A> I'm not=
 sure how else it can be done. I'll be sending out a patch=0A> shortly.=
=0A=0AHi Sean,=0A=0Ahave you considered using a module param for the LIRC=
 bridge module instead? As far as I understand it, this is an issue which=
 is entirely internal to LIRC, and it's also not something which really n=
eeds to be changed on a per-device level (either you have a modern LIRC d=
aemon or you don't, and all drivers should behave the same, no?).=0A=0AAn=
other advantage is that the parameter would then go away if and when the =
lirc bridge ever goes away (yes, I can still dream, can't I?).=0A=0ARegar=
ds,=0ADavid
