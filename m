Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:46975 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716Ab2FDPaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:30:21 -0400
Received: by lbbgk8 with SMTP id gk8so3610218lbb.26
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 08:30:18 -0700 (PDT)
Date: Mon, 4 Jun 2012 18:28:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <20120604152831.GB20313@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
 <20120604151355.GA20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> Hi Felipe,
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Monday, June 04, 2012 8:44 PM
> > To: Bhupesh SHARMA
> > Cc: laurent.pinchart@ideasonboard.com; linux-usb@vger.kernel.org;
> > balbi@ti.com; linux-media@vger.kernel.org; gregkh@linuxfoundation.org
> > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
> > videobuf2 framework
> >=20
> > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > This patch reworks the videobuffer management logic present in the
> > UVC
> > > webcam gadget and ports it to use the "more apt" videobuf2 framework
> > > for video buffer management.
> > >
> > > To support routing video data captured from a real V4L2 video capture
> > > device with a "zero copy" operation on videobuffers (as they pass
> > from
> > > the V4L2 domain to UVC domain via a user-space application), we need
> > > to support USER_PTR IO method at the UVC gadget side.
> > >
> > > So the V4L2 capture device driver can still continue to use MMAO IO
> > > method and now the user-space application can just pass a pointer to
> > > the video buffers being DeQueued from the V4L2 device side while
> > > Queueing them at the UVC gadget end. This ensures that we have a
> > > "zero-copy" design as the videobuffers pass from the V4L2 capture
> > device to the UVC gadget.
> > >
> > > Note that there will still be a need to apply UVC specific payload
> > > headers on top of each UVC payload data, which will still require a
> > > copy operation to be performed in the 'encode' routines of the UVC
> > gadget.
> > >
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> >=20
> > this patch doesn't apply. Please refresh on top of v3.5-rc1 or my
> > gadget branch which I will update in a while.
> >=20
>=20
> I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> Should I now refresh my patches on top of your "v3.5-rc1" branch ?
>=20
> I am a bit confused on what is the latest gadget branch to be used now.
> Thanks for helping out.

The gadget branch is the branch called gadget on my kernel.org tree. For
some reason this didn't apply. Probably some patches on
drivers/usb/gadget/*uvc* went into v3.5 without my knowledge. Possibly
because I was out for quite a while and asked Greg to help me out during
the merge window.

Anyway, I just pushed gadget with a bunch of new patches and part of
your series.

--=20
balbi

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzNQfAAoJEIaOsuA1yqREDVIP/2vjQKm7RNgCHtWaDJq9q6Tt
poA4pTf9AWer+4/Aso8mu1w1CyNA0FEx0sFvFpX7ljS9F8gKkrae+bec/Q6vQ7P7
OkL4xHujOyof/VrfrIReXArq8lpp1JqhwIEZKdcCrnMHaGP96S/Vxi23FHSA/IcC
FPE6ztuNfJ+rcQYKS1ImgufEQmRup1r4xxn0Jc6uaMz0Qr2tzWqgsRwxdjSFPj32
Y0G9V3xyIf4bwPK+btQExnpg6Bwu7CxV+t7+a5eYjY/DBOvDec9oPYLrZqgCbObp
AW/rzXGQr8Hdq15AfgwBbQEai4BN+4cfoD5gWoBQtKhfOTIzmKHKi/POmiYdi7nX
LQ11iz5g+fIVGNwF06H9Ng6K42BDklMbLGRZovpVnoePIaz7dV5iBObMIBuxLUdZ
C8muMuRGUNsKBcVb3Z/+fQs34/IHVpTgk1ZYQ4MewfDfFr773Ni4RtX1itKuqvz0
bbeOoeFvU8FHNvjuSu0/qJz9As/laJL8iXymEFFKYA9QlN3B0APskLBej9Hqu+LM
gv3G877lS2wIC3eG47Oicq3JbACr2Ko9J2S/NdtA+qgcOrbpuqylaHe9cz0sDYS8
6Y7p+kGo15cuQVWS7U6rsPxA6LXfg9rMR+KlLW7wZi4T+ebYa3kQSqh97nmS7LNy
blF2ph8GLZ7gbK7Jn+U7
=6h3C
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
