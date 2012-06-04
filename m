Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:52271 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368Ab2FDPiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:38:15 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 4 Jun 2012 23:37:59 +0800
Subject: RE: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
 <20120604151355.GA20313@arwen.pp.htv.fi>
 <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
 <20120604152831.GB20313@arwen.pp.htv.fi>
In-Reply-To: <20120604152831.GB20313@arwen.pp.htv.fi>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4EAPEX1MAIL1st_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4EAPEX1MAIL1st_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Monday, June 04, 2012 8:59 PM
> To: Bhupesh SHARMA
> Cc: balbi@ti.com; laurent.pinchart@ideasonboard.com; linux-
> usb@vger.kernel.org; linux-media@vger.kernel.org;
> gregkh@linuxfoundation.org
> Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
> videobuf2 framework
>=20
> On Mon, Jun 04, 2012 at 11:21:13PM +0800, Bhupesh SHARMA wrote:
> > Hi Felipe,
> >
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Monday, June 04, 2012 8:44 PM
> > > To: Bhupesh SHARMA
> > > Cc: laurent.pinchart@ideasonboard.com; linux-usb@vger.kernel.org;
> > > balbi@ti.com; linux-media@vger.kernel.org;
> > > gregkh@linuxfoundation.org
> > > Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to
> > > use
> > > videobuf2 framework
> > >
> > > On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > > > This patch reworks the videobuffer management logic present in
> the
> > > UVC
> > > > webcam gadget and ports it to use the "more apt" videobuf2
> > > > framework for video buffer management.
> > > >
> > > > To support routing video data captured from a real V4L2 video
> > > > capture device with a "zero copy" operation on videobuffers (as
> > > > they pass
> > > from
> > > > the V4L2 domain to UVC domain via a user-space application), we
> > > > need to support USER_PTR IO method at the UVC gadget side.
> > > >
> > > > So the V4L2 capture device driver can still continue to use MMAO
> > > > IO method and now the user-space application can just pass a
> > > > pointer to the video buffers being DeQueued from the V4L2 device
> > > > side while Queueing them at the UVC gadget end. This ensures that
> > > > we have a "zero-copy" design as the videobuffers pass from the
> > > > V4L2 capture
> > > device to the UVC gadget.
> > > >
> > > > Note that there will still be a need to apply UVC specific
> payload
> > > > headers on top of each UVC payload data, which will still require
> > > > a copy operation to be performed in the 'encode' routines of the
> > > > UVC
> > > gadget.
> > > >
> > > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > >
> > > this patch doesn't apply. Please refresh on top of v3.5-rc1 or my
> > > gadget branch which I will update in a while.
> > >
> >
> > I rebased and submitted my changes on your "gadget-for-v3.5" tag.
> > Should I now refresh my patches on top of your "v3.5-rc1" branch ?
> >
> > I am a bit confused on what is the latest gadget branch to be used
> now.
> > Thanks for helping out.
>=20
> The gadget branch is the branch called gadget on my kernel.org tree.
> For some reason this didn't apply. Probably some patches on
> drivers/usb/gadget/*uvc* went into v3.5 without my knowledge. Possibly
> because I was out for quite a while and asked Greg to help me out
> during the merge window.
>=20
> Anyway, I just pushed gadget with a bunch of new patches and part of
> your series.
>=20

Yes. I had sent two patches some time ago for drivers/usb/gadget/*uvc*.
For one of them I received an *applied* message from you:

> > usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffe=
r' routine

> > This patch removes the non-required spinlock acquire/release calls on
> > 'queue->irqlock' from 'uvc_queue_next_buffer' routine.
> >
> > This routine is called from 'video->encode' function (which
> translates
> > to either 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in
> 'uvc_video.c'.
> > As, the 'video->encode' routines are called with 'queue->irqlock'
> > already held, so acquiring a 'queue->irqlock' again in
> > 'uvc_queue_next_buffer' routine causes a spin lock recursion.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> applied, thanks

Not sure, if that can cause the merge conflict issue.
So now, should I send a clean patchset on top of your 3.5-rc1 branch to ens=
ure
the entire new patchset for drivers/usb/gadget/*uvc* is pulled properly?

Thanks,
Bhupesh


--_002_D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4EAPEX1MAIL1st_
Content-Type: message/rfc822

Received: from epsilon.dmz-eu.st.com (164.129.230.7) by eapex1hubcas3.st.com
 (10.80.176.7) with Microsoft SMTP Server id 8.3.192.1; Wed, 28 Mar 2012
 16:48:11 +0800
Received: from alpha.dmz-eu.st.com (alpha.dmz-eu.st.com [164.129.1.34])	by
 epsilon.dmz-eu.st.com (STMicroelectronics) with ESMTP id 26623A3	for
 <bhupesh.sharma@st.com>; Wed, 28 Mar 2012 08:49:07 +0000 (GMT)
Received: from psmtp.com (eu1sys200amx105.postini.com [207.126.144.54])	(using
 TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))	(No client certificate
 requested)	by alpha.dmz-eu.st.com (STMicroelectronics) with ESMTP id F25325B
	for <bhupesh.sharma@st.com>; Wed, 28 Mar 2012 08:49:05 +0000 (GMT)
Received: from na3sys009aog106.obsmtp.com ([74.125.149.76]) (using TLSv1) by
 eu1sys200amx105.postini.com ([207.126.147.10]) with SMTP;	Wed, 28 Mar 2012
 11:49:06 EEST
Received: from mail-bk0-f53.google.com ([209.85.214.53]) (using TLSv1) by
 na3sys009aob106.postini.com ([74.125.148.12]) with SMTP	ID
 DSNKT3LQf5wotCpKHY6DgGhqkeVSWwwaBoDH@postini.com; Wed, 28 Mar 2012 01:49:06
 PDT
Received: by mail-bk0-f53.google.com with SMTP id j4so764385bkw.40        for
 <bhupesh.sharma@st.com>; Wed, 28 Mar 2012 01:49:03 -0700 (PDT)
Received: by 10.204.9.205 with SMTP id m13mr11337178bkm.68.1332924543032;
        Wed, 28 Mar 2012 01:49:03 -0700 (PDT)
Received: from localhost (cs78217178.pp.htv.fi. [62.78.217.178])        by
 mx.google.com with ESMTPS id z17sm4761622bkw.12.2012.03.28.01.49.01
        (version=TLSv1/SSLv3 cipher=OTHER);        Wed, 28 Mar 2012 01:49:01
 -0700 (PDT)
From: Felipe Balbi <balbi@ti.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
CC: "balbi@ti.com" <balbi@ti.com>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>, spear-devel <spear-devel@list.st.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 28 Mar 2012 16:48:33 +0800
Subject: Re: [PATCH V2] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
Thread-Topic: [PATCH V2] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
Thread-Index: Ac0Mv4IM5v3D+0AZTZqYp089nWGn6w==
Message-ID: <20120328084832.GC18156@arwen.pp.htv.fi>
References: 
 <85d9f5b7f8946b44389ba3a592c00d0f6405a9eb.1332520342.git.bhupesh.sharma@st.com>
In-Reply-To: 
 <85d9f5b7f8946b44389ba3a592c00d0f6405a9eb.1332520342.git.bhupesh.sharma@st.com>
Reply-To: "balbi@ti.com" <balbi@ti.com>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: Eapex1hubcas3.st.com
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
x-pstn-levels: (S:99.90000/99.90000 CV:99.9000 FC:95.5390 LC:95.5390
 R:95.9108 P:95.9108 M:97.0282 C:98.6951 )
x-pstn-neptune: 0/0/0.00/0
x-pstn-settings: 2 (0.5000:0.0500) s cv GT3 gt2 gt1 
x-pstn-addresses: from <balbi@ti.com> [db-null] 
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
MIME-Version: 1.0

--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 23, 2012 at 10:23:13PM +0530, Bhupesh Sharma wrote:
> This patch removes the non-required spinlock acquire/release calls on
> 'queue->irqlock' from 'uvc_queue_next_buffer' routine.
>=20
> This routine is called from 'video->encode' function (which translates to=
 either
> 'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
> As, the 'video->encode' routines are called with 'queue->irqlock' already=
 held,
> so acquiring a 'queue->irqlock' again in 'uvc_queue_next_buffer' routine =
causes
> a spin lock recursion.
>=20
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

applied, thanks

--=20
balbi

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPctBgAAoJEIaOsuA1yqREh1IP/3XD+UsLfq6jys7qivaIMHQ7
gH1X4G2apIeJQyIbVWuuIv4WEGmoQzkZZFjQI7cUApNAAV1fXOFVUcnOXMv/rdZ3
s7wglJv05EAHCt2fK/mP4QVYKRnXVSXZqQKTtNpRstKPzotRcVAe8jNTo0rOX403
APe1avgdmP+N2oGi4d/Uq85kBuY4Uu04WJfcURmx7A8coydCTw+6yCT0xoRMFFHR
c1HB58z3xTxW58Yg3gAGu61GG4q5Jlsj/cCSMnHt9R2Vg1nh41pIozsCpbwSAWGE
DrVJvUhP7b0YT/gHseSBJ/E40UPhf7P2u5K6Y6HFin2mm2puGB64J8H6sQw48hP6
hL8MZFS/2Ztr9gB4lHuIcRBrPdrlYLsd4WpSyN+h2KJ2A/kHicq/sfYqfE3lnOW1
vjhg1H4oLzBS/m8kDSg3yGkz6vDq/akEInwtlG5NIZNRUbCjPLbhTkldaAqmYUc0
kj3WWwVUxXuNwblUS5E4O+yzbF2sI45tF2Fx3vphBAd/X/AhcErEC1+xnWZZPM0o
E8CU+h9BPDrKNmVb1OKULor+mtDA4M10qKYTnPCE43GryboMLKyO4if3X/WUOg+b
X3vLW+o3lh0UqF+yNEOYC6/AQBnUSQab0FkzMIvmA06ub44C4lqeZFIXiN8FgAbL
44RHZunWJxgatbC8vaQK
=iIof
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--

--_002_D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF4EAPEX1MAIL1st_--
