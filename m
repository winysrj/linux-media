Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:42221 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753217AbbAFKFD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 05:05:03 -0500
Date: Tue, 6 Jan 2015 11:03:57 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 12/13] ARM: dts: sun6i: Add sun6i-a31s.dtsi
Message-ID: <20150106100357.GH7853@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-13-git-send-email-hdegoede@redhat.com>
 <20141219183450.GZ4820@lukather>
 <54954E77.4070302@redhat.com>
 <20141221223941.GC4820@lukather>
 <549820A4.9090900@redhat.com>
 <20150105090825.GA31311@lukather>
 <54AA59D9.7030909@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Content-Disposition: inline
In-Reply-To: <54AA59D9.7030909@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 05, 2015 at 10:31:05AM +0100, Hans de Goede wrote:
> Thanks, while looking at your dt-for-3.20 branch I noticed that you've
> merged v2 of "ARM: dts: sun6i: Add ir node", I did a v3 adding an ir:
> label to the node, which I noticed was missing because you asked me to
> move the a31s dt stuff to moving label references, can you fix this up, or
> do you want me to do a follow up patch ?
>=20
> Note that having this fixed is a pre-req for the csq-cs908 dts patch.

Ah, right. I edited your previous patch to add the label.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUq7MNAAoJEBx+YmzsjxAgQNYP/3Kb1Yt87efeGhLMutwnr6xt
thfGotDMKxKnnv1eLMzFJQRJFH7cAYTJLZsbt2iCOwpgBW1aktUqDvHohBYoUNY4
9Fxk5N5Uo2Ysexx/FyMEW7dWvFEja2qWfwwteOR0I84NvUUp+kdrp7WNYQnyA9/3
qs0nwofkRvfyvpCaCPx9jElYP2BOb8KtIVCBTDELvBtdMF4DZs3EE9W+3Q6zwNZj
VMVYF72mj6zXnBz7Fc0lzRqKbC63/93ctMns7DeLcmfQfpswwATF/Xo5mPvUGkP5
Yn8CJm3AEPIKFeeO8/xcFeKTVPtQDM4Q2MHCTU0vWnWjs4gpMmFq8f0aithL4pcQ
ktSD0vlcw8SZCJt2Ozx0ij1vjpsh7N2v8Pxbz07HBxInKLeHmJfPWZMZAVAyFJco
4H6qwlowApgkZoY/iHaJcE18f4u8mESqs2pSskuyWSNGPjZFRcKa62Xnhoef3ONv
Ehafz6rMLfs5FwXMkKTWf6iAPMWQdUnx/pl+gcpB2RTa8XpwcOuC1gACcY3YBbQP
h5WCbGXzYhlXTKD0xvzcDL4TV1XUvAb3dAptbqdocuXtZjjCcKCSVpImrVY7jvd5
kpGWQbN/OqfJJvHk76bpSGNPZJkgHZwlS2KS1dwJOTL/OlSGu+nkgS7q5EgJMN6c
lHm6X7rDRxuC+gD+kWt4
=Yz3A
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
