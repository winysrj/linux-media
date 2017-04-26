Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35120 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966103AbdDZTTD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 15:19:03 -0400
Received: by mail-io0-f175.google.com with SMTP id r16so9262689ioi.2
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 12:19:03 -0700 (PDT)
Message-ID: <1493234339.29587.15.camel@ndufresne.ca>
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        linux-media@vger.kernel.org
Date: Wed, 26 Apr 2017 15:18:59 -0400
In-Reply-To: <d597e386-4a6d-61d9-8e4b-61926d7a42c2@math.uni-bielefeld.de>
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
         <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
         <2541347.TzHdYYQVhG@avalon>
         <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
         <20170425222124.GA7456@valkosipuli.retiisi.org.uk>
         <1493218407.29587.9.camel@ndufresne.ca>
         <d597e386-4a6d-61d9-8e4b-61926d7a42c2@math.uni-bielefeld.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-AVM9pRhNF32i4YUOvfca"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-AVM9pRhNF32i4YUOvfca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 26 avril 2017 =C3=A0 18:52 +0200, Tobias Jakobi a =C3=A9crit=C2=
=A0:
> Hello again,
>=20
>=20
> Nicolas Dufresne wrote:
> > Le mercredi 26 avril 2017 =C3=A0 01:21 +0300, Sakari Ailus a =C3=A9crit=
 :
> > > Hi Marek,
> > >=20
> > > On Thu, Apr 20, 2017 at 01:23:09PM +0200, Marek Szyprowski wrote:
> > > > Hi Laurent,
> > > >=20
> > > > On 2017-04-20 12:25, Laurent Pinchart wrote:
> > > > > Hi Marek,
> > > > >=20
> > > > > (CC'ing Sakari Ailus)
> > > > >=20
> > > > > Thank you for the patches.
> > > > >=20
> > > > > On Thursday 20 Apr 2017 11:13:36 Marek Szyprowski wrote:
> > > > > > Dear all,
> > > > > >=20
> > > > > > This is an updated proposal for extending EXYNOS DRM API with g=
eneric
> > > > > > support for hardware modules, which can be used for processing =
image data
> > > > > > from the one memory buffer to another. Typical memory-to-memory=
 operations
> > > > > > are: rotation, scaling, colour space conversion or mix of them.=
 This is a
> > > > > > follow-up of my previous proposal "[RFC 0/2] New feature: Frame=
buffer
> > > > > > processors", which has been rejected as "not really needed in t=
he DRM
> > > > > > core":
> > > > > > http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg=
146286.html
> > > > > >=20
> > > > > > In this proposal I moved all the code to Exynos DRM driver, so =
now this
> > > > > > will be specific only to Exynos DRM. I've also changed the name=
 from
> > > > > > framebuffer processor (fbproc) to picture processor (pp) to avo=
id confusion
> > > > > > with fbdev API.
> > > > > >=20
> > > > > > Here is a bit more information what picture processors are:
> > > > > >=20
> > > > > > Embedded SoCs are known to have a number of hardware blocks, wh=
ich perform
> > > > > > such operations. They can be used in paralel to the main GPU mo=
dule to
> > > > > > offload CPU from processing grapics or video data. One of examp=
le use of
> > > > > > such modules is implementing video overlay, which usually requi=
res color
> > > > > > space conversion from NV12 (or similar) to RGB32 color space an=
d scaling to
> > > > > > target window size.
> > > > > >=20
> > > > > > The proposed API is heavily inspired by atomic KMS approach - i=
t is also
> > > > > > based on DRM objects and their properties. A new DRM object is =
introduced:
> > > > > > picture processor (called pp for convenience). Such objects hav=
e a set of
> > > > > > standard DRM properties, which describes the operation to be pe=
rformed by
> > > > > > respective hardware module. In typical case those properties ar=
e a source
> > > > > > fb id and rectangle (x, y, width, height) and destination fb id=
 and
> > > > > > rectangle. Optionally a rotation property can be also specified=
 if
> > > > > > supported by the given hardware. To perform an operation on ima=
ge data,
> > > > > > userspace provides a set of properties and their values for giv=
en fbproc
> > > > > > object in a similar way as object and properties are provided f=
or
> > > > > > performing atomic page flip / mode setting.
> > > > > >=20
> > > > > > The proposed API consists of the 3 new ioctls:
> > > > > > - DRM_IOCTL_EXYNOS_PP_GET_RESOURCES: to enumerate all available=
 picture
> > > > > > =C2=A0 processors,
> > > > > > - DRM_IOCTL_EXYNOS_PP_GET: to query capabilities of given pictu=
re
> > > > > > =C2=A0 processor,
> > > > > > - DRM_IOCTL_EXYNOS_PP_COMMIT: to perform operation described by=
 given
> > > > > > =C2=A0 property set.
> > > > > >=20
> > > > > > The proposed API is extensible. Drivers can attach their own, c=
ustom
> > > > > > properties to add support for more advanced picture processing =
(for example
> > > > > > blending).
> > > > > >=20
> > > > > > This proposal aims to replace Exynos DRM IPP (Image Post Proces=
sing)
> > > > > > subsystem. IPP API is over-engineered in general, but not reall=
y extensible
> > > > > > on the other side. It is also buggy, with significant design fl=
aws - the
> > > > > > biggest issue is the fact that the API covers memory-2-memory p=
icture
> > > > > > operations together with CRTC writeback and duplicating feature=
s, which
> > > > > > belongs to video plane. Comparing with IPP subsystem, the PP fr=
amework is
> > > > > > smaller (1807 vs 778 lines) and allows driver simplification (E=
xynos
> > > > > > rotator driver smaller by over 200 lines).
> >=20
> > Just a side note, we have written code in GStreamer using the Exnynos 4
> > FIMC IPP driver. I don't know how many, if any, deployment still exist
> > (Exynos 4 is relatively old now), but there exist userspace for the
> > FIMC driver.
>=20
> I was searching for this code, but I didn't find anything. Are you sure
> you really mean the FIMC IPP in Exynos DRM, and not just the FIMC driver
> from the V4L2 subsystem?

Oops, I manage to be unclear. Having two drivers on the same IP isn't
helping. We wrote code around the FIMC driver on V4L2 side. This
driver:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/media/platform/exynos4-is/fimc-m2m.c

And this code:

https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/gstv4=
l2transform.c

Unless I have miss-read, the proposal here is to deprecate the V4L side
and improve the DRM side=C2=A0(which I stand against in my reply).

>=20
>=20
> With best wishes,
> Tobias
>=20
>=20
>=20
> > We use this for color transformation (from tiled to
> > linear) and scaling. The FIMC driver is in fact quite stable in
> > upstream kernel today. The GScaler V4L2 M2M driver on Exynos 5 is
> > largely based on it and has received some maintenance to properly work
> > in GStreamer. unlike this DRM API, you can reuse the same userspace
> > code across multiple platforms (which we do already). We have also
> > integrated this driver in Chromium in the past (not upstream though).
> >=20
> > I am well aware that the blitter driver has not got much attention
> > though. But again, V4L2 offers a generic interface to userspace
> > application. Fixing this driver could enable some work like this one:
> >=20
> > https://bugzilla.gnome.org/show_bug.cgi?id=3D772766
> >=20
> > This work in progress feature is a generic hardware accelerated video
> > mixer. It has been tested with IMX.6 v4l2 m2m blitter driver (which I
> > believe is in staging right now). Again, unlike the exynos/drm, this
> > code could be reused between platforms.
> >=20
> > In general, the problem with the DRM approach is that it only targets
> > displays. We often need to use these IP block for stream pre/post
> > processing outside a "playback" use case.
> >=20
> > What I'd like so see instead here, is an approach that helps both world
> > =C2=A0instead of trying to win the control over the IP block. Renesas
> > development seems to lead toward the right direction by creating
> > drivers that can be both interfaced in DRM and V4L2. For IPP and
> > GScaler on Exynos, this would be a greater benefit and finally the code
> > could be shared, having a single place to fix when we find bugs.
> >=20
> > > > >=20
> > > > > This seems to be the kind of hardware that is typically supported=
 by V4L2.
> > > > > Stupid question, why DRM ?
> > > >=20
> > > > Let me elaborate a bit on the reasons for implementing it in Exynos=
 DRM:
> > > >=20
> > > > 1. we want to replace existing Exynos IPP subsystem:
> > > > =C2=A0- it is used only in some internal/vendor trees, not in open-=
source
> > > > =C2=A0- we want it to have sane and potentially extensible userspac=
e API
> > > > =C2=A0- but we don't want to loose its functionality
> > > >=20
> > > > 2. we want to have simple API for performing single image processin=
g
> > > > operation:
> > > > =C2=A0- typically it will be used by compositing window manager, th=
is means that
> > > > =C2=A0=C2=A0=C2=A0some parameters of the processing might change on=
 each vblank (like
> > > > =C2=A0=C2=A0=C2=A0destination rectangle for example). This api allo=
ws such change on each
> > > > =C2=A0=C2=A0=C2=A0operation without any additional cost. V4L2 requi=
res to reinitialize
> > > > =C2=A0=C2=A0=C2=A0queues with new configuration on such change, wha=
t means that a bunch of
> > > > =C2=A0=C2=A0=C2=A0ioctls has to be called.
> > >=20
> > > What do you mean by re-initialising the queue? Format, buffers or som=
ething
> > > else?
> > >=20
> > > If you need a larger buffer than what you have already allocated, you=
'll
> > > need to re-allocate, V4L2 or not.
> > >=20
> > > We also do lack a way to destroy individual buffers in V4L2. It'd be =
up to
> > > implementing that and some work in videobuf2.
> > >=20
> > > Another thing is that V4L2 is very stream oriented. For most devices =
that's
> > > fine as a lot of the parameters are not changeable during streaming,
> > > especially if the pipeline is handled by multiple drivers. That said,=
 for
> > > devices that process data from memory to memory performing changes in=
 the
> > > media bus formats and pipeline configuration is not very efficient
> > > currently, largely for the same reason.
> > >=20
> > > The request API that people have been working for a bit different use=
 cases
> > > isn't in mainline yet. It would allow more efficient per-request
> > > configuration than what is currently possible, but it has turned out =
to be
> > > far from trivial to implement.
> > >=20
> > > > =C2=A0- validating processing parameters in V4l2 API is really comp=
licated,
> > > > =C2=A0=C2=A0=C2=A0because the parameters (format, src&dest rectangl=
es, rotation) are being
> > > > =C2=A0=C2=A0=C2=A0set incrementally, so we have to either allow som=
e impossible,
> > > > transitional
> > > > =C2=A0=C2=A0=C2=A0configurations or complicate the configuration st=
eps even more (like
> > > > =C2=A0=C2=A0=C2=A0calling some ioctls multiple times for both input=
 and output). In the end
> > > > =C2=A0=C2=A0=C2=A0all parameters have to be again validated just be=
fore performing the
> > > > =C2=A0=C2=A0=C2=A0operation.
> > >=20
> > > You have to validate the parameters in any case. In a MC pipeline thi=
s takes
> > > place when the stream is started.
> > >=20
> > > >=20
> > > > 3. generic approach (to add it to DRM core) has been rejected:
> > > > http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg1462=
86.html
> > >=20
> > > For GPUs I generally understand the reasoning: there's a very limited=
 number
> > > of users of this API --- primarily because it's not an application
> > > interface.
> > >=20
> > > If you have a device that however falls under the scope of V4L2 (at l=
east
> > > API-wise), does this continue to be the case? Will there be only one =
or two
> > > (or so) users for this API? Is it the case here?
> > >=20
> > > Using a device specific interface definitely has some benefits: there=
's no
> > > need to think how would you generalise the interface for other simila=
r
> > > devices. There's no need to consider backwards compatibility as it's =
not a
> > > requirement. The drawback is that the applications that need to suppo=
rt
> > > similar devices will bear the burden of having to support different A=
PIs.
> > >=20
> > > I don't mean to say that you should ram whatever under V4L2 / MC
> > > independently of how unworkable that might be, but there are also cle=
ar
> > > advantages in using a standardised interface such as V4L2.
> > >=20
> > > V4L2 has a long history behind it and if it was designed today, I bet=
 it
> > > would look quite different from what it is now.
> > >=20
> > > >=20
> > > > 4. this api can be considered as extended 'blit' operation, other D=
RM
> > > > drivers
> > > > =C2=A0=C2=A0=C2=A0(MGA, R128, VIA) already have ioctls for such ope=
ration, so there is also
> > > > =C2=A0=C2=A0=C2=A0place in DRM for it
> >=20
> > Note that I am convince that using these custom IOCTL within a
> > "compositor" implementation is much easier and uniform compared to
> > using a v4l2 driver. It probably offers lower latency. But these are
> > non-generic and are not a great fit for streaming purpose. Request API
> > and probably explicit fence may mitigate this though. Meanwhile, there
> > is some indication that even though complex, there is already some
> > people that do think implementing a compositor combining V4L2 and DRM
> > is feasible.
> >=20
> > http://events.linuxfoundation.org/sites/events/files/slides/als2015_way
> > land_weston_v2.pdf
> >=20
> > >=20
> > > Added LMML to cc.
> >=20
> > Thanks.
> >=20
>=20
>=20
--=-AVM9pRhNF32i4YUOvfca
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlkA8qMACgkQcVMCLawGqBzFTgCfcBidthX4pELpzCSuxg50xvXA
tF0AoNrAbsekwxEnEtHV1CXw+VKHQmvd
=t3pl
-----END PGP SIGNATURE-----

--=-AVM9pRhNF32i4YUOvfca--
