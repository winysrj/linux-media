Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53955 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbeHONUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 09:20:22 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v3 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Date: Wed, 15 Aug 2018 12:28:15 +0200
Message-Id: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
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
[PATCH v2 0/5] Fix OV5640 exposure & gain

And I have re-based it on top of this two fixes here:
git://jmondi.org/linux ov5640/timings_exposure

Steve Longerbeam tested that branch on his I.MX6q SabreSD board and confirms he
can now capture frames (I added his Tested-by tag to this patches). I have
verified the same on Engicam iCore I.MX6q and an Intel Atom based board.

Ideally I would like to have these two fixes merged, and Hugues' ones then
applied on top. Of course, more testing on other platforms using CSI-2 is very
welcome.

Thanks
   j

v2 -> v3:
- patch [2/2] was originally sent in a different series, compared to v2 it
  removes entries from the blob array instead of adding more.

Jacopo Mondi (2):
  media: ov5640: Re-work MIPI startup sequence
  media: ov5640: Fix timings setup code

 drivers/media/i2c/ov5640.c | 141 +++++++++++++++++++++++++++++----------------
 1 file changed, 92 insertions(+), 49 deletions(-)

--
2.7.4
