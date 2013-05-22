Return-path: <linux-media-owner@vger.kernel.org>
Received: from brandt2.jaunorange.com ([46.4.243.167]:41208 "EHLO ptaff.ca"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab3EVOeY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 10:34:24 -0400
Received: from nestor.ptaff.ca (modemcable021.216-19-135.mc.videotron.ca [135.19.216.21])
	by ptaff.ca (Postfix) with ESMTP id EF38E1BC3CD6
	for <linux-media@vger.kernel.org>; Wed, 22 May 2013 10:05:28 -0400 (EDT)
Date: Wed, 22 May 2013 10:05:26 -0400
From: Patrice Levesque <video4linux.wayne@ptaff.ca>
To: linux-media@vger.kernel.org
Subject: Re: InstantFM
Message-ID: <20130522140525.GF4308@ptaff.ca>
Reply-To: Patrice Levesque <video4linux.wayne@ptaff.ca>
References: <51993390.6080202@theo.to>
 <5199C8FA.9060704@redhat.com>
 <519A4464.7060006@theo.to>
 <519A6DBB.60608@theo.to>
 <519B23A7.90504@redhat.com>
 <519B649C.9040903@theo.to>
 <519C7E8B.9090406@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Content-Disposition: inline
In-Reply-To: <519C7E8B.9090406@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>> I could try the liquorix kernel (3.8) if you thought it might help.
> Yes, if you could try that that would be great.

If I may join the party, I too own an InstantFM USB device and I can't
get it to play radio.  All of this under kernel 3.9.3-gentoo.

dmesg:

	usb 4-2.4: new full-speed USB device number 5 using uhci_hcd
	usb 4-2.4: New USB device found, idVendor=3D06e1, idProduct=3Da155
	usb 4-2.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
	usb 4-2.4: Product: ADS InstantFM Music
	usb 4-2.4: Manufacturer: ADS TECH
	radio-si470x 4-2.4:1.2: DeviceID=3D0xffff ChipID=3D0xffff
	radio-si470x 4-2.4:1.2: software version 0, hardware version 7
	radio-si470x 4-2.4:1.2: This driver is known to work with software version=
 1,
	radio-si470x 4-2.4:1.2: but the device has software version 0.
	radio-si470x 4-2.4:1.2: If you have some trouble using this driver,
	radio-si470x 4-2.4:1.2: please report to V4L ML at linux-media@vger.kernel=
=2Eorg
	usbcore: registered new interface driver radio-si470x
	usbcore: registered new interface driver radio-si470x


xawtv-3.95-r2 (gentoo):

	radio:

	// The interface shows up with 0.00 tuned, and across the screen I
	// see
	VIDIOCGAUDIO: Inappropriate ioctl for device
	VIDIOCSAUDIO: Inappropriate ioctl for device

	radio -f 98.5:
	// The interface shows up with 98.5 tuned, and across the screen I
	// see
	VIDIOCGAUDIO: Inappropriate ioctl for device
	VIDIOCSAUDIO: Inappropriate ioctl for device

	radio -d -i:
	// Seems to scan the proper range, then returns nothing:
	[Stations]
	get_baseline:  min=3D0.000000 max=3D0.000000


xawtv3-320b1ab (seemed to be the latest version snapshot yesterday):

	radio:
	// Does not start.
	Invalid freq '127150000'. Current freq out of range?

	radio -f 98.5:
	// Does not start
	Tuning to 98.50 MHz
	Invalid freq '127150000'. Current freq out of range?

	radio -d -i:
	// Starts scanning out of range
	Warning no band specified, scanning band 1.
	scanning: 127.15 MHz - 327675
	// Then still fails
	get_baseline:  min=3D65535.000000 max=3D65535.000000
	[Stations]


Is there anything else I can try to help debug this?



--=20
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
        Patrice Levesque
         http://ptaff.ca/
        video4linux.wayne@ptaff.ca
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
--

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBCAAGBQJRnNClAAoJEPFsbcakB4r75JMH/j4+tnhUN6uezOxlrrWcxH6+
delInPpTj8OSC0sHQ0qO2867W+5FCoK32wUcpZ/IlaltOeHwB6HPcXgllw6nGre8
KtVioGPGoSUV5eTcsoT6F4MwrbgCPuYCeXV+bXgyLvM8Jka3EPMjzoyMHW7YKSiI
bJpFtP9j0HHCUy0AeFAtEb4wg3YiWvKpZkug8FJkKBTmFmn+uVl/H7BBMveXpjir
M4osAlDDQUQF7/aCL2hZs4dgoLVqhrG7k6fubUOrrMHjDRzmLvjJQHa2ANhE3tE7
+DIdB7WFhCqE4C26S5K7X5nyWE2OBhGhrmQwsQzfsp9tuwo/+YPQTARYDn38q1k=
=D4uo
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
