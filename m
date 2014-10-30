Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbaJ3L3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 07:29:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/2] Update Auvitek au0828 quirks
Date: Thu, 30 Oct 2014 09:28:10 -0200
Message-Id: <cover.1414668341.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several Auvitek au0828 listed at sound quirks. However,
the table there is incomplete. Simplify the table using a macro
for au0828 devices and update it to reflect the devices currently

-

v2: Fix SOB, au0828 driver reference and add a warning at au0828-cards.c.

Mauro Carvalho Chehab (2):
  [media] sound: simplify au0828 quirk table
  [media] sound: Update au0828 quirks table

 drivers/media/usb/au0828/au0828-cards.c |   5 +
 sound/usb/quirks-table.h                | 166 ++++++++------------------------
 2 files changed, 44 insertions(+), 127 deletions(-)

-- 
1.9.3

