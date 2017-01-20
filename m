Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45033 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750893AbdATNIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:08:40 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] IR fixes for v4.11
Date: Fri, 20 Jan 2017 13:08:34 +0000
Message-Id: <cover.1484916689.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Testing of lirc uncovered some issue with tx-only devices, and some
other minor issues.

Sean Young (4):
  [media] lirc: fix transmit-only read features
  [media] rc: remove excessive spaces from error message
  [media] lirc: LIRC_GET_MIN_TIMEOUT should be in range
  [media] lirc: fix null dereference for tx-only devices

 drivers/media/rc/ir-lirc-codec.c | 7 ++++---
 drivers/media/rc/lirc_dev.c      | 2 +-
 drivers/media/rc/rc-main.c       | 3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.9.3

