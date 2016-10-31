Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48613 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945220AbcJaRwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/9] Various IR fixes
Date: Mon, 31 Oct 2016 17:52:18 +0000
Message-Id: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Teach the redrat3 driver how to use the wideband receiver, also fix
some very nasty crashes if you disconnect a lirc device while
reading from it.

Sean Young (9):
  [media] winbond-cir: use name without space for pnp driver
  [media] redrat3: don't include vendor/product id in name
  [media] redrat3: remove dead code and pointless messages
  [media] redrat3: fix error paths in probe
  [media] redrat3: enable carrier reports using wideband receiver
  [media] redrat3: increase set size for lengths to maximum
  [media] lirc: might sleep error in lirc_dev_fop_read
  [media] lirc: prevent use-after free
  [media] lirc: use-after free while reading from device and unplugging

 drivers/media/rc/lirc_dev.c    |  18 +--
 drivers/media/rc/redrat3.c     | 283 +++++++++++++++++++++++++----------------
 drivers/media/rc/winbond-cir.c |   2 +-
 3 files changed, 181 insertions(+), 122 deletions(-)

-- 
2.7.4

