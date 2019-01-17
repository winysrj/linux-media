Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4229C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C1132054F
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfAQL2K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:28:10 -0500
Received: from mail.bootlin.com ([62.4.15.54]:34871 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfAQL2K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 06:28:10 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 2D6E920742; Thu, 17 Jan 2019 12:28:08 +0100 (CET)
Received: from localhost (build.bootlin.com [163.172.53.213])
        by mail.bootlin.com (Postfix) with ESMTPSA id F365B206DC;
        Thu, 17 Jan 2019 12:28:07 +0100 (CET)
Date:   Thu, 17 Jan 2019 12:16:35 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     ayaka <ayaka@soulik.info>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, posciak@chromium.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190117111635.ng6l7dru436kww6h@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <20181115145650.9827-2-maxime.ripard@bootlin.com>
 <20190108095228.GA5161@misaki.sumomo.pri>
 <2149617a-6a36-4c0b-26c9-7fdfee9da9c9@soulik.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iukpejxkh624ysgh"
Content-Disposition: inline
In-Reply-To: <2149617a-6a36-4c0b-26c9-7fdfee9da9c9@soulik.info>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--iukpejxkh624ysgh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 09, 2019 at 01:01:22AM +0800, ayaka wrote:
> On 1/8/19 5:52 PM, Randy 'ayaka' Li wrote:
> > On Thu, Nov 15, 2018 at 03:56:49PM +0100, Maxime Ripard wrote:
> > > From: Pawel Osciak <posciak@chromium.org>
> > >=20
> > > Stateless video codecs will require both the H264 metadata and slices=
 in
> > > order to be able to decode frames.
> > >=20
> > > This introduces the definitions for a new pixel format for H264 slice=
s that
> > > have been parsed, as well as the structures used to pass the metadata=
 from
> > > the userspace to the kernel.
> > >=20
> > > Co-Developed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >   Documentation/media/uapi/v4l/biblio.rst       |   9 +
> > >   .../media/uapi/v4l/extended-controls.rst      | 364 +++++++++++++++=
+++
> > >   .../media/uapi/v4l/pixfmt-compressed.rst      |  20 +
> > >   .../media/uapi/v4l/vidioc-queryctrl.rst       |  30 ++
> > >   .../media/videodev2.h.rst.exceptions          |   5 +
> > >   drivers/media/v4l2-core/v4l2-ctrls.c          |  42 ++
> > >   drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
> > >   include/media/v4l2-ctrls.h                    |  10 +
> > >   include/uapi/linux/v4l2-controls.h            | 166 ++++++++
> > >   include/uapi/linux/videodev2.h                |  11 +
> > >   10 files changed, 658 insertions(+)
> > > +#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
> > > +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
> > > +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x04
> > > +
> > > +struct v4l2_h264_dpb_entry {
> > > +	__u32 tag;
> > > +	__u16 frame_num;
> > > +	__u16 pic_num;
> > Although the long term reference would use picture order count
> > and short term for frame num, but only one of them is used
> > for a entry of a dpb.
> >=20
> > Besides, for a frame picture frame_num =3D pic_num * 2,
> > and frame_num =3D pic_num * 2 + 1 for a filed.
>=20
> I mistook something before and something Herman told me is wrong, I read =
the
> book explaining the ITU standard.
>=20
> The index of a short term reference picture would be frame_num or POC and
> LongTermPicNum for long term.
>=20
> But stateless hardware decoder usually don't care about whether it is long
> term or short term, as the real dpb updating or management work are not d=
one
> by the the driver or device and decoding job would only use the two list(=
or
> one list for slice P) for reference pictures. So those flag for long term=
 or
> status can be removed as well.
>=20
> Stateless decoder would care about just reference index of this picture a=
nd
> maybe some extra property for the filed coded below. Keeping a property h=
ere
> for the index of a picture is enough.

It doesn't look like it's part of the bitstream, the rockchip driver
seem like it's using the long term flags in the chromeos
driver. Tomasz, do you know why it's needed?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--iukpejxkh624ysgh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEBkEwAKCRDj7w1vZxhR
xUzbAP4tqUnWlgQBhE7is2ChB6r9cPWohmBEC5D/nCUYfP615wD/Xl3+4EL2esQP
yCBF/rcpnasfugniKvQfUKQ/7l4IKQo=
=Ydvv
-----END PGP SIGNATURE-----

--iukpejxkh624ysgh--
