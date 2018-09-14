Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:58247 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbeINVWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 17:22:25 -0400
Date: Fri, 14 Sep 2018 18:07:12 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>, hugues.fruchet@st.com
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
Message-ID: <20180914160712.GD16851@w540>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Tue, Sep 11, 2018 at 03:48:16PM +0200, Hugues Fruchet wrote:
> This patch serie fixes some problems around exposure & gain in OV5640 driver.

As you offered to collect this series and my CSI-2 fixes I have just
re-sent, you might be interested in this branch:

git://jmondi.org/linux
engicam-imx6q/media-master/ov5640/csi2_init_v4_exposure_v3

I have there re-based this series on top of mine, which is in turn
based on latest media master, where this series do not apply as-is
afaict.

I have added to Hugues' patches my reviewed-by and tested-by tags.
If you prefer to I can send you a pull request, or if you want to have
a chance to review the whole patch list please refer to the above
branch.

Let me know if I can help speeding up the inclusion of these two
series as they fix two real issues of MIPI CSI-2 capture operations
for this sensor.

Thanks
  j

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

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbm9ywAAoJEHI0Bo8WoVY8ea8P/3iUxJUfCLiO1uqpwgiX3Asc
XKrW9/G1WzlhOxDTCmenT1HevqXUa8l/BjlBBM1rT0O4UMTyoKPtx/jW3sYuHb1v
7pczZ4vg5eczFPhfbbd6j0wcjr7pb5R/DXwwMZTZ7iqsAoK1XB08sJy8asef6+WM
z+HMV8f5EG/2aJM11S8JEWwoHYIB3w7P3MWnovUd693zu7qO8KTZf/P1/ZnGurU9
xsIFJBP7THTFTDLYY6ggyFqqaw9q1I8N60VHMXMMIGNiwM20jERi4p34sh1nUtA3
y4LvpEr006hVALtGhxVbcTeF20DxytSsEu8r6Oef7bbsgQ8kdpUE+f9wEMxyDBZi
j5ycDRO+r/T58c/Sl9W4CC8m626wlqHpqOJAlZQdlEbcvAVN2ozeGmfM1oY5uTyi
xY9MvMpOhQfXDZtKwhJo86Y59X9E7vZbxd96wAq/vEgK+u4Dwb5P8CtP5p0RhBuW
cbOlUTW3koYJvEKaWFHH7obgFJA60HhyduMdV8WklP0aAKEonIY5OUxrlkPY+lta
9HIWybR+b1oVf8EdB6c4FjrifbMb1aDfu8GwK/jBZDREM+CJJoQuF3rGDjKecnxB
sRxfTTc+Un8mECWgtfLl5cGvg3kH/rE2wZICUIo7MsoR7dCFz2j9acYw4F9/YdVo
6QO2t+WKiA85sX6XSMKb
=RAv2
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
