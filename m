Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52687 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbcHSPEw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 11:04:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] docs-rst: fix warnings introduced by LaTeX patchset
Date: Fri, 19 Aug 2016 12:04:39 -0300
Message-Id: <411888a5abc400c7ca33573435d9a4bbce91a4dc.1471618226.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx is really pedantic with respect to the order where
table tags and references are created. Putting things at
the wrong order causes troubles.

The order that seems to work is:

	.. raw:: latex

	.. tabularcolumns::

	.. _foo_name:

	.. cssclass: longtable

	.. flat-table::

Reorder the tags to the above order, to avoid troubles, and
fix remaining warnings introduced by media recent patches.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 10 +++---
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 19 +++++-------
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 25 ++++++---------
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 15 ++++-----
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 10 +++---
 .../media/uapi/mediactl/media-ioc-g-topology.rst   | 18 ++++-------
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       | 10 +++---
 Documentation/media/uapi/v4l/dev-subdev.rst        |  4 +--
 Documentation/media/uapi/v4l/pixfmt-002.rst        |  5 ++-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  7 ++---
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |  8 ++---
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |  2 +-
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  8 ++---
 Documentation/media/uapi/v4l/subdev-formats.rst    |  7 ++---
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      | 12 ++++----
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |  8 ++---
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |  8 ++---
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    | 36 +++++++++++-----------
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  9 +++---
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          | 11 +++----
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  9 +++---
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  8 ++---
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 16 +++++-----
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst | 12 ++++----
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  3 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    | 12 ++++----
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 12 +++-----
 .../media/uapi/v4l/vidioc-g-enc-index.rst          | 13 ++++----
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          | 14 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     | 10 +++---
 .../media/uapi/v4l/vidioc-g-frequency.rst          |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |  9 +++---
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  8 ++---
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     | 20 ++++++------
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    | 16 +++++-----
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  8 ++---
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  | 20 ++++++------
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |  4 +--
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |  8 ++---
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |  8 ++---
 40 files changed, 205 insertions(+), 241 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index e0eaadaf2305..89ba813e577c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -41,11 +41,10 @@ device information, applications call the ioctl with a pointer to a
 struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
 returns the information to the application. The ioctl never fails.
 
-
-.. _cec-caps:
-
 .. tabularcolumns:: |p{1.2cm}|p{2.5cm}|p{13.8cm}|
 
+.. _cec-caps:
+
 .. flat-table:: struct cec_caps
     :header-rows:  0
     :stub-columns: 0
@@ -88,11 +87,10 @@ returns the information to the application. The ioctl never fails.
 	  macro.
 
 
-
-.. _cec-capabilities:
-
 .. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.6cm}|
 
+.. _cec-capabilities:
+
 .. flat-table:: CEC Capabilities Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 959e920eb7c3..42f8e856ec55 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -66,11 +66,10 @@ logical addresses are claimed or cleared.
 Attempting to call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` when
 logical address types are already defined will return with error ``EBUSY``.
 
-
-.. _cec-log-addrs:
-
 .. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
 
+.. _cec-log-addrs:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct cec_log_addrs
@@ -207,10 +206,10 @@ logical address types are already defined will return with error ``EBUSY``.
           give the CEC framework more information about the device type, even
           though the framework won't use it directly in the CEC message.
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _cec-versions:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: CEC Versions
     :header-rows:  0
     :stub-columns: 0
@@ -242,11 +241,10 @@ logical address types are already defined will return with error ``EBUSY``.
        -  CEC version according to the HDMI 2.0 standard.
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. _cec-prim-dev-types:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: CEC Primary Device Types
     :header-rows:  0
     :stub-columns: 0
@@ -310,11 +308,10 @@ logical address types are already defined will return with error ``EBUSY``.
        -  Use for a video processor device.
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. _cec-log-addr-types:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: CEC Logical Address Types
     :header-rows:  0
     :stub-columns: 0
@@ -381,10 +378,10 @@ logical address types are already defined will return with error ``EBUSY``.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _cec-all-dev-types-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: CEC All Device Types Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index c27b56881a4a..f606d2ffe6a9 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -51,11 +51,10 @@ two :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>` events with
 the same state). In that case the intermediate state changes were lost but
 it is guaranteed that the state did change in between the two events.
 
-
-.. _cec-event-state-change_s:
-
 .. tabularcolumns:: |p{1.2cm}|p{2.9cm}|p{13.4cm}|
 
+.. _cec-event-state-change_s:
+
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
     :stub-columns: 0
@@ -79,11 +78,10 @@ it is guaranteed that the state did change in between the two events.
        -  The current set of claimed logical addresses.
 
 
-
-.. _cec-event-lost-msgs_s:
-
 .. tabularcolumns:: |p{1.0cm}|p{2.0cm}|p{14.5cm}|
 
+.. _cec-event-lost-msgs_s:
+
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
     :stub-columns: 0
@@ -107,11 +105,10 @@ it is guaranteed that the state did change in between the two events.
 	  this is more than enough.
 
 
-
-.. _cec-event:
-
 .. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{2.5cm}|p{8.8cm}|
 
+.. _cec-event:
+
 .. flat-table:: struct cec_event
     :header-rows:  0
     :stub-columns: 0
@@ -175,11 +172,10 @@ it is guaranteed that the state did change in between the two events.
 	  event.
 
 
-
-.. _cec-events:
-
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
+.. _cec-events:
+
 .. flat-table:: CEC Events Types
     :header-rows:  0
     :stub-columns: 0
@@ -206,11 +202,10 @@ it is guaranteed that the state did change in between the two events.
 	  application didn't dequeue CEC messages fast enough.
 
 
-
-.. _cec-event-flags:
-
 .. tabularcolumns:: |p{6.0cm}|p{0.6cm}|p{10.9cm}|
 
+.. _cec-event-flags:
+
 .. flat-table:: CEC Event Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 32261e0510ca..b75ed7057f7c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -73,11 +73,10 @@ always call :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`.
 
 Available initiator modes are:
 
-
-.. _cec-mode-initiator_e:
-
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
+.. _cec-mode-initiator_e:
+
 .. flat-table:: Initiator Modes
     :header-rows:  0
     :stub-columns: 0
@@ -118,11 +117,10 @@ Available initiator modes are:
 
 Available follower modes are:
 
-
-.. _cec-mode-follower_e:
-
 .. tabularcolumns:: |p{6.6cm}|p{0.9cm}|p{10.0cm}|
 
+.. _cec-mode-follower_e:
+
 .. flat-table:: Follower Modes
     :header-rows:  0
     :stub-columns: 0
@@ -212,11 +210,10 @@ Available follower modes are:
 
 Core message processing details:
 
-
-.. _cec-core-processing:
-
 .. tabularcolumns:: |p{6.6cm}|p{10.9cm}|
 
+.. _cec-core-processing:
+
 .. flat-table:: Core Message Processing
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 7615c94dc826..a7074a967f8d 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -73,10 +73,10 @@ checked against the received messages to find the corresponding transmit
 result.
 
 
-.. _cec-msg:
-
 .. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{13.0cm}|
 
+.. _cec-msg:
+
 .. flat-table:: struct cec_msg
     :header-rows:  0
     :stub-columns: 0
@@ -251,11 +251,10 @@ result.
 	  valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. _cec-tx-status:
 
-.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
-
 .. flat-table:: CEC Transmit Status
     :header-rows:  0
     :stub-columns: 0
@@ -321,11 +320,10 @@ result.
 	  be set to explain which failures were seen.
 
 
+.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. _cec-rx-status:
 
-.. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
-
 .. flat-table:: CEC Receive Status
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 750dd11dbe03..c836d64df03b 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -48,11 +48,10 @@ other values untouched.
 If the ``topology_version`` remains the same, the ioctl should fill the
 desired arrays with the media graph elements.
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-topology:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_topology
     :header-rows:  0
     :stub-columns: 0
@@ -144,11 +143,10 @@ desired arrays with the media graph elements.
 	  won't store the links. It will just update ``num_links``
 
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-entity:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_entity
     :header-rows:  0
     :stub-columns: 0
@@ -189,11 +187,10 @@ desired arrays with the media graph elements.
 	  this array to zero.
 
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-interface:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
@@ -242,11 +239,10 @@ desired arrays with the media graph elements.
 	  :ref:`media-v2-intf-devnode` for details..
 
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-intf-devnode:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
@@ -270,11 +266,10 @@ desired arrays with the media graph elements.
        -  Device node minor number.
 
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-pad:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
@@ -315,11 +310,10 @@ desired arrays with the media graph elements.
 	  this array to zero.
 
 
+.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. _media-v2-link:
 
-.. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
-
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index 1b59239c7fb7..3cf44869a425 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -99,11 +99,10 @@ VBI devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does.
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
-
-.. _v4l2-vbi-format:
-
 .. tabularcolumns:: |p{2.4cm}|p{4.4cm}|p{10.7cm}|
 
+.. _v4l2-vbi-format:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_vbi_format
@@ -227,11 +226,10 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 	  applications must set it to zero.
 
 
-
-.. _vbifmt-flags:
-
 .. tabularcolumns:: |p{4.0cm}|p{1.5cm}|p{12.0cm}|
 
+.. _vbifmt-flags:
+
 .. flat-table:: Raw VBI Format Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index b1aed4541bca..7d20c725583d 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -202,14 +202,14 @@ for the pipeline described in :ref:`pipeline-scaling` (table columns
 list entity names and pad numbers).
 
 
-.. _sample-pipeline-config:
-
 .. raw:: latex
 
     \newline\newline\begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|
 
+.. _sample-pipeline-config:
+
 .. flat-table:: Sample Pipeline Configuration
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index 368da55e5f07..58e872f66a07 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -4,11 +4,10 @@
 Single-planar format structure
 ******************************
 
-
-.. _v4l2-pix-format:
-
 .. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
 
+.. _v4l2-pix-format:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_pix_format
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 8dc86b490451..4a2dbe1095b1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -12,10 +12,10 @@ array of :ref:`struct v4l2_plane_pix_format <v4l2-plane-pix-format>` structures,
 describing all planes of that format.
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-plane-pix-format:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_plane_pix_format
     :header-rows:  0
     :stub-columns: 0
@@ -49,11 +49,10 @@ describing all planes of that format.
 	  applications.
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. _v4l2-pix-format-mplane:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_pix_format_mplane
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index f7245f5e0854..39875b4158d2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -18,10 +18,10 @@ next to each other in memory.
 
     \newline\newline\begin{adjustbox}{width=\columnwidth}
 
-.. _rgb-formats:
-
 .. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
+.. _rgb-formats:
+
 .. flat-table:: Packed RGB Image Formats
     :header-rows:  2
     :stub-columns: 0
@@ -1112,8 +1112,6 @@ The meaning of their alpha bits (a) is ill-defined and interpreted as in
 either the corresponding ARGB or XRGB format, depending on the driver.
 
 
-.. _rgb-formats-deprecated:
-
 .. raw:: latex
 
     \newline\newline
@@ -1121,6 +1119,8 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
 .. tabularcolumns:: |p{4.2cm}|p{1.0cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
+.. _rgb-formats-deprecated:
+
 .. flat-table:: Deprecated Packed RGB Image Formats
     :header-rows:  2
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
index 2ffcee5b383b..6066f13af5b3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
@@ -16,7 +16,7 @@ component of each pixel in one 16 or 32 bit word.
 
     \newline\newline\begin{adjustbox}{width=\columnwidth}
 
-.. _rgb-formats:
+.. _yuv-formats:
 
 .. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index d6938cd5e03e..0dd2f7fe096f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -17,10 +17,10 @@ you think your format should be listed in a standard format section
 please make a proposal on the linux-media mailing list.
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _reserved-formats:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Reserved Image Formats
     :header-rows:  1
     :stub-columns: 0
@@ -341,10 +341,10 @@ please make a proposal on the linux-media mailing list.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _format-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Format Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 7d9b55dd6e91..a347fcc206db 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -5,11 +5,10 @@
 Media Bus Formats
 =================
 
-
-.. _v4l2-mbus-framefmt:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-mbus-framefmt:
+
 .. flat-table:: struct v4l2_mbus_framefmt
     :header-rows:  0
     :stub-columns: 0
@@ -3758,7 +3757,7 @@ the following codes.
 
 .. _v4l2-mbus-pixelcode-yuv8:
 
-.. cssclass: longtable
+.. cssclass:: longtable
 
 .. flat-table:: YUV Formats
     :header-rows:  2
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index b433132a7564..4c30b2268c70 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -78,10 +78,10 @@ is available from the LinuxTV v4l-dvb repository; see
 instructions.
 
 
-.. _name-v4l2-dbg-match:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. _name-v4l2-dbg-match:
+
 .. flat-table:: struct v4l2_dbg_match
     :header-rows:  0
     :stub-columns: 0
@@ -124,10 +124,10 @@ instructions.
 
 
 
-.. _v4l2-dbg-chip-info:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-dbg-chip-info:
+
 .. flat-table:: struct v4l2_dbg_chip_info
     :header-rows:  0
     :stub-columns: 0
@@ -171,10 +171,10 @@ instructions.
 
 
 
-.. _name-chip-match-types:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _name-chip-match-types:
+
 .. flat-table:: Chip Match Types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 28885cff682a..cb6a878a60ea 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -86,10 +86,10 @@ It is available from the LinuxTV v4l-dvb repository; see
 instructions.
 
 
-.. _v4l2-dbg-match:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. _v4l2-dbg-match:
+
 .. flat-table:: struct v4l2_dbg_match
     :header-rows:  0
     :stub-columns: 0
@@ -173,10 +173,10 @@ instructions.
 
 
 
-.. _chip-match-types:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _chip-match-types:
+
 .. flat-table:: Chip Match Types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 4287e5b21a8b..63acf4e59530 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -56,12 +56,12 @@ These ioctls are optional, not all drivers may support them. They were
 introduced in Linux 3.3.
 
 
+.. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
+
 .. _v4l2-decoder-cmd:
 
 .. cssclass:: longtable
 
-.. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
-
 .. flat-table:: struct v4l2_decoder_cmd
     :header-rows:  0
     :stub-columns: 0
@@ -189,10 +189,10 @@ introduced in Linux 3.3.
 
 
 
-.. _decoder-cmds:
-
 .. tabularcolumns:: |p{5.6cm}|p{0.6cm}|p{11.3cm}|
 
+.. _decoder-cmds:
+
 .. flat-table:: Decoder Commands
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index ad4b826a2966..e5be2a5518af 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -40,10 +40,10 @@ exceptions which the application may get by e.g. using the select system
 call.
 
 
-.. _v4l2-event:
-
 .. tabularcolumns:: |p{3.0cm}|p{4.3cm}|p{2.5cm}|p{7.7cm}|
 
+.. _v4l2-event:
+
 .. cssclass: longtable
 
 .. flat-table:: struct v4l2_event
@@ -179,12 +179,12 @@ call.
 
 
 
-.. _event-type:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. cssclass:: longtable
 
+.. _event-type:
+
 .. flat-table:: Event Types
     :header-rows:  0
     :stub-columns: 0
@@ -310,10 +310,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-event-vsync:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_event_vsync
     :header-rows:  0
     :stub-columns: 0
@@ -330,10 +330,10 @@ call.
 
 
 
-.. _v4l2-event-ctrl:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.0cm}|p{1.8cm}|p{8.5cm}|
 
+.. _v4l2-event-ctrl:
+
 .. flat-table:: struct v4l2_event_ctrl
     :header-rows:  0
     :stub-columns: 0
@@ -439,10 +439,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-event-frame-sync:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_event_frame_sync
     :header-rows:  0
     :stub-columns: 0
@@ -459,10 +459,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-event-src-change:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_event_src_change
     :header-rows:  0
     :stub-columns: 0
@@ -480,10 +480,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-event-motion-det:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_event_motion_det
     :header-rows:  0
     :stub-columns: 0
@@ -525,10 +525,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _ctrl-changes-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Control Changes
     :header-rows:  0
     :stub-columns: 0
@@ -566,10 +566,10 @@ call.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _src-changes-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Source Changes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index b2bf4f3a3c25..7054e36e061f 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -54,10 +54,10 @@ zero the ``reserved`` array. Attempts to query capabilities on a pad
 that doesn't support them will return an ``EINVAL`` error code.
 
 
-.. _v4l2-bt-timings-cap:
-
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
+.. _v4l2-bt-timings-cap:
+
 .. flat-table:: struct v4l2_bt_timings_cap
     :header-rows:  0
     :stub-columns: 0
@@ -141,10 +141,10 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 
 
-.. _v4l2-dv-timings-cap:
-
 .. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{3.5cm}|p{9.5cm}|
 
+.. _v4l2-dv-timings-cap:
+
 .. flat-table:: struct v4l2_dv_timings_cap
     :header-rows:  0
     :stub-columns: 0
@@ -206,7 +206,6 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 .. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
-
 .. _dv-bt-cap-capabilities:
 
 .. flat-table:: DV BT Timing capabilities
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 18e955ff917a..795d9215017a 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -64,10 +64,10 @@ These ioctls are optional, not all drivers may support them. They were
 introduced in Linux 2.6.21.
 
 
-.. _v4l2-encoder-cmd:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-encoder-cmd:
+
 .. flat-table:: struct v4l2_encoder_cmd
     :header-rows:  0
     :stub-columns: 0
@@ -103,10 +103,10 @@ introduced in Linux 2.6.21.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _encoder-cmds:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Encoder Commands
     :header-rows:  0
     :stub-columns: 0
@@ -165,11 +165,10 @@ introduced in Linux 2.6.21.
 	  flags are defined for this command.
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. _encoder-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Encoder Command Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 2d1444b0d017..da0b888c01cb 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -46,10 +46,10 @@ one until ``EINVAL`` is returned.
    formats may be different.
 
 
-.. _v4l2-fmtdesc:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-fmtdesc:
+
 .. flat-table:: struct v4l2_fmtdesc
     :header-rows:  0
     :stub-columns: 0
@@ -108,6 +108,7 @@ one until ``EINVAL`` is returned.
        -  :cspan:`2`
 
 	  .. _v4l2-fourcc:
+
 	  ``#define v4l2_fourcc(a,b,c,d)``
 
 	  ``(((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))``
@@ -131,10 +132,10 @@ one until ``EINVAL`` is returned.
 
 
 
-.. _fmtdesc-flags:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _fmtdesc-flags:
+
 .. flat-table:: Image Format Description Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index c6ae6f14c9f6..8fac84d839f4 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -43,10 +43,10 @@ This ioctl is supported if the ``V4L2_TUNER_CAP_FREQ_BANDS`` capability
 of the corresponding tuner/modulator is set.
 
 
-.. _v4l2-frequency-band:
-
 .. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
 
+.. _v4l2-frequency-band:
+
 .. flat-table:: struct v4l2_frequency_band
     :header-rows:  0
     :stub-columns: 0
@@ -152,10 +152,10 @@ of the corresponding tuner/modulator is set.
 
 
 
-.. _band-modulation:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _band-modulation:
+
 .. flat-table:: Band Modulation Systems
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 8f0b821bd921..f8188070335e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -41,10 +41,10 @@ index is out of bounds. To enumerate all inputs applications shall begin
 at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 
-.. _v4l2-input:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-input:
+
 .. flat-table:: struct v4l2_input
     :header-rows:  0
     :stub-columns: 0
@@ -150,10 +150,10 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _input-type:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Input Types
     :header-rows:  0
     :stub-columns: 0
@@ -179,10 +179,10 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 
 
-.. _input-status:
-
 .. tabularcolumns:: |p{4.8cm}|p{2.6cm}|p{10.1cm}|
 
+.. _input-status:
+
 .. flat-table:: Input Status Flags
     :header-rows:  0
     :stub-columns: 0
@@ -324,10 +324,10 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _input-capabilities:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Input capabilities
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 456013fb50a2..6d50b297b0aa 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -42,10 +42,10 @@ shall begin at index zero, incrementing by one until the driver returns
 EINVAL.
 
 
-.. _v4l2-output:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-output:
+
 .. flat-table:: struct v4l2_output
     :header-rows:  0
     :stub-columns: 0
@@ -140,10 +140,10 @@ EINVAL.
 
 
 
-.. _output-type:
-
 .. tabularcolumns:: |p{7.0cm}|p{1.8cm}|p{8.7cm}|
 
+.. _output-type:
+
 .. flat-table:: Output Type
     :header-rows:  0
     :stub-columns: 0
@@ -177,10 +177,10 @@ EINVAL.
 
 
 
-.. _output-capabilities:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _output-capabilities:
+
 .. flat-table:: Output capabilities
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 28f00a027cc7..2735b0496e9e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -141,11 +141,10 @@ or output. [#f1]_
        -
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. _v4l2-std-id:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: typedef v4l2_std_id
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 21fa5571b647..703091ba1391 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -50,10 +50,10 @@ cannot be satisfied. However, this is a write-only ioctl, it does not
 return the actual new audio mode.
 
 
-.. _v4l2-audio:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-audio:
+
 .. flat-table:: struct v4l2_audio
     :header-rows:  0
     :stub-columns: 0
@@ -106,10 +106,10 @@ return the actual new audio mode.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _audio-capability:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Audio Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -137,10 +137,10 @@ return the actual new audio mode.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _audio-mode:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Audio Mode Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 58dec578f54d..013f49210de9 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -68,10 +68,10 @@ EBUSY
     The device is busy and therefore can not change the timings.
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-bt-timings:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_bt_timings
     :header-rows:  0
     :stub-columns: 0
@@ -223,10 +223,10 @@ EBUSY
 
 
 
-.. _v4l2-dv-timings:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
 
+.. _v4l2-dv-timings:
+
 .. flat-table:: struct v4l2_dv_timings
     :header-rows:  0
     :stub-columns: 0
@@ -267,12 +267,10 @@ EBUSY
 
        -
 
-
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. _dv-timing-types:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: DV Timing types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 9cb98a8eaf2d..64e74786babf 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -57,10 +57,10 @@ Currently this ioctl is only defined for MPEG-2 program streams and
 video elementary streams.
 
 
-.. _v4l2-enc-idx:
-
 .. tabularcolumns:: |p{3.5cm}|p{5.6cm}|p{8.4cm}|
 
+.. _v4l2-enc-idx:
+
 .. flat-table:: struct v4l2_enc_idx
     :header-rows:  0
     :stub-columns: 0
@@ -105,10 +105,10 @@ video elementary streams.
 
 
 
-.. _v4l2-enc-idx-entry:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-enc-idx-entry:
+
 .. flat-table:: struct v4l2_enc_idx_entry
     :header-rows:  0
     :stub-columns: 0
@@ -163,11 +163,10 @@ video elementary streams.
 	  zero.
 
 
-
-.. _enc-idx-flags:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _enc-idx-flags:
+
 .. flat-table:: Index Entry Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 33445c6b6bc2..5b80481d8734 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -95,10 +95,10 @@ were set/get. Only low-level errors (e. g. a failed i2c command) can
 still cause this situation.
 
 
-.. _v4l2-ext-control:
-
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{1.5cm}|p{11.8cm}|
 
+.. _v4l2-ext-control:
+
 .. cssclass: longtable
 
 .. flat-table:: struct v4l2_ext_control
@@ -229,11 +229,10 @@ still cause this situation.
 	  ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
 
 
-
-.. _v4l2-ext-controls:
-
 .. tabularcolumns:: |p{4.0cm}|p{3.0cm}|p{2.0cm}|p{8.5cm}|
 
+.. _v4l2-ext-controls:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_ext_controls
@@ -367,11 +366,10 @@ still cause this situation.
 	  Ignored if ``count`` equals zero.
 
 
-
-.. _ctrl-class:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _ctrl-class:
+
 .. flat-table:: Control classes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index a6cbc532ff05..562505c5db0b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -76,10 +76,10 @@ hardware, therefore only the superuser can set the parameters for a
 destructive video overlay.
 
 
-.. _v4l2-framebuffer:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. _v4l2-framebuffer:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_framebuffer
@@ -284,11 +284,10 @@ destructive video overlay.
        -  Reserved. Drivers and applications must set this field to zero.
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. _framebuffer-cap:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Frame Buffer Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -374,11 +373,10 @@ destructive video overlay.
 	  exactly opposite of ``V4L2_FBUF_CAP_CHROMAKEY``
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. _framebuffer-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. cssclass:: longtable
 
 .. flat-table:: Frame Buffer Flags
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index bf0c1a13ddd7..c0468ff3546e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -52,10 +52,10 @@ assumes the closest possible value. However :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_F
 write-only ioctl, it does not return the actual new frequency.
 
 
-.. _v4l2-frequency:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-frequency:
+
 .. flat-table:: struct v4l2_frequency
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index 9b87c7f4df52..a5a997db7a33 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -55,10 +55,10 @@ encoded. If you omit them, applications assume you've used standard
 encoding. You usually do want to add them.
 
 
-.. _v4l2-jpegcompression:
-
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
+.. _v4l2-jpegcompression:
+
 .. flat-table:: struct v4l2_jpegcompression
     :header-rows:  0
     :stub-columns: 0
@@ -128,11 +128,10 @@ encoding. You usually do want to add them.
 	  and ignore this field.
 
 
-
-.. _jpeg-markers:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _jpeg-markers:
+
 .. flat-table:: JPEG Markers Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 52c7b95de8e6..0b362fc8ec29 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -61,10 +61,10 @@ To change the radio frequency the
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl is available.
 
 
-.. _v4l2-modulator:
-
 .. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
 
+.. _v4l2-modulator:
+
 .. flat-table:: struct v4l2_modulator
     :header-rows:  0
     :stub-columns: 0
@@ -162,10 +162,10 @@ To change the radio frequency the
 
 
 
-.. _modulator-txsubchans:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _modulator-txsubchans:
+
 .. flat-table:: Modulator Audio Transmission Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 7c32fe94544a..1b044613ab68 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -50,10 +50,10 @@ pointer to a struct :ref:`struct v4l2_streamparm <v4l2-streamparm>` which contai
 union holding separate parameters for input and output devices.
 
 
-.. _v4l2-streamparm:
-
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. _v4l2-streamparm:
+
 .. flat-table:: struct v4l2_streamparm
     :header-rows:  0
     :stub-columns: 0
@@ -111,10 +111,10 @@ union holding separate parameters for input and output devices.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-captureparm:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_captureparm
     :header-rows:  0
     :stub-columns: 0
@@ -194,10 +194,10 @@ union holding separate parameters for input and output devices.
 
 
 
+.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+
 .. _v4l2-outputparm:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
 .. flat-table:: struct v4l2_outputparm
     :header-rows:  0
     :stub-columns: 0
@@ -284,10 +284,10 @@ union holding separate parameters for input and output devices.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _parm-caps:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Streaming Parameters Capabilites
     :header-rows:  0
     :stub-columns: 0
@@ -305,10 +305,10 @@ union holding separate parameters for input and output devices.
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _parm-flags:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Capture Parameters Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index a52efdf94795..9798a1a86e97 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -262,10 +262,10 @@ To change the radio frequency the
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _v4l2-tuner-type:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: enum v4l2_tuner_type
     :header-rows:  0
     :stub-columns: 0
@@ -306,10 +306,10 @@ To change the radio frequency the
        - Tuner controls the RF part of a Sofware Digital Radio (SDR)
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _tuner-capability:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. cssclass:: longtable
 
 .. flat-table:: Tuner and Modulator Capability Flags
@@ -468,10 +468,10 @@ To change the radio frequency the
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _tuner-rxsubchans:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Tuner Audio Reception Flags
     :header-rows:  0
     :stub-columns: 0
@@ -537,10 +537,10 @@ To change the radio frequency the
 
 
 
+.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+
 .. _tuner-audmode:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
-
 .. flat-table:: Tuner Audio Modes
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 05d86b2b87dd..5b9922e83c58 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -41,10 +41,10 @@ filled by the driver. When the driver is not compatible with this
 specification the ioctl returns an ``EINVAL`` error code.
 
 
-.. _v4l2-capability:
-
 .. tabularcolumns:: |p{1.5cm}|p{2.5cm}|p{13cm}|
 
+.. _v4l2-capability:
+
 .. flat-table:: struct v4l2_capability
     :header-rows:  0
     :stub-columns: 0
@@ -170,10 +170,10 @@ specification the ioctl returns an ``EINVAL`` error code.
 
 
 
-.. _device-capabilities:
-
 .. tabularcolumns:: |p{6cm}|p{2.2cm}|p{8.8cm}|
 
+.. _device-capabilities:
+
 .. cssclass:: longtable
 
 .. flat-table:: Device Capabilities Flags
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 437f0f7e3001..6e4912f2e3a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -94,10 +94,10 @@ inclusive.
 See also the examples in :ref:`control`.
 
 
-.. _v4l2-queryctrl:
-
 .. tabularcolumns:: |p{1.2cm}|p{3.6cm}|p{12.7cm}|
 
+.. _v4l2-queryctrl:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_queryctrl
@@ -218,10 +218,10 @@ See also the examples in :ref:`control`.
 
 
 
-.. _v4l2-query-ext-ctrl:
-
 .. tabularcolumns:: |p{1.2cm}|p{5.0cm}|p{11.3cm}|
 
+.. _v4l2-query-ext-ctrl:
+
 .. cssclass:: longtable
 
 .. flat-table:: struct v4l2_query_ext_ctrl
@@ -384,10 +384,10 @@ See also the examples in :ref:`control`.
 
 
 
-.. _v4l2-querymenu:
-
 .. tabularcolumns:: |p{1.2cm}|p{0.6cm}|p{1.6cm}|p{13.5cm}|
 
+.. _v4l2-querymenu:
+
 .. flat-table:: struct v4l2_querymenu
     :header-rows:  0
     :stub-columns: 0
@@ -454,10 +454,10 @@ See also the examples in :ref:`control`.
 
 
 
-.. _v4l2-ctrl-type:
-
 .. tabularcolumns:: |p{5.8cm}|p{1.4cm}|p{1.0cm}|p{1.4cm}|p{6.9cm}|
 
+.. _v4l2-ctrl-type:
+
 .. cssclass:: longtable
 
 .. flat-table:: enum v4l2_ctrl_type
@@ -655,10 +655,10 @@ See also the examples in :ref:`control`.
 
 
 
-.. _control-flags:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _control-flags:
+
 .. cssclass:: longtable
 
 .. flat-table:: Control Flags
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 3e4e1f12c56c..2bc10ebb12a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -61,10 +61,10 @@ If this ioctl is called from a non-blocking filehandle, then ``EAGAIN``
 error code is returned and no seek takes place.
 
 
-.. _v4l2-hw-freq-seek:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-hw-freq-seek:
+
 .. flat-table:: struct v4l2_hw_freq_seek
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index a16b3dd4bd3c..f5e9b40b22f4 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -75,10 +75,10 @@ format to match what the hardware can provide. The modified format
 should be as close as possible to the original request.
 
 
-.. _v4l2-subdev-format:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-subdev-format:
+
 .. flat-table:: struct v4l2_subdev_format
     :header-rows:  0
     :stub-columns: 0
@@ -122,10 +122,10 @@ should be as close as possible to the original request.
 
 
 
-.. _v4l2-subdev-format-whence:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _v4l2-subdev-format-whence:
+
 .. flat-table:: enum v4l2_subdev_format_whence
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 7ae35af66123..71079746ddac 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -38,10 +38,10 @@ Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
 using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 
-.. _v4l2-event-subscription:
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
+.. _v4l2-event-subscription:
+
 .. flat-table:: struct v4l2_event_subscription
     :header-rows:  0
     :stub-columns: 0
@@ -91,10 +91,10 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 
 
-.. _event-flags:
-
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. _event-flags:
+
 .. flat-table:: Event Flags
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4

