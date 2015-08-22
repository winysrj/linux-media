Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 24/39] [media] v4l-dv-timings.h: Add to device-drivers DocBook
Date: Sat, 22 Aug 2015 14:28:09 -0300
Message-Id: <487672e3c1af170996f52dd8228fff685814af83.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are already markups for documentation at v4l-dv-timings.h,
however, they're not properly formatted.

Convert them to the right format and add this file to
the device-drivers DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 46e6818b95ce..30ba2cf2735a 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -233,8 +233,8 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
 !Iinclude/media/v4l2-ctrls.h
 !Iinclude/media/v4l2-event.h
+!Iinclude/media/v4l2-dv-timings.h
 <!-- FIXME: Removed for now due to document generation inconsistency
-X!Iinclude/media/v4l2-dv-timings.h
 X!Iinclude/media/v4l2-mediabus.h
 X!Iinclude/media/videobuf2-memops.h
 X!Iinclude/media/videobuf2-core.h
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index e18a653549cd..b6130b50a0f1 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -23,11 +23,14 @@
 
 #include <linux/videodev2.h>
 
-/** v4l2_dv_timings_presets: list of all dv_timings presets.
+/**
+ * v4l2_dv_timings_presets: list of all dv_timings presets.
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
 
-/** v4l2_check_dv_timings_fnc - timings check callback
+/**
+ * v4l2_check_dv_timings_fnc - timings check callback
+ *
  * @t: the v4l2_dv_timings struct.
  * @handle: a handle from the driver.
  *
@@ -35,83 +38,95 @@ extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
  */
 typedef bool v4l2_check_dv_timings_fnc(const struct v4l2_dv_timings *t, void *handle);
 
-/** v4l2_valid_dv_timings() - are these timings valid?
-  * @t:	  the v4l2_dv_timings struct.
-  * @cap: the v4l2_dv_timings_cap capabilities.
-  * @fnc: callback to check if this timing is OK. May be NULL.
-  * @fnc_handle: a handle that is passed on to @fnc.
-  *
-  * Returns true if the given dv_timings struct is supported by the
-  * hardware capabilities and the callback function (if non-NULL), returns
-  * false otherwise.
-  */
+/**
+ * v4l2_valid_dv_timings() - are these timings valid?
+ *
+ * @t:	  the v4l2_dv_timings struct.
+ * @cap: the v4l2_dv_timings_cap capabilities.
+ * @fnc: callback to check if this timing is OK. May be NULL.
+ * @fnc_handle: a handle that is passed on to @fnc.
+ *
+ * Returns true if the given dv_timings struct is supported by the
+ * hardware capabilities and the callback function (if non-NULL), returns
+ * false otherwise.
+ */
 bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 			   const struct v4l2_dv_timings_cap *cap,
 			   v4l2_check_dv_timings_fnc fnc,
 			   void *fnc_handle);
 
-/** v4l2_enum_dv_timings_cap() - Helper function to enumerate possible DV timings based on capabilities
-  * @t:	  the v4l2_enum_dv_timings struct.
-  * @cap: the v4l2_dv_timings_cap capabilities.
-  * @fnc: callback to check if this timing is OK. May be NULL.
-  * @fnc_handle: a handle that is passed on to @fnc.
-  *
-  * This enumerates dv_timings using the full list of possible CEA-861 and DMT
-  * timings, filtering out any timings that are not supported based on the
-  * hardware capabilities and the callback function (if non-NULL).
-  *
-  * If a valid timing for the given index is found, it will fill in @t and
-  * return 0, otherwise it returns -EINVAL.
-  */
+/**
+ * v4l2_enum_dv_timings_cap() - Helper function to enumerate possible DV
+ *	 timings based on capabilities
+ *
+ * @t:	  the v4l2_enum_dv_timings struct.
+ * @cap: the v4l2_dv_timings_cap capabilities.
+ * @fnc: callback to check if this timing is OK. May be NULL.
+ * @fnc_handle: a handle that is passed on to @fnc.
+ *
+ * This enumerates dv_timings using the full list of possible CEA-861 and DMT
+ * timings, filtering out any timings that are not supported based on the
+ * hardware capabilities and the callback function (if non-NULL).
+ *
+ * If a valid timing for the given index is found, it will fill in @t and
+ * return 0, otherwise it returns -EINVAL.
+ */
 int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
 			     const struct v4l2_dv_timings_cap *cap,
 			     v4l2_check_dv_timings_fnc fnc,
 			     void *fnc_handle);
 
-/** v4l2_find_dv_timings_cap() - Find the closest timings struct
-  * @t:	  the v4l2_enum_dv_timings struct.
-  * @cap: the v4l2_dv_timings_cap capabilities.
-  * @pclock_delta: maximum delta between t->pixelclock and the timing struct
-  *		under consideration.
-  * @fnc: callback to check if a given timings struct is OK. May be NULL.
-  * @fnc_handle: a handle that is passed on to @fnc.
-  *
-  * This function tries to map the given timings to an entry in the
-  * full list of possible CEA-861 and DMT timings, filtering out any timings
-  * that are not supported based on the hardware capabilities and the callback
-  * function (if non-NULL).
-  *
-  * On success it will fill in @t with the found timings and it returns true.
-  * On failure it will return false.
-  */
+/**
+ * v4l2_find_dv_timings_cap() - Find the closest timings struct
+ *
+ * @t:	  the v4l2_enum_dv_timings struct.
+ * @cap: the v4l2_dv_timings_cap capabilities.
+ * @pclock_delta: maximum delta between t->pixelclock and the timing struct
+ *		under consideration.
+ * @fnc: callback to check if a given timings struct is OK. May be NULL.
+ * @fnc_handle: a handle that is passed on to @fnc.
+ *
+ * This function tries to map the given timings to an entry in the
+ * full list of possible CEA-861 and DMT timings, filtering out any timings
+ * that are not supported based on the hardware capabilities and the callback
+ * function (if non-NULL).
+ *
+ * On success it will fill in @t with the found timings and it returns true.
+ * On failure it will return false.
+ */
 bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      const struct v4l2_dv_timings_cap *cap,
 			      unsigned pclock_delta,
 			      v4l2_check_dv_timings_fnc fnc,
 			      void *fnc_handle);
 
-/** v4l2_match_dv_timings() - do two timings match?
-  * @measured:	  the measured timings data.
-  * @standard:	  the timings according to the standard.
-  * @pclock_delta: maximum delta in Hz between standard->pixelclock and
-  * 		the measured timings.
-  *
-  * Returns true if the two timings match, returns false otherwise.
-  */
+/**
+ * v4l2_match_dv_timings() - do two timings match?
+ *
+ * @measured:	  the measured timings data.
+ * @standard:	  the timings according to the standard.
+ * @pclock_delta: maximum delta in Hz between standard->pixelclock and
+ * 		the measured timings.
+ *
+ * Returns true if the two timings match, returns false otherwise.
+ */
 bool v4l2_match_dv_timings(const struct v4l2_dv_timings *measured,
 			   const struct v4l2_dv_timings *standard,
 			   unsigned pclock_delta);
 
-/** v4l2_print_dv_timings() - log the contents of a dv_timings struct
-  * @dev_prefix:device prefix for each log line.
-  * @prefix:	additional prefix for each log line, may be NULL.
-  * @t:		the timings data.
-  * @detailed:	if true, give a detailed log.
-  */
+/**
+ * v4l2_print_dv_timings() - log the contents of a dv_timings struct
+ * @dev_prefix:device prefix for each log line.
+ * @prefix:	additional prefix for each log line, may be NULL.
+ * @t:		the timings data.
+ * @detailed:	if true, give a detailed log.
+ */
 void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			   const struct v4l2_dv_timings *t, bool detailed);
 
-/** v4l2_detect_cvt - detect if the given timings follow the CVT standard
+/**
+ * v4l2_detect_cvt - detect if the given timings follow the CVT standard
+ *
  * @frame_height - the total height of the frame (including blanking) in lines.
  * @hfreq - the horizontal frequency in Hz.
  * @vsync - the height of the vertical sync in lines.
@@ -131,7 +146,9 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		unsigned active_width, u32 polarities, bool interlaced,
 		struct v4l2_dv_timings *fmt);
 
-/** v4l2_detect_gtf - detect if the given timings follow the GTF standard
+/**
+ * v4l2_detect_gtf - detect if the given timings follow the GTF standard
+ *
  * @frame_height - the total height of the frame (including blanking) in lines.
  * @hfreq - the horizontal frequency in Hz.
  * @vsync - the height of the vertical sync in lines.
@@ -153,8 +170,10 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		u32 polarities, bool interlaced, struct v4l2_fract aspect,
 		struct v4l2_dv_timings *fmt);
 
-/** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
+/**
+ * v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
  *	0x15 and 0x16 from the EDID.
+ *
  * @hor_landscape - byte 0x15 from the EDID.
  * @vert_portrait - byte 0x16 from the EDID.
  *
-- 
2.4.3

