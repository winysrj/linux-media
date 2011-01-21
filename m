Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AUE2r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:28:47 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0L4Slqc027763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 23:28:47 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] rc/streamzap: timeout needs to be in NS
Date: Thu, 20 Jan 2011 23:28:37 -0500
Message-Id: <1295584117-21050-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/streamzap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 6e2911c..1b013d4 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -430,7 +430,7 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 	sz->decoder_state = PulseSpace;
 	/* FIXME: don't yet have a way to set this */
 	sz->timeout_enabled = true;
-	sz->rdev->timeout = (((SZ_TIMEOUT * SZ_RESOLUTION * 1000) &
+	sz->rdev->timeout = ((MS_TO_NS(SZ_TIMEOUT * SZ_RESOLUTION) &
 				IR_MAX_DURATION) | 0x03000000);
 	#if 0
 	/* not yet supported, depends on patches from maxim */
-- 
1.7.3.4

