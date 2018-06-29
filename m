Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49207 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbeF2Qmz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 12:42:55 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 0/2] media: i2c: ov5640: Re-work MIPI interface configuration
Date: Fri, 29 Jun 2018 18:42:38 +0200
Message-Id: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor MIPI interface is initialized with settings that require a start/stop
sequence at power-up time in order to force lanes into LP11 state, as they are
initialized in LP00 when in 'sleep mode' which I assume to be the sensor
manual definition for the D-PHY stop mode.

The stream start/stop was performed by enabling disabling clock gating,
and had the side effect to change the lanes sleep mode configuration when
stream was stopped.

Clock gating/ungating:
-       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
-                            on ? 0 : BIT(5));
-       if (ret)

Set lanes in LP11 when in 'sleep mode':
-       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
-                              on ? 0x00 : 0x70);

As some failing streaming start sequence have been observed on my testing
platform, the initialization sequence has been re-worked to the following one:

- 0x3019 = 0x70
  Configure data lanes and clock lane to LP11 when in 'sleep mode'
  (assuming this is D-PHY stop state)
- 0x4800 = 0x20
  Gate clock when non transmitting packets, MIPI bus in LP00 when non
  transmitting packets (assuming this is D-PHY LPDT)
- 0x300e = 0x58
  Select 2 lanes mode, power off TX and RX, disable MIPI interface

At stream on time:
- 0x300e = 0x4c: power TX up, enable MIPI interface

At stream off time
- 0x300e = 0x58: power TX down, disable MIPI interface.

Sam Bobrowicz has shared a patch to disable the single lanes at stream
off time and force them in LP00 state to prevent the sensor from
"transmit bad packets during configuration". Sam could you please test this
two patches and verify if you still have to manually disable the single lanes?

It would help validate the theory that 'sleep state' is actually 'stop state'
and having lanes in LP00 instead of LP11 prevents the receiver to detect when
to exit from high-speed mode.

Thanks
   j

Jacopo Mondi (2):
  media: i2c: ov5640: Re-work MIPI start sequence
  media: i2c: ov5640: Remove start/stop sequence

 drivers/media/i2c/ov5640.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--
2.7.4
