Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44981 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbeHZKds (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Aug 2018 06:33:48 -0400
Date: Sun, 26 Aug 2018 08:52:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: linux-media@vger.kernel.org
Subject: Re: V4L2 analogue gain contol
Message-ID: <20180826065209.GC25309@amd>
References: <20180822122441.7zxj4e5dczdzmo5m@laureti-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <20180822122441.7zxj4e5dczdzmo5m@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I've been looking at various image sensor drivers to see how they expose
> gains, in particular analogue ones. What I found in 4.18 looks like a
> mess to me.
>=20
> In particular, my interest is about separation of analogue vs digital
> gain and an understanding of what effect a change in gain has on the
> brightness of an image. The latter is characterized in the following
> table in the "linear" column.
>=20
> driver  | CID | register name               | min | max  | def | linear |=
 comments
> --------+-----+-----------------------------+-----+------+-----+--------+=
---------
> adv7343 | G   | ADV7343_DAC2_OUTPUT_LEVEL   | -64 | 64   | 0   |        |
> adv7393 | G   | ADV7393_DAC123_OUTPUT_LEVEL | -64 | 64   | 0   |        |
> imx258  | A   | IMX258_REG_ANALOG_GAIN      | 0   | 8191 | 0   |        |
> imx274  | G   | multiple                    |     |      |     | yes    |=
 [1]
> mt9m032 | G   | MT9M032_GAIN_ALL            | 0   | 127  | 64  | no     |=
 [2]
> mt9m111 | G   | GLOBAL_GAIN                 | 0   | 252  | 32  | no     |=
 [3]
> mt9p031 | G   | MT9P031_GLOBAL_GAIN         | 8   | 1024 | 8   | no     |=
 [4]
> mt9v011 | G   | multiple                    | 0   | 4063 | 32  |        |
> mt9v032 | G   | MT9V032_ANALOG_GAIN         | 16  | 64   | 16  | no     |=
 [5]
> ov13858 | A   | OV13858_REG_ANALOG_GAIN     | 0   | 8191 | 128 |        |
> ov2685  | A   | OV2685_REG_GAIN             | 0   | 2047 | 54  |        |
> ov5640  | G   | OV5640_REG_AEC_PK_REAL_GAIN | 0   | 1023 | 0   |        |
> ov5670  | A   | OV5670_REG_ANALOG_GAIN      | 0   | 8191 | 128 |        |
> ov5695  | A   | OV5695_REG_ANALOG_GAIN      | 16  | 248  | 248 |        |
> mt9m001 | G   | MT9M001_GLOBAL_GAIN         | 0   | 127  | 64  | no     |
> mt9v022 | G   | MT9V022_ANALOG_GAIN         | 0   | 127  | 64  |        |
>=20
> CID:
>   A -> V4L2_CID_ANALOGUE_GAIN
>   G -> V4L2_CID_GAIN, no V4L2_CID_ANALOGUE_GAIN present
> step: always 1
> comments:
> [1] controls a product of analogue and digital gain, value scales
>     roughly linear
> [2] code comments contradict data sheet
> [3] it is not clear whether it also controls a digital gain.
> [4] controls a combination of analogue and digital gain
> [5] analogue only
>=20
> The documentation (extended-controls.rst) says that the digital gain is
> supposed to be a linear fixed-point number with 0x100 meaning factor 1.
> The situation for analogue is much less precise.
>=20
> Typically, the number of analogue gains is much smaller than the number
> of digital gains. No driver exposes more than 13 bit for the analogue
> gain and half of them use at most 8 bits.
>=20
> Can we give more structure to the analogue gain as exposed by V4L2?
> Ideally, I'd like to query a driver for the possible gain values if
> there are few (say < 256) and their factors (which are often given in
> data sheets). The nature of gains though is that they are often similar
> to floating point numbers (2 ** exp * (1 + mant / precision)), which
> makes it difficult to represent them using min/max/step/default.

Yes, it would be nice to have uniform controls for that. And it would
be good if mapping to "ISO" sensitivity from digital photography existed.

> Would it be reasonable to add a new V4L2_CID_ANALOGUE_GAIN_MENU that
> claims linearity and uses fixed-point numbers like
> V4L2_CID_DIGITAL_GAIN? There already is the integer menu
> V4L2_CID_AUTO_EXPOSURE_BIAS, but it also affects the exposure.

I'm not sure if linear scale is really appropriate. You can expect
camera to do ISO100 or ISO200, but if your camera supports ISO480000,
you don't really expect it to support ISO480100.

=2E/drivers/media/i2c/et8ek8/et8ek8_driver.c already does that.

IOW logarithmic scale would be more appropriate; min/max would be
nice, and step=20

> An important application is implementing a custom gain control when the
> built-in auto exposure is not applicable.

Looking at et8ek8 again, perhaps that's the right solution? Userland
just sets the gain, and the driver automatically selects best
analog/digital gain combination.

/*
 * This table describes what should be written to the sensor register
  * for each gain value. The gain(index in the table) is in terms of
   * 0.1EV, i.e. 10 indexes in the table give 2 time more gain [0] in
    * the *analog gain, [1] in the digital gain
     *
      * Analog gain [dB] =3D 20*log10(regvalue/32); 0x20..0x100
       */
      =20

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAluCThkACgkQMOfwapXb+vJnggCbBtHZPwwCg4ILG/YKmxC1Lbpp
9SAAnR5vT9q/xHP0mNxnKQJ1nmsWvuJX
=Ua85
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
