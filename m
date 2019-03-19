Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36732C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A87620828
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbfCSJtj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 05:49:39 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:59377 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCSJtj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 05:49:39 -0400
X-Originating-IP: 90.88.22.102
Received: from localhost (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 19C6D240007;
        Tue, 19 Mar 2019 09:49:33 +0000 (UTC)
Date:   Tue, 19 Mar 2019 10:49:33 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     jernej.skrabec@siol.net, wens@csie.org, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH 6/6] arm64: dts: allwinner: h6: Add Video
 Engine node
Message-ID: <20190319094933.24n7kfluasfmmsps@flea>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
 <20190128205504.11225-7-jernej.skrabec@siol.net>
 <83d5db0b3e40cbd541ed8084d8a8052ce95887b7.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kfjmam5vgios3kkp"
Content-Disposition: inline
In-Reply-To: <83d5db0b3e40cbd541ed8084d8a8052ce95887b7.camel@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--kfjmam5vgios3kkp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2019 at 09:50:24AM +0100, Paul Kocialkowski wrote:
> Le lundi 28 janvier 2019 =E0 21:55 +0100, Jernej Skrabec a =E9crit :
> > This adds the Video engine node for H6. It can use whole DRAM range so
> > there is no need for reserved memory node.
>
> Looks like the patch adding SRAM support made it through but this one
> didn't. It looks ready to be picked up though.
>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Merged, thanks

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--kfjmam5vgios3kkp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXJC7LQAKCRDj7w1vZxhR
xUa5AP9yN3BG1WTRK91lIW2v82LQoUgZ4L5x2MVTMyKeG3AYlQD/TN3dDewW4BvS
92gox0YISyvfZwSL449hK1GpddohFgc=
=Rinj
-----END PGP SIGNATURE-----

--kfjmam5vgios3kkp--
