Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38531 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNSXu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:23:50 -0400
Date: Tue, 14 Aug 2018 17:35:59 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Message-ID: <20180814153559.GA16428@w540>
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
 <20180711072148.GH8180@w540>
 <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
 <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
 <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com>
 <20180716082929.GM8180@w540>
 <71bc3ff6-8db2-af63-f9af-72696f7d075c@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <71bc3ff6-8db2-af63-f9af-72696f7d075c@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,
   sorry for resurecting this.

On Mon, Jul 16, 2018 at 09:26:13AM -0700, Steve Longerbeam wrote:
>
>
> On 07/16/2018 01:29 AM, jacopo mondi wrote:
> >Hi Steve,
> >    thanks for keep testing it
> >
> >On Sat, Jul 14, 2018 at 01:02:32PM -0700, Steve Longerbeam wrote:
> >>
> >>On 07/14/2018 12:41 PM, Steve Longerbeam wrote:
> >>>Hi Jacopo,
> >>>
> >>>
> >>>On 07/14/2018 11:57 AM, Steve Longerbeam wrote:
> >>>>Hi Jacopo,
> >>>>
> >>>>Pardon the late reply, see below.
> >>>>
> >>>>On 07/11/2018 12:21 AM, jacopo mondi wrote:
> >>>>>Hi Steve,
> >>>>>
> >>>>>On Tue, Jul 10, 2018 at 02:10:54PM -0700, Steve Longerbeam wrote:
> >>>>>>Hi Jacopo,
> >>>>>>
> >>>>>>Sorry to report my testing on SabreSD has same result
> >>>>>>as last time. This series fixes the LP-11 timeout at stream
> >>>>>>on but captured images are still blank. I tried the 640x480
> >>>>>>mode with UYVY2X8. Here is the pad config:
> >>>>>This saddens me :(
> >>>>>
> >>>>>I'm capturing with the same format and sizes... this shouldn't be the
> >>>>>issue
> >>>>>
> >>>>>Could you confirm this matches what you have in your tree?
> >>>>>5dc2c80 media: ov5640: Fix timings setup code
> >>>>>b35e757 media: i2c: ov5640: Re-work MIPI startup sequence
> >>>>>3c4a737 media: ov5640: fix frame interval enumeration
> >>>>>41cb1c7 media: ov5640: adjust xclk_max
> >>>>>c3f3ba3 media: ov5640: add support of module orientation
> >>>>>ce85705 media: ov5640: add HFLIP/VFLIP controls support
> >>>>>8663341 media: ov5640: Program the visible resolution
> >>>>>476dec0 media: ov5640: Add horizontal and vertical totals
> >>>>>dba13a0 media: ov5640: Change horizontal and vertical resolutions na=
me
> >>>>>8f57c2f media: ov5640: Init properly the SCLK dividers
> >>>>Yes, I have that commit sequence.
> >>>>
> >>>>FWIW, I can verify what Jagan Teki reported earlier, that the driver
> >>>>still
> >>>>works on the SabreSD platform at:
> >>>>
> >>>>dba13a0 media: ov5640: Change horizontal and vertical resolutions name
> >>>>
> >>>>and is broken at:
> >>>>
> >>>>476dec0 media: ov5640: Add horizontal and vertical totals
> >>>>
> >>>>with LP-11 timeout at the mipi csi-2 receiver:
> >>>>
> >>>>[=C2=A0=C2=A0 80.763189] imx6-mipi-csi2: LP-11 timeout, phy_state =3D=
 0x00000230
> >>>>[=C2=A0=C2=A0 80.769599] ipu1_csi1: pipeline start failed with -110
> >>>And I discovered the bug in 476dec0 "media: ov5640: Add horizontal and
> >>>vertical totals". The call to ov5640_set_timings() needs to be moved
> >>>before the
> >>>calls to ov5640_get_vts() and ov5640_get_hts(). But I see you have
> >>>discovered
> >>>that as well, and fixed in the second patch in your series.
> >>>
> >I'm sorry I'm not sur I'm following. Does this mean that with that bug
> >you are referring to up here fixed by my last patch you have capture
> >working?
>
> No, capture still not working for me on SabreSD, even after fixing
> the bug in 476dec0 "media: ov5640: Add horizontal and vertical totals",
> by either using your patchset, or by running version 476dec0 of ov5640.c
> with the call to ov5640_set_timings() moved to the correct places as
> described below.
>

I've been reported a bug on exposure handling that makes the first
captured frames all black. Both me and Hugues have tried to fix the
issue (him with a more complete series, but that's another topic).
See [1] and [2]

It might be possible that you're getting blank frames with this series
applied? I never seen them as I'm skipping the first frames when
capturing, but I've now tested and without the exposure fixes (either
[1] or [2]) I actually have blank frames.

If that's the case for you too (which I hope so much) would you be
available to test again this series with exposure fixes on top?
On my platform that actually makes all frames correct.

Thanks
   j

[1] [PATCH 0/2] media: ov5640: Fix set_timings and auto-exposure
[2] [PATCH v2 0/5] Fix OV5640 exposure & gain

> Steve
>
> >>But strangely, if I revert to 476dec0, and then move the call to
> >>ov5640_set_timings()
> >>to just after ov5640_load_regs() in ov5640_set_mode_exposure_calc() and
> >>ov5640_set_mode_direct(), the LP-11 timeouts are still present. So I can
> >>confirm
> >>this strangeness which you already pointed out below [1].
> >>
> >>
> >>>>>>>The version I'm sending here re-introduces some of the timings
> >>>>>>>parameters in the
> >>>>>>>initial configuration blob (not in the single mode ones), which
> >>>>>>>apparently has
> >>>>>>>to be at least initially programmed to allow the driver to later
> >>>>>>>program them
> >>>>>>>singularly in the 'set_timings()' function. Unfortunately I do not
> >>>>>>>have a real
> >>>>>>>rationale behind this which explains why it has to be done this
> >>>>>>>way :(
> >>>>>>>
> >>[1] here :)
> >>
> >>Steve
> >>
> >>
>

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbcvbKAAoJEHI0Bo8WoVY8gmwP/2dZ7FhM0bLUJnSixj6/3EJH
5mLYDuPhFHjjKWF+2jC1jb9y2UqYvfVf52VJDWKHHJUBeXrf0QMIbpvmF2nDT792
D2cp3JYdfJQlhNR9fdUSiQMJh0ouqbHfLZ3nryqpNgsJAHaxFlESRDsYdgzLDhJt
rAWUyTU7Kx5ac/MGM1ujoMAU+xfqZI7lbn/imGv/1dn4jl23nxK18kj5HS5cmUSg
km9Ij+h27OSkv1sIIg4oM0obNLH9NE/JyOZlbSFrLCbdLCWYK3ovu3sMQbJy4MEa
ZV/M9i3WPDLXKh1oat7RZu7bn8ObhLtQ9Q9ryi2LPUPcu78v74mAu/miG64pdu8Q
roUiUTyTEPei2QGtK7+Og5Ko+HF/btj7i42NPXfCaAU0CNWbscPLzZFOV+myXVyS
sTLrzw2KHhbyfAIIgmFCawsmKCCUamuQBsKGi+RBQuAs/QvHK0ZjKNsktYAebvNL
C/BOBYNN4awPcoU/SUJOslvdh/Fqn+bfC3UXGaMBe0X8Yl7xPQlEPH8zKd/Z/OLq
b/BtzDjpoNAa2yrBvtktisaFSR6g8YYMf4p8yGs9VyV/G8pQhWfjeUnR+RFYjgXT
sUx7tBVr92+eo7EE7EeZUM0eXWuR3n4ZrkZh8Q+HEuSNrymC50fOFW1HgswhEGMT
6wximmobndpSAWoaUfV3
=J0ib
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
