Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbeGYLF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 07:05:58 -0400
Date: Wed, 25 Jul 2018 06:54:53 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVu?= =?UTF-8?B?ZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.19] Various fixes
Message-ID: <20180725065445.01e9b80a@coco.lan>
In-Reply-To: <20180725071853.GN6784@w540>
References: <a9296b29-09ad-9379-0786-de282b71abf2@xs4all.nl>
        <20180724190413.77025078@coco.lan>
        <20180725071853.GN6784@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jacopo,

Please don't do top posting! I reordered the thread for it to be at
the way it should be.

Em Wed, 25 Jul 2018 09:18:53 +0200
jacopo mondi <jacopo@jmondi.org> escreveu:

> On Tue, Jul 24, 2018 at 07:04:13PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 18 Jul 2018 12:38:58 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > =20
> > > Hi Mauro,
> > >
> > > Various fixes. Please note that I re-added the 'Add support for STD i=
octls on subdev nodes'
> > > patch. It really is needed.
> > >
> > > Regards,
> > >
> > > 	Hans
> > > =20
> > =20
> > > Jacopo Mondi (9):
> > >       sh: defconfig: migor: Update defconfig
> > >       sh: defconfig: migor: Enable CEU and sensor drivers
> > >       sh: defconfig: ecovec: Update defconfig
> > >       sh: defconfig: ecovec: Enable CEU and video drivers
> > >       sh: defconfig: se7724: Update defconfig
> > >       sh: defconfig: se7724: Enable CEU and sensor driver
> > >       sh: defconfig: ap325rxa: Update defconfig
> > >       sh: defconfig: ap325rxa: Enable CEU and sensor driver =20
> >
> > I didn't apply the above ones. I understand you want to enable
> > the sensor drivers there, but It should either go via SUPERH
> > tree or we would need his ack to merge on our tree.
> > =20
> > >       sh: migor: Remove stale soc_camera include =20
> >
> > It caused me lots of doubts if we should either apply this one
> > via the media tree or not. I ended by applying, as we're maintaining
> > the soc_camera stuff, with are being removed. So, it makes more sense
> > to merge it via our tree.
> >
> > Still, it would be nicer if we had the SUPERH maintainer's ack on
> > it.
> >
> >
> > Thanks,
> > Mauro =20
>
>
> Mauro,
>    I understand, and I failed to cc the SH people initially.
>=20
> Roping in Sato-san, Rich and the SH list.
> Could you guys please have a look here? I've gone through the media
> tree as all these changes sparkled from soc_camera removal, and while
> I was there I updated the defconfigs before enabling CEU and disabling
> soc_camera.
>=20
> How long before we miss v4.19 Mauro?

That depends on the policies SH people have. This is just build config
stuff, so I guess it could be applied anytime without much issues.

=46rom my side, I'm planning to apply the latest patches for 4.19 along
this week, reserving the next week for bug fixes only and janitorial
work.

>=20
> Thanks
>    j
>=20


Thanks,
Mauro
