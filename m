Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54419 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeINVPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 17:15:23 -0400
Date: Fri, 14 Sep 2018 18:00:12 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
Message-ID: <20180914160012.GC16851@w540>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi  Hugues,
   thanks for the patches

On Tue, Sep 11, 2018 at 03:48:16PM +0200, Hugues Fruchet wrote:
> This patch serie fixes some problems around exposure & gain in OV5640 driver.
>
> The 4th patch about autocontrols requires also a fix in v4l2-ctrls.c:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133164.html
>
> Here is the test procedure used for exposure & gain controls check:
> 1) Preview in background
> $> gst-launch-1.0 v4l2src ! "video/x-raw, width=640, Height=480" ! queue ! waylandsink -e &
> 2) Check gain & exposure values
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
>                            gain (int)    : min=0 max=1023 step=1 default=0 value=19 flags=inactive, volatile
> 3) Put finger in front of camera and check that gain/exposure values are changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=0 max=65535 step=1 default=0 value=660 flags=inactive, volatile
>                            gain (int)    : min=0 max=1023 step=1 default=0 value=37 flags=inactive, volatile
> 4) switch to manual mode, image exposition must not change
> $> v4l2-ctl --set-ctrl=gain_automatic=0
> $> v4l2-ctl --set-ctrl=auto_exposure=1
> Note the "1" for manual exposure.
>
> 5) Check current gain/exposure values:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=0 max=65535 step=1 default=0 value=330
>                            gain (int)    : min=0 max=1023 step=1 default=0 value=20
>
> 6) Put finger behind camera and check that gain/exposure values are NOT changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=0 max=65535 step=1 default=0 value=330
>                            gain (int)    : min=0 max=1023 step=1 default=0 value=20
> 7) Update exposure, check that it is well changed on display and that same value is returned:
> $> v4l2-ctl --set-ctrl=exposure=100
> $> v4l2-ctl --get-ctrl=exposure
> exposure: 100
>
> 9) Update gain, check that it is well changed on display and that same value is returned:
> $> v4l2-ctl --set-ctrl=gain=10
> $> v4l2-ctl --get-ctrl=gain
> gain: 10
>
> 10) Switch back to auto gain/exposure, verify that image is correct and values returned are correct:
> $> v4l2-ctl --set-ctrl=gain_automatic=1
> $> v4l2-ctl --set-ctrl=auto_exposure=0
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
>                            gain (int)    : min=0 max=1023 step=1 default=0 value=22 flags=inactive, volatile
> Note the "0" for auto exposure.
>

I've tested on my side and I can confirm the exposure and gain when in
auto-mode changes as expected, and it is possible to switch back and
forth between auto and manual modes.

The patches also fixes an issue when capturing frames, as the first
two/three frames where always black in my setup before this series.

(While streaming to gstreamers' fakesink)
# v4l2-ctl --get-ctrl "exposure" --get-ctrl "gain" -d /dev/video4
exposure: 885
gain: 50

(Point a light in front of the sensor)
# v4l2-ctl --get-ctrl "exposure" --get-ctrl "gain" -d /dev/video4
exposure: 17
gain: 19

(Disable auto-gain and auto-exposure)
# v4l2-ctl  -d /dev/video4 --set-ctrl=auto_exposure=1
# v4l2-ctl  -d /dev/video4 --set-ctrl=gain_automatic=0
# v4l2-ctl  -d /dev/video4 --set-ctrl=exposure=100
# v4l2-ctl --get-ctrl "exposure" --get-ctrl "gain" -d /dev/video4
exposure: 100
gain: 46

(Re-enable auto-exp and auto-gain)
# v4l2-ctl  -d /dev/video4 --set-ctrl=auto_exposure=0
# v4l2-ctl  -d /dev/video4 --set-ctrl=gain_automatic=1
# v4l2-ctl --get-ctrl "exposure" --get-ctrl "gain" -d /dev/video4
exposure: 885
gain: 46

(Finger on the sensor)
# v4l2-ctl --get-ctrl "exposure" --get-ctrl "gain" -d /dev/video4
exposure: 885
gain: 248

(Point a light on the sensor)
exposure: 16
gain: 19

So please add my
Tested-by: Jacopo Mondi <jacopo@jmondi.org>
to this series.

Thanks
   j

> ===========
> = history =
> ===========
> version 3:
>   - Change patch 5/5 by removing set_mode() orig_mode parameter as per jacopo' suggestion:
>     https://www.spinics.net/lists/linux-media/msg139457.html
>
> version 2:
>   - Fix patch 3/5 commit comment and rename binning function as per jacopo' suggestion:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg133272.html
>
> Hugues Fruchet (5):
>   media: ov5640: fix exposure regression
>   media: ov5640: fix auto gain & exposure when changing mode
>   media: ov5640: fix wrong binning value in exposure calculation
>   media: ov5640: fix auto controls values when switching to manual mode
>   media: ov5640: fix restore of last mode set
>
>  drivers/media/i2c/ov5640.c | 128 ++++++++++++++++++++++++++-------------------
>  1 file changed, 73 insertions(+), 55 deletions(-)
>
> --
> 2.7.4
>

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbm9sMAAoJEHI0Bo8WoVY8b9QP+wQW/epX2W1v2XjkYadbu7RZ
JY/Zt2rsecJxi3cGPvPFYBuCpSfWrRGVyXL98pH6IrhQKlJdNq+Bacd5YmrzZ7je
Eg2El4MixpouEW6rbt0gRLk+efygO5J3QnvCb9Ak99nVh78iJct0WFC9kCGzNdZG
IhMjCe0Lu8umchCSpJjL3MROFhbG+VxRdpqh7jkh1wr+hFqsJU8A4g79KmbYG/2h
e7pIHuO8Yu6sElpkQOfbu8jLTxwUtCdAKZUZXQqfBVPB8nN1v2dsiRbmGH86jDzp
Zg0X3JxlsCR37uL1fIFHY6LjG1rxYXlAfEfHIRYwxVY6cE8/4C2uOT1vfE5JDQ0f
AYsErZYnWrk0iu+TlLKiXEj2IUHInEGLQlHd+WfB23Jx1/p4Pfx09jmUiYychVDq
T1P0kGyxszH6m0KNbZj/GLI+lZlYi3vJkgETskjkL6qUzpCNtSaquGn1aI/ulpMK
Q2K00EOzwz4n8V5LJu0LFlvgALM6xwAXSCekUHmPMnjtCWPpdnyVOm70eC3FIv4m
1q9uadksfmpZzDRKikSLkc+WhOOg0D5UYu5RQGRJJw3MPlIfBjomjuCGzxP0eLrt
1ZOgcMkGvxofGLpTk0IoEEdMdPUz6pqMkbMJLIXqAqB2Y0R7XMwebpT/npoTzDF3
9ZeQEUYmYpTl41cmw9fm
=Yecm
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
