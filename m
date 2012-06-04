Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:54495 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab2FDQnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 12:43:40 -0400
Received: by lbgc1 with SMTP id c1so3073366lbg.15
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 09:43:34 -0700 (PDT)
Date: Mon, 4 Jun 2012 19:41:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: balbi@ti.com, Bhupesh SHARMA <bhupesh.sharma@st.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <20120604164148.GA15476@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
 <20120604152831.GB20313@arwen.pp.htv.fi>
 <12753426.T5yg9NUgS1@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <12753426.T5yg9NUgS1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 04, 2012 at 06:40:46PM +0200, Laurent Pinchart wrote:
> Hi Felipe,
>=20
> On Monday 04 June 2012 18:28:33 Felipe Balbi wrote:
> > On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> > > On Monday, June 04, 2012 8:44 PM Felipe Balbi wrote:
> > > > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > > > This patch reworks the videobuffer management logic present in the
> > > > > UVC webcam gadget and ports it to use the "more apt" videobuf2
> > > > > framework for video buffer management.
> > > > >=20
> > > > > To support routing video data captured from a real V4L2 video cap=
ture
> > > > > device with a "zero copy" operation on videobuffers (as they pass=
 from
> > > > > the V4L2 domain to UVC domain via a user-space application), we n=
eed
> > > > > to support USER_PTR IO method at the UVC gadget side.
> > > > >=20
> > > > > So the V4L2 capture device driver can still continue to use MMAO =
IO
> > > > > method and now the user-space application can just pass a pointer=
 to
> > > > > the video buffers being DeQueued from the V4L2 device side while
> > > > > Queueing them at the UVC gadget end. This ensures that we have a
> > > > > "zero-copy" design as the videobuffers pass from the V4L2 capture
> > > > > device to the UVC gadget.
> > > > >
> > > > > Note that there will still be a need to apply UVC specific payload
> > > > > headers on top of each UVC payload data, which will still require=
 a
> > > > > copy operation to be performed in the 'encode' routines of the UVC
> > > > > gadget.
> > > > >
> > > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > > >=20
> > > > this patch doesn't apply. Please refresh on top of v3.5-rc1 or my g=
adget
> > > > branch which I will update in a while.
> > >=20
> > > I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> > > Should I now refresh my patches on top of your "v3.5-rc1" branch ?
> > >=20
> > > I am a bit confused on what is the latest gadget branch to be used no=
w.
> > > Thanks for helping out.
> >=20
> > The gadget branch is the branch called gadget on my kernel.org tree. For
> > some reason this didn't apply. Probably some patches on
> > drivers/usb/gadget/*uvc* went into v3.5 without my knowledge. Possibly
> > because I was out for quite a while and asked Greg to help me out during
> > the merge window.
> >=20
> > Anyway, I just pushed gadget with a bunch of new patches and part of
> > your series.
>=20
> I would have appreciated an occasion to review them first (especially 3/5=
=20
> which should *really* have been split into several patches) :-( Have they=
 been=20
> pushed to mainline yet ?

on my branch only, but I don't plan to rebase as that would screw up my
git objects.

> I'm currently traveling to Japan for LinuxCon so I won't have time to loo=
k=20
> into this before next week. I'll send incremental patches to fix issues w=
ith=20
> the already applied patches, *please* don't apply 4/5 and 5/5 before I ca=
n=20
> review them.

sure, no problem... Will wait.

--=20
balbi

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzOVLAAoJEIaOsuA1yqREApcP/1f/tFS2QjCgk/kfAHQ3eIr0
Sbm59/+ADvWRiwpxE++wsTWWY3KD3aMoYzF1bQlKShr1oZuvJxwNkh/nQExZ6keJ
gDiGDFBzbl8qjauvCAxPmM04S8yJb2zRd/Ko4hu09Ndpxg78OKinI+lFlGeNeMke
ci0UGG1bACqJS1snfBUDflCWs05wIyEC5v00IB9gZt4GF68w/SQlV4ObDm4yubJy
I8ndoMRQVFGonK6+9vJvcGb2oAJRhaFFQGxC4Xi5XqMhhYVAOdVnR8VxD1rIebUa
oYkZm96GjemjkW9ijczUYYGhHUBZLnIROm+8PnZhlPxgBQUrRnLfZMZDXDnEMP+m
6QmcaCyTtPgq4tfrJ6Aq7wqUKB2kYWRbMBe8BGUuK5I5whIVPMWvnZpnvWzF22Q9
gBhMZ+n5CVDuKnruK4wpvR3Gbc6BZ+T96gfYuFPVEzA4f1ytcvEfvgkkYAWAJ1QG
ke0yi1QhriMbQi602M1EU1F7qkcZMyRzI+lFFJBQ+lpFRfkFGsbxTuZEqrNKQw9h
KVD0hYx7p9sLCyazxAvLiHi2HhhmRywxGhVfIRvMFvK6/Vb7xGMqaRDQNJ7CU8Z9
1ti/pPDezXBjSj15noDLYVfxHhnUHbqYkXWKauxMbl/wHJ4aT4U/Ecj5AH29yIFf
JP235buaTChEcEqCEiSL
=pJBN
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
