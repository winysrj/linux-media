Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34632 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3CEWCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 17:02:45 -0500
Received: by mail-la0-f48.google.com with SMTP id fq13so6584633lab.7
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 14:02:44 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 23:02:43 +0100
Message-ID: <CABdi052sHQBYjZkNTE5ODDTr=WWFtptUowKOpyO1A9PB00dCDA@mail.gmail.com>
Subject: [PATCH] dvb_demux: Transport stream continuity check fix
From: John Smith <johns90812@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch avoids incrementing continuity counter
demux->cnt_storage[pid] for TS packets without payload in accordance
with ISO /IEC 13818-1.

Signed-off-by: John Smith <johns90812@gmail.com>

diff --git a/drivers/media/dvb-core/dvb_demux.c
b/drivers/media/dvb-core/dvb_demux.c
index d319717..70a89c8 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -443,14 +443,18 @@ static void dvb_dmx_swfilter_packet(struct
dvb_demux *demux, const u8 *buf)
     if (demux->cnt_storage && dvb_demux_tscheck) {
         /* check pkt counter */
         if (pid < MAX_PID) {
-            if ((buf[3] & 0xf) != demux->cnt_storage[pid])
+            if (buf[3] & 0x10)
+                demux->cnt_storage[pid] =
+                    (demux->cnt_storage[pid] + 1) & 0xf;
+
+            if ((buf[3] & 0xf) != demux->cnt_storage[pid]) {
                 dprintk_tscheck("TS packet counter mismatch. "
                         "PID=0x%x expected 0x%x "
                         "got 0x%x\n",
                         pid, demux->cnt_storage[pid],
                         buf[3] & 0xf);
-
-            demux->cnt_storage[pid] = ((buf[3] & 0xf) + 1)&0xf;
+                demux->cnt_storage[pid] = buf[3] & 0xf;
+            }
         }
         /* end check */
     }
