Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37046 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751086AbdHaIM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 04:12:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>
Subject: [PATCHv2 0/3] tc358743: add CEC support
Date: Thu, 31 Aug 2017 10:12:52 +0200
Message-Id: <20170831081255.23608-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This little patch series adds support for CEC to the Toshiba TC358743
HDMI to CSI bridge.

The CEC IP is identical to that of the tc358840 for which I already had
CEC support. So this is effectively the tc358840 CEC code copied to the
tc358743. An RFC version of the tc358840 has been posted to the mailinglist
in the past, but it is still not quite ready to be merged.

Once it is ready for merging I might decide to share the CEC code between the
two drivers, but for now just put it in the tc358743 code.

Tested with a Raspberry Pi 2B, Dave Stevenson's bcm283x camera receiver
driver and an Auvidea tc358743 board.

The first patch is a tiny fix for a potential issue in a stub function,
the other two add the CEC support to the tc358743 driver.

Regards,

	Hans

Changes since v1:

- Add tiny cec.h fix for stub function.
- Don't hardcode the physical address, instead read it from the EDID.


Hans Verkuil (3):
  cec.h: initialize *parent and *port in cec_phys_addr_validate
  tc358743_regs.h: add CEC registers
  tc358743: add CEC support

 drivers/media/i2c/Kconfig         |   8 ++
 drivers/media/i2c/tc358743.c      | 205 ++++++++++++++++++++++++++++++++++++--
 drivers/media/i2c/tc358743_regs.h |  94 ++++++++++++++++-
 include/media/cec.h               |   4 +
 4 files changed, 303 insertions(+), 8 deletions(-)

-- 
2.14.1
