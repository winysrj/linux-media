Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54206 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbeDEI0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 04:26:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Thu, 05 Apr 2018 11:26:45 +0300
Message-ID: <1571834.H8Xd6h4YlB@avalon>
In-Reply-To: <CAMuHMdXoprxZNP6KuYjcYW5EYjzAAFqNn6orK24pv7k_fO+i4A@mail.gmail.com>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <2180075.m4Wkig6IL5@avalon> <CAMuHMdXoprxZNP6KuYjcYW5EYjzAAFqNn6orK24pv7k_fO+i4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Thursday, 5 April 2018 10:33:55 EEST Geert Uytterhoeven wrote:
> On Wed, Apr 4, 2018 at 5:26 PM, Laurent Pinchart wrote:
> > On Thursday, 29 March 2018 14:30:39 EEST Maxime Ripard wrote:
> >> On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas S=F6derlund wrote:
> >> > +   switch (priv->lanes) {
> >> > +   case 1:
> >> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> >> > +           break;
> >> > +   case 2:
> >> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 |
> >> > PHYCNT_ENABLE_0;
> >> > +           break;
> >> > +   case 4:
> >> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 |
> >> > PHYCNT_ENABLE_2 |
> >> > +                   PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> >> > +           break;
> >> > +   default:
> >> > +           return -EINVAL;
> >> > +   }
> >>=20
> >> I guess you could have a simpler construct here using this:
> >>=20
> >> phycnt =3D PHYCNT_ENABLECLK;
> >>=20
> >> switch (priv->lanes) {
> >>=20
> >> case 4:
> >>       phycnt |=3D PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2;
> >>=20
> >> case 2:
> >>       phycnt |=3D PHYCNT_ENABLE_1;
> >>=20
> >> case 1:
> >>       phycnt |=3D PHYCNT_ENABLE_0;
> >>       break;
> >>=20
> >> default:
> >>       return -EINVAL;
> >>=20
> >> }
> >>=20
> >> But that's really up to you.
> >=20
> > Wouldn't Niklas' version generate simpler code as it uses direct
> > assignments ?
> Alternatively, you could check for a valid number of lanes, and use
> knowledge about the internal lane bits:
>=20
>     phycnt =3D PHYCNT_ENABLECLK;
>     phycnt |=3D (1 << priv->lanes) - 1;

If Niklas is fine with that, I like it too.

=2D-=20
Regards,

Laurent Pinchart
