Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1FUPf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 11:35:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	FlorianSchandinat@gmx.de
Subject: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
Date: Tue, 21 Jun 2011 17:36:19 +0200
Message-Id: <1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <4DDAE63A.3070203@gmx.de>
References: <4DDAE63A.3070203@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This API will be used to support YUV frame buffer formats in a standard
way.

Last but not least, create a much needed fbdev API documentation and
document the format setting APIs.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/fb/api.txt |  284 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h       |   12 ++-
 2 files changed, 294 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/fb/api.txt

A bit late, but here's a patch that implements an fbdev format configuration
API to support YUV formats. My next step is to implement a prototype in an
fbdev driver to make sure the API works well.

Thanks to Florian Tobias Schandinat for providing feedback on the initial RFC.
Comments are as usual more than welcome. If you feel like writing a couple of
lines of documentation, feel free to extend the API doc. That's much needed.

diff --git a/Documentation/fb/api.txt b/Documentation/fb/api.txt
new file mode 100644
index 0000000..d4cd6ec
--- /dev/null
+++ b/Documentation/fb/api.txt
@@ -0,0 +1,284 @@
+			The Frame Buffer Device API
+			---------------------------
+
+Last revised: June 21, 2011
+
+
+0. Introduction
+---------------
+
+This document describes the frame buffer API used by applications to interact
+with frame buffer devices. In-kernel APIs between device drivers and the frame
+buffer core are not described.
+
+Due to a lack of documentation in the original frame buffer API, drivers
+behaviours differ in subtle (and not so subtle) ways. This document describes
+the recommended API implementation, but applications should be prepared to
+deal with different behaviours.
+
+
+1. Capabilities
+---------------
+
+Device and driver capabilities are reported in the fixed screen information
+capabilities field.
+
+struct fb_fix_screeninfo {
+	...
+	__u16 capabilities;		/* see FB_CAP_*			*/
+	...
+};
+
+Application should use those capabilities to find out what features they can
+expect from the device and driver.
+
+- FB_CAP_FOURCC
+
+The driver supports the four character code (FOURCC) based format setting API.
+When supported, formats are configured using a FOURCC instead of manually
+specifying color components layout.
+
+
+2. Types and visuals
+--------------------
+
+Pixels are stored in memory in hardware-dependent formats. Applications need
+to be aware of the pixel storage format in order to write image data to the
+frame buffer memory in the format expected by the hardware.
+
+Formats are described by frame buffer types and visuals. Some visuals require
+additional information, which are stored in the variable screen information
+bits_per_pixel, grayscale, fourcc, red, green, blue and transp fields.
+
+The following types and visuals are supported.
+
+- FB_TYPE_PACKED_PIXELS
+
+Color components (usually RGB or YUV) are packed together into macropixels
+that are stored in a single plane. The exact color components layout is
+described in a visual-dependent way.
+
+Frame buffer visuals that don't use multiple color components per pixel
+(such as monochrome and pseudo-color visuals) are reported as packed frame
+buffer types, even though they don't stricly speaking pack color components
+into macropixels.
+
+- FB_TYPE_PLANES
+
+Color components are stored in separate planes. Planes are located
+contiguously in memory.
+
+- FB_VISUAL_MONO01
+
+Pixels are black or white and stored on one bit. A bit set to 1 represents a
+black pixel and a bit set to 0 a white pixel. Pixels are packed together in
+bytes with 8 pixels per byte.
+
+FB_VISUAL_MONO01 is used with FB_TYPE_PACKED_PIXELS only.
+
+- FB_VISUAL_MONO10
+
+Pixels are black or white and stored on one bit. A bit set to 1 represents a
+white pixel and a bit set to 0 a black pixel. Pixels are packed together in
+bytes with 8 pixels per byte.
+
+FB_VISUAL_MONO01 is used with FB_TYPE_PACKED_PIXELS only.
+
+- FB_VISUAL_TRUECOLOR
+
+Pixels are broken into red, green and blue components, and each component
+indexes a read-only lookup table for the corresponding value. Lookup tables
+are device-dependent, and provide linear or non-linear ramps.
+
+Each component is stored in memory according to the variable screen
+information red, green, blue and transp fields.
+
+- FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR
+
+Pixel values are encoded as indices into a colormap that stores red, green and
+blue components. The colormap is read-only for FB_VISUAL_STATIC_PSEUDOCOLOR
+and read-write for FB_VISUAL_PSEUDOCOLOR.
+
+Each pixel value is stored in the number of bits reported by the variable
+screen information bits_per_pixel field. Pixels are contiguous in memory.
+
+FB_VISUAL_PSEUDOCOLOR and FB_VISUAL_STATIC_PSEUDOCOLOR are used with
+FB_TYPE_PACKED_PIXELS only.
+
+- FB_VISUAL_DIRECTCOLOR
+
+Pixels are broken into red, green and blue components, and each component
+indexes a programmable lookup table for the corresponding value.
+
+Each component is stored in memory according to the variable screen
+information red, green, blue and transp fields.
+
+- FB_VISUAL_FOURCC
+
+Pixels are stored in memory as described by the format FOURCC identifier
+stored in the variable screen information fourcc field.
+
+
+3. Screen information
+---------------------
+
+Screen information are queried by applications using the FBIOGET_FSCREENINFO
+and FBIOGET_VSCREENINFO ioctls. Those ioctls take a pointer to a
+fb_fix_screeninfo and fb_var_screeninfo structure respectively.
+
+struct fb_fix_screeninfo stores device independent unchangeable information
+about the frame buffer device and the current format. Those information can't
+be directly modified by applications, but can be changed by the driver when an
+application modifies the format.
+
+struct fb_fix_screeninfo {
+	char id[16];			/* identification string eg "TT Builtin" */
+	unsigned long smem_start;	/* Start of frame buffer mem */
+					/* (physical address) */
+	__u32 smem_len;			/* Length of frame buffer mem */
+	__u32 type;			/* see FB_TYPE_*		*/
+	__u32 type_aux;			/* Interleave for interleaved Planes */
+	__u32 visual;			/* see FB_VISUAL_*		*/
+	__u16 xpanstep;			/* zero if no hardware panning  */
+	__u16 ypanstep;			/* zero if no hardware panning  */
+	__u16 ywrapstep;		/* zero if no hardware ywrap    */
+	__u32 line_length;		/* length of a line in bytes    */
+	unsigned long mmio_start;	/* Start of Memory Mapped I/O   */
+					/* (physical address) */
+	__u32 mmio_len;			/* Length of Memory Mapped I/O  */
+	__u32 accel;			/* Indicate to driver which	*/
+					/*  specific chip/card we have	*/
+	__u16 capabilities;		/* see FB_CAP_*			*/
+	__u16 reserved[2];		/* Reserved for future compatibility */
+};
+
+struct fb_var_screeninfo stores device independent changeable information
+about a frame buffer device, its current format and video mode, as well as
+other miscellaneous parameters.
+
+struct fb_var_screeninfo {
+	__u32 xres;			/* visible resolution		*/
+	__u32 yres;
+	__u32 xres_virtual;		/* virtual resolution		*/
+	__u32 yres_virtual;
+	__u32 xoffset;			/* offset from virtual to visible */
+	__u32 yoffset;			/* resolution			*/
+
+	__u32 bits_per_pixel;		/* guess what			*/
+	union {
+		__u32 grayscale;	/* != 0 Graylevels instead of colors */
+		__u32 fourcc;		/* video mode */
+	};
+
+	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
+	struct fb_bitfield green;	/* else only length is significant */
+	struct fb_bitfield blue;
+	struct fb_bitfield transp;	/* transparency			*/
+
+	__u32 nonstd;			/* != 0 Non standard pixel format */
+
+	__u32 activate;			/* see FB_ACTIVATE_*		*/
+
+	__u32 height;			/* height of picture in mm    */
+	__u32 width;			/* width of picture in mm     */
+
+	__u32 accel_flags;		/* (OBSOLETE) see fb_info.flags */
+
+	/* Timing: All values in pixclocks, except pixclock (of course) */
+	__u32 pixclock;			/* pixel clock in ps (pico seconds) */
+	__u32 left_margin;		/* time from sync to picture	*/
+	__u32 right_margin;		/* time from picture to sync	*/
+	__u32 upper_margin;		/* time from sync to picture	*/
+	__u32 lower_margin;
+	__u32 hsync_len;		/* length of horizontal sync	*/
+	__u32 vsync_len;		/* length of vertical sync	*/
+	__u32 sync;			/* see FB_SYNC_*		*/
+	__u32 vmode;			/* see FB_VMODE_*		*/
+	__u32 rotate;			/* angle we rotate counter clockwise */
+	__u32 reserved[5];		/* Reserved for future compatibility */
+};
+
+To modify variable information, applications call the FBIOPUT_VSCREENINFO
+ioctl with a pointer to a fb_var_screeninfo structure. If the call is
+successful, the driver will update the fixed screen information accordingly.
+
+Instead of filling the complete fb_var_screeninfo structure manually,
+applications should call the FBIOGET_VSCREENINFO ioctl and modify only the
+fields they care about.
+
+
+4. Format configuration
+-----------------------
+
+Frame buffer devices offer two ways to configure the frame buffer format: the
+legacy API and the FOURCC-based API.
+
+
+The legacy API has been the only frame buffer format configuration API for a
+long time and is thus widely used by application. It is the recommended API
+for applications when using RGB and grayscale formats, as well as legacy
+non-standard formats.
+
+To select a format, applications set the fb_var_screeninfo bits_per_pixel field
+to the desired frame buffer depth. Values up to 8 will usually map to
+monochrome, grayscale or pseudocolor visuals, although this is not required.
+
+- For grayscale formats, applications set the grayscale field to a non-zero
+  value. The red, blue, green and transp fields must be set to 0 by
+  applications and ignored by drivers. Drivers must fill the red, blue and
+  green offsets to 0 and lengths to the bits_per_pixel value.
+
+- For pseudocolor formats, applications set the grayscale field to a zero
+  value. The red, blue, green and transp fields must be set to 0 by
+  applications and ignored by drivers. Drivers must fill the red, blue and
+  green offsets to 0 and lengths to the bits_per_pixel value.
+
+- For truecolor and directcolor formats, applications set the grayscale field
+  to a zero value, and the red, blue, green and transp fields to describe the
+  layout of color components in memory.
+
+struct fb_bitfield {
+	__u32 offset;			/* beginning of bitfield	*/
+	__u32 length;			/* length of bitfield		*/
+	__u32 msb_right;		/* != 0 : Most significant bit is */
+					/* right */
+};
+
+  Pixel values are bits_per_pixel wide and are split in non-overlapping red,
+  green, blue and alpha (transparency) components. Location and size of each
+  component in the pixel value are described by the fb_bitfield offset and
+  length fields. Offset are computed from the right.
+
+  Pixels are always stored in an integer number of bytes. If the number of
+  bits per pixel is not a multiple of 8, pixel values are padded to the next
+  multiple of 8 bits.
+
+Upon successful format configuration, drivers update the fb_fix_screeninfo
+type, visual and line_length fields depending on the selected format.
+
+
+The FOURCC-based API replaces format descriptions by four character codes
+(FOURCC). FOURCCs are abstract identifiers that uniquely define a format
+without explicitly describing it. This is the only API that supports YUV
+formats. Drivers are also encouraged to implement the FOURCC-based API for RGB
+and grayscale formats.
+
+Drivers that support the FOURCC-based API report this capability by setting
+the FB_CAP_FOURCC bit in the fb_fix_screeninfo capabilities field.
+
+FOURCC definitions are located in the linux/videodev2.h header. However, and
+despite starting with the V4L2_PIX_FMT_prefix, they are not restricted to V4L2
+and don't require usage of the V4L2 subsystem. FOURCC documentation is
+available in Documentation/DocBook/v4l/pixfmt.xml.
+
+To select a format, applications set the FB_VMODE_FOURCC bit in the
+fb_var_screeninfo vmode field, and set the fourcc field to the desired FOURCC.
+The bits_per_pixel, red, green, blue, transp and nonstd fields must be set to
+0 by applications and ignored by drivers. Note that the grayscale and fourcc
+fields share the same memory location. Application must thus not set the
+grayscale field to 0.
+
+Upon successful format configuration, drivers update the fb_fix_screeninfo
+type, visual and line_length fields depending on the selected format. The
+visual field is set to FB_VISUAL_FOURCC.
+
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 6a82748..359e98e 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -69,6 +69,7 @@
 #define FB_VISUAL_PSEUDOCOLOR		3	/* Pseudo color (like atari) */
 #define FB_VISUAL_DIRECTCOLOR		4	/* Direct color */
 #define FB_VISUAL_STATIC_PSEUDOCOLOR	5	/* Pseudo color readonly */
+#define FB_VISUAL_FOURCC		6	/* Visual identified by a V4L2 FOURCC */
 
 #define FB_ACCEL_NONE		0	/* no hardware accelerator	*/
 #define FB_ACCEL_ATARIBLITT	1	/* Atari Blitter		*/
@@ -154,6 +155,8 @@
 
 #define FB_ACCEL_PUV3_UNIGFX	0xa0	/* PKUnity-v3 Unigfx		*/
 
+#define FB_CAP_FOURCC		1	/* Device supports FOURCC-based formats */
+
 struct fb_fix_screeninfo {
 	char id[16];			/* identification string eg "TT Builtin" */
 	unsigned long smem_start;	/* Start of frame buffer mem */
@@ -171,7 +174,8 @@ struct fb_fix_screeninfo {
 	__u32 mmio_len;			/* Length of Memory Mapped I/O  */
 	__u32 accel;			/* Indicate to driver which	*/
 					/*  specific chip/card we have	*/
-	__u16 reserved[3];		/* Reserved for future compatibility */
+	__u16 capabilities;		/* see FB_CAP_*			*/
+	__u16 reserved[2];		/* Reserved for future compatibility */
 };
 
 /* Interpretation of offset for color fields: All offsets are from the right,
@@ -220,6 +224,7 @@ struct fb_bitfield {
 #define FB_VMODE_INTERLACED	1	/* interlaced	*/
 #define FB_VMODE_DOUBLE		2	/* double scan */
 #define FB_VMODE_ODD_FLD_FIRST	4	/* interlaced: top line first */
+#define FB_VMODE_FOURCC		8	/* video mode expressed as a FOURCC */
 #define FB_VMODE_MASK		255
 
 #define FB_VMODE_YWRAP		256	/* ywrap instead of panning     */
@@ -246,7 +251,10 @@ struct fb_var_screeninfo {
 	__u32 yoffset;			/* resolution			*/
 
 	__u32 bits_per_pixel;		/* guess what			*/
-	__u32 grayscale;		/* != 0 Graylevels instead of colors */
+	union {
+		__u32 grayscale;	/* != 0 Graylevels instead of colors */
+		__u32 fourcc;		/* FOURCC format */
+	};
 
 	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
 	struct fb_bitfield green;	/* else only length is significant */
-- 
Regards,

Laurent Pinchart

