Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeF2KGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 06:06:52 -0400
Date: Fri, 29 Jun 2018 07:06:47 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Message-ID: <20180629070647.1ce7f73b@coco.lan>
In-Reply-To: <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
        <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
        <20180628083732.3679d730@coco.lan>
        <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jun 2018 14:47:05 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/28/18 13:37, Mauro Carvalho Chehab wrote:
> > Em Thu, 17 May 2018 16:30:16 +0200
> > Niklas S=C3=B6derlund         <niklas.soderlund+renesas@ragnatech.se> e=
screveu:
> >  =20
> >> There is no way to control the standard of subdevices which are part of
> >> a media device. The ioctls which exists all target video devices
> >> explicitly and the idea is that the video device should talk to the
> >> subdevice. For subdevices part of a media graph this is not possible a=
nd
> >> the standard must be controlled on the subdev device directly. =20
> >=20
> > Why isn't it possible? A media pipeline should have at least a video
> > devnode where the standard ioctls will be issued. =20
>=20
> Not for an MC-centric device like the r-car or imx. It's why we have v4l-=
subdev
> ioctls for the DV_TIMINGS API, but the corresponding SDTV standards API is
> missing.
>=20
> And in a complex scenario there is nothing preventing you from having mul=
tiple
> SDTV inputs, some of which need PAL-BG, some SECAM, some NTSC (less likel=
y)
> which are all composed together (think security cameras or something like=
 that).
>=20
> You definitely cannot set the standard from a video device. If nothing el=
se,
> it would be completely inconsistent with how HDMI inputs work.
>=20
> The whole point of MC centric devices is that you *don't* control subdevs
> from video nodes.

Well, the way it is, this change is disruptive, as, as far as I remember,
MC-based devices with tvp5150 already sets STD via the /dev/video device.

If we're willing to add it, we'll need to be clear when one approach
should be taken, and be clear that, if the SUBDEV version is used, the
driver should not support the non-subdev option.

>=20
> Regards,
>=20
> 	Hans
>=20
> > So, I don't see why you would need to explicitly set the standard inside
> > a sub-device.
> >=20
> > The way I see, inside a given pipeline, all subdevs should be using the
> > same video standard (maybe except for a m2m device with would have some
> > coded that would be doing format conversion).
> >=20
> > Am I missing something?
> >=20
> > Thanks,
> > Mauro
> >  =20
>=20



Thanks,
Mauro
