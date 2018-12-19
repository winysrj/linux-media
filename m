Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9617EC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F7022086C
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbeLSPjt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:39:49 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37160 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbeLSPjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 10:39:48 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id DD8C1206FF; Wed, 19 Dec 2018 16:39:45 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id B12E72037D;
        Wed, 19 Dec 2018 16:39:35 +0100 (CET)
Date:   Wed, 19 Dec 2018 16:39:36 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: Re: [PATCH v4 0/6] media/sun6i: Allwinner A64 CSI support
Message-ID: <20181219153936.pxu6nwf2conp4b3m@flea>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
 <20181218152122.4zj6wgbukhrl6ly6@flea>
 <CAMty3ZA4xXVLKx-yj+2_iJ700+yTLesjEAgS8Wu2i8otPScpaw@mail.gmail.com>
 <20181219102450.picswsg3yevba23j@flea>
 <CAMty3ZB04E46kMKVvo-QxpVQBus74at3uKJC_QzS788UiCAeeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="42s4xmtnspqvogyw"
Content-Disposition: inline
In-Reply-To: <CAMty3ZB04E46kMKVvo-QxpVQBus74at3uKJC_QzS788UiCAeeg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--42s4xmtnspqvogyw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

65;5402;1c
On Wed, Dec 19, 2018 at 04:11:50PM +0530, Jagan Teki wrote:
> On Wed, Dec 19, 2018 at 3:55 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> >
> > On Tue, Dec 18, 2018 at 08:58:22PM +0530, Jagan Teki wrote:
> > > On Tue, Dec 18, 2018 at 8:51 PM Maxime Ripard <maxime.ripard@bootlin.=
com> wrote:
> > > >
> > > > On Tue, Dec 18, 2018 at 05:03:14PM +0530, Jagan Teki wrote:
> > > > > This series support CSI on Allwinner A64.
> > > > >
> > > > > Tested 640x480, 320x240, 720p, 1080p resolutions UYVY8_2X8 format.
> > > > >
> > > > > Changes for v4:
> > > > > - update the compatible string order
> > > > > - add proper commit message
> > > > > - included BPI-M64 patch
> > > > > - skipped amarula-a64 patch
> > > > > Changes for v3:
> > > > > - update dt-bindings for A64
> > > > > - set mod clock via csi driver
> > > > > - remove assign clocks from dtsi
> > > > > - remove i2c-gpio opendrian
> > > > > - fix avdd and dovdd supplies
> > > > > - remove vcc-csi pin group supply
> > > > >
> > > > > Note: This series created on top of H3 changes [1]
> > > > >
> > > > > [1] https://patchwork.kernel.org/cover/10705905/
> > > >
> > > > You had memory corruption before, how was this fixed?
> > >
> > > Memory corruption observed with default 600MHz on 1080p. It worked
> > > fine on BPI-M64 (with 300MHz)
> >
> > I don't get it. In the previous version of those patches, you were
> > mentionning you were still having this issue, even though you had the
> > clock running at 300MHz, and then you tried to convince us to merge
> > the patches nonetheless.
> >
> > Why would you say that then if that issue was fixed?
>=20
> Previous version has A64-Relic board, which has some xclk issue on
> sensor side wrt 1080p. I have tried 300MHz on the same hardware, it's
> failing to capture on 30fps and so I tried 600MHz(which is default) on
> the same configuration but it encounter memory corruption.
>=20
> So, for checking whether there is an issue with hardware on A64-Relic
> I moved with BPI-M64 dev board. which is working 1080p with 300MHz, ie
> reason I have not included A64-Relic on this version and included
> BPI-M64. We processed A64-Relic to hardware team to figure out the
> clock and once ie fixed I'm planning to send DTS patch for that.
>=20
> This is overall summary, hope you understand.

Ok, great, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--42s4xmtnspqvogyw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXBpmOAAKCRDj7w1vZxhR
xS6UAQDZ0gzJ6Cpqb1L748mR/KCe7R4lzSPjadp+Ltn60pN+WgEAwiW65t5DGkTU
TkBvF6d0ycQwn2u7f7jwIzCs/pG+XgM=
=7Fyr
-----END PGP SIGNATURE-----

--42s4xmtnspqvogyw--
