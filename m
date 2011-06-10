Return-path: <mchehab@pedra>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:35647 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab1FJIWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:22:08 -0400
Date: Fri, 10 Jun 2011 11:22:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-usb@vger.kernel.org,
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
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
Message-ID: <20110610082158.GH31396@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Enx9fNJ0XV5HaWRu"
Content-Disposition: inline
In-Reply-To: <4DF1CDE1.4080303@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--Enx9fNJ0XV5HaWRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 09:55:13AM +0200, Hans de Goede wrote:
> Currently this will cause the usb mass storage driver to see a
> disconnect, and any possible still pending writes are lost ...
>=20
> This is IMHO unacceptable, but currently there is nothing we can
> do to avoid this.
>=20
> 2) So called dual mode cameras are (cheap) stillcams often even
> without an lcdscreen viewfinder, and battery backed sram instead
> of flash, which double as a webcam. We have drivers for both the
> stillcam function of these (in libgphoto2, so using usbfs) as
> well as for the webcam function (v4l2 kernel drivers).
>=20
> These drivers work well, and are mature. Yet the user experience
> is rather poor. Under gnome the still-cam contents will be
> automatically be made available as a "drive" using a gvfs-gphoto2 fuse
> mount. This however involves sending a disconnect to the v4l2 kernel
> driver, and thus the /dev/video# node disappearing. So if a user
> wants to use the device as a webcam he/she needs to first go to
> nautilus and unmount the gvfs mount. Until that is done the user will
> simply get a message from an app like cheese that he has no webcam,
> not even an ebusy error, just that he has no such device.

that sounds quite weird. Should only happen if still image and video
functions are on different configurations or different alt-settings of
the same interface. But if they are on same configurations and separate
interfaces, you should be able to bind gphoto to the still image
interface and v4l2 to the camera interface.

How's the device setup ?

> So what do we need to make this situation better:
> 1) A usb_driver callback alternative to the disconnect callback,
>    I propose to call this soft_disconnect. This serves 2 purposes
>    a) It will allow the driver to tell the caller that that is not
>       a good idea by returning an error code (think usb mass storage
>       driver and mounted filesystem

I'm not sure you even need a driver callback for that. Should we leave
that to Desktop manager ?

--=20
balbi

--Enx9fNJ0XV5HaWRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8dQmAAoJEAv8Txj19kN1ja8IAIKaemkwNZoPLeY5qNzQ5Ot6
6YCV0gibGvZ1F2NJS1FtymqpD6GXd316+hPDLV/QGGs5s6su0ta/DoItNLKRW4Sx
mbxzccvnnTPzP5IPv5M0BFNZj4j9vf4XULoe9Wi/TbwyrcF7jTDdxu5+VIy1ktCm
dp75lMkwiXj2XLXK7eqW3A58B1aqM6yzrlgMGuiFICAufY/XmgyytyRgM2CLsvCL
wqog7x2ZrIQ/aB3wzrD6rOkijzdZVpLfRlCLFUVEmB2Vmy2Uyc9tMf6kzipdxR/D
9Qtt5GfAAiOguyz3fci3d6LjTKrpLTySjz0+NyUno/F097xitastr0H6Zr3XLaM=
=EECD
-----END PGP SIGNATURE-----

--Enx9fNJ0XV5HaWRu--
