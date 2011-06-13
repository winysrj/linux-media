Return-path: <mchehab@pedra>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57865 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab1FMJF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 05:05:27 -0400
Date: Mon, 13 Jun 2011 12:05:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Felipe Balbi <balbi@ti.com>, Hans de Goede <hdegoede@redhat.com>,
	linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
Message-ID: <20110613090517.GE3633@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
 <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
 <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
 <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 05:43:06PM -0500, Theodore Kilgore wrote:
> > there's nothing in the USB spec that says you need different product IDs
> > for different modes of operation. No matter if it's still or webcam
> > configuration, the underlying function is the same: capture images using
> > a set of lenses and image sensor.
>=20
> True, true. But I will add that most of these cameras are Class 255,=20
> Subclass 255, Protocol 255 (Proprietary, Proprietary, Proprietary).

well, if the manufacturer doesn't want to implement UVC for whatever
reason, it's his call ;-)

--=20
balbi

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9dLNAAoJEAv8Txj19kN1Hz4H/1laguQ92u7SAQTGc2dPyrbf
f2uGXRdnLy+AUCVoSxqRZ2I6XsHyb7QvElr7GvJHzwCoF3ZKUWY1iakB9IjeswRx
Red55WN/Zb3fEbAnj1w75mk2Uh2TI6fJCID7Ic6rLt1eYMpoA9kzOuE3+RUxkvSi
Ig8SbduGOVbGxSyNTAt5Kc+hHwZP2nFJasYLvmfVe8pcDntojC/8vaXmfSj8zm5W
/QOQAu+u+/9c2I0Z7ZfbiZin3+qkhzSa9/S4MrQhIm0E2m0pja4MdCchEr/qnz9i
IsGf3h6B5HqQY8UZs24I2nzY0CnL84VnQFj40YxV5ewqQ2XSHObFlRsF3Xp/JMM=
=nr9e
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--
