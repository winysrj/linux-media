Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:52592 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaAWALb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 19:11:31 -0500
Date: Thu, 23 Jan 2014 01:11:29 +0100
From: Sebastian Reichel <sre@debian.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Message-ID: <20140123001128.GA12425@earth.universe>
References: <20131103220315.GA11659@earth.universe>
 <20140120232719.GA30894@earth.universe>
 <52E045DE.10706@gmail.com>
 <2960230.3bGpm3THhQ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <2960230.3bGpm3THhQ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 22, 2014 at 11:57:45PM +0100, Laurent Pinchart wrote:
> [...]
>> camera-switch {
>>      /*
>>       * TODO:
>>       *  - check if the switching code is generic enough to use a
>>       *    more generic name like "gpio-camera-switch".
>=20
> I think you can use a more generic name. You could probably get some=20
> inspiration from the i2c-mux-gpio DT bindings.

My main concern is, that the gpio used for switching is also
connected to the reset pin of one of the cameras. Maybe that
fact can just be neglected, though?

> [...]

-- Sebastian

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS4F4wAAoJENju1/PIO/qaa6kP/31H7aF2nUkXaI/y5r6DYhx4
Uc7nKcLVgcF4wd8/VLbNEhg1Gw9PUdCkF42qZIm2WC+hj5OukG38Gw1aZanGBHNB
yx1x0o9tflVhikcpVz1QJfPqgDnMLgbpyIxPTtYVNRsY+sMpDpR+2+k/kRLYPtLv
RY5m2w6lRPvcmiV8LLzj7WEwlotJz/mdQLwvvLsmcfoHMnK9K4s/6rQdNOmycj0a
kztUp/qiyQqU2vAHcfmdAfyBQ30m3pUCo0g7s4ctJ461i0lxb220tB+NqbO/wFgJ
2wKBY9TDJJqwzwOcxrbbCXi/uEs/Syafe/KYvbtmOYbnn+SiK3e3HrHQRPlnR8+Q
NJyZ1IkvV/5wZ15lpH+vqoZjRa6iUyFwQ93kIi4YAnBk64hGW0Q31szqbCn4XnJs
2HGaDygf38SwJH5e77NR40H2PyaJ3tCjKeZdGAHQ1CUURGkRhVcQZkz60A7kjP56
LAqcxP/5HYKSAqs82Ud2etp03IzxXRWEBPOq4I7b4bbjNgdZyrWfY5okVdWgiguZ
7nNJw+2Y4SSHLOLf2x1IHmV6JaqvzebfHefBRoN+v6f4oa5q9TRQuWqBB+5dXeA+
KsNeywP9OOLQGp3AE1f4+AML8/oDU0ADna3AWrUIVWC4CJY4S+BPEetPoEqVjRmt
j/H5J2VBvy0I9wX/B/E9
=vxpY
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
