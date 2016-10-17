Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:54607 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758191AbcJQWOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 18:14:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 13/28] [media] dib0700: fix uninitialized data on 'repeat' event
Date: Tue, 18 Oct 2016 00:13:34 +0200
Message-Id: <20161017221355.1861551-1-arnd@arndb.de>
In-Reply-To: <20161017220342.1627073-1-arnd@arndb.de>
References: <20161017220342.1627073-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After a recent cleanup patch, "gcc -Wmaybe-uninitialized" reports a new
warning about an existing bug:

drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
drivers/media/usb/dvb-usb/dib0700_core.c:763:2: error: ‘protocol’ may be used uninitialized in this function [-Werror=maybe-uninitialized]

It turns out that the "0 0 0 FF" sequence of input data has already
caused an uninitialized data use for the keycode variable, but that
was hidden with the 'uninitialized_var()' macro. Now, the protocol
is also uninitialized.

This changes the code to not report any key for this sequence, which
fixes both problems, and allows us to also remove the misleading
uninitialized_var() annotation.

It is possible that we should call rc_repeat() here, but I'm not
sure about that.

Fixes: 2ceeca0499d7 ("[media] rc: split nec protocol into its three variants")
Fixes: d3c501d1938c ("V4L/DVB: dib0700: Fix RC protocol logic to properly handle NEC/NECx and RC-5")
Cc: Sean Young <sean@mess.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f319665..3678ebf 100644
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
@@ -742,11 +742,10 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 			protocol = RC_TYPE_NEC;
 		}
 
+		rc_keydown(d->rc_dev, protocol, keycode, toggle);
 		break;
 	default:
 		deb_data("RC5 protocol\n");
-		protocol = RC_TYPE_RC5;
-		toggle = poll_reply->report_id;
 		keycode = RC_SCANCODE_RC5(poll_reply->rc5.system, poll_reply->rc5.data);
 
 		if ((poll_reply->rc5.data ^ poll_reply->rc5.not_data) != 0xff) {
@@ -754,14 +753,13 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 			err("key failed integrity check: %02x %02x %02x %02x",
 			    poll_reply->rc5.not_used, poll_reply->rc5.system,
 			    poll_reply->rc5.data, poll_reply->rc5.not_data);
-			goto resubmit;
+			break;
 		}
 
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, keycode, poll_reply->report_id);
 		break;
 	}
 
-	rc_keydown(d->rc_dev, protocol, keycode, toggle);
-
 resubmit:
 	/* Clean the buffer before we requeue */
 	memset(purb->transfer_buffer, 0, RC_MSG_SIZE_V1_20);
-- 
2.9.0

