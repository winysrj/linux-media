Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy004.phy.lolipop.jp ([157.7.104.45]:60540 "EHLO
        smtp-proxy004.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751505AbcIJE5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 00:57:48 -0400
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: clemens@ladisch.de, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: [RFC][PATCH 1/2] ALSA: control: export layout of TLV payload to UAPI header
Date: Sat, 10 Sep 2016 13:50:15 +0900
Message-Id: <1473483016-10529-2-git-send-email-o-takashi@sakamocchi.jp>
In-Reply-To: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
References: <1473483016-10529-1-git-send-email-o-takashi@sakamocchi.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In ALSA control interface, each element set can have threshold level
information. This information is transferred between drivers/applications,
in a shape of tlv packet. The layout of this packet is defined in
'uapi/sound/asound.h' (struct snd_ctl_tlv):

struct snd_ctl_tlv {
    unsigned int numid;
    unsigned int length;
    unsigned int tlv[0];
};

Data in the payload (struct snd_ctl_tlv.tlv) is expected to be filled
according to our own protocol. This protocol is described in
'include/sound/tlv.h'. A layout of the payload is expected as:

struct snd_ctl_tlv.tlv[0]: one of SNDRV_CTL_TLVT_XXX
struct snd_ctl_tlv.tlv[1]: Length of data
struct snd_ctl_tlv.tlv[2...]: data

Unfortunately, the macro is not exported to user land yet, thus
applications cannot get to know the protocol.

Additionally, ALSA control core has a feature called as 'user-defined'
element set. This allows applications to add/remove arbitrary element sets
with elements to control devices. Elements in the element set can be
operated by the same way as the ones added by in-kernel implementation.

For threshold level information of 'user-defined' element set, applications
need to register the information to an element set. However, as described
above, layout of the payload is closed in kernel land. This is quite
inconvenient, too.

This commit moves the protocol to UAPI header for TLV. According to this
change, an old header is obsoleted.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 include/sound/tlv.h      | 62 +-----------------------------------------------
 include/uapi/sound/tlv.h | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/include/sound/tlv.h b/include/sound/tlv.h
index df97d19..7b0d0d1 100644
--- a/include/sound/tlv.h
+++ b/include/sound/tlv.h
@@ -22,67 +22,7 @@
  *
  */
 
-/*
- * TLV structure is right behind the struct snd_ctl_tlv:
- *   unsigned int type  	- see SNDRV_CTL_TLVT_*
- *   unsigned int length
- *   .... data aligned to sizeof(unsigned int), use
- *        block_length = (length + (sizeof(unsigned int) - 1)) &
- *                       ~(sizeof(unsigned int) - 1)) ....
- */
-
+/* You should include UAPI header directly, instead of this. */
 #include <uapi/sound/tlv.h>
 
-#define TLV_ITEM(type, ...) \
-	(type), TLV_LENGTH(__VA_ARGS__), __VA_ARGS__
-#define TLV_LENGTH(...) \
-	((unsigned int)sizeof((const unsigned int[]) { __VA_ARGS__ }))
-
-#define TLV_CONTAINER_ITEM(...) \
-	TLV_ITEM(SNDRV_CTL_TLVT_CONTAINER, __VA_ARGS__)
-#define DECLARE_TLV_CONTAINER(name, ...) \
-	unsigned int name[] = { TLV_CONTAINER_ITEM(__VA_ARGS__) }
-
-#define TLV_DB_SCALE_MASK	0xffff
-#define TLV_DB_SCALE_MUTE	0x10000
-#define TLV_DB_SCALE_ITEM(min, step, mute)			\
-	TLV_ITEM(SNDRV_CTL_TLVT_DB_SCALE,			\
-		 (min),					\
-		 ((step) & TLV_DB_SCALE_MASK) |		\
-			((mute) ? TLV_DB_SCALE_MUTE : 0))
-#define DECLARE_TLV_DB_SCALE(name, min, step, mute) \
-	unsigned int name[] = { TLV_DB_SCALE_ITEM(min, step, mute) }
-
-/* dB scale specified with min/max values instead of step */
-#define TLV_DB_MINMAX_ITEM(min_dB, max_dB)			\
-	TLV_ITEM(SNDRV_CTL_TLVT_DB_MINMAX, (min_dB), (max_dB))
-#define TLV_DB_MINMAX_MUTE_ITEM(min_dB, max_dB)			\
-	TLV_ITEM(SNDRV_CTL_TLVT_DB_MINMAX_MUTE, (min_dB), (max_dB))
-#define DECLARE_TLV_DB_MINMAX(name, min_dB, max_dB) \
-	unsigned int name[] = { TLV_DB_MINMAX_ITEM(min_dB, max_dB) }
-#define DECLARE_TLV_DB_MINMAX_MUTE(name, min_dB, max_dB) \
-	unsigned int name[] = { TLV_DB_MINMAX_MUTE_ITEM(min_dB, max_dB) }
-
-/* linear volume between min_dB and max_dB (.01dB unit) */
-#define TLV_DB_LINEAR_ITEM(min_dB, max_dB)		    \
-	TLV_ITEM(SNDRV_CTL_TLVT_DB_LINEAR, (min_dB), (max_dB))
-#define DECLARE_TLV_DB_LINEAR(name, min_dB, max_dB)	\
-	unsigned int name[] = { TLV_DB_LINEAR_ITEM(min_dB, max_dB) }
-
-/* dB range container:
- * Items in dB range container must be ordered by their values and by their
- * dB values. This implies that larger values must correspond with larger
- * dB values (which is also required for all other mixer controls).
- */
-/* Each item is: <min> <max> <TLV> */
-#define TLV_DB_RANGE_ITEM(...) \
-	TLV_ITEM(SNDRV_CTL_TLVT_DB_RANGE, __VA_ARGS__)
-#define DECLARE_TLV_DB_RANGE(name, ...) \
-	unsigned int name[] = { TLV_DB_RANGE_ITEM(__VA_ARGS__) }
-/* The below assumes that each item TLV is 4 words like DB_SCALE or LINEAR */
-#define TLV_DB_RANGE_HEAD(num)			\
-	SNDRV_CTL_TLVT_DB_RANGE, 6 * (num) * sizeof(unsigned int)
-
-#define TLV_DB_GAIN_MUTE	-9999999
-
 #endif /* __SOUND_TLV_H */
diff --git a/include/uapi/sound/tlv.h b/include/uapi/sound/tlv.h
index ffc4f20..b741e0e 100644
--- a/include/uapi/sound/tlv.h
+++ b/include/uapi/sound/tlv.h
@@ -28,4 +28,64 @@
 #define SNDRV_CTL_TLVT_CHMAP_VAR	0x102	/* channels freely swappable */
 #define SNDRV_CTL_TLVT_CHMAP_PAIRED	0x103	/* pair-wise swappable */
 
+/*
+ * TLV structure is right behind the struct snd_ctl_tlv:
+ *   unsigned int type  	- see SNDRV_CTL_TLVT_*
+ *   unsigned int length
+ *   .... data aligned to sizeof(unsigned int), use
+ *        block_length = (length + (sizeof(unsigned int) - 1)) &
+ *                       ~(sizeof(unsigned int) - 1)) ....
+ */
+#define TLV_ITEM(type, ...) \
+	(type), TLV_LENGTH(__VA_ARGS__), __VA_ARGS__
+#define TLV_LENGTH(...) \
+	((unsigned int)sizeof((const unsigned int[]) { __VA_ARGS__ }))
+
+#define TLV_CONTAINER_ITEM(...) \
+	TLV_ITEM(SNDRV_CTL_TLVT_CONTAINER, __VA_ARGS__)
+#define DECLARE_TLV_CONTAINER(name, ...) \
+	unsigned int name[] = { TLV_CONTAINER_ITEM(__VA_ARGS__) }
+
+#define TLV_DB_SCALE_MASK	0xffff
+#define TLV_DB_SCALE_MUTE	0x10000
+#define TLV_DB_SCALE_ITEM(min, step, mute)			\
+	TLV_ITEM(SNDRV_CTL_TLVT_DB_SCALE,			\
+		 (min),					\
+		 ((step) & TLV_DB_SCALE_MASK) |		\
+			((mute) ? TLV_DB_SCALE_MUTE : 0))
+#define DECLARE_TLV_DB_SCALE(name, min, step, mute) \
+	unsigned int name[] = { TLV_DB_SCALE_ITEM(min, step, mute) }
+
+/* dB scale specified with min/max values instead of step */
+#define TLV_DB_MINMAX_ITEM(min_dB, max_dB)			\
+	TLV_ITEM(SNDRV_CTL_TLVT_DB_MINMAX, (min_dB), (max_dB))
+#define TLV_DB_MINMAX_MUTE_ITEM(min_dB, max_dB)			\
+	TLV_ITEM(SNDRV_CTL_TLVT_DB_MINMAX_MUTE, (min_dB), (max_dB))
+#define DECLARE_TLV_DB_MINMAX(name, min_dB, max_dB) \
+	unsigned int name[] = { TLV_DB_MINMAX_ITEM(min_dB, max_dB) }
+#define DECLARE_TLV_DB_MINMAX_MUTE(name, min_dB, max_dB) \
+	unsigned int name[] = { TLV_DB_MINMAX_MUTE_ITEM(min_dB, max_dB) }
+
+/* linear volume between min_dB and max_dB (.01dB unit) */
+#define TLV_DB_LINEAR_ITEM(min_dB, max_dB)		    \
+	TLV_ITEM(SNDRV_CTL_TLVT_DB_LINEAR, (min_dB), (max_dB))
+#define DECLARE_TLV_DB_LINEAR(name, min_dB, max_dB)	\
+	unsigned int name[] = { TLV_DB_LINEAR_ITEM(min_dB, max_dB) }
+
+/* dB range container:
+ * Items in dB range container must be ordered by their values and by their
+ * dB values. This implies that larger values must correspond with larger
+ * dB values (which is also required for all other mixer controls).
+ */
+/* Each item is: <min> <max> <TLV> */
+#define TLV_DB_RANGE_ITEM(...) \
+	TLV_ITEM(SNDRV_CTL_TLVT_DB_RANGE, __VA_ARGS__)
+#define DECLARE_TLV_DB_RANGE(name, ...) \
+	unsigned int name[] = { TLV_DB_RANGE_ITEM(__VA_ARGS__) }
+/* The below assumes that each item TLV is 4 words like DB_SCALE or LINEAR */
+#define TLV_DB_RANGE_HEAD(num)			\
+	SNDRV_CTL_TLVT_DB_RANGE, 6 * (num) * sizeof(unsigned int)
+
+#define TLV_DB_GAIN_MUTE	-9999999
+
 #endif
-- 
2.7.4

