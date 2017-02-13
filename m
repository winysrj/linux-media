Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46798 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbdBMPak (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 10:30:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 00/11] media: rcar-vin: fix OPS and format/pad index issues
Date: Mon, 13 Feb 2017 17:31:05 +0200
Message-ID: <1812889.6lH78FPids@avalon>
In-Reply-To: <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se> <35612ce2-57b1-3059-60c8-18806e3f066a@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 13 Feb 2017 15:19:13 Hans Verkuil wrote:
> Hi Niklas,
>=20
> One general remark: in many commit logs you mistype 'subdeivce'. Can =
you
> fix that for the v2?
>=20
> On 01/31/2017 04:40 PM, Niklas S=F6derlund wrote:
> > Hi,
> >=20
> > This series address issues with the R-Car Gen2 VIN driver. The most=

> > serious issue is the OPS when unbind and rebinding the i2c driver f=
or
> > the video source subdevice which have popped up as a blocker for ot=
her
> > work.
> >=20
> > This series is broken out of my much larger R-Car Gen3 enablement s=
eries
> > '[PATCHv2 00/32] rcar-vin: Add Gen3 with media controller support'.=
 I
> > plan to remove that series form patchwork and focus on these fixes =
first
> > as they are blocking other development. Once the blocking issues ar=
e
> > removed I will rebase and repost the larger Gen3 series.
> >=20
> > Patch 1-4 fix simple problems found while testing
> >=20
> >     1-2 Fix format problems when the format is (re)set.
> >     3   Fix media pad errors
> >     4   Fix standard enumeration problem
> >=20
> > Patch 5 adds a wrapper function to retrieve the active video source=

> > subdevice. This is strictly not needed on Gen2 which only have one
> > possible video source per VIN instance (This will change on Gen3). =
But
> > patch 6-8,11 which fixes real issues on Gen2 make use of this wrapp=
er, as
> > not risk breaking things by removing this wrapper in this series an=
d
> > then readding it in a later Gen3 series I have chosen to keep the p=
atch.
> > Please let me know if I should drop it and rewrite patch 6-11 (if
> > possible I would like to avoid that).
> >=20
> > Patch 6-8 deals with video source subdevice pad index handling by m=
oving
> > the information from struct rvin_dev to struct rvin_graph_entity an=
d
> > moving the pad index probing to the struct v4l2_async_notifier comp=
lete
> > callback. This is needed to allow the bind/unbind fix in patch 10-1=
1.
> >=20
> > Patch 9 use the pad information when calling enum_mbus_code.
> >=20
> > Patch 10-11 fix a OPS when unbinding/binding the video source subde=
vice.
>=20
> This will not help: you can unbind a subdev at any time, including wh=
en
> it is in use.
>=20
> But why do you need this at all? You can also set suppress_bind_attrs=
 in
> the adv7180 driver to prevent the bind/unbind files from appearing.
>=20
> It really makes no sense for subdevs. In fact, all subdevs should set=
 this
> flag since in the current implementation this is completely impossibl=
e to
> implement safely.
>=20
> I suggest you drop the patches relating to this and instead set the s=
uppress
> flag.

The adv7180 is connected to an I2C controller that can be unbound. Sett=
ing the=20
suppress_bind_attrs flag in the driver thus won't prevent the device fr=
om=20
being unbound. suppress_bind_attrs is not a good solution for I2C drive=
rs.

--=20
Regards,

Laurent Pinchart
