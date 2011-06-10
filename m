Return-path: <mchehab@pedra>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39387 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1FJM2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 08:28:38 -0400
Date: Fri, 10 Jun 2011 15:28:31 +0300
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
Message-ID: <20110610122829.GO31396@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110610002103.GA7169@xanatos>
 <4DF1CDE1.4080303@redhat.com>
 <20110610082158.GH31396@legolas.emea.dhcp.ti.com>
 <4DF1D79F.3020401@redhat.com>
 <20110610084224.GI31396@legolas.emea.dhcp.ti.com>
 <4DF20BC8.1060703@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UOYwgDhKKQYesrzQ"
Content-Disposition: inline
In-Reply-To: <4DF20BC8.1060703@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--UOYwgDhKKQYesrzQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 10, 2011 at 02:19:20PM +0200, Hans de Goede wrote:
> >>>>So what do we need to make this situation better:
> >>>>1) A usb_driver callback alternative to the disconnect callback,
> >>>>    I propose to call this soft_disconnect. This serves 2 purposes
> >>>>    a) It will allow the driver to tell the caller that that is not
> >>>>       a good idea by returning an error code (think usb mass storage
> >>>>       driver and mounted filesystem
> >>>
> >>>I'm not sure you even need a driver callback for that. Should we leave
> >>>that to Desktop manager ?
> >>
> >>Not sure what you mean here, but we need for a way for drivers to say
> >>no to a software caused disconnection. See my usb mass storage device
> >>which is still mounted getting redirected to a vm example. This cannot
> >
> >in that case, why don't you just flush all data and continue ? Also,
> >desktop manager knows that a particular device mounted, so it could also
> >ask the user if s/he wants to continue.
> >
> >I'm not sure preventing a disconnect is a good thing.
>=20
> I assume you are sure preventing data loss is a good thing? Because in
> this example the 2 are the same.
>=20
> Also note I'm not suggestion at always preventing the disconnect, I'm
> suggesting to add a new try_disconnect ioctl, which apps which want
> to behave nicely can use instead of the regular disconnect ioctl, and
> then drivers can prevent the disconnect. Apps using the old ioctl will
> still get an unconditional disconnect as before.

I'm just not sure if this should sit in the kernel. You can easily have
some sort of device manager (much like udisks for storage) to track this
down for ya. So instead of calling usbfs straight, you need to go via
the "device manager". This device manager should know that before
calling 'disconnect' it must be sure there's nothing pending.

> >>One could also argue that making the existing disconnect ioctl return
> >>-EBUSY in some cases now is an ABI change.
> >
> >OTOH, if the user really wants to move the usb device to the guest OS,
> >he has just requested for that, so should we prevent it ? what we need
> >is for the applications to be notified to exit cleanly and release the
> >device because the user has requested to do so. No ?
>=20
> We are talking about a device with a mounted file system on it here,
> any process could be holding files open on there, and there currently
> exists no mechanism to notify all apps to exit cleanly and release
> the files. Even if there were some method for a desktop environment
> like gnome to ask apps to release those files, and all gnome apps
> where to be modified to support that mechanism, then there are still
> 1000-s of non gnome (or kde, xfce, whatever) apps which will not
> support that.

Still, I'm not sure this is argument good enough to add another sort of
conflicting ioctl to the kernel. It won't prevent apps from calling the
other disconnect anyway. And besides, if an app can be modified to use
the try_disconnect ioctl, they can be modified for the system
notification (on userland) too, can't they ?

> We already have a mechanism to cleanly close down a filesystem, it
> is called unmount. And it will fail if apps have files open. All I'm
> suggesting is forwarding this ebusy failure to the application
> trying to disconnect the driver from the usb mass storage interface.
>=20
> Simply removing the filesystem from under apps holding files open will
> lead to io errors, and very unhappy apps.

Correct, but does the solution _have_ to sit in kernel ? I'm not sure.
If you add the try_disconnect ioctl and all applications one your
desktop, except one, are playing nice, you will still have problems. To
me, it sounds much nicer to add such things on userland alone, in a way
such that it doesn't matter if it's a usb storage, mmc card, or eSATA
drive. That should be hidden from apps IMHO.

--=20
balbi

--UOYwgDhKKQYesrzQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8g3tAAoJEAv8Txj19kN1XKsIAKyMIYOjV9ltwoenVc9oVPAO
yXfNCtlsQc+FMjRgfmCCQZRqr+KwiMAUGmLPXGLkw/aMpdA6WpPkd+rA50X40SEq
3nnPYrb2g4CNtZLJSzbo+jlGLJqFDq5RJ3WryfhBWhSR5S6iFTzRlkplcdJqeek+
OA5o6LvGXS69HcWA3O1swzqKV65SWwdWkMnEgN5Awe2232vkkzzke46VNxcQ2+YK
xUw0QzWJsg7rhpwQZkMsKAClpf/mmv268LsQiPzz1zLqsnWgkP4ZXrxXNSHB5fxj
41Tt44o0F3Wq//XS6UP6bwG4IXR2JuDTNEiO3MVKFyXAliOylpFacZvwOjAom/0=
=OvWl
-----END PGP SIGNATURE-----

--UOYwgDhKKQYesrzQ--
