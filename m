Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0943C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22A62054F
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfAQL2M (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:28:12 -0500
Received: from mail.bootlin.com ([62.4.15.54]:34886 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbfAQL2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 06:28:11 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id E9B52207B2; Thu, 17 Jan 2019 12:28:08 +0100 (CET)
Received: from localhost (build.bootlin.com [163.172.53.213])
        by mail.bootlin.com (Postfix) with ESMTPSA id C03E42074E;
        Thu, 17 Jan 2019 12:28:08 +0100 (CET)
Date:   Thu, 17 Jan 2019 12:21:50 +0100
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
Message-ID: <20190117112150.qfzqjdmrqpcjqvnh@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <20181115145650.9827-2-maxime.ripard@bootlin.com>
 <20190108095228.GA5161@misaki.sumomo.pri>
 <2149617a-6a36-4c0b-26c9-7fdfee9da9c9@soulik.info>
 <2e734dd6-d459-9990-61fe-27301df35ff7@soulik.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oqkbl2a7clijvahv"
Content-Disposition: inline
In-Reply-To: <2e734dd6-d459-9990-61fe-27301df35ff7@soulik.info>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--oqkbl2a7clijvahv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 10, 2019 at 09:33:01PM +0800, ayaka wrote:
> I forget a important thing, for the rkvdec and rk hevc decoder, it would
> requests cabac table, scaling list, picture parameter set and reference
> picture storing in one or various of DMA buffers. I am not talking about =
the
> data been parsed, the decoder would requests a raw data.
>=20
> For the pps and rps, it is possible to reuse the slice header, just let t=
he
> decoder know the offset from the bitstream bufer, I would suggest to add
> three properties(with sps) for them. But I think we need a method to mark=
 a
> OUTPUT side buffer for those aux data.

I'm not sure this is something we actually want. The whole design
decision was that we wouldn't have a bitstream parser in the kernel,
and doing as you suggest goes against that design.

And either if it is something that turns out to be useful, this is
really out of scope for this series.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--oqkbl2a7clijvahv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEBlTgAKCRDj7w1vZxhR
xRcgAP0dWriJx8+o1omXhfWzZxnYLft+14hPq2CjUX6JxflfLQEAmPrSaLuuzNxR
APurR6hH+cGQ0z90Wdyrw41F9LbmnAg=
=fkam
-----END PGP SIGNATURE-----

--oqkbl2a7clijvahv--
