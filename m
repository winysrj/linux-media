Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:50593 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbcFVLzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 07:55:23 -0400
Subject: Re: [PATCH v4 2/9] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
 <5767DAE4.3000202@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	mchehab@osg.samsung.com
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <576A7B03.30206@butterbrot.org>
Date: Wed, 22 Jun 2016 13:48:19 +0200
MIME-Version: 1.0
In-Reply-To: <5767DAE4.3000202@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ISUCCAgTkCwJQo46GUIaT48UGd6cQpp2W"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ISUCCAgTkCwJQo46GUIaT48UGd6cQpp2W
Content-Type: multipart/mixed; boundary="G9vPtNkIDxIaEiQBv5VJV38dTT4thkKhf"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, Nick Dyer <nick.dyer@itdev.co.uk>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org,
 Benjamin Tissoires <benjamin.tissoires@redhat.com>,
 Benson Leung <bleung@chromium.org>, Alan Bowens <Alan.Bowens@atmel.com>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Chris Healy <cphealy@gmail.com>, Henrik Rydberg <rydberg@bitmath.org>,
 Andrew Duggan <aduggan@synaptics.com>, James Chen <james.chen@emc.com.tw>,
 Dudley Du <dudl@cypress.com>, Andrew de los Reyes <adlr@chromium.org>,
 sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
 mchehab@osg.samsung.com
Message-ID: <576A7B03.30206@butterbrot.org>
Subject: Re: [PATCH v4 2/9] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
 <5767DAE4.3000202@xs4all.nl>
In-Reply-To: <5767DAE4.3000202@xs4all.nl>

--G9vPtNkIDxIaEiQBv5VJV38dTT4thkKhf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20.06.2016 14:00, Hans Verkuil wrote:
> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>> Some touch controllers send out raw touch data in a similar way to a
>> greyscale frame grabber. Add a new device type for these devices.
>>
>> Use a new device prefix v4l-touch for these devices, to stop generic
>> capture software from treating them as webcams.
>>
>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
>> ---
>>  drivers/input/touchscreen/sur40.c    |  4 ++--
>>  drivers/media/v4l2-core/v4l2-dev.c   | 13 ++++++++++---
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 15 ++++++++++-----
>>  include/media/v4l2-dev.h             |  3 ++-
>>  include/uapi/linux/videodev2.h       |  1 +

Generally a good idea in my opinion, but I think the SUR40 is a special
case: the whole point of putting in a V4L2 driver was that software like
reacTIVision, which already has a V4L2 interface, can then use that
device like any other camera.

Come to think of it, wouldn't it make sense to expose the other touch
devices as generic frame grabbers, too, so you can easily view the debug
output with any generic tool like cheese?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--G9vPtNkIDxIaEiQBv5VJV38dTT4thkKhf--

--ISUCCAgTkCwJQo46GUIaT48UGd6cQpp2W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAldqewQACgkQ7CzyshGvatjsqwCfYO5yV5e2+qrPwBIV1ZJ49zyC
G7cAoIYUhXZMAmdZTNhFnM4PrH8eF7Um
=q3DS
-----END PGP SIGNATURE-----

--ISUCCAgTkCwJQo46GUIaT48UGd6cQpp2W--
