Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:33978 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424443AbeCBOfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 09:35:13 -0500
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
Subject: [PATCH 00/12] media: ov5640: Misc cleanup and improvements
Date: Fri,  2 Mar 2018 15:34:48 +0100
Message-Id: <20180302143500.32650-1-maxime.ripard@bootlin.com>
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

 drivers/media/i2c/ov5640.c | 777 ++++++++++++++++++++++++++-------------------
 1 file changed, 452 insertions(+), 325 deletions(-)

-- 
2.14.3
