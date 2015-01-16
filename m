Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36443 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbAPLFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 06:05:45 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so23677398pab.7
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 03:05:45 -0800 (PST)
Date: Fri, 16 Jan 2015 12:05:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv3 0/3] hdmi: add unpack and logging functions
Message-ID: <20150116110538.GA4885@ulmo.nvidia.com>
References: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 01:14:19PM +0100, Hans Verkuil wrote:
> This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
> adds unpacking and logging functions to hdmi.c. It also uses those
> in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
> once this functionality is merged).
>=20
> Changes since v2:
> - Applied most comments from Thierry's review
> - Renamed HDMI_AUDIO_CODING_TYPE_EXT_STREAM as per Thierry's suggestion.
>=20
> Thierry, if this OK, then please give your Ack and I'll post a pull
> request for 3.20 for the media git tree.

Patches 1, 2 and 3:

Acked-by: Thierry Reding <treding@nvidia.com>

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUuPCCAAoJEN0jrNd/PrOhFhsQAJ1bBWELatjZtmXpz5IIKBb7
Y+Vk0NOa55B07+iq+G9vQDYyZEva/L8JSH2LPPCQWOwGOSTc4Uf8bSSJWbSuBswi
g0MzspyiY6x6ytoW7mcyyO5QyVhzXo3S8U7/5HS167nyT9n6GuNy1y/Jua5elfDB
rPpplB8sn4McZauaS9zcQ3EDBOjlVC2KK08zoSkuJTf54DeksXLorgd81ex7C4H4
QsOjd33/wG5n5FHRyWK6vZi/+SIjTudyuWDUAoiJ1DgZPtIevI9zaluqH9R4iQyx
pNo5UOC9npbt3IxFDDrzkux2/BIoq86mGJ+dY9PKhbUg6Q4Ejy1CbuK8gjktmugH
ZZWUuh6yaAiURQSdrhYlmRXTMAF/aLvAd2iLI2cNqKiSSEpymUEhbNcLO2YeO7GF
kmarfOT1crmHTvwKPiUnJzsdvwtDJxsoAg4dYqSMAN/bK8WG9m1yuVhl4H3Ol3Gb
rD+tPrqf4jHnMibzmuRSW7sso5rsI6MDQ05ShNQIw/rDoh9Mt09YVWuQvo6s9G90
dyG2EhLofB7mUFIjUjbPST+bLOZPQyvq5CWHvc7Ga837RIyMgviionsv3L6Vau98
duO0BltoI1pctM3zbaLDRz0z8LyFBWXgD6SOt7gqspwsdyxbZAK5ZdowmXVBYYWO
GMogl7olT4yYxHR1NqH4
=56oB
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
