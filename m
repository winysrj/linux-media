Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43171 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752296AbeDOJyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 05:54:24 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Warren Sturm <warren.sturm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Andy Walls <awalls.cx18@gmail.com>
Subject: [PATCH stable v4.15 0/3] lirc_zilog bugs
Date: Sun, 15 Apr 2018 10:54:19 +0100
Message-Id: <cover.1523785117.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has a few problems, however the driver has been removed from
staging in v4.16 (replaced by a new driver). Please can these patches
be included in the 4.15.* stable tree.

Thanks

Sean Young (3):
  media: staging: lirc_zilog: broken reference counting
  Revert "media: lirc_zilog: driver only sends LIRCCODE"
  media: staging: lirc_zilog: incorrect reference counting

 drivers/staging/media/lirc/lirc_zilog.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.14.3
