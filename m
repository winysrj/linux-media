Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:10843 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaKQMSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:06 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [REVIEW PATCH 0/5] img-ir: Some fixes
Date: Mon, 17 Nov 2014 12:17:44 +0000
Message-ID: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here are a few fixes for the img-ir RC driver.

Patch 1 is the important one. I've tagged it for stable.

The other 4 are minor fixes/improvements that don't need backporting to
stable.

Dylan Rajaratnam (1):
  img-ir/hw: Always read data to clear buffer

James Hogan (4):
  img-ir/hw: Drop [un]register_decoder declarations
  img-ir: Depend on METAG or MIPS or COMPILE_TEST
  img-ir: Don't set driver's module owner
  MAINTAINERS: Add myself as img-ir maintainer

 MAINTAINERS                           | 5 +++++
 drivers/media/rc/img-ir/Kconfig       | 1 +
 drivers/media/rc/img-ir/img-ir-core.c | 1 -
 drivers/media/rc/img-ir/img-ir-hw.c   | 6 ++++--
 drivers/media/rc/img-ir/img-ir-hw.h   | 3 ---
 5 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.0.4

