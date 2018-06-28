Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:38939 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752095AbeF1R3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 13:29:44 -0400
From: Brad Love <brad@nextdimension.cc>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2] [RFC] em28xx: Fix dual transport stream use
Date: Thu, 28 Jun 2018 12:29:08 -0500
Message-Id: <1530206949-16122-1-git-send-email-brad@nextdimension.cc>
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

This v2 patch changes from shared state and device locking to a
simple check to verify if a device has dual tuner capability.
If a device is a single tuner model, then alt mode is explicitly
set during start_streaming, but dual tuner devices are not altered.
Testing has shown that DualHD devices, both isoc and bulk models,
work correctly if alt mode is set once in em28xx_dvb_init.

This v2 patch only handles the regression, and ignores the fact
alt mode setting logic could probably be rethought across
em28xx-dvb, em28xx-video, and em28xx-also drivers. However since
the alt mode is never set to 0 on DVB stream stop, this simple v2
approach seems sufficient for now.


Brad Love (1):
  em28xx: Fix dual transport stream operation

 drivers/media/usb/em28xx/em28xx-dvb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.7.4
