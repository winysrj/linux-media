Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:40304 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbcBTHBe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 02:01:34 -0500
From: Keith Packard <keithp@keithp.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
In-Reply-To: <56C5A248.8080902@xs4all.nl>
References: <20160217145254.3085b333@lwn.net> <56C56A56.8010107@xs4all.nl> <87vb5me2wy.fsf@intel.com> <56C5A248.8080902@xs4all.nl>
Date: Thu, 18 Feb 2016 22:00:14 -0700
Message-ID: <861t89l2g1.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hans Verkuil <hverkuil@xs4all.nl> writes:

> But good table handling is a prerequisite for us since we rely heavily on=
 that.

I converted an asciidoc document that included some tables to sphinx via
docbook using pandoc; that seemed to generate workable results for me,
but my needs are pretty simple.

Asciidoc has more sophisticated table support, providing the ability to
align text within cells and paint different kinds of borders. Sphinx
provides for spanning rows and columns, and multi-line auto-wrapped cell
contents. The rst docs say there's an emacs mode that can help paint the
source format, but I haven't tried that yet.

In any case, here's some tables from the document I converted:

asciidoc via docbook:

http://altusmetrum.org/AltOS/doc/altusmetrum.html#_altus_metrum_hardware_sp=
ecifications

sphinx:

http://keithp.com/~keithp/altusmetrum-sphinx/hardwarespecs.html#altus-metru=
m-hardware-specifications

While completely unconfigurable, rst tables do at least benefit from an
easier to read input syntax; asciidoc tables are about as readable in
source form as troff or latex...

asciidoc:

	.Altus Metrum Flight Computer Electronics
	[options=3D"header"]
	|=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
	|Device | Barometer | Z-axis accel | GPS | 3D sensors | Storage | RF Outpu=
t | Battery

	|TeleMetrum v1.0
	|MP3H6115 10km (33k')
	|MMA2202 50g
	|SkyTraq
	|-
	|1MB
	|10mW
	|3.7V

	|TeleMetrum v1.1
	|MP3H6115 10km (33k')
	|MMA2202 50g
	|SkyTraq
	|-
	|2MB
	|10mW
	|3.7V

	|TeleMetrum v1.2
	|MP3H6115 10km (33k')
	|ADXL78 70g
	|SkyTraq
	|-
	|2MB
	|10mW
	|3.7V

	|TeleMetrum v2.0
	|MS5607 30km (100k')
	|MMA6555 102g
	|uBlox Max-7Q
	|-
	|8MB
	|40mW
	|3.7V

	|TeleMini v1.0
	|MP3H6115 10km (33k')
	|-
	|-
	|-
	|5kB
	|10mW
	|3.7V

	|EasyMini v1.0
	|MS5607 30km (100k')
	|-
	|-
	|-
	|1MB
	|-
	|3.7-12V

	|TeleMega v1.0
	|MS5607 30km (100k')
	|MMA6555 102g
	|uBlox Max-7Q
	|MPU6000 HMC5883
	|8MB
	|40mW
	|3.7V

	|EasyMega v1.0
	|MS5607 30km (100k')
	|MMA6555 102g
	|-
	|MPU6000 HMC5883
	|8MB
	|-
	|3.7V

	|=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

rst:

	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| Device    | Barometer | Z-axis    | GPS       | 3D        | Storage   | =
RF Output | Battery   |
	|           |           | accel     |           | sensors   |           | =
          |           |
	+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
	| TeleMetru | MP3H6115  | MMA2202   | SkyTraq   | -         | 1MB       | =
10mW      | 3.7V      |
	| m         | 10km      | 50g       |           |           |           | =
          |           |
	| v1.0      | (33k')    |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| TeleMetru | MP3H6115  | MMA2202   | SkyTraq   | -         | 2MB       | =
10mW      | 3.7V      |
	| m         | 10km      | 50g       |           |           |           | =
          |           |
	| v1.1      | (33k')    |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| TeleMetru | MP3H6115  | ADXL78    | SkyTraq   | -         | 2MB       | =
10mW      | 3.7V      |
	| m         | 10km      | 70g       |           |           |           | =
          |           |
	| v1.2      | (33k')    |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| TeleMetru | MS5607    | MMA6555   | uBlox     | -         | 8MB       | =
40mW      | 3.7V      |
	| m         | 30km      | 102g      | Max-7Q    |           |           | =
          |           |
	| v2.0      | (100k')   |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| TeleMini  | MP3H6115  | -         | -         | -         | 5kB       | =
10mW      | 3.7V      |
	| v1.0      | 10km      |           |           |           |           | =
          |           |
	|           | (33k')    |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| EasyMini  | MS5607    | -         | -         | -         | 1MB       | =
-         | 3.7-12V   |
	| v1.0      | 30km      |           |           |           |           | =
          |           |
	|           | (100k')   |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| TeleMega  | MS5607    | MMA6555   | uBlox     | MPU6000   | 8MB       | =
40mW      | 3.7V      |
	| v1.0      | 30km      | 102g      | Max-7Q    | HMC5883   |           | =
          |           |
	|           | (100k')   |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+
	| EasyMega  | MS5607    | MMA6555   | -         | MPU6000   | 8MB       | =
-         | 3.7V      |
	| v1.0      | 30km      | 102g      |           | HMC5883   |           | =
          |           |
	|           | (100k')   |           |           |           |           | =
          |           |
	+-----------+-----------+-----------+-----------+-----------+-----------+-=
----------+-----------+


=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVsahXtsiGmkAAAARAQjIeQ//XuNqaSOwkYG3VkugKBegaTCRLkMAvB+Q
5unBZzHLlybYgVRtDfkmaTwtxaE0qv+dPg1Mhubk4ix8jb8uwAYWOUHzyrGxkY/w
qzPWPd8yzw7IRjhLcNk3Oa3e122MCEg2BGbc4Ffd8oyD/KS7PiazYUbqNXQxAuYM
hVyM1yKfjp1IXd1H1apS1F0ChOI2lHhAuPvCuJ4cMICZKZZgKhzUVe1Bhd4StqRv
IGFlHbWsVw9fG8mr8xxBAHi+NgryJ3YXVJxs0mDg6KxqAlLiWzrMh77UO4h1UHgy
5vXvieXtLYGBHrRr8NjCNLqje1spSVGFw9l4AuiMrZ+hdQ+jLv866hFkAvfWNB23
IJDTh8mpNnlTlucs0DgNPGTBGN6b7CIw1+PO2De4K0nywmG1/ee4LbtUJsu9ML44
2ZCW/BQ2mbPut1iP9SvdNa2CQ33Zs85QwcTVjA7JBaUpVqy+SDDHB5OopkCLXBUN
mav0uLU5F7s1AnahUhlVDR/6qEKjs3PJVX6Q+5sX7R67yhfP9sORgeMYc2hO9rHW
aVYY3j/H/+jNFmeenQXuQ+U1LX/gYN2nYlb1BLObYfWJxG4Tax+lEiOoqUDcHgfv
jgHjgMYA0qeHAs+O0lpaTq3yfJbv8mO6A5M4l6xEsN5WVgHRiYIjRsMAFFAMRDOU
WqGmmAQMh2U=
=JTNr
-----END PGP SIGNATURE-----
--=-=-=--
