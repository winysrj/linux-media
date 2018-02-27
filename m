Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49546 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbeB0Pkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:40 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 00/13] media: ov772x/tw9910 cleanup
Date: Tue, 27 Feb 2018 16:40:17 +0100
Message-Id: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
  as you have started cleaning up those two drivers as they've been now
moved away from soc_camera I have added a few style fixes for both of them
on top of your two patches:

commit ae24b8a1d5f9 ("media: tw9910: solve coding style issues")
commit 2d595d14fe8b ("media: ov772x: fix whitespace issues")

checkpatch now returns no error apart from a > 80 columns in ov772x I did not
break for sake of readability.

Thanks
   j

Jacopo Mondi (13):
  media: tw9910: Fix parameter alignment issue
  media: tw9910: Empty line before end-of-function return
  media: tw9910: Align function parameters
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

 drivers/media/i2c/ov772x.c |  63 +++++++++++++---------------
 drivers/media/i2c/tw9910.c | 101 ++++++++++++++++++++-------------------------
 2 files changed, 72 insertions(+), 92 deletions(-)

--
2.7.4
