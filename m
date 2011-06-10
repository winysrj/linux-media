Return-path: <mchehab@pedra>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42850 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897Ab1FJSfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:35:06 -0400
Date: Fri, 10 Jun 2011 21:34:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
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
Message-ID: <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
 <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IX4edXMD7HczJcpd"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--IX4edXMD7HczJcpd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 01:16:47PM -0500, Theodore Kilgore wrote:
> As I have been involved in writing the drivers (both the kernel and the=
=20
> libgphoto2 drivers) for many of the affected cameras, perhaps I should=20
> expand on this problem. There are lots of responses to this original=20
> message of Hans. I will try to take some of their comments into account,=
=20
> below. First, some background.
>=20
> 1. All of the cameras in question have only one USB Vendor:Product number=
=2E=20
> In this sense, they are not "good citizens" which have different Product=
=20

there's nothing in the USB spec that says you need different product IDs
for different modes of operation. No matter if it's still or webcam
configuration, the underlying function is the same: capture images using
a set of lenses and image sensor.

> numbers for the two distinct modes of functioning. Thus, the problems are=
=20
> from that standpoint unavoidable.

I don't see any problems in this situation. If, for that particular
product, webcam and still image functionality are mutually exclusive,
then that's how the product (and their drivers) have to work.

If the linux community decided to put webcam functionality in kernel and
still image functionality on a completely separate driver, that's
entirely our problem.

> 2. Until recently in the history of Linux, there was an irreconcilable=20
> conflict. If a kernel driver for the video streaming mode was present and=
=20
> installed, it was not possible to use the camera in stillcam mode at all.=
=20
> Thus the only solution to the problem was to blacklist the kernel module=
=20
> so that it would not get loaded automatically and only to install said=20
> module by hand if the camera were to be used in video streaming mode, the=
n=20
> to rmmod it immediately afterwards. Very cumbersome, obviously.=20

true... but why couldn't we combine both in kernel or in userspace
altogether ? Why do we have this split ? (words from a newbie in V4L2,
go easy :-p)

> 3. The current state of affairs is an advance on (2) but it is still=20
> inelegant. What happens now is, libusb has been revised in such a way tha=
t=20
> the kernel module is disabled (though still present) if a userspace drive=
r=20
> (libgphoto2) wants to access the device (the camera). If it is desired to=
=20
> do video streaming after that, the camera needs to be re-plugged, which=
=20
> then causes the module to be automatically re-loaded.

It's still wrong. This should be just another
USB_REQ_SET_CONFIGURATION(). If this is was just one single driver, you
could easily do that.

> 4. Hans is absolutely correct about the problem with certain Gnome apps=
=20
> (and certain distros which blindly use them), which load up the libgphoto=
2=20
> driver for the camera as soon as it is detected. The consequence (cf. ite=
m=20
> 3) is that the camera can never be used as a webcam. The only solution to=
=20
> that problem is to disable the automatic loading of the libgphoto2 driver.

Or, to move the libgphoto2 driver to kernel, combine it in the same
driver that handles streaming. No ?

> 5. It could be said that those who came up with the "user-friendly"=20
> "solution" described in (4) were not very clever, and perhaps they ought=
=20
> to fix their own mess. I would strongly agree that they ought to have=20
> thought before coding, as the result is not user-friendly in the least.=
=20

I agree here

> 6. The question has been asked whether the cameras are always using the=
=20
> same interface. Typically, yes. The same altsetting? That depends on the=
=20
> camera. Some of them use isochronous transport for streaming, and some of=
=20
> them rely exclusively upon bulk transport. Those which use bulk transport=
=20
> only are confined to altsetting 0.

the transfer type or the way the configurations are setup shouldn't
matter much for the end functionality.

> Some possible solutions?
>=20
> Well, first of all it needs to be understood that the problem originates=
=20
> as a bad feature of something good, namely the rigid separation of=20
> kernelspace and userspace functionality which is an integral part of the=
=20
> Linux security model. Some other operating systems are not so careful, an=
d=20
> thus they do not have a problem about supporting dual-mode hardware.

You'd need to describe this fully. What's the problem in having one
driver handle all modes of operation of that particular camera ? Sounds
like a decision from V4L2 folks not to take still image cameras in
kernel. Am I wrong ?

> Second, it appears to me that the problem is most appropriately addressed=
=20
> from the userspace side and perhaps also from the kernelspace side.=20
>=20
> In userspace, it would be a really good idea if those who are attempting=
=20
> to write user-friendly apps and to create user-friendly distros would=20
> actually learn some of the basics of Linux, such as the rudiments of the=
=20
> security model. Since dual-mode cameras are known to exist, it would have=
=20
> been appropriate, when one is detected, to pop up a dialog window which=
=20
> asks the user to choose a webcam app or a stillcam app. Even this minor=
=20
> innovation would stop a lot of user grief. Frankly, I am mystified that=
=20
> this was not done.

I think this is still not good. It should be more "fluid". If the camera
has separate alternate settings or different configurations, all it
takes (from a USB standpoint) is to send the correct SetConfiguration or
SetInterface command and the camera should happily change its mode of
operation.

Which means that a simple ioctl() to change the mode of operation would
suffice should the driver be combined.

> This still leaves the problem (see item 3, above) that a dual-mode camera=
=20
> needs to be re-plugged in order to re-enable the access to /dev/video* if=
=20
> it has been used in stillcam mode. If it is possible to do a re-plug in=
=20
> software, this would help a lot. It does not matter if the re-plug is don=
e=20
> in userspace or in kernelspace, so long as it can be done, somehow, after=
=20
> libusb relinquishes the camera. Or, fix things up somehow so that the=20
> kernel module automatically re-activates itself when the userspace app=20
> (using libgphoto2) is closed down.
>=20
> Finally, another possible alternative would be to figure out how to do=20
> something in the kernel module which permits the camera to be accessed by=
=20
> libusb.

I don't see the possibility of combining both drivers and use
/dev/videoX for streaming and something like /dev/camX for still image.
Now, the only thing you have to be sure in kernel space is that you
don't allow both to be accessed together, but there are ways to handle
it.

--=20
balbi

--IX4edXMD7HczJcpd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8mPMAAoJEAv8Txj19kN1mNoH/RiTYS6w2rxGhdUtzp1SdG4L
OdJNnSYeHyFUs8C1yW4l+mVhabw7rsWA6S5JG1TT6AM6dOP9G72Wma3WNKCyWWWv
pgE6h0rxHjUfmmaGflbf0UaiVUVomzLtJz2wLAmy4GUDrtz+VIyQFWhTmGp+gc9n
xSzHN9pgZ6sRoi1gWWgA2g+ULlWdtkeKpqY+cgaq197tUfBHYWuMetxMmzgWRpZG
bJxEFCO4OBkrFBo1x9DlNk/SyOl1eDyTfH019gOZbUjCEoxdYhUeSKn333YmSsYy
SLnfEelUHjolaFXyAQ5ElamgkXiW1BDwIz8NZvYek97vChqvuUKCRzAi3RY83OY=
=C9ca
-----END PGP SIGNATURE-----

--IX4edXMD7HczJcpd--
