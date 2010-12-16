Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:54538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab0LPTBB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 14:01:01 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBGJ1080030146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:01:00 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/4] mceusb: set a default rx timeout
Date: Thu, 16 Dec 2010 14:00:35 -0500
Message-Id: <1292526037-21491-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1292526037-21491-1-git-send-email-jarod@redhat.com>
References: <1292526037-21491-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Its possible for the call to read rx timeout from the hardware to fail,
in which case we end up with a bogus rx timeout value. Set a default one
when filling in the rc struct, and we'll just overwrite it later w/the
value from hardware, but if that read fails, we've at least got a sane
rx timeout value to work with (1000ms is the default value I've seen
returned on most if not all mceusb hardware).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 0739dee..94b95d4 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1059,6 +1059,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
+	rc->timeout = MS_TO_NS(1000);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
-- 
1.7.1

