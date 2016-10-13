Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52563 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932257AbcJMV2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 17:28:46 -0400
Date: Thu, 13 Oct 2016 22:28:44 +0100
From: Sean Young <sean@mess.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dib0700: fix nec repeat handling
Message-ID: <20161013212844.GA23230@gofer.mess.org>
References: <1476366699-21611-1-git-send-email-geert@linux-m68k.org>
 <20161013211407.GB21731@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161013211407.GB21731@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When receiving a nec repeat, ensure the correct scancode is repeated
rather than a random value from the stack. This removes the need
for the bogus uninitialized_var() and also fixes the warnings:

    drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
    drivers/media/usb/dvb-usb/dib0700_core.c:679: warning: ‘protocol’ may be used uninitialized in this function

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f319665..5bb23ef 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -677,7 +677,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_rc_response *poll_reply;
 	enum rc_type protocol;
-	u32 uninitialized_var(keycode);
+	u32 keycode;
 	u8 toggle;
 
 	deb_info("%s()\n", __func__);
@@ -718,7 +718,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		    poll_reply->nec.data       == 0x00 &&
 		    poll_reply->nec.not_data   == 0xff) {
 			poll_reply->data_state = 2;
-			break;
+			rc_repeat(d->rc_dev);
+			goto resubmit;
 		}
 
 		if ((poll_reply->nec.data ^ poll_reply->nec.not_data) != 0xff) {
-- 
2.7.4

