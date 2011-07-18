Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1GRTyl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 15:54:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IJsfW7025531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 15:54:41 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2 2/9] [media] mceusb: give hardware time to reply to cmds
Date: Mon, 18 Jul 2011 15:54:22 -0400
Message-Id: <1311018869-22794-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes the init routine is blasting commands out to the hardware
faster than it can reply. Throw a brief delay in there to give the
hardware a chance to reply before we send the next command.

v2: use msleep instead of mdelay per Mauro's suggestion

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 111bead..b1ea485 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -735,6 +735,7 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
 {
 	mce_request_packet(ir, data, size, MCEUSB_TX);
+	msleep(10);
 }
 
 static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
-- 
1.7.1

