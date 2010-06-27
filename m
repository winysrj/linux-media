Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48033 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0F0JKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 05:10:01 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 8A2E28C413
	for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 12:09:59 +0300 (EEST)
Message-ID: <4C271564.2020501@kolumbus.fi>
Date: Sun, 27 Jun 2010 12:09:56 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Avoid unnecessary data copying inside dvb_dmx_swfilter_204()
 function
References: <4C2615FB.2000805@kolumbus.fi>
In-Reply-To: <4C2615FB.2000805@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

Here is an improved version of the original patch:
The original patch removed unnecessary copying for 204 sized packets only.
This patch improves performance for 188 sized packets too.

Unnecessary copying means: if dvb_dmx_swfilter(_204)() doesn't have to
modify
the source packet, the source packet is delivered for
dvb_dmx_swfilter_packet()
without copying.

This assumes, that a DMA transfer won't modify the accepted 188/204 sized
packet underneath while dvb_dmx_swfilter_packet() processes it.
The assumption is already in dvb_dmx_swfilter_packets().

With tasklets the risk for breaking the assumption is low. If there
would be
a normal thread instead of a tasklet, copying from the DMA buffer might
come too late.

Could someone test this patch who uses the dvb_dmx_swfilter() function
(188 sized)?

So _dvb_dmx_swfilter is now common for both 188 and 204 sized packet
parsing.
The measure was done during recording of H.264 steram under VDR,
using "perf top -d 10"

   PerfTop:      62 irqs/sec  kernel:80.6% [1000Hz cycles],  (all, 1 CPUs)

             samples  pcnt
function                                            DSO

              339.00 18.1%
dvb_dmx_swfilter_packet                            
[dvb_core]                                                   
              315.00 16.9%
acpi_pm_read                                       
[kernel.kallsyms]                                            
               70.00  3.7%
_ZN2SI5CRC325crc32EPKcij                           
/usr/sbin/vdr                                                
               53.00  2.8%
mantis_i2c_xfer                                    
[mantis_core]                                                
               53.00  2.8%
__mktime_internal                                  
/lib64/libc-2.12.so                                          
               39.00  2.1%
_ZN14cAudioRepacker6RepackEP17cRingBufferLinearPKhi
/usr/sbin/vdr                                                
               33.00  1.8%
delay_tsc                                          
[kernel.kallsyms]                                            
               30.00  1.6%
dvb_dmx_memcopy                                    
[dvb_core]                                                   
               28.00  1.5%
dvb_ringbuffer_write                               
[dvb_core]                                                   
               28.00  1.5%
_dvb_dmx_swfilter                                  
[dvb_core]                                                   


diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c
b/drivers/media/dvb/dvb-core/dvb_demux.c
index 977ddba..2ddaaaa 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -478,95 +478,78 @@ void dvb_dmx_swfilter_packets(struct dvb_demux
*demux, const u8 *buf,
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
 
-void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
+static inline int findNextSyncByte(const u8 *buf, int pos, size_t
count, const int pktsize)
+{
+    while(likely(pos < count)) {
+        if (likely(buf[pos] == 0x47 || (pktsize == 204 && buf[pos] ==
0xB8)))
+            break;
+        pos++;
+    }
+
+    return pos;
+}
+
+/* pktsize must be either 204 or 188. If pktsize is 204, 0xB8 must be
accepted for SYNC byte too, but then convert it into 0x47.
+ * Designed pktsize so, that compiler would remove 204 related code
during inlining. */
+static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8
*buf, size_t count, const int pktsize)
 {
     int p = 0, i, j;
+    const u8 *q;
 
     spin_lock(&demux->lock);
 
-    if (demux->tsbufp) {
+    if (likely(demux->tsbufp)) { /* tsbuf[0] is now 0x47. */
         i = demux->tsbufp;
-        j = 188 - i;
-        if (count < j) {
+        j = pktsize - i;
+        if (unlikely(count < j)) {
             memcpy(&demux->tsbuf[i], buf, count);
             demux->tsbufp += count;
             goto bailout;
         }
         memcpy(&demux->tsbuf[i], buf, j);
-        if (demux->tsbuf[0] == 0x47)
+        if (likely(demux->tsbuf[0] == 0x47)) /* double check */
             dvb_dmx_swfilter_packet(demux, demux->tsbuf);
         demux->tsbufp = 0;
         p += j;
     }
 
-    while (p < count) {
-        if (buf[p] == 0x47) {
-            if (count - p >= 188) {
-                dvb_dmx_swfilter_packet(demux, &buf[p]);
-                p += 188;
-            } else {
-                i = count - p;
-                memcpy(demux->tsbuf, &buf[p], i);
-                demux->tsbufp = i;
-                goto bailout;
-            }
-        } else
-            p++;
+    while (likely((p = findNextSyncByte(buf, p, count, pktsize)) <
count)) {
+        if (unlikely(count - p < pktsize))
+            break;
+
+        q = &buf[p];
+
+        if (unlikely(pktsize == 204 && (*q == 0xB8))) {
+            memcpy(demux->tsbuf, q, 188);
+            demux->tsbuf[0] = 0x47;
+            q = demux->tsbuf;
+        }
+        dvb_dmx_swfilter_packet(demux, q);
+        p += pktsize;
+    }
+
+    i = count - p;
+    if (likely(i)) {
+        memcpy(demux->tsbuf, &buf[p], i);
+        demux->tsbufp = i;
+        if (unlikely(pktsize == 204 && demux->tsbuf[0] == 0xB8))
+            demux->tsbuf[0] = 0x47;
     }
 
 bailout:
     spin_unlock(&demux->lock);
 }
 
+void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
+{
+    _dvb_dmx_swfilter(demux, buf, count, 188);
+}
+
 EXPORT_SYMBOL(dvb_dmx_swfilter);
 
 void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf,
size_t count)
 {
-    int p = 0, i, j;
-    u8 tmppack[188];
-
-    spin_lock(&demux->lock);
-
-    if (demux->tsbufp) {
-        i = demux->tsbufp;
-        j = 204 - i;
-        if (count < j) {
-            memcpy(&demux->tsbuf[i], buf, count);
-            demux->tsbufp += count;
-            goto bailout;
-        }
-        memcpy(&demux->tsbuf[i], buf, j);
-        if ((demux->tsbuf[0] == 0x47) || (demux->tsbuf[0] == 0xB8)) {
-            memcpy(tmppack, demux->tsbuf, 188);
-            if (tmppack[0] == 0xB8)
-                tmppack[0] = 0x47;
-            dvb_dmx_swfilter_packet(demux, tmppack);
-        }
-        demux->tsbufp = 0;
-        p += j;
-    }
-
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
-        }
-    }
-
-bailout:
-    spin_unlock(&demux->lock);
+    _dvb_dmx_swfilter(demux, buf, count, 204);
 }
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_204);

