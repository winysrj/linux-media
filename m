Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44595 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964929AbeF0PcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:32:07 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@infradead.org,
        parker.l.reed@gmail.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] em28xx: Disconnect oops fix and cleanup
Date: Wed, 27 Jun 2018 10:31:59 -0500
Message-Id: <1530113521-26749-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series cleans up an oops that is encountered during
USB disconnect on all Hauppauge dual-tuner DualHD devices.

A duplicate PID that was added is also removed, since it
already existed on the line above.

Brad Love (2):
  em28xx: Remove duplicate PID
  em28xx: Fix DualHD disconnect oops

 drivers/media/usb/em28xx/em28xx-cards.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4
