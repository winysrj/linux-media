Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39915 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdKVJpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 04:45:38 -0500
Date: Wed, 22 Nov 2017 10:45:26 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20171122094526.nqxfy2e5jzxw7nl4@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20171121154827.5a35xa6zlqrrvkxx@flea.lan>
 <20171122093306.d30fe641f269d62daa1f66b4@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u6lfy6vuiynj7llz"
Content-Disposition: inline
In-Reply-To: <20171122093306.d30fe641f269d62daa1f66b4@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u6lfy6vuiynj7llz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 22, 2017 at 09:33:06AM +0800, Yong wrote:
> > On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > > and CSI1 is used for parallel interface. This is not documented in
> > > datasheet but by testing and guess.
> > >=20
> > > This patch implement a v4l2 framework driver for it.
> > >=20
> > > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > > ISP's support are not included in this patch.
> > >=20
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> >=20
> > Thanks again for this driver.
> >=20
> > It seems like at least this iteration is behaving in a weird way with
> > DMA transfers for at least YU12 and NV12 (and I would assume YV12).
> >=20
> > Starting a transfer of multiple frames in either of these formats,
> > using either ffmpeg (ffmpeg -f v4l2 -video_size 640x480 -framerate 30
> > -i /dev/video0 output.mkv) or yavta (yavta -c80 -p -F --skip 0 -f NV12
> > -s 640x480 $(media-c tl -e 'sun6i-csi')) will end up in a panic.
> >=20
> > The panic seems to be generated with random data going into parts of
> > the kernel memory, the pattern being in my case something like
> > 0x8287868a which is very odd (always around 0x88)
> >=20
> > It turns out that when you cover the sensor, the values change to
> > around 0x28, so it really seems like it's pixels that have been copied
> > there.
> >=20
> > I've looked quickly at the DMA setup, and it seems reasonable to
> > me. Do you have the same issue on your side? Have you been able to
> > test those formats using your hardware?
>=20
> I had tested the following formats with BT1120 input:
> V4L2_PIX_FMT_NV12		-> NV12
> V4L2_PIX_FMT_NV21		-> NV21
> V4L2_PIX_FMT_NV16		-> NV16
> V4L2_PIX_FMT_NV61		-> NV61
> V4L2_PIX_FMT_YUV420		-> YU12
> V4L2_PIX_FMT_YVU420		-> YV12
> V4L2_PIX_FMT_YUV422P		-> 422P
> And they all work fine.

Ok, that's good to know.

> > Given that they all are planar formats and YUYV and the likes work
> > just fine, maybe we can leave them aside for now?
>=20
> V4L2_PIX_FMT_YUV422P and V4L2_PIX_FMT_YUYV is OK, and V4L2_PIX_FMT_NV12
> is bad? It's really weird.
>=20
> What's your input bus code format, type and width?

The sensor is an ov5640, so the MBUS code for the bus is
MEDIA_BUS_FMT_YUYV8_2X8.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--u6lfy6vuiynj7llz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAloVRzIACgkQ0rTAlCFN
r3Qv3A//TfchjwJNbD9sgLMM+WjOEgQykBu9mfhviY5AByF0eVBDsych+AZpO/4S
eh6lfhiRSd6En348f4f6dMF2zT6dUT6NIAIWqNtiAidVVfYuY8XJXQY2xJ65SVm/
BiZtYFq8waIFS3ojbI8SAS5xh0OX6CNFXGYbWe6YpuWCgBnftNteh/L8HE/XnzPR
Npc8kwBLNvvw+ZKSdz0rm7nnFzd6A9S4++tzFDb1ozolwLoRo9aulGrLJ9SP/3a2
P2ek0AnqdZbUYUHbsnzQVagbEsLQME8omKHe8ekxzprA+Jul05R8f+q0IbqOj3U0
YLe+YT91kGnfc49FEWOFsWJR0CVhNKeRTy0SzOJMHn44sW9NuxQyZ3wSyjRCc0t6
KL+rRsgZ/F+wr9wwSUZRtSoaj/9H2qTpKnCm1ODRQNa7sUv+Hl5KMPGWfPRZgJl4
6AFNhkimS59aMV1Jnoz1GNqfb43MULK3ZEN3bRhBg2ERl82edm81tl+QhBlT+Zrm
tRRfkYnZgXpTcreFWNrnHsFw/vmFvxsIAk4963qQVnCk1WMN0HETNYn9yY+p+Br0
g6jyXNSi001iLsvqjknWbRCwTDSUD/fwFerse9ykxg4vnIGPPRfP6uzw+YMhQZ+7
la/fMcK1r4VOvX5EA9DrSRok5H5oQSVFTXRd5g2pJqJbBnB9FfI=
=XFrr
-----END PGP SIGNATURE-----

--u6lfy6vuiynj7llz--
