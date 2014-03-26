Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38440 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaCZVKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 17:10:55 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so1704101wgg.13
        for <linux-media@vger.kernel.org>; Wed, 26 Mar 2014 14:10:54 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 0/3] rc: Misc fixes for v3.15
Date: Wed, 26 Mar 2014 21:08:30 +0000
Message-Id: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few misc fixes for v3.15, all relating to my previous patches.

James Hogan (3):
  rc-main: Revert generic scancode filtering support
  rc-main: Limit to a single wakeup protocol group
  rc: img-ir: Expand copyright headers with GPL notices

 drivers/media/rc/img-ir/img-ir-core.c  |  5 +++++
 drivers/media/rc/img-ir/img-ir-hw.c    |  5 +++++
 drivers/media/rc/img-ir/img-ir-hw.h    |  5 +++++
 drivers/media/rc/img-ir/img-ir-jvc.c   |  5 +++++
 drivers/media/rc/img-ir/img-ir-nec.c   |  5 +++++
 drivers/media/rc/img-ir/img-ir-raw.c   |  5 +++++
 drivers/media/rc/img-ir/img-ir-raw.h   |  5 +++++
 drivers/media/rc/img-ir/img-ir-sanyo.c |  5 +++++
 drivers/media/rc/img-ir/img-ir-sharp.c |  5 +++++
 drivers/media/rc/img-ir/img-ir-sony.c  |  5 +++++
 drivers/media/rc/img-ir/img-ir.h       |  5 +++++
 drivers/media/rc/rc-main.c             | 39 ++++++++++++++++++----------------
 12 files changed, 76 insertions(+), 18 deletions(-)

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: Antti Seppälä <a.seppala@gmail.com>
-- 
1.8.3.2

