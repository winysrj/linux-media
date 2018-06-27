Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:56187 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934936AbeF0Tlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 15:41:42 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@infradead.org,
        dheitmueller@kernellabs.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] [RFC] em28xx: Fix dual transport stream use
Date: Wed, 27 Jun 2018 14:41:22 -0500
Message-Id: <1530128483-31662-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When dual transport stream support was added the call to set
alt mode on the USB interface was moved to em28xx_dvb_init.
This was reported to break streaming for a device, so the
call was re-added to em28xx_start_streaming.

Commit 509f89652f83 ("media: em28xx: fix a regression with HVR-950")

This regression fix however broke dual transport stream support.
When a tuner starts streaming it sets alt mode on the USB interface.
The problem is both tuners share the same USB interface, so when
the second tuner becomes active and sets alt mode on the interface
it kills streaming on the other port.

It was suggested add a refcount somewhere and only set alt mode if
no tuners are currently active on the interface. This requires
sharing some state amongst both tuner devices, with appropriate
locking.

What I've done here is the following:
- Add a usage_count pointer to struct em28xx
- Share usage_count between both em28xx devices
- Only set alt mode if usage_count is zero
- Increment usage_count when each tuner becomes active
- Decrement usage_count when a tuner becomes idle

With usage_count in the main em28xx struct, locking is handled as
follows:
- if a secondary tuner exists, lock dev->dev_next->lock
- if no secondary tuner exists, lock dev->lock

By using the above scheme a single tuner device, will lock itself,
the first tuner in a dual tuner device will lock the second tuner,
and the second tuner in a dual tuner device will lock itself aka
the second tuner instance.

This is a perhaps a little hacky, which is why I've added the RFC.
A quick solution was required though, so I don't fix a couple
newer Hauppauge devices, just to break a lot of older ones.


Brad Love (1):
  em28xx: Fix dual transport stream operation

 drivers/media/usb/em28xx/em28xx-cards.c |  6 ++++-
 drivers/media/usb/em28xx/em28xx-dvb.c   | 47 +++++++++++++++++++++++++++++++--
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 51 insertions(+), 3 deletions(-)

-- 
2.7.4
