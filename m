Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdK0LYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 06:24:18 -0500
Date: Mon, 27 Nov 2017 09:24:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tycho =?UTF-8?B?TMO8cnNlbg==?= <tycholursen@gmail.com>
Cc: Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [GIT PULL] SAA716x DVB driver
Message-ID: <20171127092408.20de0fe0@vento.lan>
In-Reply-To: <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
        <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
        <20170827073040.6e96d79a@vento.lan>
        <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
        <20170909181123.392cfbb0@vento.lan>
        <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
        <20170916125042.78c4abad@recife.lan>
        <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
        <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 24 Nov 2017 17:28:37 +0100
Tycho L=C3=BCrsen <tycholursen@gmail.com> escreveu:

> Hi Mauro,
>=20
> afaik the last communication about submission of this driver was about=20
> two months ago.
>=20
> This driver is important to me, because I own several TurboSight cards=20
> that are saa716x based. I want to submit a patch that supports my cards.=
=20
> Of course I can only do so when you accept this driver in the first place.
>=20
> Any chance you and S=C3=B6ren agree about how to proceed about this drive=
r=20
> anytime soon?

If we can reach an agreement about what should be done for the driver
to be promoted from staging some day, I'll merge it. Otherwise,
it can be kept maintained out of tree. This driver has been maintained
OOT for a very long time, and it seems that people were happy with
that, as only at the second half of this year someone is requesting
to merge it.

So, while I agree that the best is to merge it upstream and
address the issues that made it OOT for a long time, we shouldn't
rush it with the risk of doing more harm than good.

Thanks,
Mauro
