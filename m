Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:50741 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeINVN6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 17:13:58 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v4 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Date: Fri, 14 Sep 2018 17:58:39 +0200
Message-Id: <1536940721-25802-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello ov5640 people,
   this driver has received a lot of attention recently, and this series aims
to fix the CSI-2 interface startup on i.Mx6Q platforms.

Please refer to the v2 cover letters for more background informations:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133420.html

This two patches alone allows the MIPI interface to startup properly, but in
order to capture good images (good as in 'not completely black') exposure and
gain handling should be fixed too.
Hugues Fruchet has a series in review that fixes that issues:
[PATCH v3 0/5] Fix OV5640 exposure & gain

I have re-based Hugues' one this two patches and the latest media-tree master
at
git://jmondi.org/linux engicam-imx6q/media-master/ov5640/csi2_init_v4_exposure_v3

For the interested to test.

Compared to previous version, the series has been tested by Loic on
Dragonboard-410c and he helped finding out a discrepancy between the
(working) implementation and the sensor manual I have now add a comment on.

Testing so far has been done with only 2 data lanes, anyone with a 1-data lane
setup willing to test would be great.

Thanks
  j

v3 -> v4:
- Add Loic's tested by tag
- Add comment on register 0x300e[7:5] discrepancy between implementation
  and sensor manual (thanks Loic)

v2 -> v3:
- patch [2/2] was originally sent in a different series, compared to v2 it
  removes entries from the blob array instead of adding more.

Jacopo Mondi (2):
  media: ov5640: Re-work MIPI startup sequence
  media: ov5640: Fix timings setup code

 drivers/media/i2c/ov5640.c | 149 ++++++++++++++++++++++++++++++---------------
 1 file changed, 100 insertions(+), 49 deletions(-)

--
2.7.4
