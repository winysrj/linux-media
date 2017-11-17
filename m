Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:55740 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965001AbdKQIB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 03:01:29 -0500
Date: Fri, 17 Nov 2017 09:01:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi@googlegroups.com, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, thomas@vitsch.nl,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171117080127.mtfkehxbofk56alv@flea>
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
 <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
 <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
 <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
 <20171116110204.poakahqjz4sj7pmu@flea>
 <1510862395.8053.39.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="getz74tx42g6yqfo"
Content-Disposition: inline
In-Reply-To: <1510862395.8053.39.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--getz74tx42g6yqfo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Thu, Nov 16, 2017 at 02:59:55PM -0500, Nicolas Dufresne wrote:
> Le jeudi 16 novembre 2017 =E0 12:02 +0100, Maxime Ripard a =E9crit :
> > Assuming that the request API is in, we'd need to:
> >   - Finish the MPEG4 support
> >   - Work on more useful codecs (H264 comes to my mind)
>=20
> For which we will have to review the tables and make sure they match
> the spec (the easy part). But as an example, that branch uses a table
> that merge Mpeg4 VOP and VOP Short Header. We need to make sure it does
> not pause problems or split it up. On top of that, ST and Rockchip
> teams should give some help and sync with these tables on their side.
> We also need to consider decoder like Tegra 2. In H264, they don't need
> frame parsing, but just the PPS/SPS data (might just be parsed in the
> driver, like CODA ?). There is other mode of operation, specially in
> H264/HEVC low latency, where the decoder will be similar, but will
> accept and process slices right away, without waiting for the full
> frame.

Sorry if it's a dumb question, but what branches and tables are you
talking about here?

> We also need some doc, to be able to tell the GStreamer and FFMPEG team
> how to detect and handle these decoder. I doubt the libv4l2 proposed
> approach will be used for these two projects since they already have
> their own parser and would like to not parse twice. As an example, we
> need to document that V4L2_PIX_FMT_MPEG2_FRAME implies using the
> Request API and specific CID. We should probably also ping the Chrome
> Devs, which probably have couple of pending branches around this.

We've had a prototype that wasn't based on libv4l but was based on the
VA-API, and it's been working great for us so far.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--getz74tx42g6yqfo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJaDpdXAAoJEBx+YmzsjxAgGUYQAJ2qKRzrbZEzq+6eodVQsi9z
DTMXwpmeslmoVNYGQZ2+rvdsy5QnceJyPEBABjRdwfOU42ukmyy/A9eowbo17+K8
mSntSNb1ySt5TFulKW7jAdNJzUDKamtP3jZ2G9n86Dz7X59CJRtUkaph8QX1r4Jh
anCaC3PQaa2S27JhjE4uudn2xLbLD/gwDh2TyrNtFyI2ZKS59780nOidAO8tBjco
J+mAb/GI45WmWghK1uYOPd8DoEss0fqRmA8wnGoMTGgufYPhIHXxw4HX/TgeXT3I
p/jPc1hQWL+Rri95BiOVmCGA5vhiE3SkDSJAEh8mQcfIMDKmLiucbpPu+y9+LhF1
+KIWkAzPSmzUZgPp4aVx3jIeDYueR3lyqix7mE19eVp0zSH+bHaK4lBz8lb/Rcs2
gnYS2pxs0WXlu03B5YSp4vk7FDUKYQFMgtj8o4FYNreR25TQX+8JBVK0GAuVTOKW
870QtgTf23N06g/XldmHusN7xWohSnG2aXbM1qQleOkUOIyYQ8s1wJqAgXYQPP7X
k3MiyhtLwBNjrJ9ljlGS+yRmMIuJzdn0imBW3Ib7Cbo/uIPPUGfRGuSSRR317yld
4KlycDNAKLBGWSH8rKX25E1KObmADJHK5zzCnMsf8WjXPLzJ3w2lS7uik8XwkaoF
iLhbKcF5OVd/5GNerKdI
=H2LR
-----END PGP SIGNATURE-----

--getz74tx42g6yqfo--
