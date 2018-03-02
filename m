Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42047 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426315AbeCBOqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:46:55 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 00/11] media: ov772x/tw9910 cleanup
Date: Fri,  2 Mar 2018 15:46:32 +0100
Message-Id: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
   as I had one more patch to add to the series, I have now re-based it on top
of Joe's changes, which were based on top of yours already part of media-tree
master branch.

Please apply on top of:

commit bc3c49d6bbfb ("media: tw9910: Miscellaneous neatening")
commit 71c07c61b340 ("media: tw9910: Whitespace alignment")
commit ae24b8a1d5f9 ("media: tw9910: solve coding style issues")
commit 2d595d14fe8b ("media: ov772x: fix whitespace issues")

Thanks
  j

v1 -> v2:
- Rebased on top of Joe's cleanup patches: 2 patches squashed
- Add patch 12/12


Jacopo Mondi (11):
  media: tw9910: Re-order variables declaration
  media: tw9910: Re-organize in-code comments
  media: tw9910: Mixed style fixes
  media: tw9910: Sort includes alphabetically
  media: tw9910: Replace msleep(1) with usleep_range
  media: ov772x: Align function parameters
  media: ov772x: Re-organize in-code comments
  media: ov772x: Empty line before end-of-function return
  media: ov772x: Re-order variables declaration
  media: ov772x: Replace msleep(1) with usleep_range
  media: ov772x: Unregister async subdevice

 drivers/media/i2c/ov772x.c | 65 ++++++++++++++++--------------------
 drivers/media/i2c/tw9910.c | 83 ++++++++++++++++++----------------------------
 2 files changed, 61 insertions(+), 87 deletions(-)

--
2.7.4
