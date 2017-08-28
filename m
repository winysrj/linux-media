Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32347 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbdH1Kta (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:49:30 -0400
Subject: Re: [PATCH v2 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
 <20170819212410.3084-2-sakari.ailus@linux.intel.com>
 <20170828103351.GF18012@amd>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <46aaf723-a657-3b43-7be7-8d899d3db9c3@linux.intel.com>
Date: Mon, 28 Aug 2017 13:48:26 +0300
MIME-Version: 1.0
In-Reply-To: <20170828103351.GF18012@amd>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="657O4RNNq5hUhSDejv2brW1f2E6QAE8h7"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--657O4RNNq5hUhSDejv2brW1f2E6QAE8h7
Content-Type: multipart/mixed; boundary="1lh2qTPEfsfsPVV0tXUoWheoVvoXfDqO1";
 protected-headers="v1"
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, javier@dowhile0.org,
 jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
 devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <46aaf723-a657-3b43-7be7-8d899d3db9c3@linux.intel.com>
Subject: Re: [PATCH v2 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
 <20170819212410.3084-2-sakari.ailus@linux.intel.com>
 <20170828103351.GF18012@amd>
In-Reply-To: <20170828103351.GF18012@amd>

--1lh2qTPEfsfsPVV0tXUoWheoVvoXfDqO1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

Thanks for the review!

On 08/28/17 13:33, Pavel Machek wrote:
> Hi!
>=20
>> +
>> +Ranges below noted as [a, b] are closed ranges between a and b, i.e. =
a
>> +and b are included in the range.
>=20
> Normally I've seen <a, b> for closed ranges, (a, b) for open
> ranges. Is that different in your country?

I guess there are different notations. :-) I've seen regular parentheses
being used for open ranges, too, but not < and >.

Open range is documented in a related well written Wikipedia article:

<URL:https://en.wikipedia.org/wiki/Open_range>

Are there such open ranges in Czechia? For instance, reindeer generally
roam freely in Finnish Lappland.

What comes to the patch, I guess "interval" could be a more appropriate
term to use in this case:

<URL:https://en.wikipedia.org/wiki/Interval_(mathematics)>

The patch is in line with the Wikipedia article in notation but not in
terminology. I'll send a fix.

--=20
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com


--1lh2qTPEfsfsPVV0tXUoWheoVvoXfDqO1--

--657O4RNNq5hUhSDejv2brW1f2E6QAE8h7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQTw0Dd6DU8lp5I47+VtQDYbbijBkwUCWaP0+gAKCRBtQDYbbijB
kzeYAP9xdcH28zg2oBOcwflI5n5+08BmtbYA4kifizv5SrjbOgD9GupwKunplw3/
zOU1PnrPBG4mqZz0NOzxHTdUxYWling=
=CKza
-----END PGP SIGNATURE-----

--657O4RNNq5hUhSDejv2brW1f2E6QAE8h7--
