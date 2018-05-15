Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbeEOVpU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 17:45:20 -0400
Date: Tue, 15 May 2018 18:45:06 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 0/6] Asynchronous UVC
Message-ID: <20180515184451.51e539b7@vento.lan>
In-Reply-To: <91961caf-0f0b-fa58-ea01-b3dd37b67e88@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
        <20180515162233.2937906e@vento.lan>
        <91961caf-0f0b-fa58-ea01-b3dd37b67e88@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 May 2018 21:19:50 +0100
Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:

> Hi Mauro,
>=20
> On 15/05/18 20:22, Mauro Carvalho Chehab wrote:
> > Em Tue, 27 Mar 2018 17:45:57 +0100
> > Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:
> >  =20
> >> The Linux UVC driver has long provided adequate performance capabiliti=
es for
> >> web-cams and low data rate video devices in Linux while resolutions we=
re low.
> >>
> >> Modern USB cameras are now capable of high data rates thanks to USB3 w=
ith
> >> 1080p, and even 4k capture resolutions supported.
> >>
> >> Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BR=
IO
> >> (isochronous transfers) can generate more data than an embedded ARM co=
re is
> >> able to process on a single core, resulting in frame loss.
> >>
> >> A large part of this performance impact is from the requirement to
> >> =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination fr=
ames. This unfortunate
> >> requirement is due to the UVC protocol allowing a variable length head=
er, and
> >> thus it is not possible to provide the target frame buffers directly.
> >>
> >> Extra throughput is possible by moving the actual memcpy actions to a =
work
> >> queue, and moving the memcpy out of interrupt context thus allowing wo=
rk tasks
> >> to be scheduled across multiple cores.
> >>
> >> This series has been tested on both the ZED and BRIO cameras on arm64
> >> platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a So=
nix USB2
> >> Camera, and a built in Toshiba Laptop camera, and with thanks to Phili=
pp Zabel
> >> for testing on a Lite-On internal Laptop Webcam, Logitech C910 (USB2 i=
soc),
> >> Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).
> >>
> >> As far as I am aware iSight devices, and devices which use UVC to enco=
de data
> >> (output device) have not yet been tested - but should find no ill effe=
ct (at
> >> least not until they are tested of course :D )
> >>
> >> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> >> Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
> >>
> >> v2:
> >>  - Fix race reported by Guennadi
> >>
> >> v3:
> >>  - Fix similar race reported by Laurent
> >>  - Only queue work if required (encode/isight do not queue work)
> >>  - Refactor/Rename variables for clarity
> >>
> >> v4:
> >>  - (Yet another) Rework of the uninitialise path.
> >>    This time to hopefully clean up the shutdown races for good.
> >>    use usb_poison_urb() to halt all URBs, then flush the work queue
> >>    before freeing.
> >>  - Rebase to latest linux-media/master =20
> >=20
> > Kieran/Laurent,
> >=20
> > What's the status of this patchset? =20
>=20
> I believe v4 was my final version (until someone tells me otherwise), and=
 fixed
> all known races. Unless there has been bitrot since I posted  (was last r=
ebased
> at v4.16-rc4 ?) ...
>=20
> It would be good to at least get it in -next for a while if not mainline.=
..
>=20
> Laurent ?
>=20
> The latest version is available in a branch at :
>   git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git uvc/asy=
nc/v4
>=20
> Let me know if I need to post a rebased version.

=46rom my side, if there are just minor conflicts, no need to rebase, but
Laurent should ack if I'm willing to pick from your git tree. If he
acks, please send a pull request with git pull-request. Both patchwork
regex parser and my scripts rely on the exact format produced by git.

Regards,
Mauro
