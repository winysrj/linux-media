Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50943
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752891AbdICCfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 01/12] media: v4l uAPI: add descriptions for arguments to all ioctls
Date: Sat,  2 Sep 2017 23:34:53 -0300
Message-Id: <8643ea4f2dbeb6ec8f5d97498a7745331caf7209.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several ioctls are missing descriptions for the third argument
of the ioctl() command. They should have a description, as
otherwise the output won't be ok, and will sound like something
is missing.

So, add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-create-bufs.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-cropcap.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst            | 1 +
 Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst             | 1 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst             | 1 +
 Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst                | 2 +-
 Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst            | 1 +
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst                   | 1 +
 Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst        | 5 ++---
 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst            | 2 +-
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst            | 1 +
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst                  | 1 +
 Documentation/media/uapi/v4l/vidioc-enumaudioout.rst               | 1 +
 Documentation/media/uapi/v4l/vidioc-enuminput.rst                  | 1 +
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst                 | 1 +
 Documentation/media/uapi/v4l/vidioc-enumstd.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-expbuf.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-audio.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst                 | 1 +
 Documentation/media/uapi/v4l/vidioc-g-crop.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst               | 1 +
 Documentation/media/uapi/v4l/vidioc-g-edid.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst                      | 1 +
 Documentation/media/uapi/v4l/vidioc-g-frequency.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-g-input.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst                 | 1 +
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-g-output.rst                   | 1 +
 Documentation/media/uapi/v4l/vidioc-g-parm.rst                     | 1 +
 Documentation/media/uapi/v4l/vidioc-g-priority.rst                 | 2 +-
 Documentation/media/uapi/v4l/vidioc-g-selection.rst                | 5 +----
 Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst           | 1 +
 Documentation/media/uapi/v4l/vidioc-g-std.rst                      | 1 +
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-overlay.rst                    | 1 +
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst                | 1 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst                       | 1 +
 Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst           | 1 +
 Documentation/media/uapi/v4l/vidioc-querybuf.rst                   | 1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst                   | 1 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst                  | 2 ++
 Documentation/media/uapi/v4l/vidioc-querystd.rst                   | 1 +
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst                    | 2 +-
 Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst             | 1 +
 Documentation/media/uapi/v4l/vidioc-streamon.rst                   | 2 +-
 Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst     | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst      | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst              | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst               | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst    | 1 +
 Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst         | 1 +
 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst            | 1 +
 58 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index aaca12fca06e..a39e18d69511 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_create_buffers`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 0f80d5ca2643..a65dbec6b20b 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_cropcap`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index e1e5507e79ff..7709852282c2 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_dbg_chip_info`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 5960a6547f41..f4e8dd5f7889 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_dbg_register`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index fcd9c933870d..cb3565f36793 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_event`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 5156b6ce4ce1..63ead6b7a115 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_dv_timings_cap`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index ae20ee573757..5ae8c933b1b9 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -29,7 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-
+    Pointer to struct :c:type:`v4l2_encoder_cmd`.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 3e9d0f69cc73..63dca65f49e4 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_enum_dv_timings`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index a2adaa4bd4dd..019c513df217 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_fmtdesc`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 146b75d63736..fea7dc3c879d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -26,9 +26,8 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    Pointer to a struct :c:type:`v4l2_frmivalenum`
-    structure that contains a pixel format and size and receives a frame
-    interval.
+    Pointer to struct :c:type:`v4l2_frmivalenum`
+    that contains a pixel format and size and receives a frame interval.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 628f1aa66338..8fcc46d307d5 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    Pointer to a struct :c:type:`v4l2_frmsizeenum`
+    Pointer to struct :c:type:`v4l2_frmsizeenum`
     that contains an index and pixel format and receives a frame width
     and height.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 4e5f5e5bf632..195cf45f3c32 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_frequency_band`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
index 74bc3ed0bdd8..8e5193e8696f 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_audio`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index 4470a1ece5cf..6d2b4f6e78b0 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_audioout`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 266e48ab237f..0350069a56c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_input`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 93a2cf3b310c..697dcd186ae3 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_output`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 19ada126b651..b7fda29f46a1 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_standard`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index 246e48028d40..226e83eb28a9 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_exportbuffer`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 5b67e81a0db6..290851f99386 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_audio`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index d16ecbaddc59..1c98af33ee70 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_audioout`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 13771ee3e94a..a6ed43ba9ca3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_crop`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index d8a379182a34..299b9aabbac2 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_control`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 5b8e2fcb9c3a..2696380626d4 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -35,6 +35,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_dv_timings`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index a16a193a1cbf..acab90f06e5a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -36,6 +36,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+   Pointer to struct :c:type:`v4l2_edid`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index af0737fe4b32..9dfe64fc21a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_enc_idx`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 59a3bde8c1a3..2011c2b2ee67 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -34,6 +34,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_ext_controls`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index 4a6a03d158ca..fc73bf0f6052 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_framebuffer`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index d082f9a21548..f598ea9166e3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -31,6 +31,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_format`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index 46ab276f412b..c1cccb144660 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_frequency`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
index 1364a918fbce..1dcef44eef02 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-input.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-input.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer an integer with input index.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index 8ba353067b33..a1773ea9543e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_jpegcompression`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 77d017eb3fcc..a47b6a15cfbe 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_modulator`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
index 7750948fc61b..3e0093f66834 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-output.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-output.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to an integer with output index.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 3b2e6e59a334..616a5ea3f8fa 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_streamparm`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index a763988f64e4..c28996b4a45c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -29,7 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    Pointer to an enum v4l2_priority type.
+    Pointer to an enum :c:type:`v4l2_priority` type.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index c1ee86472918..f1d9df029e0d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -29,11 +29,8 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_SELECTION, VIDIOC_S_SELECTION
-
 ``argp``
-
+    Pointer to struct :c:type:`v4l2_selection`.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index f26650b6d409..a9633cae76c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_sliced_vbi_cap`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index cd856ad21a28..90791ab51a53 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to :c:type:`v4l2_std_id`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 9278267f5e9a..491866484f57 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_tuner`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-overlay.rst b/Documentation/media/uapi/v4l/vidioc-overlay.rst
index cd7b62ebc53b..1383e3db25fc 100644
--- a/Documentation/media/uapi/v4l/vidioc-overlay.rst
+++ b/Documentation/media/uapi/v4l/vidioc-overlay.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to an integer.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index bdcfd9fe550d..70687a86ae38 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_buffer`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 1f3612637200..9e448a4aa3aa 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_buffer`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 0d16853b1b51..6c82eafd28bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_dv_timings`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index 0bdc8e0abddc..dd54747fabc9 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_buffer`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 12e0d9a63cd8..9494af96bae7 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_capability`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 518739ff40eb..5bd26e8c9a1a 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -32,6 +32,8 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_queryctl`, :c:type:`v4l2_query_ext_ctrl`
+    or :c:type`v4l2_querymenu` (depending on the ioctl).
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index 3ef9ab37f582..cf40bca19b9f 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to :c:type:`v4l2_std_id`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index a4180d576ee5..316f52c8a310 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-
+    Pointer to struct :c:type:`v4l2_requestbuffers`.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 5672ca48d2bd..b318cb8e1df3 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_hw_freq_seek`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index 972d5b3c74aa..e851a6961b78 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -29,7 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-
+    Pointer to an integer.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 1a02c935c8b5..1bfe3865dcc2 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_frame_interval_enum`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 746c24ed97a0..33fdc3ac9316 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_frame_size_enum`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index 0dfee3829ee2..4e4291798e4b 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -26,6 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_mbus_code_enum`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index 000e8fcd3f25..69b2ae8e7c15 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_crop`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index b352456dfe2c..81c5d331af9a 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_format`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index 46159dcfce30..5af0a7179941 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_frame_interval`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 071d9c033db6..b1d3dbbef42a 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -29,6 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_subdev_selection`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index e4a51431032c..a95cbf2a126d 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -30,6 +30,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
+    Pointer to struct :c:type:`v4l2_event_subscription`.
 
 
 Description
-- 
2.13.5
