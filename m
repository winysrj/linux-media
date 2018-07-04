Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46575 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752826AbeGDM7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:12 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 0/5] Fix OV5640 exposure & gain
Date: Wed, 4 Jul 2018 14:58:38 +0200
Message-ID: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch serie fixes some problems around exposure & gain in OV5640 driver.

The 4th patch about autocontrols requires also a fix in v4l2-ctrls.c:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133164.html

Here is the test procedure used for exposure & gain controls check:
1) Preview in background
$> gst-launch-1.0 v4l2src ! "video/x-raw, width=640, Height=480" ! queue ! waylandsink -e &
2) Check gain & exposure values
$> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
                       exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
                           gain (int)    : min=0 max=1023 step=1 default=0 value=19 flags=inactive, volatile
3) Put finger in front of camera and check that gain/exposure values are changing:
$> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
                       exposure (int)    : min=0 max=65535 step=1 default=0 value=660 flags=inactive, volatile
                           gain (int)    : min=0 max=1023 step=1 default=0 value=37 flags=inactive, volatile
4) switch to manual mode, image exposition must not change
$> v4l2-ctl --set-ctrl=gain_automatic=0
$> v4l2-ctl --set-ctrl=auto_exposure=1
Note the "1" for manual exposure.

5) Check current gain/exposure values:
$> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
                       exposure (int)    : min=0 max=65535 step=1 default=0 value=330
                           gain (int)    : min=0 max=1023 step=1 default=0 value=20

6) Put finger behind camera and check that gain/exposure values are NOT changing:
$> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
                       exposure (int)    : min=0 max=65535 step=1 default=0 value=330
                           gain (int)    : min=0 max=1023 step=1 default=0 value=20
7) Update exposure, check that it is well changed on display and that same value is returned:
$> v4l2-ctl --set-ctrl=exposure=100
$> v4l2-ctl --get-ctrl=exposure
exposure: 100

9) Update gain, check that it is well changed on display and that same value is returned:
$> v4l2-ctl --set-ctrl=gain=10
$> v4l2-ctl --get-ctrl=gain
gain: 10

10) Switch back to auto gain/exposure, verify that image is correct and values returned are correct:
$> v4l2-ctl --set-ctrl=gain_automatic=1
$> v4l2-ctl --set-ctrl=auto_exposure=0
$> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
                       exposure (int)    : min=0 max=65535 step=1 default=0 value=330 flags=inactive, volatile
                           gain (int)    : min=0 max=1023 step=1 default=0 value=22 flags=inactive, volatile
Note the "0" for auto exposure.



Hugues Fruchet (5):
  media: ov5640: fix exposure regression
  media: ov5640: fix auto gain & exposure when changing mode
  media: ov5640: fix wrong binning value in exposure calculation
  media: ov5640: fix auto controls values when switching to manual mode
  media: ov5640: fix restore of last mode set

 drivers/media/i2c/ov5640.c | 120 ++++++++++++++++++++++++++-------------------
 1 file changed, 70 insertions(+), 50 deletions(-)

-- 
1.9.1
