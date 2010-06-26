Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:50596 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0FZPAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 11:00:14 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id C14BFEF3F7
	for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 18:00:12 +0300 (EEST)
Received: from kuusi.koti (a88-114-153-83.elisa-laajakaista.fi [88.114.153.83])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 9AF004033
	for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 18:00:11 +0300 (EEST)
Message-ID: <4C2615FB.2000805@kolumbus.fi>
Date: Sat, 26 Jun 2010 18:00:11 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Avoid unnecessary data copying inside dvb_dmx_swfilter_204()
 function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro Carvalho Chehab.

I'm sorry for sending this twice. I Don't know yet how to disable HTML
formatting permanently.

This patch does a significant performance improvement (for the function
involved)
by avoiding move of 188 sized packets during 204 to 188 packet conversion.
Also this has a robustness fix at discontinuity points of DMA transfer
blocks.
I have tested that this code works.


While using "perf top", I noticed that there were two functions that
used CPU:
One was dvb_dmx_swfilter_packet and the other was dvb_dmx_swfilter_204.

dvb_dmx_swfilter_204 converts the packets from 204 byte format into 188
format.
It does so by copying the packet before modifications to it. I noticed
that it was a very rare case
(usually at most once in 16K data) when the SYNC byte had to be modified
from 0xB8 to 0x47.

So my modification does following things:
* Take a copy of the 188 or 204 bytes only if the packet must be
modified or backed up.
* Backing up last < 204 bytes: store only data with the 1st byte as the
SYNC byte (0xB8 or 0x47).
   This is the robustness fix: back up a beginning of a real packet, not
some unknown data block.

During my testing, this loses some bytes occassionally because of some
garbage in DMA transferred data:
I measured the number of lost bytes in the inline function that searches
the next SYNC byte.
So the algorithm seems to work, usually there aren't many bursts of
skipped bytes after the stream has stabilized.
I wanted to know how many bytes are skipped and in which positions in
16K block:

Jun 26 16:20:37 koivu kernel: demux: skipped 49 bytes at position 3379
Jun 26 16:20:37 koivu kernel: demux: skipped 18 bytes at position 9868
Jun 26 16:20:37 koivu kernel: demux: skipped 30 bytes at position 10090
Jun 26 16:20:38 koivu kernel: demux: skipped 14 bytes at position 7208
Jun 26 16:20:38 koivu kernel: demux: skipped 114 bytes at position 7426
Jun 26 16:20:38 koivu kernel: demux: skipped 103 bytes at position 12920
Jun 26 16:20:38 koivu kernel: demux: skipped 72 bytes at position 13431
Jun 26 16:20:38 koivu kernel: demux: skipped 1 bytes at position 13707
Jun 26 16:20:45 koivu kernel: demux: skipped 140 bytes at position 8476
Jun 26 16:20:46 koivu kernel: demux: skipped 70 bytes at position 11396
Jun 26 16:20:46 koivu kernel: demux: skipped 8 bytes at position 11670
Jun 26 16:20:46 koivu kernel: demux: skipped 2 bytes at position 11882

I measured performance improvement with "Perf top". The CPU was probably
mostly at 1Ghz and sometimes at 2Ghz,
so the actual number of samples changed randomly, but the relative
performance change between
unaltered dvb_dmx_swfilter_packet() and dvb_dmx_swfilter_204() is
significant (unrelated rows removed):
Testing was done with H.264 channel recording, and with Mercurial
version of v4l-dvb branch.
The patch below is done against v4l-dvb GIT version.

Original performance:
             samples  pcnt
function                                            DSO
               66.00 14.1%
dvb_dmx_swfilter_packet                            
[dvb_core]                                                      
               59.00 12.6%
dvb_dmx_swfilter_204                               
[dvb_core]                                                      
               11.00  2.4%
mantis_i2c_xfer                                    
[mantis_core]                                                   

Performance after patching:
             samples  pcnt
function                                            DSO
               81.00 29.0%
dvb_dmx_swfilter_packet                            
[dvb_core]                                             
               14.00  5.0%
mantis_i2c_xfer                                    
[mantis_core]                                          
                8.00  2.9%
dvb_dmx_swfilter_204                               
[dvb_core]                                             

So the relative performance has increased by a mangditude for
dvb_dmx_swfilter_204().

This patch is a modified version of the original dvb_dmx_swfilter_204().
I can give this patch for the Linux Kernel with license:

* This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.

as the original license in that file.

Patch written by: Marko Ristola <marko.ristola@kolumbus.fi>


Regards,
Marko Ristola


diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c
b/drivers/media/dvb/dvb-core/dvb_demux.c
index 977ddba..627d103 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -520,49 +520,60 @@ bailout:
 
 EXPORT_SYMBOL(dvb_dmx_swfilter);
 
+static inline int find204Sync(const u8 *buf, int pos, size_t count)
+{
+    while(likely(pos < count)) {
+        if (likely(buf[pos] == 0x47 || buf[pos] == 0xB8))
+            break;
+        pos++;
+    }
+
+    return pos;
+}
+
 void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf,
size_t count)
 {
     int p = 0, i, j;
-    u8 tmppack[188];
+    const u8 *q;
 
     spin_lock(&demux->lock);
 
-    if (demux->tsbufp) {
+    if (likely(demux->tsbufp)) { /* tsbuf[0] is now 0x47. */
         i = demux->tsbufp;
         j = 204 - i;
-        if (count < j) {
+        if (unlikely(count < j)) {
             memcpy(&demux->tsbuf[i], buf, count);
             demux->tsbufp += count;
             goto bailout;
         }
         memcpy(&demux->tsbuf[i], buf, j);
-        if ((demux->tsbuf[0] == 0x47) || (demux->tsbuf[0] == 0xB8)) {
-            memcpy(tmppack, demux->tsbuf, 188);
-            if (tmppack[0] == 0xB8)
-                tmppack[0] = 0x47;
-            dvb_dmx_swfilter_packet(demux, tmppack);
-        }
+        if (likely(demux->tsbuf[0] == 0x47)) /* double check */
+            dvb_dmx_swfilter_packet(demux, demux->tsbuf);
         demux->tsbufp = 0;
         p += j;
     }
 
-    while (p < count) {
-        if ((buf[p] == 0x47) || (buf[p] == 0xB8)) {
-            if (count - p >= 204) {
-                memcpy(tmppack, &buf[p], 188);
-                if (tmppack[0] == 0xB8)
-                    tmppack[0] = 0x47;
-                dvb_dmx_swfilter_packet(demux, tmppack);
-                p += 204;
-            } else {
-                i = count - p;
-                memcpy(demux->tsbuf, &buf[p], i);
-                demux->tsbufp = i;
-                goto bailout;
-            }
-        } else {
-            p++;
+    while (likely((p = find204Sync(buf, p, count)) < count)) {
+        if (unlikely(count - p < 204))
+            break;
+
+        q = &buf[p];
+
+        if (unlikely(*q == 0xB8)) {
+            memcpy(demux->tsbuf, q, 188);
+            demux->tsbuf[0] = 0x47;
+            q = demux->tsbuf;
         }
+        dvb_dmx_swfilter_packet(demux, q);
+        p += 204;
+    }
+
+    i = count - p;
+    if (likely(i)) {
+        memcpy(demux->tsbuf, &buf[p], i);
+        demux->tsbufp = i;
+        if (unlikely(demux->tsbuf[0] == 0xB8))
+            demux->tsbuf[0] = 0x47;
     }
 
 bailout:

