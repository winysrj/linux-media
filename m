Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:38191 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbeH2Rtz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 13:49:55 -0400
Date: Wed, 29 Aug 2018 15:52:44 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Daniel Mack <daniel@zonque.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Message-ID: <20180829135244.GI3566@w540>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
 <CAMZdPi9rdO88=m3BXtUZFUheAaS__Jx58NhYwi7L+sCmhx8apA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Content-Disposition: inline
In-Reply-To: <CAMZdPi9rdO88=m3BXtUZFUheAaS__Jx58NhYwi7L+sCmhx8apA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Loic,

On Tue, Aug 28, 2018 at 05:08:07PM +0200, Loic Poulain wrote:
> On 15 August 2018 at 12:28, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> > Hello ov5640 people,
> >    this driver has received a lot of attention recently, and this series aims
> > to fix the CSI-2 interface startup on i.Mx6Q platforms.
> >
> > Please refer to the v2 cover letters for more background informations:
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg133420.html
> >
> > This two patches alone allows the MIPI interface to startup properly, but in
> > order to capture good images (good as in 'not completely black') exposure and
> > gain handling should be fixed too.
> > Hugues Fruchet has a series in review that fixes that issues:
> > [PATCH v2 0/5] Fix OV5640 exposure & gain
> >
> > And I have re-based it on top of this two fixes here:
> > git://jmondi.org/linux ov5640/timings_exposure
> >
> > Steve Longerbeam tested that branch on his I.MX6q SabreSD board and confirms he
> > can now capture frames (I added his Tested-by tag to this patches). I have
> > verified the same on Engicam iCore I.MX6q and an Intel Atom based board.
> >
> > Ideally I would like to have these two fixes merged, and Hugues' ones then
> > applied on top. Of course, more testing on other platforms using CSI-2 is very
> > welcome.
> >
> > Thanks
> >    j
> >
> > v2 -> v3:
> > - patch [2/2] was originally sent in a different series, compared to v2 it
> >   removes entries from the blob array instead of adding more.
> >
> > Jacopo Mondi (2):
> >   media: ov5640: Re-work MIPI startup sequence
> >   media: ov5640: Fix timings setup code
> >
> >  drivers/media/i2c/ov5640.c | 141 +++++++++++++++++++++++++++++----------------
> >  1 file changed, 92 insertions(+), 49 deletions(-)
> >
> > --
> > 2.7.4
> >
>
> Thanks for this work.
> I've just tested this with a dragonboard-410c (MICPI/CSI) + OV5640 sensor.
> It works on my side for 1280*720, 1920*1080 and 2592*1944 formats.
>
> Tested-by: Loic Poulain <loic.poulain@linaro.org>

Thanks for testing!

Just out of curiosity, did the dragonboard-410c CSI-2 interface had
issues poperly starting up before this series like the i.MX6q did?

Thanks
   j

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbhqUrAAoJEHI0Bo8WoVY8OpQP/3CbNiXluyzS8x8owAVxwxdR
urz12qnBZyuC4fQ01P/6yV9x+KDoaSdoAIgd8XL6wDKVtBDYaWCX6xkP67nuA62h
AAE1w4T07mERwHsgWV8i0ek0hrd1cAZSDgXec33hhkqWc4oQob5/k17mVMfOyUQN
lclkHAMoyEEgoxoJP383bnbRPg6bLeY1RGjSVxtnuMnpurbTR/YrqrrZ+tDgISd4
6z5A1fHYFwZUv6VIKvLEipZL9bQqH30R+v/1CeP4eJvU4QJKY0PYI2CgtMgVs/3D
6+XcX1Vup8vMNnTGfYOybrKl/p9pH3XVJB2dmKWBhkOuQPAyW4J8KXSZ+r5C7432
WZSS9W2EzxTr6Txxz2WHlcZmxS5eRN4vaJnCH+8h4FIstlnqfTGo0bCFHNClOZJV
8RFWbWnMRViocyPNna/qAoynnaP2cCMaiMv1dxZbzdx/avRZH+fhS4klFg0EuGUW
ziV4+gbGvPKwjWrwTdX3yE8WZk6cUDgYPVqA/drai1k/R6fB/Wflwc2Kcm4+kqri
qllEtbyAjHD1MaYb36h5csl+GbxHkSfION6cew7L2qmoFCbyftcccd1Fe1NB2fxa
I6qjOxyhNlPttpkD2yxbWmkVaaUqS+RNEE6T3Zpf713Ns6Gm1LMjq2ldnBntjRfI
wQbRsZjRq8MEfyIWv/Aq
=7rgo
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
