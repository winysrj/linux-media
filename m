Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56304 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751402AbdH3OlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 10:41:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 0/2] tc358743: add CEC support
Date: Wed, 30 Aug 2017 16:41:20 +0200
Message-Id: <20170830144122.29054-1-hverkuil@xs4all.nl>
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

Regards,

	Hans

Hans Verkuil (2):
  tc358743_regs.h: add CEC registers
  tc358743: add CEC support

 drivers/media/i2c/Kconfig         |   8 ++
 drivers/media/i2c/tc358743.c      | 196 ++++++++++++++++++++++++++++++++++++--
 drivers/media/i2c/tc358743_regs.h |  94 +++++++++++++++++-
 3 files changed, 290 insertions(+), 8 deletions(-)

-- 
2.14.1
