Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39007 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab2FDPmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:42:44 -0400
Received: by lahi5 with SMTP id i5so3662414lah.0
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 08:42:38 -0700 (PDT)
Date: Mon, 4 Jun 2012 18:40:53 +0300
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
Message-ID: <20120604154052.GD20313@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
 <20120604151355.GA20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
 <20120604152831.GB20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Content-Disposition: inline
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4@EAPEX1MAIL1.st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 04, 2012 at 11:37:59PM +0800, Bhupesh SHARMA wrote:
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Monday, June 04, 2012 8:59 PM
> > To: Bhupesh SHARMA
> > Cc: balbi@ti.com; laurent.pinchart@ideasonboard.com; linux-
> > usb@vger.kernel.org; linux-media@vger.kernel.org;
> > gregkh@linuxfoundation.org
> > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
> > videobuf2 framework
> >=20
> > On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> > > Hi Felipe,
> > >
> > > > -----Original Message-----
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Monday, June 04, 2012 8:44 PM
> > > > To: Bhupesh SHARMA
> > > > Cc: laurent.pinchart@ideasonboard.com; linux-usb@vger.kernel.org;
> > > > balbi@ti.com; linux-media@vger.kernel.org;
> > > > gregkh@linuxfoundation.org
> > > > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to
> > > > use
> > > > videobuf2 framework
> > > >
> > > > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > > > This patch reworks the videobuffer management logic present in
> > the
> > > > UVC
> > > > > webcam gadget and ports it to use the "more apt" videobuf2
> > > > > framework for video buffer management.
> > > > >
> > > > > To support routing video data captured from a real V4L2 video
> > > > > capture device with a "zero copy" operation on videobuffers (as
> > > > > they pass
> > > > from
> > > > > the V4L2 domain to UVC domain via a user-space application), we
> > > > > need to support USER_PTR IO method at the UVC gadget side.
> > > > >
> > > > > So the V4L2 capture device driver can still continue to use MMAO
> > > > > IO method and now the user-space application can just pass a
> > > > > pointer to the video buffers being DeQueued from the V4L2 device
> > > > > side while Queueing them at the UVC gadget end. This ensures that
> > > > > we have a "zero-copy" design as the videobuffers pass from the
> > > > > V4L2 capture
> > > > device to the UVC gadget.
> > > > >
> > > > > Note that there will still be a need to apply UVC specific
> > payload
> > > > > headers on top of each UVC payload data, which will still require
> > > > > a copy operation to be performed in the 'encode' routines of the
> > > > > UVC
> > > > gadget.
> > > > >
> > > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > >
> > > > this patch doesn't apply. Please refresh on top of v3.5-rc1 or my
> > > > gadget branch which I will update in a while.
> > > >
> > >
> > > I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> > > Should I now refresh my patches on top of your "v3.5-rc1" branch ?
> > >
> > > I am a bit confused on what is the latest gadget branch to be used
> > now.
> > > Thanks for helping out.
> >=20
> > The gadget branch is the branch called gadget on my kernel.org tree.
> > For some reason this didn't apply. Probably some patches on
> > drivers/usb/gadget/*uvc* went into v3.5 without my knowledge. Possibly
> > because I was out for quite a while and asked Greg to help me out
> > during the merge window.
> >=20
> > Anyway, I just pushed gadget with a bunch of new patches and part of
> > your series.
> >=20
>=20
> Yes. I had sent two patches some time ago for drivers/usb/gadget/*uvc*.
> For one of them I received an *applied* message from you:

that was already applied long ago. ;-)

>=20
> > > usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buf=
fer' routine
>=20
> > > This patch removes the non-required spinlock acquire/release calls on
> > > 'queue->irqlock' from 'uvc_queue_next_buffer' routine.
> > >
> > > This routine is called from 'video->encode' function (which
> > translates
> > > to either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> > 'uvc_video.c'.
> > > As, the 'video->encode' routines are called with 'queue->irqlock'
> > > already held, so acquiring a 'queue->irqlock' again in
> > > 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> > >
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >=20
> > applied, thanks
>=20
> Not sure, if that can cause the merge conflict issue.
> So now, should I send a clean patchset on top of your 3.5-rc1 branch to e=
nsure
> the entire new patchset for drivers/usb/gadget/*uvc* is pulled properly?

Yes please, just give kernel.org about 20 minutes to sync all git
servers.

Just so you know, head on my gadget branch is:

commit fbcaba0e3dcec8451cccdc1fa92fcddbde2bc3f2
Author: Bhupesh Sharma <bhupesh.sharma@st.com>
Date:   Fri Jun 1 15:08:56 2012 +0530

    usb: gadget: uvc: Add super-speed support to UVC webcam gadget
   =20
    This patch adds super-speed support to UVC webcam gadget.
   =20
    Also in this patch:
        - We add the configurability to pass bInterval, bMaxBurst, mult
          factors for video streaming endpoint (ISOC IN) through module
          parameters.
   =20
        - We use config_ep_by_speed helper routine to configure video
          streaming endpoint.
   =20
    Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzNcEAAoJEIaOsuA1yqREflMQALYUHim4xpNKkbQI/O+exKmq
2eLjBLd6xSmyLtecJ5+f39CCpaY+teM8l03Fvx+TSmSOSUnp+Dhh25bbCb6LBMmL
MJM+/zjxURzoOWkMrcuTB1n57g3NlmarlhIWCppSIk3ym3OgMn/BRBKcQwOjyvm9
V0po6GOSY5SRuuJAZJ/kbWNOkugWiuTj3+UoTGJuw3UICX/GOHXxMrkQgDVotAfG
z37kuBZ2Kn5oos1EZkH4KIFssZsbUcw1MwswW7cmg9xhpcmwXZWmJ33Up+A+n1Dy
rBMxOpvcv13enunR6u7kD5prROmS9zK/acSN6fBdS5ODof+UuaH3BJjyZEv1vk8Y
ehNYBWfEi9HyVT1s7lJXZoQZaB0qopALdMH2HkapyUsNQcUIYuFmyXpucF4scGY2
DVXmvKZTQW/+teEVTw18IPFAtmEDa3g0blDn2PrHKwpyCJWcKGIpj3MuKwBASjhr
SQoIlfSvzf5w7SMUt1uXpyptJ7rXawdk47im6WGarJBBkQkE5zbXE5CZX8q4Mnj8
LnPSv2EHKUNA1hktyKKvYtGifDNFXwARpOD5hxQUyNHmI5sN4mjrkYFpVak1qTtD
pCUgRKS1RVbEBhoBXikJt3l6vGHG4FzK9P9DNKH/4nOEIlfIM6ISIQLKesHGtlpO
MgPvgwIG/wl23RR2mZ3o
=9OI7
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
