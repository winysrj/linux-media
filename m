Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeF2M3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:29:01 -0400
Date: Fri, 29 Jun 2018 09:28:56 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Message-ID: <20180629092856.73406202@coco.lan>
In-Reply-To: <1b948535-8067-fef6-efd9-92aff3049ec5@xs4all.nl>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
        <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
        <20180628083732.3679d730@coco.lan>
        <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
        <20180629070647.1ce7f73b@coco.lan>
        <1b948535-8067-fef6-efd9-92aff3049ec5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Jun 2018 12:26:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/29/18 12:06, Mauro Carvalho Chehab wrote:
> > Em Thu, 28 Jun 2018 14:47:05 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >  =20
> >> On 06/28/18 13:37, Mauro Carvalho Chehab wrote: =20
> >>> Em Thu, 17 May 2018 16:30:16 +0200
> >>> Niklas S=C3=B6derlund         <niklas.soderlund+renesas@ragnatech.se>=
 escreveu:
> >>>    =20
> >>>> There is no way to control the standard of subdevices which are part=
 of
> >>>> a media device. The ioctls which exists all target video devices
> >>>> explicitly and the idea is that the video device should talk to the
> >>>> subdevice. For subdevices part of a media graph this is not possible=
 and
> >>>> the standard must be controlled on the subdev device directly.   =20
> >>>
> >>> Why isn't it possible? A media pipeline should have at least a video
> >>> devnode where the standard ioctls will be issued.   =20
> >>
> >> Not for an MC-centric device like the r-car or imx. It's why we have v=
4l-subdev
> >> ioctls for the DV_TIMINGS API, but the corresponding SDTV standards AP=
I is
> >> missing.
> >>
> >> And in a complex scenario there is nothing preventing you from having =
multiple
> >> SDTV inputs, some of which need PAL-BG, some SECAM, some NTSC (less li=
kely)
> >> which are all composed together (think security cameras or something l=
ike that).
> >>
> >> You definitely cannot set the standard from a video device. If nothing=
 else,
> >> it would be completely inconsistent with how HDMI inputs work.
> >>
> >> The whole point of MC centric devices is that you *don't* control subd=
evs
> >> from video nodes. =20
> >=20
> > Well, the way it is, this change is disruptive, as, as far as I remembe=
r,
> > MC-based devices with tvp5150 already sets STD via the /dev/video devic=
e. =20
>=20
> Really? Which driver? I am not aware of this and I think you are mistaken.
> Remember that we are talking about MC-centric drivers. em28xx is not MC-c=
entric,
> even though it has a media device.

OMAP3. There are some boards out there with tvp5150.

>=20
> >=20
> > If we're willing to add it, we'll need to be clear when one approach
> > should be taken, and be clear that, if the SUBDEV version is used, the
> > driver should not support the non-subdev option. =20
>=20
> Of course, but in the case of em28xx the tvp5150 v4l-subdev node is never
> created, so this is not a problem.
>=20
> Regards,
>=20
> 	Hans
>=20
> >  =20
> >>
> >> Regards,
> >>
> >> 	Hans
> >> =20
> >>> So, I don't see why you would need to explicitly set the standard ins=
ide
> >>> a sub-device.
> >>>
> >>> The way I see, inside a given pipeline, all subdevs should be using t=
he
> >>> same video standard (maybe except for a m2m device with would have so=
me
> >>> coded that would be doing format conversion).
> >>>
> >>> Am I missing something?
> >>>
> >>> Thanks,
> >>> Mauro
> >>>    =20
> >> =20
> >=20
> >=20
> >=20
> > Thanks,
> > Mauro
> >  =20
>=20



Thanks,
Mauro
