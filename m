Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EA5C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B39620872
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfCRPrH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:47:07 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52215 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfCRPrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 11:47:07 -0400
X-Originating-IP: 90.88.22.102
Received: from localhost (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 44FD3E000E;
        Mon, 18 Mar 2019 15:47:01 +0000 (UTC)
Date:   Mon, 18 Mar 2019 16:47:00 +0100
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
Message-ID: <20190318154700.4qks2qfxown2frgk@flea>
References: <cover.f011581516bfe7650c9d4c6054bb828e6227e309.1551964740.git-series.maxime.ripard@bootlin.com>
 <1d374e71ffcc396b71461ea916cac3d957f8d86c.1551964740.git-series.maxime.ripard@bootlin.com>
 <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
 <20190313153130.hnp5eybcgjm34i4n@flea>
 <CAAFQd5BeiGVvDcZTFVYg_Qbw1NxRcWFybW2FcDGE=ohFWHFbYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6v4js2jdf5aop6i4"
Content-Disposition: inline
In-Reply-To: <CAAFQd5BeiGVvDcZTFVYg_Qbw1NxRcWFybW2FcDGE=ohFWHFbYA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6v4js2jdf5aop6i4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2019 at 01:13:33PM +0900, Tomasz Figa wrote:
> On Thu, Mar 14, 2019 at 12:31 AM Maxime Ripard
> <maxime.ripard@bootlin.com> wrote:
> >
> > Hi Tomasz,
> >
> > On Fri, Mar 08, 2019 at 03:12:18PM +0900, Tomasz Figa wrote:
> > > > +.. _v4l2-mpeg-h264:
> > > > +
> > > > +``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
> > > > +    Specifies the sequence parameter set (as extracted from the
> > > > +    bitstream) for the associated H264 slice data. This includes t=
he
> > > > +    necessary parameters for configuring a stateless hardware deco=
ding
> > > > +    pipeline for H264.  The bitstream parameters are defined accor=
ding
> > > > +    to :ref:`h264`. Unless there's a specific comment, refer to the
> > > > +    specification for the documentation of these fields, section 7=
=2E4.2.1.1
> > > > +    "Sequence Parameter Set Data Semantics".
> > >
> > > I don't see this section being added by this patch. Where does it com=
e from?
> >
> > This is referring to the the H264 spec itself, as I was trying to
> > point out with the reference in that paragraph. How would you write
> > this down to make it more obvious?
> >
>
> Aha, somehow it didn't come to my mind when reading it. How about
> something like below?
>
> Unless there is a specific comment, refer to the ITU-T Rec. H.264
> specification, section "7.4.2.1.1 Sequence parameter set data semantics"
> (as of the 04/2017 edition).

The :ref:`h264` currently expands to "ITU H.264", which means in the
documentation, in the case above, it ends up as

 The bitstream parameters are defined according to ITU H.264. Unless
 there=E2=80=99s a specific comment, refer to the specification for the
 documentation of these fields, section 7.4.2.1.1 =E2=80=9CSequence Paramet=
er
 Set Data Semantics=E2=80=9D.

I could change the reference to have "ITU-T Rec. H.264 Specification
(04/2017 Edition)". Would that work for you?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--6v4js2jdf5aop6i4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXI+9dAAKCRDj7w1vZxhR
xXB/AP0T8YM+El428l/A0FFCvAGlhgvQNysMgviWspLVoOjQegEA6BMmueOSMX0+
LnMCEycu25iALW2XuZQjTG95/G53tgU=
=p+ih
-----END PGP SIGNATURE-----

--6v4js2jdf5aop6i4--
