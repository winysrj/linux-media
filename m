Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73144C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CE50217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfBRLUr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:20:47 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:37147 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfBRLUr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 06:20:47 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 0045320006;
        Mon, 18 Feb 2019 11:20:43 +0000 (UTC)
Date:   Mon, 18 Feb 2019 12:21:09 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for
 VIDIOC_SUBDEV_[GS]_ROUTING
Message-ID: <20190218112109.slu6kkcbwb6fn2hr@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
 <20190115235303.GG31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="he6c2bl5y2ngqiij"
Content-Disposition: inline
In-Reply-To: <20190115235303.GG31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--he6c2bl5y2ngqiij
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent, Sakari,

On Wed, Jan 16, 2019 at 01:53:03AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
>
> Thank you for the patch.
>
> On Fri, Nov 02, 2018 at 12:31:31AM +0100, Niklas S=C3=B6derlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >
> > Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
> > VIDIOC_SUBDEV_S_ROUTING IOCTLs.
>
> Let's instead design the ioctl in a way that doesn't require compat
> handling.
>

Care to explain what makes this ioctl require a compat version? I
don't see assumptions on the word length on the implementation. What
am I missing?

Thanks
  j

> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 77 +++++++++++++++++++
> >  1 file changed, 77 insertions(+)
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/me=
dia/v4l2-core/v4l2-compat-ioctl32.c
> > index 6481212fda772c73..83af332763f41a6b 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -1045,6 +1045,66 @@ static int put_v4l2_event32(struct v4l2_event __=
user *p64,
> >  	return 0;
> >  }
> >
> > +struct v4l2_subdev_routing32 {
> > +	compat_caddr_t routes;
> > +	__u32 num_routes;
> > +	__u32 reserved[5];
> > +};
> > +
> > +static int get_v4l2_subdev_routing(struct v4l2_subdev_routing __user *=
p64,
> > +				   struct v4l2_subdev_routing32 __user *p32)
> > +{
> > +	struct v4l2_subdev_route __user *routes;
> > +	compat_caddr_t p;
> > +	u32 num_routes;
> > +
> > +	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
> > +	    get_user(p, &p32->routes) ||
> > +	    get_user(num_routes, &p32->num_routes) ||
> > +	    put_user(num_routes, &p64->num_routes) ||
> > +	    copy_in_user(&p64->reserved, &p32->reserved,
> > +			 sizeof(p64->reserved)) ||
> > +	    num_routes > U32_MAX / sizeof(*p64->routes))
> > +		return -EFAULT;
> > +
> > +	routes =3D compat_ptr(p);
> > +
> > +	if (!access_ok(VERIFY_READ, routes,
> > +		       num_routes * sizeof(*p64->routes)))
> > +		return -EFAULT;
> > +
> > +	if (put_user((__force struct v4l2_subdev_route *)routes,
> > +		     &p64->routes))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static int put_v4l2_subdev_routing(struct v4l2_subdev_routing __user *=
p64,
> > +				   struct v4l2_subdev_routing32 __user *p32)
> > +{
> > +	struct v4l2_subdev_route __user *routes;
> > +	compat_caddr_t p;
> > +	u32 num_routes;
> > +
> > +	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
> > +	    get_user(p, &p32->routes) ||
> > +	    get_user(num_routes, &p64->num_routes) ||
> > +	    put_user(num_routes, &p32->num_routes) ||
> > +	    copy_in_user(&p32->reserved, &p64->reserved,
> > +			 sizeof(p64->reserved)) ||
> > +	    num_routes > U32_MAX / sizeof(*p64->routes))
> > +		return -EFAULT;
> > +
> > +	routes =3D compat_ptr(p);
> > +
> > +	if (!access_ok(VERIFY_WRITE, routes,
> > +		       num_routes * sizeof(*p64->routes)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> >  struct v4l2_edid32 {
> >  	__u32 pad;
> >  	__u32 start_block;
> > @@ -1117,6 +1177,8 @@ static int put_v4l2_edid32(struct v4l2_edid __use=
r *p64,
> >  #define VIDIOC_STREAMOFF32	_IOW ('V', 19, s32)
> >  #define VIDIOC_G_INPUT32	_IOR ('V', 38, s32)
> >  #define VIDIOC_S_INPUT32	_IOWR('V', 39, s32)
> > +#define VIDIOC_SUBDEV_G_ROUTING32 _IOWR('V', 38, struct v4l2_subdev_ro=
uting32)
> > +#define VIDIOC_SUBDEV_S_ROUTING32 _IOWR('V', 39, struct v4l2_subdev_ro=
uting32)
> >  #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
> >  #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
> >
> > @@ -1195,6 +1257,8 @@ static long do_video_ioctl(struct file *file, uns=
igned int cmd, unsigned long ar
> >  	case VIDIOC_STREAMOFF32: cmd =3D VIDIOC_STREAMOFF; break;
> >  	case VIDIOC_G_INPUT32: cmd =3D VIDIOC_G_INPUT; break;
> >  	case VIDIOC_S_INPUT32: cmd =3D VIDIOC_S_INPUT; break;
> > +	case VIDIOC_SUBDEV_G_ROUTING32: cmd =3D VIDIOC_SUBDEV_G_ROUTING; brea=
k;
> > +	case VIDIOC_SUBDEV_S_ROUTING32: cmd =3D VIDIOC_SUBDEV_S_ROUTING; brea=
k;
> >  	case VIDIOC_G_OUTPUT32: cmd =3D VIDIOC_G_OUTPUT; break;
> >  	case VIDIOC_S_OUTPUT32: cmd =3D VIDIOC_S_OUTPUT; break;
> >  	case VIDIOC_CREATE_BUFS32: cmd =3D VIDIOC_CREATE_BUFS; break;
> > @@ -1227,6 +1291,15 @@ static long do_video_ioctl(struct file *file, un=
signed int cmd, unsigned long ar
> >  		compatible_arg =3D 0;
> >  		break;
> >
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING:
> > +		err =3D alloc_userspace(sizeof(struct v4l2_subdev_routing),
> > +				      0, &new_p64);
> > +		if (!err)
> > +			err =3D get_v4l2_subdev_routing(new_p64, p32);
> > +		compatible_arg =3D 0;
> > +		break;
> > +
> >  	case VIDIOC_G_EDID:
> >  	case VIDIOC_S_EDID:
> >  		err =3D alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
> > @@ -1368,6 +1441,10 @@ static long do_video_ioctl(struct file *file, un=
signed int cmd, unsigned long ar
> >  		if (put_v4l2_edid32(new_p64, p32))
> >  			err =3D -EFAULT;
> >  		break;
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING:
> > +		err =3D put_v4l2_subdev_routing(new_p64, p32);
> > +		break;
> >  	}
> >  	if (err)
> >  		return err;
>
> --
> Regards,
>
> Laurent Pinchart

--he6c2bl5y2ngqiij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxqlSUACgkQcjQGjxah
VjxFtw/9GDoyvvanz/qsJJ3Rgf+zeW1fJ2Fx9a9lS9HRGNRtc7jKdmQhG0R61iOG
fhW8HG1s4neBIsOrJiB4M7QeKhX1KhUzO1p5YFXFKTBgNx9yFdU0Inaega88M1Jw
bHDS6SjGnMTCu7g570bEL9cSeRHMnFWgiabjjyGATB2/U1A17pLlnBGrgNGQ39t0
3eNQRaM1zDjAElNCOakCxI/TlldSMxVeG3soTY6P+vs3+VDO8GWOp2Ji0+KwrGQ5
1g2WyVkQaRC2p9GvRA7qXFqmddMhstFuOAwBUiGic0ZITZWqejsHA9hbonYpxuR0
cTQX0SlmDf6Ry1tlB+3qKyYKz8Y6BQO85E80WG5frZ7g4unNMjxtim7YkOYgcCRl
Ukea+k9Mk7xmdHDbJ5QttyOLoXjfTD0Xu/1imCNzP+eKqw9qX9DyP0f2nh1JaWKX
9o51Qd7JWRAakG8JuXoSt3aExGL/D7AwR26BOsMzKDEPNzsYgTTTKnPWd1UdM4Yf
lfC2XDKzTFtRJGOVYHAQj0HxaVtlcdeigIlkNpnLgA0lxan0pPaSSiR2AsD4v84/
/ZcHQjDPRYPf82s9cl2Ps3IE0O0Ju6s2tcput3cgUlUNP7kcJ2MNdk33pUtuK0AR
qkkxeLEC4lW+fg+QRuFzkG2Itne5hdP47mYS4WXAZn1zlCA3jfQ=
=Tab7
-----END PGP SIGNATURE-----

--he6c2bl5y2ngqiij--
