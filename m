Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37303 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757227AbeAISzD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 13:55:03 -0500
Date: Tue, 9 Jan 2018 19:49:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180109184904.dsfv26sym5trr2fs@flea>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k5wo54tp6bqqq7cp"
Content-Disposition: inline
In-Reply-To: <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k5wo54tp6bqqq7cp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Mon, Jan 08, 2018 at 05:13:39PM +0000, Hugues FRUCHET wrote:
> I'm using a ST board with OV5640 wired in parallel bus output in order=20
> to interface to my STM32 DCMI parallel interface.
> Perhaps could you describe your setup so I could help on understanding=20
> the problem on your side. From my past experience with this sensor=20
> module, you can first check hsync/vsync polarities, the datasheet is=20
> buggy on VSYNC polarity as documented in patch 4/5.

I'm testing using the driver, using a parallel interface:
https://patchwork.kernel.org/patch/10129463/

The bus is 8-bits wide, and like I was saying, we had a separate
driver for the ov5640 that is working fine with that driver, so the
hardware setup works, and the capture driver should be mostly ok too.

By dumping the registers, I've seen some differences on the clock
setup, I'll try to hack something tomorrow and let you know :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--k5wo54tp6bqqq7cp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpVDpwACgkQ0rTAlCFN
r3R9eQ//W9qd5aq7bXkpRHpqAAvX32d+ZozVyRgRWEeM6TDkYSg1trSXlH9iolId
d8xLTqc/HFN3Cx1DyxO9BvWfFqfm1m+9t37kQtB9xKs/v5gxTF7C59SXAWxrJJnQ
y9GB+CdIWsA6HmT7mBO37GBkItPQ5G9e+ArLbsv43uPvZw7TpkeBFvHc8IEPl9s4
WkQFYcZ+Mr5blDRdXK+/B683QI+pZz0FATHVuMUOhfytzXtoXbQr6OVuCo74Ku2W
AVOzeFyG0PNEbl+UFEd2cUUgI+4QCetud1ttv8pQi4iQvnfdkE1VhsCtISivFjgD
FOIk7uAdagKBGfC+2OMmvZvHjhSaYnzVMe28rB3gVCze9uDoXfTp8vZSU04v9SKd
Kq080fueFHTL+qrQAkjwOA2u/llDpVJfhy7ZlA8/A+PnAeidzXV31lNAzYdMGrtG
+zMYQY4DV3ggWWm6J9xOBjasHVND/pI9aP9VJu+jgxtyWzReyHxyMGEBDWb6qQNW
x2JlYK1PTDrgMWqsgcLsmbav2/U5SMPc4hTbxw+FNgeVi4lyXb6DFPjV0XiHh8Qc
GBL0cgkZwHL6QZAPfCl8Sq95bFvpyoVSvKfGh9zKsbrMbs+AIf/hRaMyuni17E6H
HiIb43If1QaOT1VIZS4EOTX3lrqSG5pmgYz2xpbTa1L0Sntya0k=
=FcnG
-----END PGP SIGNATURE-----

--k5wo54tp6bqqq7cp--
