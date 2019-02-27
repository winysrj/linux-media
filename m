Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C28C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 20:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E78221850
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 20:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfB0U6D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:58:03 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48648 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfB0U6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 15:58:02 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id 91DCE27E79E
Message-ID: <a581712b3d269525615f21781b45a09e84a22f57.camel@collabora.com>
Subject: Re: [PATCH v4 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date:   Wed, 27 Feb 2019 15:57:55 -0500
In-Reply-To: <20190227100146.beakovktekqcaei3@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
         <9817c9875638ed2484d61e6e128e2551cf3bda4c.1550672228.git-series.maxime.ripard@bootlin.com>
         <CAAFQd5D3CVQQDkP3uKM6dYkmfsLohXcdjG0wMMLukFf-D=TCsw@mail.gmail.com>
         <5d95629590e6ca2abbec898e8e9ee478f7a3a6cc.camel@collabora.com>
         <20190227100146.beakovktekqcaei3@flea>
Organization: Collabora
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-S6lyGFrRwRJDWlN87Fjq"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-S6lyGFrRwRJDWlN87Fjq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 27 f=C3=A9vrier 2019 =C3=A0 11:01 +0100, Maxime Ripard a =C3=A9=
crit :
> > Also regarding the pixel formats. I still think we should have two
> > pixel formats: V4L2_PIX_FMT_H264_SLICE_RAW and
> > V4L2_PIX_FMT_H264_SLICE_ANNEX_B, to properly represent "raw" NALUs
> > and "annex B" formatted NALUs.
>=20
> I agree with that, but I was under the impression that it would be
> part of your series, since you would be the prime user (at first at
> least).

Notice that Ezequiel is requesting a rename of V4L2_PIX_FMT_H264_SLICE
to V4L2_PIX_FMT_H264_SLICE_RAW, which is being added in this serie.

Nicolas

--=-S6lyGFrRwRJDWlN87Fjq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXHb50wAKCRBxUwItrAao
HFOmAKDSSg4Ecfd2ern37wzLqAAjCt+RXgCghVkTcG9LDo4MXMoHwi0ZK0TFpaM=
=QTnQ
-----END PGP SIGNATURE-----

--=-S6lyGFrRwRJDWlN87Fjq--

