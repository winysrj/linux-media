Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:59657 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728444AbeGYI3U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 04:29:20 -0400
Date: Wed, 25 Jul 2018 09:18:53 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.19] Various fixes
Message-ID: <20180725071853.GN6784@w540>
References: <a9296b29-09ad-9379-0786-de282b71abf2@xs4all.nl>
 <20180724190413.77025078@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ztcJpsdPpsnnlAp8"
Content-Disposition: inline
In-Reply-To: <20180724190413.77025078@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ztcJpsdPpsnnlAp8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Mauro,
   I understand, and I failed to cc the SH people initially.

Roping in Sato-san, Rich and the SH list.
Could you guys please have a look here? I've gone through the media
tree as all these changes sparkled from soc_camera removal, and while
I was there I updated the defconfigs before enabling CEU and disabling
soc_camera.

How long before we miss v4.19 Mauro?

Thanks
   j

On Tue, Jul 24, 2018 at 07:04:13PM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 18 Jul 2018 12:38:58 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
> > Hi Mauro,
> >
> > Various fixes. Please note that I re-added the 'Add support for STD ioctls on subdev nodes'
> > patch. It really is needed.
> >
> > Regards,
> >
> > 	Hans
> >
>
> > Jacopo Mondi (9):
> >       sh: defconfig: migor: Update defconfig
> >       sh: defconfig: migor: Enable CEU and sensor drivers
> >       sh: defconfig: ecovec: Update defconfig
> >       sh: defconfig: ecovec: Enable CEU and video drivers
> >       sh: defconfig: se7724: Update defconfig
> >       sh: defconfig: se7724: Enable CEU and sensor driver
> >       sh: defconfig: ap325rxa: Update defconfig
> >       sh: defconfig: ap325rxa: Enable CEU and sensor driver
>
> I didn't apply the above ones. I understand you want to enable
> the sensor drivers there, but It should either go via SUPERH
> tree or we would need his ack to merge on our tree.
>
> >       sh: migor: Remove stale soc_camera include
>
> It caused me lots of doubts if we should either apply this one
> via the media tree or not. I ended by applying, as we're maintaining
> the soc_camera stuff, with are being removed. So, it makes more sense
> to merge it via our tree.
>
> Still, it would be nicer if we had the SUPERH maintainer's ack on
> it.
>
>
> Thanks,
> Mauro

--ztcJpsdPpsnnlAp8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbWCRdAAoJEHI0Bo8WoVY8qCIP/2ayuVwc7QXaZOlIHL1JnM7o
uOyuVGWi8pRACnieYLjPxHdLgGAUySnOvjb9vEXbxQFo3U39K8ReFjAoOb64y4Nm
R5T91AqAX182MJu1u3HGAdJqnHKFXrneEVex/Jrp+YjpsAe7fmQkU2dsl1K0mvIa
aMncDaM46WOLKPbCT9y2xXTxHTkqVrrSYsg7czLw5fSdRadiNYYXrq4r/UdeOJhg
h8aYF9LMRE37sWNr3ahadAULd/WvXTk1VYPuCzcKxts8vdCAjN0p2jWIoRzTu0Iv
blrZYJ7tjXzFZ5Wv8k48mZ1kb1R7Wqp7UCqlYjwnrnDvATK2QatL/1yqYJjZtz5I
RhBkQkOH2ibjsVYUBhzy4R0BYsWtu5A5s0xxnVbyBkVOTzRmJEBFtVvWfLDi9gfx
3Kkp5o/HN26HTlBeFFWCk7oySRUSqi7eERxBwNx7EASkkBMUd51V8hgrKCD3CIaY
KXaU3Zz8oZ6QMmulmK6Z0OXiONdGG6Y2dLZgI4JBi9u8UUNkp+rPg873v4YUtvEm
jUNbw/D1xuPj1s7jzSZT1aqKCu54Q5eSnNgXi1BNCTwcpg7YxpF9T+1jQrzjklva
8OMLyiLs1adoVaD7ELqDzdLoTdAAv/LRdFK9MWNeyD02cGRf7asYyv8Sva3EkV6d
E/7wdii9FVeYCBsGWh3a
=7ubM
-----END PGP SIGNATURE-----

--ztcJpsdPpsnnlAp8--
