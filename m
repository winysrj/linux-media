Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:48244 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932274AbcJMNvl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 09:51:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] dib0700: Fix uninitialized protocol for NEC repeat codes
Date: Thu, 13 Oct 2016 15:51:39 +0200
Message-Id: <1476366699-21611-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

    drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
    drivers/media/usb/dvb-usb/dib0700_core.c:679: warning: ‘protocol’ may be used uninitialized in this function

When receiving an NEC repeat code, protocol is indeed not initialized.
Set it to RC_TYPE_NECX to fix this.

Fixes: 2ceeca0499d74521 ("[media] rc: split nec protocol into its three variants")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Is RC_TYPE_NECX correct, or should it be RC_TYPE_NEC?
I used RC_TYPE_NECX based on the checks for {,not_}data and
{,not_}system for the other cases.
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f3196658fb700706..5878ae4d20ad27ed 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -718,6 +718,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		    poll_reply->nec.data       == 0x00 &&
 		    poll_reply->nec.not_data   == 0xff) {
 			poll_reply->data_state = 2;
+			protocol = RC_TYPE_NECX;
 			break;
 		}
 
-- 
1.9.1

