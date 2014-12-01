Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:46904 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLAMzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 07:55:21 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>,
	James Hogan <james.hogan@imgtec.com>,
	<linux-media@vger.kernel.org>
Subject: [REVIEW PATCH 0/2] img-ir: Some more fixes
Date: Mon, 1 Dec 2014 12:55:08 +0000
Message-ID: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few more fixes for the img-ir RC driver in addition to the ones I
posted a couple of weeks ago.

The first patch fixes some broken behaviour when the same protocol is
set twice and the effective scancode filter gets cleared as a result.

The second patch fixes a potential deadlock and lockdep splat due to the
repeat end timer being del_timer_sync'd with the spin lock held when
changing protocols.

The second patch here depends on "img-ir/hw: Always read data to clear
buffer" (patch 1 in the previous img-ir patchset) to avoid conflicts, so
that patch should be applied first.

I've tagged both for stable (v3.15+).

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>
Cc: linux-media@vger.kernel.org

James Hogan (2):
  img-ir/hw: Avoid clearing filter for no-op protocol change
  img-ir/hw: Fix potential deadlock stopping timer

 drivers/media/rc/img-ir/img-ir-hw.c | 28 +++++++++++++++++++++++++---
 drivers/media/rc/img-ir/img-ir-hw.h |  3 +++
 2 files changed, 28 insertions(+), 3 deletions(-)

-- 
2.0.4

