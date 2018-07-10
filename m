Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54155 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389912AbeGJSgi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 14:36:38 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Date: Tue, 10 Jul 2018 20:36:06 +0200
Message-Id: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series fixes capture operations on i.MX6Q platforms (and possible other
platforms reported not working) using MIPI CSI-2 interface.

This iteration expands the v1 version with an additional fix, initially
submitted by Maxime in his series:
[PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
https://www.spinics.net/lists/linux-media/msg134436.html

The original patch has been reported not fully fixing the issues by Daniel Mack
in his comment here below (on a Qualcomm platform if I'm not wrong):
https://www.spinics.net/lists/linux-media/msg134524.html
On my i.MX6Q testing platform that patch alone does not fix MIPI capture
neither.

The version I'm sending here re-introduces some of the timings parameters in the
initial configuration blob (not in the single mode ones), which apparently has
to be at least initially programmed to allow the driver to later program them
singularly in the 'set_timings()' function. Unfortunately I do not have a real
rationale behind this which explains why it has to be done this way :(

For the MIPI startup sequence re-work patch, no changes compared to v1.
Steve reported he has verified the LP-11 timout issue is solved on his testing
platform too. For more details, please refer to the v1 cover letter:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133352.html

Thanks
   j

Jacopo Mondi (1):
  media: i2c: ov5640: Re-work MIPI startup sequence

Samuel Bobrowicz (1):
  media: ov5640: Fix timings setup code

 drivers/media/i2c/ov5640.c | 107 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 82 insertions(+), 25 deletions(-)

--
2.7.4
