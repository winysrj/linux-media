Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46466 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932227AbcLHWWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 17:22:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 0/6] Fix tvp5150 regression with em28xx
Date: Fri,  9 Dec 2016 00:22:40 +0200
Message-Id: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series fixes a regression reported by Devin Heitmueller that
affects a large number of em28xx. The problem was introduced by

commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Tue Jan 26 06:59:39 2016 -0200

    [media] em28xx: fix implementation of s_stream

that started calling s_stream(1) in the em28xx driver when enabling the
stream, resulting in the tvp5150 s_stream() operation writing several
registers with values fit for other platforms (namely OMAP3, possibly others)
but not for em28xx.

The series starts with two unrelated drive-by cleanups and an unrelated bug
fix. It then continues with a patch to remove an unneeded and armful call to
tvp5150_reset() when getting the format from the subdevice (4/6), an update of
an invalid comment and the addition of macros for register bits in order to
make the code more readable (5/6) and actually allow following the incorrect
code flow, and finally a rework of the s_stream() operation to fix the
problem.

I haven't been able to test this with an em28xx device as I don't own any. I
would appreciate if someone could give the series a go.

Laurent Pinchart (6):
  v4l: tvp5150: Compile tvp5150_link_setup out if
    !CONFIG_MEDIA_CONTROLLER
  v4l: tvp5150: Don't inline the tvp5150_selmux() function
  v4l: tvp5150: Add missing break in set control handler
  v4l: tvp5150: Don't reset device in get/set format handlers
  v4l: tvp5150: Fix comment regarding output pin muxing
  v4l: tvp5150: Don't override output pinmuxing at stream on/off time

 drivers/media/i2c/tvp5150.c     | 60 +++++++++++++++++++++++++----------------
 drivers/media/i2c/tvp5150_reg.h |  9 +++++++
 2 files changed, 46 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart

