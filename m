Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47911 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbeBSQTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 11:19:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Alexandre-Xavier =?ISO-8859-1?Q?Labont=E9=2DLamoureux?=
        <axdoomer@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
Date: Mon, 19 Feb 2018 18:19:55 +0200
Message-ID: <3383770.t3Sncl0gtc@avalon>
In-Reply-To: <alpine.DEB.2.20.1802191456110.8694@axis700.grange>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com> <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com> <alpine.DEB.2.20.1802191456110.8694@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, 19 February 2018 15:58:40 EET Guennadi Liakhovetski wrote:
> On Mon, 19 Feb 2018, Kieran Bingham wrote:
> > On 17/02/18 20:47, Alexandre-Xavier Labont=E9-Lamoureux wrote:
> >> Hi,
> >>=20
> >> I'm running Linux 4.9.0-5-amd64 on Debian. I built the drivers from
> >> the latest git and installed the modules.
> >=20
> > Could you please be specific here?
> >=20
> > Are you referring to linux-media/master branch or such? The latest from
> > Linus' tree?
> >=20
> > Please also detail the steps you have taken to reproduce this issue - a=
nd
> > of course - if you have made any code changes to make the latest UVC
> > module compile against a v4.9 kernel...
> >=20
> > Building the latest git tree and installing as a module on a v4.9 kernel
> > is quite a leap... I wouldn't have expected that to work.
> >=20
> > The code would have to be compiled against a v4.9 kernel directly, and I
> > didn't think compiling the UVC driver against older kernels worked.
> >=20
> > (at least it didn't work cleanly when I tried to compile v4.15 against a
> > v4.14 kernel last month)
> >=20
> >> Now, two device nodes are created for my webcam. This is not normal as
> >> it has never happened to me before. If I connect another webcam to my
> >> laptop, two more device nodes will be created for this webcam. So two
> >> new device nodes are created for a single webcam.
> >=20
> > I believe Guennadi's latest work for handling meta-data (in the latest
> > v4.16-rc1 I think) will create two device nodes.
>=20
> That's correct. The lower index node (/dev/video0) is a video node, the
> higher videoo node (/dev/video1) is a metadata node.
>=20
> > > The name of my webcam appears twice in the device comobox in Guvcview
> > > because of this. One of them will not work if I select it.
> >=20
> > It would be expected that only the device with video functions as a
> > streaming camera device, while the other would not.
>=20
> Exactly.
>=20
> > > My webcam has completely stopped working with Cheese and VLC.
> >=20
> > This part is of particular concern however.
> >=20
> > Guennadi - Have you tested Cheese/VLC with your series?
>=20
> Sure, with cheese you can specify which camera you need by using its
> --device=3D parameter. Eventually it's expected, that those programs will=
 be
> updated to recognise metadata nodes and not attempt to use them.

I've tested VLC (2.2.8) and haven't noticed any issue. If a program is=20
directed to the metadata video node and tries to capture video from it it w=
ill=20
obviously fail. That being said, software that work today should continue=20
working, otherwise it's a regression, and we'll have to handle that.

> > Are there any known issues that need looking at ?
> >=20
> >>> v4l2-ctl --list-devices
> >>=20
> >> Laptop_Integrated_Webcam_E4HD:  (usb-0000:00:1a.0-1.5):
> >>     /dev/video0
> >>     /dev/video1
> >>>=20
> >>> ls /dev/video*
> >>=20
> >> /dev/video0  /dev/video1

=2D-=20
Regards,

Laurent Pinchart
