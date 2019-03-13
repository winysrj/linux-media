Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986FDC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 15:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B6220693
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 15:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfCMPbh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:31:37 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41917 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfCMPbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 11:31:36 -0400
X-Originating-IP: 90.88.22.102
Received: from localhost (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 188DB2001C;
        Wed, 13 Mar 2019 15:31:30 +0000 (UTC)
Date:   Wed, 13 Mar 2019 16:31:30 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH v5 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190313153130.hnp5eybcgjm34i4n@flea>
References: <cover.f011581516bfe7650c9d4c6054bb828e6227e309.1551964740.git-series.maxime.ripard@bootlin.com>
 <1d374e71ffcc396b71461ea916cac3d957f8d86c.1551964740.git-series.maxime.ripard@bootlin.com>
 <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ajdvt5cmol7qlvjq"
Content-Disposition: inline
In-Reply-To: <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ajdvt5cmol7qlvjq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomasz,

On Fri, Mar 08, 2019 at 03:12:18PM +0900, Tomasz Figa wrote:
> > +.. _v4l2-mpeg-h264:
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
> > +    Specifies the sequence parameter set (as extracted from the
> > +    bitstream) for the associated H264 slice data. This includes the
> > +    necessary parameters for configuring a stateless hardware decoding
> > +    pipeline for H264.  The bitstream parameters are defined according
> > +    to :ref:`h264`. Unless there's a specific comment, refer to the
> > +    specification for the documentation of these fields, section 7.4.2=
=2E1.1
> > +    "Sequence Parameter Set Data Semantics".
>=20
> I don't see this section being added by this patch. Where does it come fr=
om?

This is referring to the the H264 spec itself, as I was trying to
point out with the reference in that paragraph. How would you write
this down to make it more obvious?

> > +.. c:type:: v4l2_ctrl_h264_decode_param
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_h264_decode_param
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``num_slices``
> > +      - Number of slices needed to decode the current frame
> > +    * - __u16
> > +      - ``idr_pic_flag``
> > +      - Is the picture an IDR picture?
>=20
> Sounds like this could be made a flag to be consistent with how this
> kind of fields are represented in the other structs.

I'll change that, thanks!

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ajdvt5cmol7qlvjq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXIkiUgAKCRDj7w1vZxhR
xavfAP9bhwdJ2wUQuKw5TknAoBpc78H/fFPXVIjzIJB9zLWosAD+LGJ77nFYbr6A
GbMjIdwf9GK8AmGTtx8y3/M3koyr9A4=
=AolL
-----END PGP SIGNATURE-----

--ajdvt5cmol7qlvjq--
