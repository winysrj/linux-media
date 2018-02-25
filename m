Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34889 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbeBYMb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:56 -0500
Received: by mail-wm0-f54.google.com with SMTP id x7so9987651wmc.0
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:56 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 12/12] [media] ngene: compensate for TS buffer offset shifts
Date: Sun, 25 Feb 2018 13:31:40 +0100
Message-Id: <20180225123140.19486-13-d.scheller.oss@gmail.com>
In-Reply-To: <20180225123140.19486-1-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

A possible hardware bug was discovered when using CA addon hardware
attached to the ngene hardware, in that the TS input buffer much likely
will shift and thus become unaligned to 188 byte blocks (a full TS frame)
when things like CA module initialisation (which happens via differing
communication paths) take place. This causes the TS NULL removal in
tsin_exchange() to fail to detect this previously inserted data and thus
causes userspace applications to receive data they didn't sent beforehand
and ultimately cause troubles.

On driver load with an inserted CAM, buffers are fine at first (note that
the driver has to keep the communication running from/to the card by
inserting TS NULL frames, this is done in tsout_exchange() via
FillTSBuffer() - that data is simply sent back by the hardware):

  offset | 0    1   2   3   4   5 .... 188 189 190 191 192 193 .... 376
  data   | 47  1f  ff  10  6f  6f ....  47  1f  ff  10  6f  6f ....  47

After a few seconds, the CA module is recognised and initialised, which is
signalled by

  dvb_ca_en50221: dvb_ca adapter X: DVB CAM detected and initialised successfully

This is where the first shift happens (this is always four bytes), buffer
becomes like this:

  offset | 0    1   2   3   4   5 .... 188 189 190 191 192 193 .... 376
  data   | 6f  6f  6f  6f  47  1f ....  6f  6f  6f  6f  47  1f ....  6f

Next, VDR, TVHeadend or any other CI aware application is started, buffers
will shift by even more bytes. It is believed this is due to the hardware
not handling control and data bytes properly distinct, and control data
having an influence on the actual data stream, which we cannot properly
detect at the driver level.

Workaround this hardware quirk by adding a detection for the TS sync byte
0x47 before each TS frame copy, scan for a new SYNC byte and a TS NULL
packet if buffers become unaligned, take note of that offset and apply
that when copying data to the DVB ring buffers. The last <188 bytes from
the hardware buffers are stored in a temp buffer (tsin_buffer), for which
the remainder will be in the beginning of the next hardware buffer (next
iteration of tsin_exchange()). That remainder will be appended to the
temp buffer and finally sent to the DVB ring buffer. The resulting TS
stream is perfectly fine, and the TS NULL packets inserted by the driver
which are sent back are properly removed. The resulting offset is being
clamped to 188 byte segments (one TS packet). Though this can result in
a repeated TS packet if the overall offset grows beyond this (and it
will grow only on CA initialisation), this is still way better than
unaligned TS frames and data sent to userspace that just isn't supposed
to be there.

This compensation can be toggled by the ci_tsfix modparam, which defaults
to 1 (enabled). In the case of problems, this can be turned off by setting
the parameter to 0 to restore the old behaviour.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Changes since v1:
- TS buffer offset correction missed a check for the remaining buffer
  length before copying the next full 188-byte block, which might could
  have caused out-of-bound-reads from void *buf. Also, tsin_find_offset
  returns it's offset clamped to 188 byte boundaries to not accidentally
  skip over valid TS data. Few typos in the commit message were fixed
  and a note for the modparam was added, too.

 drivers/media/pci/ngene/ngene-dvb.c | 91 ++++++++++++++++++++++++++++++++++++-
 drivers/media/pci/ngene/ngene.h     |  3 ++
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index 6d72b9f69418..0f9759a4d124 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -38,6 +38,9 @@
 
 #include "ngene.h"
 
+static int ci_tsfix = 1;
+module_param(ci_tsfix, int, 0444);
+MODULE_PARM_DESC(ci_tsfix, "Detect and fix TS buffer offset shifs in conjunction with CI expansions (default: 1/enabled)");
 
 /****************************************************************************/
 /* COMMAND API interface ****************************************************/
@@ -123,6 +126,24 @@ static u32 overflow;
 static u32 stripped;
 #endif
 
+static int tsin_find_offset(void *buf, u32 len)
+{
+	int i, l;
+
+	l = len - sizeof(fill_ts);
+	if (l <= 0)
+		return -1;
+
+	for (i = 0; i < l; i++) {
+		if (((char *)buf)[i] == 0x47) {
+			if (!memcmp(buf + i, fill_ts, sizeof(fill_ts)))
+				return i % 188;
+		}
+	}
+
+	return -1;
+}
+
 static inline void tsin_copy_stripped(struct ngene *dev, void *buf)
 {
 	if (memcmp(buf, fill_ts, sizeof(fill_ts)) != 0) {
@@ -153,18 +174,86 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 {
 	struct ngene_channel *chan = priv;
 	struct ngene *dev = chan->dev;
-
+	int tsoff;
 
 	if (flags & DF_SWAP32)
 		swap_buffer(buf, len);
 
 	if (dev->ci.en && chan->number == 2) {
+		/* blindly copy buffers if ci_tsfix is disabled */
+		if (!ci_tsfix) {
+			while (len >= 188) {
+				tsin_copy_stripped(dev, buf);
+
+				buf += 188;
+				len -= 188;
+			}
+			return NULL;
+		}
+
+		/* ci_tsfix = 1 */
+
+		/*
+		 * since the remainder of the TS packet which got cut off
+		 * in the previous tsin_exchange() run is at the beginning
+		 * of the new TS buffer, append this to the temp buffer and
+		 * send it to the DVB ringbuffer afterwards.
+		 */
+		if (chan->tsin_offset) {
+			memcpy(&chan->tsin_buffer[(188 - chan->tsin_offset)],
+			       buf, chan->tsin_offset);
+			tsin_copy_stripped(dev, &chan->tsin_buffer);
+
+			buf += chan->tsin_offset;
+			len -= chan->tsin_offset;
+		}
+
+		/*
+		 * copy TS packets to the DVB ringbuffer and detect new offset
+		 * shifts by checking for a valid TS SYNC byte
+		 */
 		while (len >= 188) {
+			if (*((char *)buf) != 0x47) {
+				/*
+				 * no SYNC header, find new offset shift
+				 * (max. 188 bytes, tsoff will be mod 188)
+				 */
+				tsoff = tsin_find_offset(buf, len);
+				if (tsoff > 0) {
+					chan->tsin_offset += tsoff;
+					chan->tsin_offset %= 188;
+
+					buf += tsoff;
+					len -= tsoff;
+
+					dev_info(&dev->pci_dev->dev,
+						 "%s(): tsin_offset shift by %d on channel %d\n",
+						 __func__, tsoff,
+						 chan->number);
+
+					/*
+					 * offset corrected. re-check remaining
+					 * len for a full TS frame, break and
+					 * skip to fragment handling if < 188.
+					 */
+					if (len < 188)
+						break;
+				}
+			}
+
 			tsin_copy_stripped(dev, buf);
 
 			buf += 188;
 			len -= 188;
 		}
+
+		/*
+		 * if a fragment is left, copy to temp buffer. The remainder
+		 * will be appended in the next tsin_exchange() iteration.
+		 */
+		if (len > 0 && len < 188)
+			memcpy(&chan->tsin_buffer, buf, len);
+
 		return NULL;
 	}
 
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 66d8eaa28549..01d9f1b58fcb 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -732,6 +732,9 @@ struct ngene_channel {
 #endif
 
 	int running;
+
+	int tsin_offset;
+	u8  tsin_buffer[188];
 };
 
 
-- 
2.16.1
