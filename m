Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbeJ2AGc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Oct 2018 20:06:32 -0400
Date: Sun, 28 Oct 2018 12:21:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Antoni Bella =?UTF-8?B?UMOpcmV6?= <antonibella5@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kaffeine: cool pull request in GitHub
Message-ID: <20181028122130.4ffd266f@coco.lan>
In-Reply-To: <18566905.EYTn87RyQ2@alba>
References: <18566905.EYTn87RyQ2@alba>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antoni,

Em Sun, 28 Oct 2018 01:02:39 +0200
Antoni Bella P=C3=A9rez <antonibella5@yahoo.com> escreveu:

>   Hi
>=20
>   I found three pull request in GitHub and this code has not been include=
d in=20
> the master branch.
>=20
> 	<https://github.com/KDE/kaffeine/pulls?q=3Dis%3Apr+is%3Aclosed>
>=20
> 	* Fix audio CD playing
> 	  #3 by mrandybu was closed a day ago=20
>=20
> 	* Add support for parallel instant records
> 	  #2 by kochstefan was closed on 17 Feb=20
>=20
> 	* Fix compile on FreeBSD
> 	  uest in GitHu#1 by arvedarved was closed on 3 May 2016
>=20
>   I think that would be interesting include it to https://cgit.kde.org/
> kaffeine.git for next release. After your review... ;-)

Thank you for pointing it to me. That audio CD was broken for a long
time. Good to have it fixed.

I applied all 3 series. Not sure if the FreeBSD is really useful, as
AFAIKT the Linux DVB API is specific to Linux, but maybe someone=20
backported it.

Anyway, it doesn't hurt applying it.=20

Thanks,
Mauro
