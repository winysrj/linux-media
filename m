Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3KJKvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 05:51:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VfSbj-0002ot-Qy
	for linux-media@vger.kernel.org; Sun, 10 Nov 2013 11:51:07 +0100
Received: from p54BD390D.dip0.t-ipconnect.de ([84.189.57.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 10 Nov 2013 11:51:07 +0100
Received: from linux by p54BD390D.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 10 Nov 2013 11:51:07 +0100
To: linux-media@vger.kernel.org
From: Martin Kittel <linux@martin-kittel.de>
Subject: Patch mceusb: fix invalid urb interval 
Date: Sun, 10 Nov 2013 10:50:45 +0000 (UTC)
Message-ID: <loom.20131110T113621-661@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I had trouble getting my MCE remote control to work on my new Intel
mainboard. It was working fine with older boards but with the new board
there would be no reply from the remote just after the setup package was
received during the init phase.
I traced the problem down to the mceusb_dev_recv function where the received
urb is resubmitted again. The problem is that my new board is so blazing
fast that the initial urb was processed in less than a single 125
microsecond interval, so the urb as it was received had urb->interval set to 0.
As the urb is just resubmitted as it came in it now had an invalid interval
set and was rejected.
The patch just resets urb->interval to its initial value and adds some error
diagnostics (which would have saved me a lot of time during my analysis).

Any comment is welcome.

Best wishes,

Martin.


diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 3c76101..c5313cb 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1030,7 +1030,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir
 static void mceusb_dev_recv(struct urb *urb)
 {
        struct mceusb_dev *ir;
-       int buf_len;
+       int buf_len, res;
 
        if (!urb)
                return;
@@ -1067,7 +1067,11 @@ static void mceusb_dev_recv(struct urb *urb)
                break;
        }
 
-       usb_submit_urb(urb, GFP_ATOMIC);
+       urb->interval = ir->usb_ep_out->bInterval; /* reset urb interval */
+       res = usb_submit_urb(urb, GFP_ATOMIC);
+       if (res) {
+               mce_dbg(ir->dev, "restart request FAILED! (res=%d)\n", res);
+       }
 }
 
 static void mceusb_get_emulator_version(struct mceusb_dev *ir)


