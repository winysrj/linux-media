Return-path: <mchehab@pedra>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33697 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab1FJImd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:42:33 -0400
Date: Fri, 10 Jun 2011 11:42:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org,
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
Message-ID: <20110610084224.GI31396@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
 <20110610082158.GH31396@legolas.emea.dhcp.ti.com>
 <4DF1D79F.3020401@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OfrWf2Fun5Ae4m0Y"
Content-Disposition: inline
In-Reply-To: <4DF1D79F.3020401@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--OfrWf2Fun5Ae4m0Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 10:36:47AM +0200, Hans de Goede wrote:
> >On Fri, Jun 10, 2011 at 09:55:13AM +0200, Hans de Goede wrote:
> >>Currently this will cause the usb mass storage driver to see a
> >>disconnect, and any possible still pending writes are lost ...
> >>
> >>This is IMHO unacceptable, but currently there is nothing we can
> >>do to avoid this.
> >>
> >>2) So called dual mode cameras are (cheap) stillcams often even
> >>without an lcdscreen viewfinder, and battery backed sram instead
> >>of flash, which double as a webcam. We have drivers for both the
> >>stillcam function of these (in libgphoto2, so using usbfs) as
> >>well as for the webcam function (v4l2 kernel drivers).
> >>
> >>These drivers work well, and are mature. Yet the user experience
> >>is rather poor. Under gnome the still-cam contents will be
> >>automatically be made available as a "drive" using a gvfs-gphoto2 fuse
> >>mount. This however involves sending a disconnect to the v4l2 kernel
> >>driver, and thus the /dev/video# node disappearing. So if a user
> >>wants to use the device as a webcam he/she needs to first go to
> >>nautilus and unmount the gvfs mount. Until that is done the user will
> >>simply get a message from an app like cheese that he has no webcam,
> >>not even an ebusy error, just that he has no such device.
> >
> >that sounds quite weird. Should only happen if still image and video
> >functions are on different configurations or different alt-settings of
> >the same interface. But if they are on same configurations and separate
> >interfaces, you should be able to bind gphoto to the still image
> >interface and v4l2 to the camera interface.
> >
> >How's the device setup ?
> >
>=20
> These are very cheap devices, and as such poorly designed. There still
> and webcam functionality is on the same interface. This is likely done
> this way because the devices cannot handle both functions at the same
> time.

ok got it.

> >>So what do we need to make this situation better:
> >>1) A usb_driver callback alternative to the disconnect callback,
> >>    I propose to call this soft_disconnect. This serves 2 purposes
> >>    a) It will allow the driver to tell the caller that that is not
> >>       a good idea by returning an error code (think usb mass storage
> >>       driver and mounted filesystem
> >
> >I'm not sure you even need a driver callback for that. Should we leave
> >that to Desktop manager ?
>=20
> Not sure what you mean here, but we need for a way for drivers to say
> no to a software caused disconnection. See my usb mass storage device
> which is still mounted getting redirected to a vm example. This cannot

in that case, why don't you just flush all data and continue ? Also,
desktop manager knows that a particular device mounted, so it could also
ask the user if s/he wants to continue.

I'm not sure preventing a disconnect is a good thing.

> be reliably done from userspace. Where as it is trivial to do this
> from kernel space. One could advocate to make the existing disconnect
> ioctl use the new soft_disconnect usb_driver callback instead of
> adding a new usbfs ioctl for this, but that means that a driver
> can block any and all userspace triggered disconnects. Where as
> having a new ioctl, means that apps which want to play nice can play
> nice, while keeping the possibility of a hard userspace initiated
> disconnect.
>=20
> One could also argue that making the existing disconnect ioctl return
> -EBUSY in some cases now is an ABI change.

OTOH, if the user really wants to move the usb device to the guest OS,
he has just requested for that, so should we prevent it ? what we need
is for the applications to be notified to exit cleanly and release the
device because the user has requested to do so. No ?

--=20
balbi

--OfrWf2Fun5Ae4m0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8djwAAoJEAv8Txj19kN1lOkH/3n5QtOpUc7ZSsQxqwyevcBe
dT3Do/RQNKGS/LlAS/4e3bl/pPY/R3YQ12xXLhanwG8GJoCSKns2dygVal2XJsal
06A1vWwrBn73zFyhL1eYG+Kr1sQBObE7UNBWrhjO6u9xHDwRPJc5IUm9DDOXYqUn
CSCTFANyGm/9/zj5QCIbaw8GF1kJFKaZKHha9sFNh86ZZZvZwqfahjxoe8H7pup5
dRD61s5YlnxsghSsOO1NnkpmmCA4Bl3rGgJcS7DfsKcbAzEPBh3pJ6Xm1KgknLlT
W8lsXm8+33qgcrLpGGykCOWTI0jz66CcweXHcWQv92YmKVvoGiOKwtd/ebBdoDs=
=cczZ
-----END PGP SIGNATURE-----

--OfrWf2Fun5Ae4m0Y--
