Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53304 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbeJRRcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 13:32:03 -0400
Date: Thu, 18 Oct 2018 11:31:52 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Sam Bobrowicz <sam@elite-embedded.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v4 01/12] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20181018093152.q5yusjycwbzxnyfq@flea>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-2-maxime.ripard@bootlin.com>
 <20181016165450.GB11703@w540>
 <CAFwsNOHpZ+Kf6YQnENuYLtwenjGzWfy=TYqaEC5tjLmaoeTA+g@mail.gmail.com>
 <20181017194835.GA17549@w540>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ubqqlyogeaz4dnrn"
Content-Disposition: inline
In-Reply-To: <20181017194835.GA17549@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ubqqlyogeaz4dnrn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 17, 2018 at 09:51:43PM +0200, jacopo mondi wrote:
> Hello Sam and Maxime (and other ov5640-ers :)
>=20
> On Wed, Oct 17, 2018 at 10:54:01AM -0700, Sam Bobrowicz wrote:
> > Hello Maxime and Jacopo (and other ov5640-ers),
> >
> > I just submitted my version of this patch to the mailing list as RFC.
> > It is working on my MIPI platform. Please try it if you have time.
> > Hopefully we can merge these two into a single patch that doesn't
> > break any platforms.
>=20
> Thanks, I have seen your patch but it seems to contain a lot of things
> already part of Maxime's series. Was this intentional?
>=20
> Now the un-pleaseant part: I have just sent out my re-implementation
> of the MIPI clock tree configuration, based on top of Maxime's series.
> Both you and me have spent a looot of time on this I'm sure, and now
> we have two competing implementations.
>=20
> I had a quick look at yours, and for sure there are things I am not
> taking care of (I'm thinking about the 0x4837 register that seems to
> be important for your platform), so I think both our implementations
> can benefits from a comparison. What is important to me is that both
> you and me don't feel like our work has been wasted, so let's try to
> find out a way to get the better of the two put together, and possibly
> applied on top of Maxime's series, so that a v5 of this will work for
> both MIPI and DVP interfaces. How to do that I'm not sure atm, I think
> other reviewers might help in that if they want to have a look at both
> our series :)

IIRC, Sam's system has never worked with the ov5640 driver, and his
patches now make it work.

Your patches on the other hand make sure that the current series
doesn't break existing users. So I guess we could merge your current
patches into the v5 of my rework, and have Sam send his work on top of
that.

Does that make sense?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ubqqlyogeaz4dnrn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlvIUwcACgkQ0rTAlCFN
r3SJlg//exevJrZw7+607YykwP4lszPpuK4PA9wkTaDX1NQt5Md9dW0AxIe4o/+p
B3y1VhT9GUDXoC0P3tcwXS+hm8dP/Hitx/Sd4g/pqDQBzIMhiww6u1B72+pH5rtQ
WQm9ajgNJYE29tjsdL3hTyD1Xz2lUHnI3N/rD3fXSSO+ncN8JNOL3vJIVjIU09eZ
FYlYjoDMjV/SVamazEor06d3qSzwsN5VO1WDrpXsPoPOCSzoOEkRpFj9RRvoltBI
aaDEz+H/zNvULZ9Q6miS0Ad3gDJQ+IWdt0JtD8n3MInO4+8OC7zHu9INjpubCwjJ
hwlMZCZ1wlhT3qwbdzs2gSKuovfEFxquKu2+PvIiqXf6WZsurF6ET03v/fP9rW2E
a69x/wu2EwjSZxiA90V7NRjXFJcgyFxdUmYPHQrS6/qGqk22MSAPy7PKsJjLF425
2DVuf0P4ONiYz1Le/JkPha59N6U4pLnRjVnzM1wiLiC25JnC3DJwvrxcYOPcECeB
MPrqUlShu8ObvouJvpqp+0kdklwAhRRnh1UVa2gSgNO9b9wjW4byyvfXOeGiVj9m
+b6FqqpQQBt3iO+Zmmif/xGGNtGPIfO3FM/WROGfHQHXqbzlgNDMI2pLSCb/jlvn
GtgVPaxu1szoa17jK1x9kGVC0NTDcuXkEGmLT7LePwNQ6Rcl6w8=
=bUPp
-----END PGP SIGNATURE-----

--ubqqlyogeaz4dnrn--
