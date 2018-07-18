Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41891 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbeGRL4m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 07:56:42 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH 0/2] media: ov5640: Fix set_timings and auto-exposure
Date: Wed, 18 Jul 2018 13:19:01 +0200
Message-Id: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   the ov5640 driver has received a lot of attentions recently.

Maxime and Sam tackled the clock tree handling and I tried to fix the MIPI
capture on i.MX6 platforms, but none of those patches ever made it to inclusion.

Although a few fixes have been circulating around those series, and it's my
opinion it is worth including them before any other developments takes place.

I'm sending here a re-work of a patch from Sam and Maxime to fix timings setup,
and a small fix for auto-exposure enabling/disabling operations.

Each patch has a comment, on which I would like to have some feedback on.

[1/1] has already received several acks on the mailing list, but never a
formal Reviewed-by or Tested-by, while [2/2] is new.

Thanks
   j

Jacopo Mondi (2):
  media: ov5640: Fix timings setup code
  media: ov5640: Fix auto-exposure disabling

 drivers/media/i2c/ov5640.c | 75 ++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 43 deletions(-)

--
2.7.4
