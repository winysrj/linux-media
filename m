Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41794 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754277AbeDZMca (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 08:32:30 -0400
Date: Thu, 26 Apr 2018 14:32:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180426123227.vneif6wuvuu6cih5@ninjato>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <6809346.dy34v3ukH6@avalon>
 <20180423203615.2ntymbibkgw2aiks@ninjato>
 <2216127.6rtmsKdYAn@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="akllzxdcdhvoyn22"
Content-Disposition: inline
In-Reply-To: <2216127.6rtmsKdYAn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--akllzxdcdhvoyn22
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Ah, didn't notice that so far. Can't find it in drivers/i2c/busses.
> > Where are those?
>=20
> IIRC the OMAP I2C adapter supports SCCB natively. I'm not sure the driver=
=20
> implements that though.

It doesn't currently. And seeing how long it sits in HW without a driver
for it, I don't have much expectations.

> > > we need to forward native SCCB calls all the way down the stack in th=
at
> > > case.
> >=20
> > And how is it done currently?
>=20
> Currently we go down to .master_xfer(), and adapters can then decide to u=
se=20
> the hardware SCCB support. Again, it might not be implemented :-)

To sum it up: hardware-driven SCCB support is a very rare exception not
implemented anywhere in all those years. From a pragmatic point of view,
I'd say: we should be open for it, but we don't need to design around
it.

> I'm fine with SCCB helpers. Please note, however, that SCCB differs from =
SMBus=20
> in two ways: NACKs shall be ignored by the master (even though most SCCB=
=20
> devices generate an ack, so we could likely ignore this), and write-read=
=20
> sequences shouldn't use a repeated start. Apart from that register reads =
and=20

Especially the latter is a huge difference to SMBus, and so I think it
will be much safer to not abuse SMBus calls for SCCB.

> register writes are identical to SMBus, which prompted the reuse (or abus=
e) of=20
> the SMBus API. If we end up implementing SCCB helpers, they will likely l=
ook=20
> very, very similar to the SMBus implementation, including the SMBus emula=
ted=20
> transfer helper.

I don't think so. SCCB has much less transaction types than SMBus. Also, the
fallback as sketched in this patch (one master write, then a master
read) would be impossible on SMBus.

I have an idea in my mind. Maybe it is better to implement an RFC first,
so we can talk over code (even if only in prototype stage). I already
found this in ov7670.c, so I am proven wrong on this one already:

 472  * Note that there are two versions of these.  On the XO 1, the
 473  * i2c controller only does SMBUS, so that's what we use.  The
 474  * ov7670 is not really an SMBUS device, though, so the communication
 475  * is not always entirely reliable.

Sigh...


--akllzxdcdhvoyn22
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlrhxtcACgkQFA3kzBSg
KbZdcw//b6mrbF/fVtIqIo1qE0xGIzvJZT9qH/7vm9+765qdqKsLavH9MCHTjKK9
uHrA8l2hZOsBnqlXy9WcuHl8mqz/eMSuwkYbv0iBtcsZxN1kAvBOUgqyDzy/PPP1
prwd/WRzGS7N7gdB9ai25oO81GiI65t8tdffwb9CKv0bQ5/jNnoZIt+rKtTq1/CN
ujlQXcugTBkqsq6y5J2/xNe5hhNLB6mb0zTv11oCTvuDsoAd1hyeHMdaywtn+eL5
H5OcetTtZksKB49kPLSQj4LzVihjJdHmu70cztnrZXHpDprLuwrCxN9gLxMICFJ9
Eky6YBuWSnAGnW7N+TxGba+XG5YUel0EBc+tyGZPCm++H+1rfHrfmsvVR4N9gOH3
EujdDPWJLvtATLagzr8KlkfpHDxaQjvRPIvVTd9ZMkVgl/Hb7Y7hOsj3rMAWiShC
VrJLIbYEOpndVnq4TREtmyd/Ug9SxezIksJJbwEZeniW1AoeZ+iaLoQ8S/Et/P22
k3txjDao9hd8cfdszDF5i+LteNZa42SKftiDNLroI7zu+o3PHOacyqJ5NPTwPU9V
zdo66kg3vqpWb1Qo6N7aSJ3lTAvFJKl0ECT4qXRGaygqV5xxEMFp0nesoIh6CUzX
nxwMkZ69ME4UwJXOQqW2z6ypx6xF75UI9fRGUK4UZazWbAxe4kg=
=pShC
-----END PGP SIGNATURE-----

--akllzxdcdhvoyn22--
