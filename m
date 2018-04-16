Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53126 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbeDPMhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:37:15 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Date: Mon, 16 Apr 2018 14:36:49 +0200
Message-Id: <20180416123701.15901-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Changes from v1:
  - Integrated Hugues' suggestions to fix v4l2-compliance
  - Fixed the bus width with JPEG
  - Dropped the clock rate calculation loops for something simpler as
    suggested by Sakari
  - Cache the exposure value instead of using the control value
  - Rebased on top of 4.17

Maxime Ripard (10):
  media: ov5640: Don't force the auto exposure state at start time
  media: ov5640: Init properly the SCLK dividers
  media: ov5640: Change horizontal and vertical resolutions name
  media: ov5640: Add horizontal and vertical totals
  media: ov5640: Program the visible resolution
  media: ov5640: Adjust the clock based on the expected rate
  media: ov5640: Compute the clock rate at runtime
  media: ov5640: Enhance FPS handling
  media: ov5640: Add 60 fps support
  media: ov5640: Remove duplicate auto-exposure setup

Mylène Josserand (2):
  media: ov5640: Add auto-focus feature
  media: ov5640: Add light frequency control

 drivers/media/i2c/ov5640.c | 752 +++++++++++++++++++++----------------
 1 file changed, 422 insertions(+), 330 deletions(-)

-- 
2.17.0
