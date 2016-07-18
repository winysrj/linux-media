Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 13/18] [media] cx2341x.rst: add contents of README.vbi
Date: Mon, 18 Jul 2016 15:30:35 -0300
Message-Id: <d7b3ae79e1f72218b1a196c3669ff2d29e9b9c11.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Finally, adds the content of README.vbi at cx2341x.rst after
its conversion to ReST format.

Now, add information about this chipset and its driver is
inside a single chapter at the media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx2341x.rst  | 50 ++++++++++++++++++++++++++++
 Documentation/video4linux/cx2341x/README.vbi | 45 -------------------------
 2 files changed, 50 insertions(+), 45 deletions(-)
 delete mode 100644 Documentation/video4linux/cx2341x/README.vbi

diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/media/v4l-drivers/cx2341x.rst
index 15bfd345df48..e06d07ebdecd 100644
--- a/Documentation/media/v4l-drivers/cx2341x.rst
+++ b/Documentation/media/v4l-drivers/cx2341x.rst
@@ -3806,3 +3806,53 @@ Raw format c example
 	fclose(fin);
 	return 0;
 	}
+
+
+Format of embedded V4L2_MPEG_STREAM_VBI_FMT_IVTV VBI data
+---------------------------------------------------------
+
+Author: Hans Verkuil <hverkuil@xs4all.nl>
+
+
+This section describes the V4L2_MPEG_STREAM_VBI_FMT_IVTV format of the VBI data
+embedded in an MPEG-2 program stream. This format is in part dictated by some
+hardware limitations of the ivtv driver (the driver for the Conexant cx23415/6
+chips), in particular a maximum size for the VBI data. Anything longer is cut
+off when the MPEG stream is played back through the cx23415.
+
+The advantage of this format is it is very compact and that all VBI data for
+all lines can be stored while still fitting within the maximum allowed size.
+
+The stream ID of the VBI data is 0xBD. The maximum size of the embedded data is
+4 + 43 * 36, which is 4 bytes for a header and 2 * 18 VBI lines with a 1 byte
+header and a 42 bytes payload each. Anything beyond this limit is cut off by
+the cx23415/6 firmware. Besides the data for the VBI lines we also need 36 bits
+for a bitmask determining which lines are captured and 4 bytes for a magic cookie,
+signifying that this data package contains V4L2_MPEG_STREAM_VBI_FMT_IVTV VBI data.
+If all lines are used, then there is no longer room for the bitmask. To solve this
+two different magic numbers were introduced:
+
+'itv0': After this magic number two unsigned longs follow. Bits 0-17 of the first
+unsigned long denote which lines of the first field are captured. Bits 18-31 of
+the first unsigned long and bits 0-3 of the second unsigned long are used for the
+second field.
+
+'ITV0': This magic number assumes all VBI lines are captured, i.e. it implicitly
+implies that the bitmasks are 0xffffffff and 0xf.
+
+After these magic cookies (and the 8 byte bitmask in case of cookie 'itv0') the
+captured VBI lines start:
+
+For each line the least significant 4 bits of the first byte contain the data type.
+Possible values are shown in the table below. The payload is in the following 42
+bytes.
+
+Here is the list of possible data types:
+
+.. code-block:: c
+
+	#define IVTV_SLICED_TYPE_TELETEXT       0x1     // Teletext (uses lines 6-22 for PAL)
+	#define IVTV_SLICED_TYPE_CC             0x4     // Closed Captions (line 21 NTSC)
+	#define IVTV_SLICED_TYPE_WSS            0x5     // Wide Screen Signal (line 23 PAL)
+	#define IVTV_SLICED_TYPE_VPS            0x7     // Video Programming System (PAL) (line 16)
+
diff --git a/Documentation/video4linux/cx2341x/README.vbi b/Documentation/video4linux/cx2341x/README.vbi
deleted file mode 100644
index 5807cf156173..000000000000
--- a/Documentation/video4linux/cx2341x/README.vbi
+++ /dev/null
@@ -1,45 +0,0 @@
-
-Format of embedded V4L2_MPEG_STREAM_VBI_FMT_IVTV VBI data
-=========================================================
-
-This document describes the V4L2_MPEG_STREAM_VBI_FMT_IVTV format of the VBI data
-embedded in an MPEG-2 program stream. This format is in part dictated by some
-hardware limitations of the ivtv driver (the driver for the Conexant cx23415/6
-chips), in particular a maximum size for the VBI data. Anything longer is cut
-off when the MPEG stream is played back through the cx23415.
-
-The advantage of this format is it is very compact and that all VBI data for
-all lines can be stored while still fitting within the maximum allowed size.
-
-The stream ID of the VBI data is 0xBD. The maximum size of the embedded data is
-4 + 43 * 36, which is 4 bytes for a header and 2 * 18 VBI lines with a 1 byte
-header and a 42 bytes payload each. Anything beyond this limit is cut off by
-the cx23415/6 firmware. Besides the data for the VBI lines we also need 36 bits
-for a bitmask determining which lines are captured and 4 bytes for a magic cookie,
-signifying that this data package contains V4L2_MPEG_STREAM_VBI_FMT_IVTV VBI data.
-If all lines are used, then there is no longer room for the bitmask. To solve this
-two different magic numbers were introduced:
-
-'itv0': After this magic number two unsigned longs follow. Bits 0-17 of the first
-unsigned long denote which lines of the first field are captured. Bits 18-31 of
-the first unsigned long and bits 0-3 of the second unsigned long are used for the
-second field.
-
-'ITV0': This magic number assumes all VBI lines are captured, i.e. it implicitly
-implies that the bitmasks are 0xffffffff and 0xf.
-
-After these magic cookies (and the 8 byte bitmask in case of cookie 'itv0') the
-captured VBI lines start:
-
-For each line the least significant 4 bits of the first byte contain the data type.
-Possible values are shown in the table below. The payload is in the following 42
-bytes.
-
-Here is the list of possible data types:
-
-#define IVTV_SLICED_TYPE_TELETEXT       0x1     // Teletext (uses lines 6-22 for PAL)
-#define IVTV_SLICED_TYPE_CC             0x4     // Closed Captions (line 21 NTSC)
-#define IVTV_SLICED_TYPE_WSS            0x5     // Wide Screen Signal (line 23 PAL)
-#define IVTV_SLICED_TYPE_VPS            0x7     // Video Programming System (PAL) (line 16)
-
-Hans Verkuil <hverkuil@xs4all.nl>
-- 
2.7.4


