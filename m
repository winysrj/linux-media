Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.114]:42692 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCMK3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 06:29:53 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/3] rc: img-ir: Fixes a few warnings
Date: Thu, 13 Mar 2014 10:29:20 +0000
Message-ID: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix a few warnings in the img-ir driver, one from
coccinelle and two more from W=1 (thanks Mauro).

James Hogan (3):
  rc: img-ir: hw: Remove unnecessary semi-colon
  rc: img-ir: hw: Fix min/max bits setup
  rc: img-ir: jvc: Remove unused no-leader timings

 drivers/media/rc/img-ir/img-ir-hw.c  |  8 ++++----
 drivers/media/rc/img-ir/img-ir-jvc.c | 11 -----------
 2 files changed, 4 insertions(+), 15 deletions(-)

-- 
1.8.1.2

