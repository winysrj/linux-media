Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49050 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727503AbeI0VFB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 17:05:01 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 0/4] OV5640: reduce rate according to maximum pixel clock
Date: Thu, 27 Sep 2018 16:46:03 +0200
Message-ID: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch serie aims to reduce parallel port rate according to maximum pixel
clock frequency admissible by camera interface in front of the sensor.
This allows to support any resolutions/framerate requests by decreasing
the framerate according to maximum camera interface capabilities.
This allows typically to enable 5Mp YUV/RGB frame capture even if 15fps
framerate could not be reached by platform.

This work is based on OV5640 Maxime Ripard's runtime clock computing serie [1]
which allows to adapt the clock tree registers according to maximum pixel
clock.

Then the first patch adds handling of pclk divider registers
DVP_PCLK_DIVIDER (0x3824) and VFIFO_CTRL0C (0x460c) in order to
correlate the rate to the effective pixel clock output on parallel interface.

A new devicetree property "pclk-max-frequency" is introduced in order
to inform sensor of the camera interface maximum admissible pixel clock.
This new devicetree property handling is added to V4L2 core.

Then OV5640 ov5640_set_dvp_pclk() is modified to clip rate according
to optional maximum pixel clock property.

References:
  [1] [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements https://www.mail-archive.com/linux-media@vger.kernel.org/msg131655.html

Hugues Fruchet (4):
  media: ov5640: move parallel port pixel clock divider out of registers
    set
  media: v4l2-core: add pixel clock max frequency parallel port property
  media: dt-bindings: media: Document pclk-max-frequency property
  media: ov5640: reduce rate according to maximum pixel clock frequency

 .../devicetree/bindings/media/video-interfaces.txt |  2 +
 drivers/media/i2c/ov5640.c                         | 78 ++++++++++++++++------
 drivers/media/v4l2-core/v4l2-fwnode.c              |  3 +
 include/media/v4l2-fwnode.h                        |  2 +
 4 files changed, 65 insertions(+), 20 deletions(-)

-- 
2.7.4
