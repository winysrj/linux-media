Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42846
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750754AbcK2CPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 21:15:20 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] media protect enable and disable source handler paths
Date: Mon, 28 Nov 2016 19:15:12 -0700
Message-Id: <cover.1480384155.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two patches fix enable and disable source handler paths. These
aren't dependent patches, grouped because they fix similar problems.

This work is triggered by a review comment from Mauro Chehab on a
snd_usb_audio patch about protecting the enable and disabel handler
path in it.

Ran tests to make sure enable and disable handler paths work. When
digital stream is active, analog app finds the tuner busy and vice
versa. Also ran the Sakari's unbind while video stream is active test.

Shuah Khan (2):
  media: au0828 fix to protect enable/disable source set and clear
  media: protect enable and disable source handler checks and calls

 drivers/media/dvb-core/dvb_frontend.c  | 24 ++++++++++++++++++------
 drivers/media/usb/au0828/au0828-core.c | 21 +++++++++------------
 drivers/media/v4l2-core/v4l2-mc.c      | 26 ++++++++++++++++++--------
 3 files changed, 45 insertions(+), 26 deletions(-)

-- 
2.7.4

