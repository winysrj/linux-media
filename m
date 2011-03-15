Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:47649 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab1COIx2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:28 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
	Florian Mickler <florian@mickler.org>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 03/16] [media] a800: get rid of on-stack dma buffers
Date: Tue, 15 Mar 2011 09:43:35 +0100
Message-Id: <1300178655-24832-3-git-send-email-florian@mickler.org>
In-Reply-To: <1300178655-24832-1-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
 <1300178655-24832-1-git-send-email-florian@mickler.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/a800.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 53b93a4..fe2366b 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -78,17 +78,26 @@ static struct rc_map_table rc_map_a800_table[] = {
 
 static int a800_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	u8 key[5];
+	int ret;
+	u8 *key = kmalloc(5, GFP_KERNEL);
+	if (!key)
+		return -ENOMEM;
+
 	if (usb_control_msg(d->udev,usb_rcvctrlpipe(d->udev,0),
 				0x04, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, key, 5,
-				2000) != 5)
-		return -ENODEV;
+				2000) != 5) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	/* call the universal NEC remote processor, to find out the key's state and event */
 	dvb_usb_nec_rc_key_to_event(d,key,event,state);
 	if (key[0] != 0)
 		deb_rc("key: %x %x %x %x %x\n",key[0],key[1],key[2],key[3],key[4]);
-	return 0;
+	ret = 0;
+out:
+	kfree(key);
+	return ret;
 }
 
 /* USB Driver stuff */
-- 
1.7.4.rc3

