Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47930 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1D1POV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:21 -0400
Subject: [PATCH 04/10] rc-core: add trailing silence in rc-loopback tx
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:32 +0200
Message-ID: <20110428151332.8272.25147.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If an IR command is sent (using the LIRC userspace) to rc-loopback
which doesn't include a trailing space, the result is that the message
won't be completely decoded. In addition, "leftovers" from a previous
transmission can be left until the next one. Fix this by faking a long
silence after the end of TX data.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 49cee61..cc846b2 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -146,6 +146,12 @@ static int loop_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
 		if (rawir.duration)
 			ir_raw_event_store_with_filter(dev, &rawir);
 	}
+
+	/* Fake a silence long enough to cause us to go idle */
+	rawir.pulse = false;
+	rawir.duration = dev->timeout;
+	ir_raw_event_store_with_filter(dev, &rawir);
+
 	ir_raw_event_handle(dev);
 
 out:

