Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51362 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbeLCIop (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:45 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v6 00/12] media: ov5640: Misc cleanup and improvements
Date: Mon,  3 Dec 2018 09:44:15 +0100
Message-Id: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a "small" series that mostly cleans up the ov5640 driver code,
slowly getting rid of the big data array for more understandable code
(hopefully).

The biggest addition would be the clock rate computation at runtime,
instead of relying on those arrays to setup the clock tree
properly. As a side effect, it fixes the framerate that was off by
around 10% on the smaller resolutions, and we now support 60fps.

This also introduces a bunch of new features.

Let me know what you think,
Maxime

Changes from v5:
  - Squashed Jacopo patches fixing MIPI-CSI

Changes from v4:
  - Squashed Jacopo patches fixing the MIPI-CSI case
  - Prefer clock rates superior to the ideal clock rate, even if it
    means having a less precise one.
  - Fix the JPEG case according to Hugues suggestions
  - Rebased on 4.20

Changes from v3:
  - Rebased on current Sakari tree
  - Fixed an error when changing only the framerate

Changes from v2:
  - Rebased on latest Sakari PR
  - Fixed the issues reported by Hugues: improper FPS returned for
    formats, improper rounding of the FPS, some with his suggestions,
    some by simplifying the logic.
  - Expanded the clock tree comments based on the feedback from Samuel
    Bobrowicz and Loic Poulain
  - Merged some of the changes made by Samuel Bobrowicz to fix the
    MIPI rate computation, fix the call sites of the
    ov5640_set_timings function, the auto-exposure calculation call,
    etc.
  - Split the patches into smaller ones in order to make it more
    readable (hopefully)

Changes from v1:
  - Integrated Hugues' suggestions to fix v4l2-compliance
  - Fixed the bus width with JPEG
  - Dropped the clock rate calculation loops for something simpler as
    suggested by Sakari
  - Cache the exposure value instead of using the control value
  - Rebased on top of 4.17

Jacopo Mondi (1):
  media: ov5640: Fix set format regression

Maxime Ripard (11):
  media: ov5640: Adjust the clock based on the expected rate
  media: ov5640: Remove the clocks registers initialization
  media: ov5640: Remove redundant defines
  media: ov5640: Remove redundant register setup
  media: ov5640: Compute the clock rate at runtime
  media: ov5640: Remove pixel clock rates
  media: ov5640: Enhance FPS handling
  media: ov5640: Make the return rate type more explicit
  media: ov5640: Make the FPS clamping / rounding more extendable
  media: ov5640: Add 60 fps support
  media: ov5640: Remove duplicate auto-exposure setup

 drivers/media/i2c/ov5640.c | 764 ++++++++++++++++++++++----------------
 1 file changed, 452 insertions(+), 312 deletions(-)

base-commit: 5019ebef9ac7922a8d233cb6fa7a0626454ca80d
-- 
git-series 0.9.1
