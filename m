Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE47C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6D420881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfA1Icz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:32:55 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:36393 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfA1Icy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:32:54 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id C8806240018;
        Mon, 28 Jan 2019 08:32:49 +0000 (UTC)
Date:   Mon, 28 Jan 2019 09:33:04 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com
Subject: Re: [PATCH] media: ov5640: Fix set 15fps regression
Message-ID: <20190128083304.nxuvxecrcq63v2vn@uno.localdomain>
References: <20190124175801.28018-1-jagan@amarulasolutions.com>
 <20190125153958.3aertsxgdzjldlzd@flea>
 <CAMty3ZCuBqiOGAixWhy5bYqUHk0_=NvX08zp2F+MT4GgVEo+Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y2wz7z6pl7dcejld"
Content-Disposition: inline
In-Reply-To: <CAMty3ZCuBqiOGAixWhy5bYqUHk0_=NvX08zp2F+MT4GgVEo+Rw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--y2wz7z6pl7dcejld
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi everyone,

On Mon, Jan 28, 2019 at 01:20:37PM +0530, Jagan Teki wrote:
> On Fri, Jan 25, 2019 at 9:10 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > On Thu, Jan 24, 2019 at 11:28:01PM +0530, Jagan Teki wrote:
> > > The ov5640_try_frame_interval operation updates the FPS as per user
> > > input based on default ov5640_frame_rate, OV5640_30_FPS which is failed
> > > to update when user trigger 15fps.
> > >
> > > So, initialize the default ov5640_frame_rate to OV5640_15_FPS so-that
> > > it can satisfy to update all fps.
> > >
> > > Fixes: 5a3ad937bc78 ("media: ov5640: Make the return rate type more explicit")
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> >
> > I'm pretty sure I tested this and it was working fine. You're
> > mentionning a regression, but what regression is there exactly (ie,
> > what was working before that commit that doesn't work anymore?). What
> > tools/commands are you using to see this behaviour?
>

I think Jagan's right, here.

For the 15FPS use case, the below condition in the for loop of
ov5640_try_frame_interval() never gets satisfied (0 < 0 ?) and 'rate' retains
its initial value of 30FPS.

		if (abs(curr_fps - fps) < abs(best_fps - fps)) {
			best_fps = curr_fps;
			rate = i;
		}

To make more clear what's happening, I would initialize 'rate' just
before 'best_fps' before the for loop. Anyway, please add:
Acked-by: Jacopo Mondi <jacopo@jmondi.org>

Maxime, does this make sense to you?

Thanks
   j


> In fact I have mentioned this on your v9 [1], may be you missed it.
>
> I have reproduced with media-ctl, below is the full log. let me know
> if I still miss anything.
>
> Before this change:
> # media-ctl -p
> Media controller API version 5.0.0
>
> Media device information
> ------------------------
> driver          sun6i-csi
> model           Allwinner Video Capture Device
> serial
> bus info
> hw revision     0x0
> driver version  5.0.0
>
> Device topology
> - entity 1: sun6i-csi (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Sink
>                 <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]
>
> - entity 5: ov5640 1-003c (1 pad, 1 link)
>             type V4L2 subdev subtype Sensor flags 0
>             device node name /dev/v4l-subdev0
>         pad0: Source
>                 [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
> xfer:srgb ycbcr:601 quantization:full-range]
>                 -> "sun6i-csi":0 [ENABLED,IMMUTABLE]
>
> # media-ctl --set-v4l2 "'ov5640 1-003c':0[fmt:UYVY8_2X8/640x480@1/15 field:none]
> "
> # media-ctl -p
> Media controller API version 5.0.0
>
> Media device information
> ------------------------
> driver          sun6i-csi
> model           Allwinner Video Capture Device
> serial
> bus info
> hw revision     0x0
> driver version  5.0.0
>
> Device topology
> - entity 1: sun6i-csi (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Sink
>                 <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]
>
> - entity 5: ov5640 1-003c (1 pad, 1 link)
>             type V4L2 subdev subtype Sensor flags 0
>             device node name /dev/v4l-subdev0
>         pad0: Source
>                 [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
> xfer:srgb ycbcr:601 quantization:full-range]
>                 -> "sun6i-csi":0 [ENABLED,IMMUTABLE]
>
>
> After this change:
> # media-ctl -p
> Media controller API version 5.0.0
>
> Media device information
> ------------------------
> driver          sun6i-csi
> model           Allwinner Video Capture Device
> serial
> bus info
> hw revision     0x0
> driver version  5.0.0
>
> Device topology
> - entity 1: sun6i-csi (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Sink
>                 <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]
>
> - entity 5: ov5640 1-003c (1 pad, 1 link)
>             type V4L2 subdev subtype Sensor flags 0
>             device node name /dev/v4l-subdev0
>         pad0: Source
>                 [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
> xfer:srgb ycbcr:601 quantization:full-range]
>                 -> "sun6i-csi":0 [ENABLED,IMMUTABLE]
>
> # media-ctl --set-v4l2 "'ov5640 1-003c':0[fmt:UYVY8_2X8/640x480@1/15 field:none]
> "
> # media-ctl -p
> Media controller API version 5.0.0
>
> Media device information
> ------------------------
> driver          sun6i-csi
> model           Allwinner Video Capture Device
> serial
> bus info
> hw revision     0x0
> driver version  5.0.0
>
> Device topology
> - entity 1: sun6i-csi (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Sink
>                 <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]
>
> - entity 5: ov5640 1-003c (1 pad, 1 link)
>             type V4L2 subdev subtype Sensor flags 0
>             device node name /dev/v4l-subdev0
>         pad0: Source
>                 [fmt:UYVY8_2X8/640x480@1/15 field:none colorspace:srgb
> xfer:srgb ycbcr:601 quantization:full-range]
>                 -> "sun6i-csi":0 [ENABLED,IMMUTABLE]
>
> [1] https://patchwork.kernel.org/patch/10708931/

--y2wz7z6pl7dcejld
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxOvkAACgkQcjQGjxah
VjxO2A//ZTZVcZ5XCBK0E8Uh5HpIR2A4IbhPl2n07Rz50EcVLqiiB0k6mwR5xNt4
8AYqFRBFzsqSw5w6nJ7uFjIIG/REJPs7WyOpeUWHPpxAY5VOqx3b3r9yklF2ln1b
pDUtxDjafIr5/hJPQWN56Hi8MdY2oWWb5mnaYfAqJRrtnM/92F/gFATY2JwKQKMV
xChw2lOy6rz3Wz6+mLkeEiPpC2IH7TUtqBgAafHBYtN/cWTuztE2aalOnJd6EnLS
RoIdAnY+SgngNcREUwq4WbDoQDN0iXIQ2q73NTUlZcNHRYsuLpahpoUOHja9lkI5
DtJRy1CCSzPmtXWAEyf9s8Hy37HBUWvLYB9cSV1aaaDjHzzZeRrUMPBwL1yGRNl1
02c0tYRQZdae7kINKDZ93hEu7aVIUYAHmRjoFNpxihIHcm28ErAk3eihVZXpvBe/
iGstfOjws1o+GV7+fKQphPHkpf/r5qK9qy1dAgSsLNIouBUiUdAva4w4jU4rk98H
t61/wJMAz25Oe4iZnLAd7tC/BoVV/pkIYZc/eG+4nXDkBzNIBYTS05nWAiUOq04x
P+tbgcet05eNX0WkQ1v/srip0nKTVTiyYd9v6fVfCCMZRdBHfN7phgO3lduXEK4W
d8H438kkT6Z9rzV3HQf2UOVDyvIqlBekz8hxOd1miaOIpJpIsGY=
=iwec
-----END PGP SIGNATURE-----

--y2wz7z6pl7dcejld--
