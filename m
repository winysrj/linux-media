Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:51677 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdCRDSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 23:18:36 -0400
Received: from [192.168.23.40] (anwhome.anw.at [195.234.103.23])
        by mail.anw.at (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id v2I24NI4002371
        for <linux-media@vger.kernel.org>; Sat, 18 Mar 2017 03:04:23 +0100
To: linux-media@vger.kernel.org
From: "Jasmin J." <jasmin@anw.at>
Subject: [PATCH] media/dvb-core: Race condition when writing to CAM.
Message-ID: <ea8ab902-d50c-2e6d-52b0-0181188ef0e6@anw.at>
Date: Sat, 18 Mar 2017 03:04:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It started with a sporadic message in syslog:
"CAM tried to send a buffer larger than the ecount size"
This message is not the fault itself, but a consecutive fault, after a read
error from the CAM. This happens only on several CAMs, several hardware, and
of course sporadic.

It is a consecutive fault, if the last read from the CAM did fail. I guess
this will not happen on all CAMs, but at least it did on mine. There was a
write error to the CAM and during the re-initialization procedure, the CAM
finished the last read, although it got a RS.

The write error to the CAM happened because a race condition between HC write,
checking DA and FR.
This patch added an additional check for DA(RE), just after checking FR. It is
important to read the CAMs status register again, to give the CAM the
necessary time for a proper reaction to HC.
Please note the description within the source code (patch below).

Signed-off-by: Jasmin jessich <jasmin@anw.at>
Acked-by: rjkm@metzlerbros.de
Tested-by: rjkm@metzlerbros.de
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 8d65028..0007839 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -785,6 +785,24 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
                goto exit;
        }
 
+       /* It may need some time for the CAM to settle down, or there might be a
+          race condition between the CAM, writing HC and our last check for DA.
+          This happens, if the CAM asserts DA, just after checking DA before we
+          are setting HC. In this case it might be a bug in the CAM to keep the
+          FR bit, the lower layer/HW communication requires a longer timeout or
+          the CAM needs more time internally. But this happens in reality!
+          We need to read the status from the HW again and do the same we did
+          for the previous check for DA */
+       if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+               goto exit;
+       if (status & (STATUSREG_DA | STATUSREG_RE)) {
+               if (status & STATUSREG_DA)
+                       dvb_ca_en50221_thread_wakeup(ca);
+
+               status = -EAGAIN;
+               goto exit;
+       }
+
        /* send the amount of data */
        if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH, bytes_write >> 8)) != 0)
                goto exit;
-- 
2.7.4
