Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57585 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbeECLIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 07:08:13 -0400
Date: Thu, 3 May 2018 12:08:12 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.18] rc changes
Message-ID: <20180503110812.pj4cybqjam33dxpw@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just small changes: detect some more zilog transmitters (after trawling
ebay I found some more cards with a zilog ir), and support the directional
pad on the imon pad remote.

Thanks
Sean

The following changes since commit a2b2eff6ac2716f499defa590a6ec4ba379d765e:

  media: v4l: fwnode: Fix comment incorrectly mentioning v4l2_fwnode_parse_endpoint (2018-04-23 17:20:07 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18b

for you to fetch changes up to 67e7db576556620150ac4386a5c77651242833ca:

  media: rc: probe zilog transmitter when zilog receiver is found (2018-05-03 11:42:57 +0100)

----------------------------------------------------------------
Sean Young (3):
      media: rc: only register protocol for rc device if enabled
      media: rc: imon decoder: support the stick
      media: rc: probe zilog transmitter when zilog receiver is found

 drivers/media/i2c/ir-kbd-i2c.c     |   4 +-
 drivers/media/rc/ir-imon-decoder.c | 135 ++++++++++++++++++++++++++++++++++++-
 drivers/media/rc/rc-core-priv.h    |   3 +
 drivers/media/rc/rc-ir-raw.c       |  30 +++++----
 4 files changed, 156 insertions(+), 16 deletions(-)
