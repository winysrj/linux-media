Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:49907 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbeJRDem (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 23:34:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: maxime.ripard@bootlin.com, sam@elite-embedded.com,
        mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Subject: [PATCH 0/2] media: ov5640: Re-implement MIPI clock tree configuration
Date: Wed, 17 Oct 2018 21:37:16 +0200
Message-Id: <1539805038-22321-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello ov5640 people,
   this small series based on top of Maxime's v4
"media: ov5640: Misc cleanup and improvements"
which fixes configuration of the MIPI clock tree which I have found not
working in Maxime's series.

As the aforementioned series containes a lot of useful things, I based my work
on top of it with the hope this can be included in Maxime's next v5.

I have tested capture with a MIPI CSI-2 2 lane interface, with the following
results (frame rates reported by yavta)

1920x1080
Captured 100 frames in 6.696864 seconds (14.932362 fps, 61927490.138103 B/s).
Captured 100 frames in 3.355459 seconds (29.802182 fps, 123595609.386497 B/s).
Captured 100 frames in 1.656115 seconds (60.382280 fps, 37098872.964740 B/s).

1024x768
Captured 100 frames in 7.425156 seconds (13.467729 fps, 21182906.577451 B/s).
Captured 100 frames in 3.431391 seconds (29.142700 fps, 45837504.382334 B/s).
Captured 100 frames in 1.667302 seconds (59.977113 fps, 36849938.056268 B/s).

640x480
Captured 100 frames in 6.656321 seconds (15.023312 fps, 9230323.152105 B/s).
Captured 100 frames in 3.323515 seconds (30.088620 fps, 18486448.133840 B/s).
Captured 100 frames in 1.665959 seconds (60.025487 fps, 36879659.103255 B/s).

320x240
Captured 100 frames in 6.660575 seconds (15.013718 fps, 2306107.089817 B/s).
Captured 100 frames in 3.333978 seconds (29.994199 fps, 4607108.983740 B/s).
Captured 100 frames in 1.666797 seconds (59.995308 fps, 36861117.460615 B/s).

I have also verified images are good in all resolutions.

Sam has just shared his fixes for MIPI CSI-2 which are indeed different from
these ones. My dream now would be to unify all of our changes in next Maxime's
series iteration and have this merged.

Please note that once this gets in, we could then get rid of fixed framerates,
and hopefully improve mode settings and configuration \o/.

I'll try to look into Sam's series next, and see if conflicts with this, or
those can be merged together.

A lot of interesting stuff happening on this driver!

Thanks
   j

Jacopo Mondi (2):
  media: ov5640: Add check for PLL1 output max frequency
  media: ov5640: Re-implement MIPI clock configuration

 drivers/media/i2c/ov5640.c | 124 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 99 insertions(+), 25 deletions(-)

--
2.7.4
