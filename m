Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57972 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETMpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 08:45:43 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so543276eek.21
        for <linux-media@vger.kernel.org>; Tue, 20 May 2014 05:45:41 -0700 (PDT)
Date: Tue, 20 May 2014 14:43:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "Lin, Mengdong" <mengdong.lin@intel.com>,
	"Yang, Libin" <libin.yang@intel.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"Nikkanen, Kimmo" <kimmo.nikkanen@intel.com>,
	Greg KH <greg@kroah.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"Babu, Ramesh" <ramesh.babu@intel.com>,
	"Koul, Vinod" <vinod.koul@intel.com>,
	"Shankar, Uma" <uma.shankar@intel.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	"Girdwood, Liam R" <liam.r.girdwood@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [Intel-gfx] [RFC] set up an sync channel between audio and
 display driver (i.e. ALSA and DRM)
Message-ID: <20140520124325.GA6240@ulmo>
References: <F46914AEC2663F4A9BB62374E5EEF8F82B447059@SHSMSX101.ccr.corp.intel.com>
 <20140520100204.GM8790@phenom.ffwll.local>
 <20140520100438.GN8790@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20140520100438.GN8790@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 12:04:38PM +0200, Daniel Vetter wrote:
> Also adding dri-devel and linux-media. Please don't forget these lists for
> the next round.
> -Daniel
>=20
> On Tue, May 20, 2014 at 12:02:04PM +0200, Daniel Vetter wrote:
> > Adding Greg just as an fyi since we've chatted briefly about the avsink
> > bus. Comments below.
> > -Daniel
> >=20
> > On Tue, May 20, 2014 at 02:52:19AM +0000, Lin, Mengdong wrote:
> > > This RFC is based on previous discussion to set up a generic communic=
ation channel between display and audio driver and
> > > an internal design of Intel MCG/VPG HDMI audio driver. It's still an =
initial draft and your advice would be appreciated
> > > to improve the design.
> > >=20
> > > The basic idea is to create a new avsink module and let both drm and =
alsa depend on it.
> > > This new module provides a framework and APIs for synchronization bet=
ween the display and audio driver.
> > >=20
> > > 1. Display/Audio Client
> > >=20
> > > The avsink core provides APIs to create, register and lookup a displa=
y/audio client.
> > > A specific display driver (eg. i915) or audio driver (eg. HD-Audio dr=
iver) can create a client, add some resources
> > > objects (shared power wells, display outputs, and audio inputs, regis=
ter ops) to the client, and then register this
> > > client to avisink core. The peer driver can look up a registered clie=
nt by a name or type, or both. If a client gives
> > > a valid peer client name on registration, avsink core will bind the t=
wo clients as peer for each other. And we
> > > expect a display client and an audio client to be peers for each othe=
r in a system.
> > >=20
> > > int avsink_new_client ( const char *name,
> > >                             int type,   /* client type, display or au=
dio */
> > >                             struct module *module,
> > >                             void *context,
> > >                             const char *peer_name,
> > >                             struct avsink_client **client_ret);
> > >=20
> > > int avsink_free_client (struct avsink_client *client);
> >=20
> >=20
> > Hm, my idea was to create a new avsink bus and let vga drivers register
> > devices on that thing and audio drivers register as drivers. There's a =
bit
> > more work involved in creating a full-blown bus, but it has a lot of
> > upsides:
> > - Established infrastructure for matching drivers (i.e. audio drivers)
> >   against devices (i.e. avsinks exported by gfx drivers).
> > - Module refcounting.
> > - power domain handling and well-integrated into runtime pm.
> > - Allows integration into componentized device framework since we're
> >   dealing with a real struct device.
> > - Better decoupling between gfx and audio side since registration is do=
ne
> >   at runtime.
> > - We can attach drv private date which the audio driver needs.

I think this would be another case where the interface framework[0]
could potentially be used. It doesn't give you all of the above, but
there's no reason it couldn't be extended. Then again, adding too much
would end up duplicating more of the driver core, so if something really
heavy-weight is required here, then the interface framework is not the
best option.

[0]: https://lkml.org/lkml/2014/5/13/525

> > > On system boots, the avsink module is loaded before the display and a=
udio driver module. And the display and audio
> > > driver may be loaded on parallel.
> > > * If a specific display driver (eg. i915) supports avsink, it can cre=
ate a display client, add power wells and display
> > >   outputs to the client, and then register the display client to the =
avsink core. Then it may look up if there is any
> > >   audio client registered, by name or type, and may find an audio cli=
ent registered by some audio driver.
> > >=20
> > > * If an audio driver supports avsink, it usually should look up a reg=
istered display client by name or type at first,
> > >   because it may need the shared power well in GPU and check the disp=
lay outputs' name to bind the audio inputs. If
> > >   the display client is not registered yet, the audio driver can choo=
se to wait (maybe in a work queue) or return
> > >   -EAGAIN for a deferred probe. After the display client is found, th=
e audio driver can register an audio client with

-EPROBE_DEFER is the correct error code for deferred probing.

> > > 6. Display register operation (optional)
> > >=20
> > > Some audio driver needs to access GPU audio registers. The register o=
ps are provided by the peer display client.
> > >=20
> > > struct avsink_registers_ops {
> > >          int (*read_register) (uint32_t reg_addr, uint32_t *data, voi=
d *context);
> > >          int (*write_register) (uint32_t reg_addr, uint32_t data, voi=
d *context);
> > >          int (*read_modify_register) (uint32_t reg_addr, uint32_t dat=
a, uint32_t mask, void *context);
> > >=20
> > > int avsink_define_reg_ops (struct avsink_client *client, struct avsin=
k_registers_ops *ops);
> > >=20
> > > And avsink core provides API for the audio driver to access the displ=
ay registers:
> > >=20
> > > int avsink_read_display_register(struct avsink_client *client , uint3=
2_t offset, uint32_t *data);
> > > int avsink_write_display_register(struct avsink_client *client , uint=
32_t offset, uint32_t data);
> > > int avsink_read_modify_display_register(struct avsink_client *client,=
 uint32_t offset, uint32_t data, uint32_t mask);
> > >=20
> > > If the client is an audio client, the avsink core will find it peer d=
isplay client and call its register ops;
> > > and if the client is a display client, the avsink core will just call=
 its own register ops.
> >=20
> > Oh dear. Where do we need this? Imo this is really horrible, but if we
> > indeed need this then a struct device is better - we can attach mmio
> > resources to devices and let the audio side remap them as best as they =
see
> > fit.

Can't this just be put behind an explicit API that does what the
register writes would do? If you share an MMIO region between drivers
you always need to make sure that they don't step on each others' toes.
An explicity API can easily take care of that.

Thierry

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe03tAAoJEN0jrNd/PrOhRwQP/25HaVQpLkb3JZwEkE4PzRAo
B/2FDVI6qtwO4CtJSORlUcU9JhDbKoTLidj9oB0MyDk3mQgwlXiUyveWdohxFakQ
rW3rvejA5eaRl9cxwNItbFvmI+8MzNjtciz2tmXD+78TUwRGPiV6cxeKkf69Gtlc
0CSKQfaK29v44/AXXzrJtlpafjJDXHZgFo1i0C/pIzNi5RJZaFWTzQXPr+Xsaq7e
FOawKLwDaP42UCKVnO5c/F77HrcBi4w4cGV7xkXgJpIr46sT9Xe3vui4dB8q0DXZ
9UDIXcbVXG8MbqB/tvT+s6dIdear15LtDYGwhw/Wy4oqF1A4HO6U5abd1QAMHrUl
MMT9nqF1aI1UqN5n9gKpRP1v7DOarzW8nadZfUj4HYwDqrka+xYu8qI9Ky0QHNuD
WlhhnhTpnHRzfnS1RB6DD9VLKMu8uLQ7a+cqtwnm0Azd0hI+tUKxrJo5Q8WOjnLr
YRU9M+B7ZV4RtPXt1omLJPNIp7SofAXmYCrV3GHXp9LpNu+onW3Pt+/NZeVdX06b
QwzlK/0BmNgsDs1zH9G3CUFlKdvBJbYokTNsQE2p6J6U1tsr1Gpxw4bj7+8yUKQd
vmUlXWH4hlUrLOVA7aMZ739jp5ahD2JWbUghowSi+NE4z/luesHEPHMAZf1Q/eOV
SwiMITZ1ptLNlYmX+63v
=opo4
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
