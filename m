Return-path: <mchehab@pedra>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43144 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab1FJVqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 17:46:13 -0400
Date: Sat, 11 Jun 2011 00:46:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
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
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
Message-ID: <20110610214604.GA2379@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1106101714130.1812-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106101714130.1812-100000@iolanthe.rowland.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 05:18:39PM -0400, Alan Stern wrote:
> > > 2. Until recently in the history of Linux, there was an irreconcilabl=
e=20
> > > conflict. If a kernel driver for the video streaming mode was present=
 and=20
> > > installed, it was not possible to use the camera in stillcam mode at =
all.=20
> > > Thus the only solution to the problem was to blacklist the kernel mod=
ule=20
> > > so that it would not get loaded automatically and only to install sai=
d=20
> > > module by hand if the camera were to be used in video streaming mode,=
 then=20
> > > to rmmod it immediately afterwards. Very cumbersome, obviously.=20
> >=20
> > true... but why couldn't we combine both in kernel or in userspace
> > altogether ? Why do we have this split ? (words from a newbie in V4L2,
> > go easy :-p)
>=20
> I think the problem may be that the PTP protocol used in the still-cam
> mode isn't suitable for a kernel driver.  Or if it is suitable, it
> would have to be something like a shared-filesystem driver -- nothing
> like a video driver.  You certainly wouldn't want to put it in V4L2.

ach true.. Had forgotten that detail. Needs more thinking.

--=20
balbi

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8pCcAAoJEAv8Txj19kN1vIMH/1wWO0iXIGPErUjScfT1qi7+
3ySZwnGkRHdT8kWd6TP5LahNo+bgwbTKhAyFymmB8wA4imGQtKkj0VwDvpLDYvVD
H9jsNUN/MunGo/VXRgCzzkowBtUk/lCvOOUH8oj5uG2qbzan6ywi0gquCUJfjGFT
ZMQlcuj6ylj8Wo1oBhhTr9QsetpI/mQaMu1afj5h+3uHglblBNIiVeClH2HBJrms
lyw39eOSpbAS4OeMBdqAg8I6fUvDg0ONm0taV91DW3EaaMktw4xewCnQCgkrVmCY
KedrYuuQEz8zHcZiPp1L0z1fantJUEfyyf6iV0AXpMnjZKWtlBLR2gY3E4ZuPhA=
=rp8p
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
