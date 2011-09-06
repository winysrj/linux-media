Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45387 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1IFTKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 15:10:24 -0400
Received: by ewy4 with SMTP id 4so2873299ewy.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 12:10:23 -0700 (PDT)
Message-ID: <4E667019.9000703@gmail.com>
Date: Tue, 06 Sep 2011 21:10:17 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com
Subject: Re: [RFC] Reserved fields in v4l2_mbus_framefmt, v4l2_subdev_format
 alignment
References: <20110905155528.GB1308@valkosipuli.localdomain>
In-Reply-To: <20110905155528.GB1308@valkosipuli.localdomain>
Content-Type: multipart/mixed;
 boundary="------------070507060602000705060602"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070507060602000705060602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sakari,

On 09/05/2011 05:55 PM, Sakari Ailus wrote:
> Hi all,
> 
> I recently came across a few issues in the definitions of v4l2_subdev_format
> and v4l2_mbus_framefmt when I was working on sensor control that I wanted to
> bring up here. The appropriate structure right now look like this:
> 
> include/linux/v4l2-subdev.h:
> ---8<---
> /**
>   * struct v4l2_subdev_format - Pad-level media bus format
>   * @which: format type (from enum v4l2_subdev_format_whence)
>   * @pad: pad number, as reported by the media API
>   * @format: media bus format (format code and frame size)
>   */
> struct v4l2_subdev_format {
>          __u32 which;
>          __u32 pad;
>          struct v4l2_mbus_framefmt format;
>          __u32 reserved[8];
> };
> ---8<---
> 
> include/linux/v4l2-mediabus.h:
> ---8<---
> /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus
>   * @width:      frame width
>   * @height:     frame height
>   * @code:       data format code (from enum v4l2_mbus_pixelcode)
>   * @field:      used interlacing type (from enum v4l2_field)
>   * @colorspace: colorspace of the data (from enum v4l2_colorspace)
>   */
> struct v4l2_mbus_framefmt {
>          __u32                   width;
>          __u32                   height;
>          __u32                   code;
>          __u32                   field;
>          __u32                   colorspace;
>          __u32                   reserved[7];
> };
> ---8<---
> 
> Offering a lower level interface for sensors which allows better control of
> them from the user space involves providing the link frequency to the user
> space. While the link frequency will be a control, together with the bus
> type and number of lanes (on serial links), this will define the pixel
> clock.
> 
> <URL:http://www.spinics.net/lists/linux-media/msg36492.html>
> 
> After adding pixel clock to v4l2_mbus_framefmt there will be six reserved
> fields left, one of which will be further possibly consumed by maximum image
> size:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg35949.html>

Yes, thanks for remembering about it. I have done some experiments with a sensor
producing JPEG data and I'd like to add '__u32 framesamples' field to struct
v4l2_mbus_framefmt, even though it solves only part of the problem.
I'm not sure when I'll be able to get this finished though. I've just attached
the initial patch now.

> 
> Frame blanking (horizontal and vertical) and number of lanes might be needed
> in the struct as well in the future, bringing the reserved count down to
> two. I find this alarmingly low for a relatively new structure definition
> which will potentially have a few different uses in the future.

Sorry, could you explain why we need to put the blanking information in struct
v4l2_mbus_framefmt ? I thought it had been initially agreed that the control
framework will be used for this.

> 
> The another issue is that the size of the v4l2_subdev_format struct is not
> aligned to a power of two. Instead of the intended 32 u32's, the size is
> actually 22 u32's.

hmm, is this really an issue ? What is advantage of having the structure size
being the power of 2 ? Isn't multiple of 4 just enough ?

> 
> The interface is present in the 3.0 and marked experimental. My proposal is
> to add reserved fields to v4l2_mbus_framefmt to extend its size up to 32
> u32's. I understand there are already few which use the interface right now
> and thus this change must be done now or left as-is forever.

hmm, I feel a bit uncomfortable with increasing size of data structure which
is quite widely used, not only in sensors, also in TV capture cards, tuners, etc.
So far struct v4l2_mbus_framefmt was quite generic. IMHO it might be good to try
to avoid extending it widely with properties specific to single subsystem.

--
Regards,
Sylwester

--------------070507060602000705060602
Content-Type: text/x-patch;
 name="0001-v4l-Add-framesamples-field-in-struct-v4l2_mbus_frame.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-v4l-Add-framesamples-field-in-struct-v4l2_mbus_frame.pa";
 filename*1="tch"

>From 18600fc32e65a6653491981b602af102f1dd52cb Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Sun, 21 Aug 2011 00:51:59 +0200
Subject: [PATCH/RFC] v4l: Add framesamples field in struct v4l2_mbus_framefmt

The purpose of the new 'framesamples' field is to allow
the video pipeline elements to negotiate memory buffer size
for a transmitted frame.
This is mostly useful for compressed data formats where the
buffer size cannot be derived from pixel width and height
and the pixel code.
In case of the user space subdev API the applications must
assure the 'framesamples' value is consistent across the
pipeline. The drivers should validate those values before
the streaming is enabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   15 +++++++++++----
 Documentation/DocBook/media/v4l/subdev-formats.xml |    7 ++++++-
 include/linux/v4l2-mediabus.h                      |    4 +++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 05c8fef..48a1cdc 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -113,7 +113,7 @@
     <para>Drivers that implement the <link linkend="media-controller-intro">media
     API</link> can expose pad-level image format configuration to applications.
     When they do, applications can use the &VIDIOC-SUBDEV-G-FMT; and
-    &VIDIOC-SUBDEV-S-FMT; ioctls. to negotiate formats on a per-pad basis.</para>
+    &VIDIOC-SUBDEV-S-FMT; ioctls to negotiate formats on a per-pad basis.</para>
 
     <para>Applications are responsible for configuring coherent parameters on
     the whole pipeline and making sure that connected pads have compatible
@@ -158,9 +158,16 @@
 
       <para>Formats returned by the driver during a negotiation iteration are
       guaranteed to be supported by the device. In particular, drivers guarantee
-      that a returned format will not be further changed if passed to an
-      &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such as
-      formats on other pads or links' configuration are not changed).</para>
+      that returned format, except the <structfield>framesamples</structfield>
+      field, will not be further changed if passed to an &VIDIOC-SUBDEV-S-FMT;
+      call as-is (as long as external parameters, such as formats on other pads
+      or links' configuration are not changed).</para>
+
+      <para> For compressed data formats the number of samples per frame may be
+      influenced by controls related to the compression process. Thus the
+      applications should use &VIDIOC-SUBDEV-G-FMT; ioctl to query an exact format
+      whenever such controls have been applied after the negotiation iteration.
+      </para>
 
       <para>Drivers automatically propagate formats inside sub-devices. When a
       try or active format is set on a pad, corresponding formats on other pads
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..d0827b4 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -35,7 +35,12 @@
 	</row>
 	<row>
 	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[7]</entry>
+	  <entry><structfield>framesamples</structfield></entry>
+	  <entry>Number of data samples on media bus per frame.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>reserved</structfield>[6]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..ce776e8 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ * @framesamples: number of data samples per frame
  */
 struct v4l2_mbus_framefmt {
 	__u32			width;
@@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u32			reserved[7];
+	__u32			framesamples;
+	__u32			reserved[6];
 };
 
 #endif
-- 
1.7.4.1


--------------070507060602000705060602--
