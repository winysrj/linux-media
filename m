Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.utsp.utwente.nl ([130.89.2.14]:42429 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZC3PYt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 11:24:49 -0400
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Message-Id: <0835E36E-BB8D-4B15-BFD7-1430350B8E18@student.utwente.nl>
From: Koen Kooi <k.kooi@student.utwente.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-5-273918330"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2 framework
Date: Mon, 30 Mar 2009 17:23:59 +0200
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-5-273918330
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

Op 30 mrt 2009, om 16:34 heeft Hiremath, Vaibhav het volgende  
geschreven:

> Hi,
>
> With reference to the mail-thread started by Sakari on Resizer  
> driver interface,
>
> http://marc.info/?l=linux-omap&m=123628392325716&w=2
>
> I would like to bring some issues and propose changes to adapt such  
> devices under V4L2 framework. Sorry for delayed response on this  
> mail-thread, actually I was on vacation.

I extracted a patch from that branch, but I can't figure out how to  
actually enable the resizer on beagleboard, overo and omapzoom, since  
the patches to do that seem to be missing from the branches of the ISP  
tree. Any clue where I can get those?
Also, any test apps for the new code? AIUI dmai doesn't understand the  
new code yet.

regards,

Koen

--Apple-Mail-5-273918330
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: Dit deel van het bericht is digitaal ondertekend
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)

iD8DBQFJ0OQRMkyGM64RGpERAi7mAJ9CpjCrpN9dPQsQFO+G2LKUANIhuwCdFBJX
wR87MLrixtrix+w3qL1DzpQ=
=GOkn
-----END PGP SIGNATURE-----

--Apple-Mail-5-273918330--
