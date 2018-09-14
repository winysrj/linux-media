Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:62984 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbeINXFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:05:19 -0400
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <df2bd151-a83e-4ba8-2bf8-982c96c64c9f@mentor.com>
Date: Fri, 14 Sep 2018 10:49:39 -0700
MIME-Version: 1.0
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hughes,

The whole series,

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

and

Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
on i.MX6q SabreSD with MIPI CSI-2 OV5640 module


On 09/11/2018 06:48 AM, Hugues Fruchet wrote:
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
>                         exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
>                             gain (int)    : min=0 max=1023 step=1 default=0 value=19 flags=inactive, volatile
> 3) Put finger in front of camera and check that gain/exposure values are changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                         exposure (int)    : min=0 max=65535 step=1 default=0 value=660 flags=inactive, volatile
>                             gain (int)    : min=0 max=1023 step=1 default=0 value=37 flags=inactive, volatile
> 4) switch to manual mode, image exposition must not change
> $> v4l2-ctl --set-ctrl=gain_automatic=0
> $> v4l2-ctl --set-ctrl=auto_exposure=1
> Note the "1" for manual exposure.
>
> 5) Check current gain/exposure values:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                         exposure (int)    : min=0 max=65535 step=1 default=0 value=330
>                             gain (int)    : min=0 max=1023 step=1 default=0 value=20
>
> 6) Put finger behind camera and check that gain/exposure values are NOT changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                         exposure (int)    : min=0 max=65535 step=1 default=0 value=330
>                             gain (int)    : min=0 max=1023 step=1 default=0 value=20
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
>                         exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
>                             gain (int)    : min=0 max=1023 step=1 default=0 value=22 flags=inactive, volatile
> Note the "0" for auto exposure.
>
> ===========
> = history =
> ===========
> version 3:
>    - Change patch 5/5 by removing set_mode() orig_mode parameter as per jacopo' suggestion:
>      https://www.spinics.net/lists/linux-media/msg139457.html
>
> version 2:
>    - Fix patch 3/5 commit comment and rename binning function as per jacopo' suggestion:
>      https://www.mail-archive.com/linux-media@vger.kernel.org/msg133272.html
>
> Hugues Fruchet (5):
>    media: ov5640: fix exposure regression
>    media: ov5640: fix auto gain & exposure when changing mode
>    media: ov5640: fix wrong binning value in exposure calculation
>    media: ov5640: fix auto controls values when switching to manual mode
>    media: ov5640: fix restore of last mode set
>
>   drivers/media/i2c/ov5640.c | 128 ++++++++++++++++++++++++++-------------------
>   1 file changed, 73 insertions(+), 55 deletions(-)
>
