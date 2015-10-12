Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60296 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbbJLPmm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 11:42:42 -0400
Date: Mon, 12 Oct 2015 17:42:38 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCHv5 10/13] hackrf: add support for transmitter
Message-ID: <20151012154238.GA28125@earth>
References: <201510110807.WZHKJhfM%fengguang.wu@intel.com>
 <561A753D.8010600@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <561A753D.8010600@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sun, Oct 11, 2015 at 05:42:05PM +0300, Antti Palosaari wrote:
> Moikka!
> IMHO it is false positive. Variable which is defined on line 777 is used
> just few lines later on line 782 as can be seen easily. I think it is
> because option CONFIG_DYNAMIC_DEBUG is not set => dev_dbg_ratelimited()
> macro is likely just NOP and gives that warning. Maybe some more logic to is
> needed in order to avoid that kind of warnings.

You can flag it with __maybe_unused:

struct usb_interface __maybe_unused *intf = dev->intf;

-- Sebastian

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWG9TqAAoJENju1/PIO/qa11YQAJtG31ZHiAWZqF6OAV1Vv7r4
Tch6M20ajOWGLukA/nz56qXjQhrcVocWG2iNExlVxccPq61BkE8lc1YoizSXiOaq
HVEwmiyNScjjsRLKw48qv+tDh3XdUJjKFA6f5UTPNKm4ouYKDvoMZCZUMRz8wF5a
4vmTxTIlFztEYNba5gTMazk3Yg16x5IJrKICtBk5hKgL3NLYmrMofq9ahVD5AHb5
shABMC6lFCs6vJP/QqkstR0FvwxwyqlcVBTcYk2RMsOTX6H4T1ZGKbCwGSk2KJlW
LqDN9Dfhy4M8yfcCYOTGPjJdFB829yS6eLaOyuUwYur3vGVHDClVozi1t95/s8y9
MEYgvNkH39CDJjcH4DeQ1DqkWpwUTGz2owOMVPS6yWX9XeL8G4X3x95SzapvEstT
CwvJq0pE86KdmTeWZgbg8TUBekOtCIyubeMTJS76/MACaGMWB6V5W3i82zCfgpwZ
01qAzzhfmFJ5X69hYF/bH1OQ/imr95xcLtzEwMAMMNMklUh1kGHSdViB6SZmZzAw
aDdITMULaHMg46sSkS22ulYZLg9yy98qR0hzS0vPO/p3Ii/NJcXwzQ/AyxPPhOMv
a24J/43yw/a/z20oOHjGHamtFcHO+dQn+m0HoHu9ly+KaerUAdocZhHsFO5OztgJ
JbE+maaPqkPZtcpHvM5T
=LpRS
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
