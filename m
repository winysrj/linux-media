Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37772 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759305AbeD0VrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 17:47:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/8] v4l: vsp1: Use SPDX license headers
Date: Sat, 28 Apr 2018 00:47:25 +0300
Message-ID: <9975058.6n0K4TYcZK@avalon>
In-Reply-To: <45a7f1d7-9802-9b3b-c964-2f37c113cc8e@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-2-laurent.pinchart+renesas@ideasonboard.com> <45a7f1d7-9802-9b3b-c964-2f37c113cc8e@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Saturday, 28 April 2018 00:25:51 EEST Kieran Bingham wrote:
> Hi Laurent,
>=20
> Thank you for the patch, and going through the whole driver for this upda=
te.
> On 22/04/18 23:34, Laurent Pinchart wrote:
> > Adopt the SPDX license identifier headers to ease license compliance
> > management. All files in the driver are licensed under the GPLv2+ except
> > for the vsp1_regs.h file which is licensed under the GPLv2. This is
> > likely an oversight, but fixing this requires contacting the copyright
> > owners and is out of scope for this patch.
>=20
> I agree that's out of scope for this patch, but it's not too exhaustive a
> list to correct at a later date:
>=20
> git shortlog -e -n -s -- ./drivers/media/platform/vsp1/vsp1_regs.h
>     19  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>      5  Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
>      3  Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>      2  Geert Uytterhoeven <geert+renesas@glider.be>
>      2  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>      1  Linus Torvalds <torvalds@linux-foundation.org>
>      1  Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>      1  Wolfram Sang <wsa+renesas@sang-engineering.com>
>=20
> (Both Geert and Linus are merge commits there)

I agree with you, I've sent a separate patch.

> > While at it fix the file descriptions to match file names where copy and
> > paste error occurred.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
>=20
> It's crazy that we have two types of comment style for the SPDX identifie=
r -
> but that's not a fault in this patch, so:
>=20
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> > ---
> >=20
> >  drivers/media/platform/vsp1/vsp1.h        | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_brx.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_brx.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_clu.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_clu.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_dl.c     | 8 ++------
> >  drivers/media/platform/vsp1/vsp1_dl.h     | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_drm.c    | 8 ++------
> >  drivers/media/platform/vsp1/vsp1_drm.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_drv.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_entity.c | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_entity.h | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hgo.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hgo.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hgt.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hgt.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_histo.c  | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_histo.h  | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hsit.c   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_hsit.h   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_lif.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_lif.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_lut.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_lut.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_pipe.c   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_pipe.h   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_regs.h   | 5 +----
> >  drivers/media/platform/vsp1/vsp1_rpf.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_rwpf.c   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_rwpf.h   | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_sru.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_sru.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_uds.c    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_uds.h    | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_video.c  | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_video.h  | 6 +-----
> >  drivers/media/platform/vsp1/vsp1_wpf.c    | 6 +-----
> >  37 files changed, 39 insertions(+), 186 deletions(-)

=2D-=20
Regards,

Laurent Pinchart
