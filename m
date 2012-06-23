Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38833 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2FWMAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 08:00:13 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, kernel-janitors@vger.kernel.org,
	Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] dvb-core: Release semaphore on error path dvb_register_device().
Date: Sat, 23 Jun 2012 17:29:54 +0530
Message-Id: <1340452794-8117-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

There is a missing "up_write()" here. Semaphore should be released
before returning error value.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
Destination tree "linux-next"

 drivers/media/dvb/dvb-core/dvbdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 00a6732..39eab73 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -243,6 +243,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if (minor == MAX_DVB_MINORS) {
 		kfree(dvbdevfops);
 		kfree(dvbdev);
+		up_write(&minor_rwsem);
 		mutex_unlock(&dvbdev_register_lock);
 		return -EINVAL;
 	}
-- 
1.7.4.4

