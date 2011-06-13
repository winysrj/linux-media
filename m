Return-path: <mchehab@pedra>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53392 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab1FMNNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 09:13:00 -0400
Date: Mon, 13 Jun 2011 16:12:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: balbi@ti.com, Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans de Goede <hdegoede@redhat.com>,
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
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
Message-ID: <20110613131242.GQ3633@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
 <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
 <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
 <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
 <20110613090517.GE3633@legolas.emea.dhcp.ti.com>
 <4DF60B72.5020509@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0TNCHh3fkwjpuuE"
Content-Disposition: inline
In-Reply-To: <4DF60B72.5020509@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--L0TNCHh3fkwjpuuE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 13, 2011 at 10:06:58AM -0300, Mauro Carvalho Chehab wrote:
> Em 13-06-2011 06:05, Felipe Balbi escreveu:
> > Hi,
> >=20
> > On Fri, Jun 10, 2011 at 05:43:06PM -0500, Theodore Kilgore wrote:
> >>> there's nothing in the USB spec that says you need different product =
IDs
> >>> for different modes of operation. No matter if it's still or webcam
> >>> configuration, the underlying function is the same: capture images us=
ing
> >>> a set of lenses and image sensor.
> >>
> >> True, true. But I will add that most of these cameras are Class 255,=
=20
> >> Subclass 255, Protocol 255 (Proprietary, Proprietary, Proprietary).
> >=20
> > well, if the manufacturer doesn't want to implement UVC for whatever
> > reason, it's his call ;-)
>=20
> This argument is bogus.
>=20
> UVC were implemented too late. There are lots of chipsets that are not UV=
C-compliant,
> simply because there were no UVC at the time those chipsets were designed.
>=20
> Still today, newer devices using those chipsets are still at the market.
>=20
> This is the same as saying that we should not support USB 1.1 or USB 2.0
> because they're not fully USB 3.0 compliant.

I would think the small wink at the end was enough to label the reply as
a joke. Apparently not :-)

--=20
balbi

--L0TNCHh3fkwjpuuE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9gzKAAoJEAv8Txj19kN1fqoH/id9cidkeiKw5JGTH+8WG9+g
QPF2ptN91nMF+qvJLQPVWSmxBZWTam7oi9fpAftlNwPHPN1vAzY4EYNyYUQpm9xA
5P+kwQbrdvAVW4w80c2e7ur6Hbm6Owbls1T8Hu00wjlW9Rz7/rDy8SLZOrHRX99d
Dvq2KXPSs5Qnvi5KJu5AAMJrIenp0/jhNeHLm8jWEa+e1OjyQCeYBwrzPx6eHNic
ZEjx9o0w2X2sJIKorY4uUEkjT84ip+2pdhOrJVB+v/F9Y7DoAvadUtxYKUNjp/wJ
G1/AEo4PtOOf0P/3G9JeuTWwT7P+jFfO76ggI+0mskaOJohFSiTLQ0flCL+nliY=
=Bjz8
-----END PGP SIGNATURE-----

--L0TNCHh3fkwjpuuE--
