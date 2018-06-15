Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45144 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936212AbeFONTt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 09:19:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] Documentation/media/uapi/mediactl: redo tables
Date: Fri, 15 Jun 2018 15:19:44 +0200
Message-Id: <20180615131946.79802-2-hverkuil@xs4all.nl>
In-Reply-To: <20180615131946.79802-1-hverkuil@xs4all.nl>
References: <20180615131946.79802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the '-  .. row 1' lines to make it easier to add new rows to
the tables in the future without having to renumber these lines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../uapi/mediactl/media-ioc-device-info.rst   |  48 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst |  83 +--
 .../uapi/mediactl/media-ioc-enum-links.rst    |  70 +--
 .../uapi/mediactl/media-ioc-g-topology.rst    | 204 ++-----
 .../media/uapi/mediactl/media-types.rst       | 499 +++++-------------
 5 files changed, 185 insertions(+), 719 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index f690f9afc470..649cb3d9e058 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -48,12 +48,8 @@ ioctl never fails.
     :widths:       1 1 2
 
 
-    -  .. row 1
-
-       -  char
-
+    *  -  char
        -  ``driver``\ [16]
-
        -  Name of the driver implementing the media API as a NUL-terminated
 	  ASCII string. The driver version is stored in the
 	  ``driver_version`` field.
@@ -62,66 +58,38 @@ ioctl never fails.
 	  the driver identity. It is also useful to work around known bugs,
 	  or to identify drivers in error reports.
 
-    -  .. row 2
-
-       -  char
-
+    *  -  char
        -  ``model``\ [32]
-
        -  Device model name as a NUL-terminated UTF-8 string. The device
 	  version is stored in the ``device_version`` field and is not be
 	  appended to the model name.
 
-    -  .. row 3
-
-       -  char
-
+    *  -  char
        -  ``serial``\ [40]
-
        -  Serial number as a NUL-terminated ASCII string.
 
-    -  .. row 4
-
-       -  char
-
+    *  -  char
        -  ``bus_info``\ [32]
-
        -  Location of the device in the system as a NUL-terminated ASCII
 	  string. This includes the bus type name (PCI, USB, ...) and a
 	  bus-specific identifier.
 
-    -  .. row 5
-
-       -  __u32
-
+    *  -  __u32
        -  ``media_version``
-
        -  Media API version, formatted with the ``KERNEL_VERSION()`` macro.
 
-    -  .. row 6
-
-       -  __u32
-
+    *  -  __u32
        -  ``hw_revision``
-
        -  Hardware device revision in a driver-specific format.
 
-    -  .. row 7
-
-       -  __u32
-
+    *  -  __u32
        -  ``driver_version``
-
        -  Media device driver version, formatted with the
 	  ``KERNEL_VERSION()`` macro. Together with the ``driver`` field
 	  this identifies a particular driver.
 
-    -  .. row 8
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved``\ [31]
-
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 582fda488810..961466ae821d 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -58,142 +58,87 @@ id's until they get an error.
     :stub-columns: 0
     :widths: 1 1 1 1 8
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``id``
-
        -
        -
        -  Entity id, set by the application. When the id is or'ed with
 	  ``MEDIA_ENT_ID_FLAG_NEXT``, the driver clears the flag and returns
 	  the first entity with a larger id.
 
-    -  .. row 2
-
-       -  char
-
+    *  -  char
        -  ``name``\ [32]
-
        -
        -
        -  Entity name as an UTF-8 NULL-terminated string.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``type``
-
        -
        -
        -  Entity type, see :ref:`media-entity-functions` for details.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``revision``
-
        -
        -
        -  Entity revision. Always zero (obsolete)
 
-    -  .. row 5
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -
        -
        -  Entity flags, see :ref:`media-entity-flag` for details.
 
-    -  .. row 6
-
-       -  __u32
-
+    *  -  __u32
        -  ``group_id``
-
        -
        -
        -  Entity group ID. Always zero (obsolete)
 
-    -  .. row 7
-
-       -  __u16
-
+    *  -  __u16
        -  ``pads``
-
        -
        -
        -  Number of pads
 
-    -  .. row 8
-
-       -  __u16
-
+    *  -  __u16
        -  ``links``
-
        -
        -
        -  Total number of outbound links. Inbound links are not counted in
 	  this field.
 
-    -  .. row 9
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved[4]``
-
        -
        -
        -  Reserved for future extensions. Drivers and applications must set
           the array to zero.
 
-    -  .. row 10
-
-       -  union
-
-    -  .. row 11
+    *  -  union
 
-       -
+    *  -
        -  struct
-
        -  ``dev``
-
        -
        -  Valid for (sub-)devices that create a single device node.
 
-    -  .. row 12
-
-       -
+    *  -
        -
        -  __u32
-
        -  ``major``
-
        -  Device node major number.
 
-    -  .. row 13
-
-       -
+    *  -
        -
        -  __u32
-
        -  ``minor``
-
        -  Device node minor number.
 
-    -  .. row 14
-
-       -
+    *  -
        -  __u8
-
        -  ``raw``\ [184]
-
        -
        -
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index 256168b3c3be..17abdeed1a9c 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -62,35 +62,21 @@ returned during the enumeration process.
     :stub-columns: 0
     :widths:       1 1 2
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``entity``
-
        -  Entity id, set by the application.
 
-    -  .. row 2
-
-       -  struct :c:type:`media_pad_desc`
-
+    *  -  struct :c:type:`media_pad_desc`
        -  \*\ ``pads``
-
        -  Pointer to a pads array allocated by the application. Ignored if
 	  NULL.
 
-    -  .. row 3
-
-       -  struct :c:type:`media_link_desc`
-
+    *  -  struct :c:type:`media_link_desc`
        -  \*\ ``links``
-
        -  Pointer to a links array allocated by the application. Ignored if
 	  NULL.
 
 
-
 .. c:type:: media_pad_desc
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
@@ -100,37 +86,20 @@ returned during the enumeration process.
     :stub-columns: 0
     :widths:       1 1 2
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``entity``
-
        -  ID of the entity this pad belongs to.
 
-    -  .. row 2
-
-       -  __u16
-
+    *  -  __u16
        -  ``index``
-
        -  0-based pad index.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved[2]``
-
        -  Reserved for future extensions. Drivers and applications must set
           the array to zero.
 
@@ -145,37 +114,20 @@ returned during the enumeration process.
     :stub-columns: 0
     :widths:       1 1 2
 
-
-    -  .. row 1
-
-       -  struct :c:type:`media_pad_desc`
-
+    *  -  struct :c:type:`media_pad_desc`
        -  ``source``
-
        -  Pad at the origin of this link.
 
-    -  .. row 2
-
-       -  struct :c:type:`media_pad_desc`
-
+    *  -  struct :c:type:`media_pad_desc`
        -  ``sink``
-
        -  Pad at the target of this link.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -  Link flags, see :ref:`media-link-flag` for more details.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved[4]``
-
        -  Reserved for future extensions. Drivers and applications must set
           the array to zero.
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index c4055ddf070a..a3f259f83b25 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -55,119 +55,66 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-
-    -  .. row 1
-
-       -  __u64
-
+    *  -  __u64
        -  ``topology_version``
-
        -  Version of the media graph topology. When the graph is created,
 	  this field starts with zero. Every time a graph element is added
 	  or removed, this field is incremented.
 
-    -  .. row 2
-
-       -  __u32
-
+    *  -  __u32
        -  ``num_entities``
-
        -  Number of entities in the graph
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved1``
-
        -  Applications and drivers shall set this to 0.
 
-    -  .. row 4
-
-       -  __u64
-
+    *  -  __u64
        -  ``ptr_entities``
-
        -  A pointer to a memory area where the entities array will be
 	  stored, converted to a 64-bits integer. It can be zero. if zero,
 	  the ioctl won't store the entities. It will just update
 	  ``num_entities``
 
-    -  .. row 5
-
-       -  __u32
-
+    *  -  __u32
        -  ``num_interfaces``
-
        -  Number of interfaces in the graph
 
-    -  .. row 6
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved2``
-
        -  Applications and drivers shall set this to 0.
 
-    -  .. row 7
-
-       -  __u64
-
+    *  -  __u64
        -  ``ptr_interfaces``
-
        -  A pointer to a memory area where the interfaces array will be
 	  stored, converted to a 64-bits integer. It can be zero. if zero,
 	  the ioctl won't store the interfaces. It will just update
 	  ``num_interfaces``
 
-    -  .. row 8
-
-       -  __u32
-
+    *  -  __u32
        -  ``num_pads``
-
        -  Total number of pads in the graph
 
-    -  .. row 9
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved3``
-
        -  Applications and drivers shall set this to 0.
 
-    -  .. row 10
-
-       -  __u64
-
+    *  -  __u64
        -  ``ptr_pads``
-
        -  A pointer to a memory area where the pads array will be stored,
 	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
 	  won't store the pads. It will just update ``num_pads``
 
-    -  .. row 11
-
-       -  __u32
-
+    *  -  __u32
        -  ``num_links``
-
        -  Total number of data and interface links in the graph
 
-    -  .. row 12
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved4``
-
        -  Applications and drivers shall set this to 0.
 
-    -  .. row 13
-
-       -  __u64
-
+    *  -  __u64
        -  ``ptr_links``
-
        -  A pointer to a memory area where the links array will be stored,
 	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
 	  won't store the links. It will just update ``num_links``
@@ -182,37 +129,20 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``id``
-
        -  Unique ID for the entity.
 
-    -  .. row 2
-
-       -  char
-
+    *  -  char
        -  ``name``\ [64]
-
        -  Entity name as an UTF-8 NULL-terminated string.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``function``
-
        -  Entity main function, see :ref:`media-entity-functions` for details.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved``\ [6]
-
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
@@ -226,45 +156,25 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``id``
-
        -  Unique ID for the interface.
 
-    -  .. row 2
-
-       -  __u32
-
+    *  -  __u32
        -  ``intf_type``
-
        -  Interface type, see :ref:`media-intf-type` for details.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -  Interface flags. Currently unused.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved``\ [9]
-
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
-    -  .. row 5
-
-       -  struct media_v2_intf_devnode
-
+    *  -  struct media_v2_intf_devnode
        -  ``devnode``
-
        -  Used only for device node interfaces. See
 	  :c:type:`media_v2_intf_devnode` for details..
 
@@ -278,24 +188,14 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``major``
-
        -  Device node major number.
 
-    -  .. row 2
-
-       -  __u32
-
+    *  -  __u32
        -  ``minor``
-
        -  Device node minor number.
 
-
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
 .. c:type:: media_v2_pad
@@ -305,37 +205,20 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``id``
-
        -  Unique ID for the pad.
 
-    -  .. row 2
-
-       -  __u32
-
+    *  -  __u32
        -  ``entity_id``
-
        -  Unique ID for the entity where this pad belongs.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved``\ [5]
-
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
@@ -349,49 +232,28 @@ desired arrays with the media graph elements.
     :stub-columns: 0
     :widths: 1 2 8
 
-
-    -  .. row 1
-
-       -  __u32
-
+    *  -  __u32
        -  ``id``
-
        -  Unique ID for the link.
 
-    -  .. row 2
-
-       -  __u32
-
+    *  -  __u32
        -  ``source_id``
-
        -  On pad to pad links: unique ID for the source pad.
 
 	  On interface to entity links: unique ID for the interface.
 
-    -  .. row 3
-
-       -  __u32
-
+    *  -  __u32
        -  ``sink_id``
-
        -  On pad to pad links: unique ID for the sink pad.
 
 	  On interface to entity links: unique ID for the entity.
 
-    -  .. row 4
-
-       -  __u32
-
+    *  -  __u32
        -  ``flags``
-
        -  Link flags, see :ref:`media-link-flag` for more details.
 
-    -  .. row 5
-
-       -  __u32
-
+    *  -  __u32
        -  ``reserved``\ [6]
-
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 2dda14bd89b7..96910cf2eaaa 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -8,6 +8,38 @@ Types and flags used to represent the media graph elements
 ..  tabularcolumns:: |p{8.2cm}|p{10.3cm}|
 
 .. _media-entity-functions:
+.. _MEDIA-ENT-F-UNKNOWN:
+.. _MEDIA-ENT-F-V4L2-SUBDEV-UNKNOWN:
+.. _MEDIA-ENT-F-IO-V4L:
+.. _MEDIA-ENT-F-IO-VBI:
+.. _MEDIA-ENT-F-IO-SWRADIO:
+.. _MEDIA-ENT-F-IO-DTV:
+.. _MEDIA-ENT-F-DTV-DEMOD:
+.. _MEDIA-ENT-F-TS-DEMUX:
+.. _MEDIA-ENT-F-DTV-CA:
+.. _MEDIA-ENT-F-DTV-NET-DECAP:
+.. _MEDIA-ENT-F-CONN-RF:
+.. _MEDIA-ENT-F-CONN-SVIDEO:
+.. _MEDIA-ENT-F-CONN-COMPOSITE:
+.. _MEDIA-ENT-F-CAM-SENSOR:
+.. _MEDIA-ENT-F-FLASH:
+.. _MEDIA-ENT-F-LENS:
+.. _MEDIA-ENT-F-ATV-DECODER:
+.. _MEDIA-ENT-F-TUNER:
+.. _MEDIA-ENT-F-IF-VID-DECODER:
+.. _MEDIA-ENT-F-IF-AUD-DECODER:
+.. _MEDIA-ENT-F-AUDIO-CAPTURE:
+.. _MEDIA-ENT-F-AUDIO-PLAYBACK:
+.. _MEDIA-ENT-F-AUDIO-MIXER:
+.. _MEDIA-ENT-F-PROC-VIDEO-COMPOSER:
+.. _MEDIA-ENT-F-PROC-VIDEO-PIXEL-FORMATTER:
+.. _MEDIA-ENT-F-PROC-VIDEO-PIXEL-ENC-CONV:
+.. _MEDIA-ENT-F-PROC-VIDEO-LUT:
+.. _MEDIA-ENT-F-PROC-VIDEO-SCALER:
+.. _MEDIA-ENT-F-PROC-VIDEO-STATISTICS:
+.. _MEDIA-ENT-F-VID-MUX:
+.. _MEDIA-ENT-F-VID-IF-BRIDGE:
+.. _MEDIA-ENT-F-DTV-DECODER:
 
 .. cssclass:: longtable
 
@@ -15,139 +47,56 @@ Types and flags used to represent the media graph elements
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
-
-       .. _MEDIA-ENT-F-UNKNOWN:
-       .. _MEDIA-ENT-F-V4L2-SUBDEV-UNKNOWN:
-
-       -  ``MEDIA_ENT_F_UNKNOWN`` and
-
+    *  -  ``MEDIA_ENT_F_UNKNOWN`` and
 	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
-
        -  Unknown entity. That generally indicates that a driver didn't
 	  initialize properly the entity, which is a Kernel bug
 
-    -  .. row 2
-
-       ..  _MEDIA-ENT-F-IO-V4L:
-
-       -  ``MEDIA_ENT_F_IO_V4L``
-
+    *  -  ``MEDIA_ENT_F_IO_V4L``
        -  Data streaming input and/or output entity.
 
-    -  .. row 3
-
-       ..  _MEDIA-ENT-F-IO-VBI:
-
-       -  ``MEDIA_ENT_F_IO_VBI``
-
+    *  -  ``MEDIA_ENT_F_IO_VBI``
        -  V4L VBI streaming input or output entity
 
-    -  .. row 4
-
-       ..  _MEDIA-ENT-F-IO-SWRADIO:
-
-       -  ``MEDIA_ENT_F_IO_SWRADIO``
-
+    *  -  ``MEDIA_ENT_F_IO_SWRADIO``
        -  V4L Software Digital Radio (SDR) streaming input or output entity
 
-    -  .. row 5
-
-       ..  _MEDIA-ENT-F-IO-DTV:
-
-       -  ``MEDIA_ENT_F_IO_DTV``
-
+    *  -  ``MEDIA_ENT_F_IO_DTV``
        -  DVB Digital TV streaming input or output entity
 
-    -  .. row 6
-
-       ..  _MEDIA-ENT-F-DTV-DEMOD:
-
-       -  ``MEDIA_ENT_F_DTV_DEMOD``
-
+    *  -  ``MEDIA_ENT_F_DTV_DEMOD``
        -  Digital TV demodulator entity.
 
-    -  .. row 7
-
-       ..  _MEDIA-ENT-F-TS-DEMUX:
-
-       -  ``MEDIA_ENT_F_TS_DEMUX``
-
+    *  -  ``MEDIA_ENT_F_TS_DEMUX``
        -  MPEG Transport stream demux entity. Could be implemented on
 	  hardware or in Kernelspace by the Linux DVB subsystem.
 
-    -  .. row 8
-
-       ..  _MEDIA-ENT-F-DTV-CA:
-
-       -  ``MEDIA_ENT_F_DTV_CA``
-
+    *  -  ``MEDIA_ENT_F_DTV_CA``
        -  Digital TV Conditional Access module (CAM) entity
 
-    -  .. row 9
-
-       ..  _MEDIA-ENT-F-DTV-NET-DECAP:
-
-       -  ``MEDIA_ENT_F_DTV_NET_DECAP``
-
+    *  -  ``MEDIA_ENT_F_DTV_NET_DECAP``
        -  Digital TV network ULE/MLE desencapsulation entity. Could be
 	  implemented on hardware or in Kernelspace
 
-    -  .. row 10
-
-       ..  _MEDIA-ENT-F-CONN-RF:
-
-       -  ``MEDIA_ENT_F_CONN_RF``
-
+    *  -  ``MEDIA_ENT_F_CONN_RF``
        -  Connector for a Radio Frequency (RF) signal.
 
-    -  .. row 11
-
-       ..  _MEDIA-ENT-F-CONN-SVIDEO:
-
-       -  ``MEDIA_ENT_F_CONN_SVIDEO``
-
+    *  -  ``MEDIA_ENT_F_CONN_SVIDEO``
        -  Connector for a S-Video signal.
 
-    -  .. row 12
-
-       ..  _MEDIA-ENT-F-CONN-COMPOSITE:
-
-       -  ``MEDIA_ENT_F_CONN_COMPOSITE``
-
+    *  -  ``MEDIA_ENT_F_CONN_COMPOSITE``
        -  Connector for a RGB composite signal.
 
-    -  .. row 13
-
-       ..  _MEDIA-ENT-F-CAM-SENSOR:
-
-       -  ``MEDIA_ENT_F_CAM_SENSOR``
-
+    *  -  ``MEDIA_ENT_F_CAM_SENSOR``
        -  Camera video sensor entity.
 
-    -  .. row 14
-
-       ..  _MEDIA-ENT-F-FLASH:
-
-       -  ``MEDIA_ENT_F_FLASH``
-
+    *  -  ``MEDIA_ENT_F_FLASH``
        -  Flash controller entity.
 
-    -  .. row 15
-
-       ..  _MEDIA-ENT-F-LENS:
-
-       -  ``MEDIA_ENT_F_LENS``
-
+    *  -  ``MEDIA_ENT_F_LENS``
        -  Lens controller entity.
 
-    -  .. row 16
-
-       ..  _MEDIA-ENT-F-ATV-DECODER:
-
-       -  ``MEDIA_ENT_F_ATV_DECODER``
-
+    *  -  ``MEDIA_ENT_F_ATV_DECODER``
        -  Analog video decoder, the basic function of the video decoder is
 	  to accept analogue video from a wide variety of sources such as
 	  broadcast, DVD players, cameras and video cassette recorders, in
@@ -155,36 +104,21 @@ Types and flags used to represent the media graph elements
 	  its component parts, luminance and chrominance, and output it in
 	  some digital video standard, with appropriate timing signals.
 
-    -  .. row 17
-
-       ..  _MEDIA-ENT-F-TUNER:
-
-       -  ``MEDIA_ENT_F_TUNER``
-
+    *  -  ``MEDIA_ENT_F_TUNER``
        -  Digital TV, analog TV, radio and/or software radio tuner, with
 	  consists on a PLL tuning stage that converts radio frequency (RF)
 	  signal into an Intermediate Frequency (IF). Modern tuners have
 	  internally IF-PLL decoders for audio and video, but older models
 	  have those stages implemented on separate entities.
 
-    -  .. row 18
-
-       ..  _MEDIA-ENT-F-IF-VID-DECODER:
-
-       -  ``MEDIA_ENT_F_IF_VID_DECODER``
-
+    *  -  ``MEDIA_ENT_F_IF_VID_DECODER``
        -  IF-PLL video decoder. It receives the IF from a PLL and decodes
 	  the analog TV video signal. This is commonly found on some very
 	  old analog tuners, like Philips MK3 designs. They all contain a
 	  tda9887 (or some software compatible similar chip, like tda9885).
 	  Those devices use a different I2C address than the tuner PLL.
 
-    -  .. row 19
-
-       ..  _MEDIA-ENT-F-IF-AUD-DECODER:
-
-       -  ``MEDIA_ENT_F_IF_AUD_DECODER``
-
+    *  -  ``MEDIA_ENT_F_IF_AUD_DECODER``
        -  IF-PLL sound decoder. It receives the IF from a PLL and decodes
 	  the analog TV audio signal. This is commonly found on some very
 	  old analog hardware, like Micronas msp3400, Philips tda9840,
@@ -192,36 +126,16 @@ Types and flags used to represent the media graph elements
 	  tuner PLL and should be controlled together with the IF-PLL video
 	  decoder.
 
-    -  .. row 20
-
-       ..  _MEDIA-ENT-F-AUDIO-CAPTURE:
-
-       -  ``MEDIA_ENT_F_AUDIO_CAPTURE``
-
+    *  -  ``MEDIA_ENT_F_AUDIO_CAPTURE``
        -  Audio Capture Function Entity.
 
-    -  .. row 21
-
-       ..  _MEDIA-ENT-F-AUDIO-PLAYBACK:
-
-       -  ``MEDIA_ENT_F_AUDIO_PLAYBACK``
-
+    *  -  ``MEDIA_ENT_F_AUDIO_PLAYBACK``
        -  Audio Playback Function Entity.
 
-    -  .. row 22
-
-       ..  _MEDIA-ENT-F-AUDIO-MIXER:
-
-       -  ``MEDIA_ENT_F_AUDIO_MIXER``
-
+    *  -  ``MEDIA_ENT_F_AUDIO_MIXER``
        -  Audio Mixer Function Entity.
 
-    -  .. row 23
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-COMPOSER:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_COMPOSER``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_COMPOSER``
        -  Video composer (blender). An entity capable of video
 	  composing must have at least two sink pads and one source
 	  pad, and composes input video frames onto output video
@@ -229,12 +143,7 @@ Types and flags used to represent the media graph elements
 	  color keying, raster operations (ROP), stitching or any other
 	  means.
 
-    -  ..  row 24
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-PIXEL-FORMATTER:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER``
        -  Video pixel formatter. An entity capable of pixel formatting
 	  must have at least one sink pad and one source pad. Read
 	  pixel formatters read pixels from memory and perform a subset
@@ -243,12 +152,7 @@ Types and flags used to represent the media graph elements
 	  a subset of dithering, pixel encoding conversion and packing
 	  and write pixels to memory.
 
-    -  ..  row 25
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-PIXEL-ENC-CONV:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV``
        -  Video pixel encoding converter. An entity capable of pixel
 	  enconding conversion must have at least one sink pad and one
 	  source pad, and convert the encoding of pixels received on
@@ -257,12 +161,7 @@ Types and flags used to represent the media graph elements
 	  to RGB to/from HSV, RGB to/from YUV and CFA (Bayer) to RGB
 	  conversions.
 
-    -  ..  row 26
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-LUT:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_LUT``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_LUT``
        -  Video look-up table. An entity capable of video lookup table
 	  processing must have one sink pad and one source pad. It uses
 	  the values of the pixels received on its sink pad to look up
@@ -271,12 +170,7 @@ Types and flags used to represent the media graph elements
 	  separately or combine them for multi-dimensional table
 	  lookups.
 
-    -  ..  row 27
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-SCALER:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
        -  Video scaler. An entity capable of video scaling must have
 	  at least one sink pad and one source pad, and scale the
 	  video frame(s) received on its sink pad(s) to a different
@@ -287,46 +181,26 @@ Types and flags used to represent the media graph elements
 	  sub-sampling (occasionally also referred to as skipping) are
 	  considered as scaling.
 
-    -  ..  row 28
-
-       ..  _MEDIA-ENT-F-PROC-VIDEO-STATISTICS:
-
-       -  ``MEDIA_ENT_F_PROC_VIDEO_STATISTICS``
-
+    *  -  ``MEDIA_ENT_F_PROC_VIDEO_STATISTICS``
        -  Video statistics computation (histogram, 3A, etc.). An entity
 	  capable of statistics computation must have one sink pad and
 	  one source pad. It computes statistics over the frames
 	  received on its sink pad and outputs the statistics data on
 	  its source pad.
 
-    -  ..  row 29
-
-       ..  _MEDIA-ENT-F-VID-MUX:
-
-       -  ``MEDIA_ENT_F_VID_MUX``
-
+    *  -  ``MEDIA_ENT_F_VID_MUX``
        - Video multiplexer. An entity capable of multiplexing must have at
          least two sink pads and one source pad, and must pass the video
          frame(s) received from the active sink pad to the source pad.
 
-    -  ..  row 30
-
-       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
-
-       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
-
+    *  -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
        - Video interface bridge. A video interface bridge entity must have at
          least one sink pad and at least one source pad. It receives video
          frames on its sink pad from an input video bus of one type (HDMI, eDP,
          MIPI CSI-2, etc.), and outputs them on its source pad to an output
          video bus of another type (eDP, MIPI CSI-2, parallel, etc.).
 
-    -  ..  row 31
-
-       ..  _MEDIA-ENT-F-DTV-DECODER:
-
-       -  ``MEDIA_ENT_F_DTV_DECODER``
-
+    *  -  ``MEDIA_ENT_F_DTV_DECODER``
        -  Digital video decoder. The basic function of the video decoder is
 	  to accept digital video from a wide variety of sources
 	  and output it in some digital video standard, with appropriate
@@ -335,263 +209,145 @@ Types and flags used to represent the media graph elements
 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-entity-flag:
+.. _MEDIA-ENT-FL-DEFAULT:
+.. _MEDIA-ENT-FL-CONNECTOR:
 
 .. flat-table:: Media entity flags
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
-
-       ..  _MEDIA-ENT-FL-DEFAULT:
-
-       -  ``MEDIA_ENT_FL_DEFAULT``
-
+    *  -  ``MEDIA_ENT_FL_DEFAULT``
        -  Default entity for its type. Used to discover the default audio,
 	  VBI and video devices, the default camera sensor, etc.
 
-    -  .. row 2
-
-       ..  _MEDIA-ENT-FL-CONNECTOR:
-
-       -  ``MEDIA_ENT_FL_CONNECTOR``
-
+    *  -  ``MEDIA_ENT_FL_CONNECTOR``
        -  The entity represents a connector.
 
 
 ..  tabularcolumns:: |p{6.5cm}|p{6.0cm}|p{5.0cm}|
 
 .. _media-intf-type:
+.. _MEDIA-INTF-T-DVB-FE:
+.. _MEDIA-INTF-T-DVB-DEMUX:
+.. _MEDIA-INTF-T-DVB-DVR:
+.. _MEDIA-INTF-T-DVB-CA:
+.. _MEDIA-INTF-T-DVB-NET:
+.. _MEDIA-INTF-T-V4L-VIDEO:
+.. _MEDIA-INTF-T-V4L-VBI:
+.. _MEDIA-INTF-T-V4L-RADIO:
+.. _MEDIA-INTF-T-V4L-SUBDEV:
+.. _MEDIA-INTF-T-V4L-SWRADIO:
+.. _MEDIA-INTF-T-V4L-TOUCH:
+.. _MEDIA-INTF-T-ALSA-PCM-CAPTURE:
+.. _MEDIA-INTF-T-ALSA-PCM-PLAYBACK:
+.. _MEDIA-INTF-T-ALSA-CONTROL:
+.. _MEDIA-INTF-T-ALSA-COMPRESS:
+.. _MEDIA-INTF-T-ALSA-RAWMIDI:
+.. _MEDIA-INTF-T-ALSA-HWDEP:
+.. _MEDIA-INTF-T-ALSA-SEQUENCER:
+.. _MEDIA-INTF-T-ALSA-TIMER:
 
 .. flat-table:: Media interface types
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
-
-       ..  _MEDIA-INTF-T-DVB-FE:
-
-       -  ``MEDIA_INTF_T_DVB_FE``
-
+    *  -  ``MEDIA_INTF_T_DVB_FE``
        -  Device node interface for the Digital TV frontend
-
        -  typically, /dev/dvb/adapter?/frontend?
 
-    -  .. row 2
-
-       ..  _MEDIA-INTF-T-DVB-DEMUX:
-
-       -  ``MEDIA_INTF_T_DVB_DEMUX``
-
+    *  -  ``MEDIA_INTF_T_DVB_DEMUX``
        -  Device node interface for the Digital TV demux
-
        -  typically, /dev/dvb/adapter?/demux?
 
-    -  .. row 3
-
-       ..  _MEDIA-INTF-T-DVB-DVR:
-
-       -  ``MEDIA_INTF_T_DVB_DVR``
-
+    *  -  ``MEDIA_INTF_T_DVB_DVR``
        -  Device node interface for the Digital TV DVR
-
        -  typically, /dev/dvb/adapter?/dvr?
 
-    -  .. row 4
-
-       ..  _MEDIA-INTF-T-DVB-CA:
-
-       -  ``MEDIA_INTF_T_DVB_CA``
-
+    *  -  ``MEDIA_INTF_T_DVB_CA``
        -  Device node interface for the Digital TV Conditional Access
-
        -  typically, /dev/dvb/adapter?/ca?
 
-    -  .. row 5
-
-       ..  _MEDIA-INTF-T-DVB-NET:
-
-       -  ``MEDIA_INTF_T_DVB_NET``
-
+    *  -  ``MEDIA_INTF_T_DVB_NET``
        -  Device node interface for the Digital TV network control
-
        -  typically, /dev/dvb/adapter?/net?
 
-    -  .. row 6
-
-       ..  _MEDIA-INTF-T-V4L-VIDEO:
-
-       -  ``MEDIA_INTF_T_V4L_VIDEO``
-
+    *  -  ``MEDIA_INTF_T_V4L_VIDEO``
        -  Device node interface for video (V4L)
-
        -  typically, /dev/video?
 
-    -  .. row 7
-
-       ..  _MEDIA-INTF-T-V4L-VBI:
-
-       -  ``MEDIA_INTF_T_V4L_VBI``
-
+    *  -  ``MEDIA_INTF_T_V4L_VBI``
        -  Device node interface for VBI (V4L)
-
        -  typically, /dev/vbi?
 
-    -  .. row 8
-
-       ..  _MEDIA-INTF-T-V4L-RADIO:
-
-       -  ``MEDIA_INTF_T_V4L_RADIO``
-
+    *  -  ``MEDIA_INTF_T_V4L_RADIO``
        -  Device node interface for radio (V4L)
-
        -  typically, /dev/radio?
 
-    -  .. row 9
-
-       ..  _MEDIA-INTF-T-V4L-SUBDEV:
-
-       -  ``MEDIA_INTF_T_V4L_SUBDEV``
-
+    *  -  ``MEDIA_INTF_T_V4L_SUBDEV``
        -  Device node interface for a V4L subdevice
-
        -  typically, /dev/v4l-subdev?
 
-    -  .. row 10
-
-       ..  _MEDIA-INTF-T-V4L-SWRADIO:
-
-       -  ``MEDIA_INTF_T_V4L_SWRADIO``
-
+    *  -  ``MEDIA_INTF_T_V4L_SWRADIO``
        -  Device node interface for Software Defined Radio (V4L)
-
        -  typically, /dev/swradio?
 
-    -  .. row 11
-
-       ..  _MEDIA-INTF-T-V4L-TOUCH:
-
-       -  ``MEDIA_INTF_T_V4L_TOUCH``
-
+    *  -  ``MEDIA_INTF_T_V4L_TOUCH``
        -  Device node interface for Touch device (V4L)
-
        -  typically, /dev/v4l-touch?
 
-    -  .. row 12
-
-       ..  _MEDIA-INTF-T-ALSA-PCM-CAPTURE:
-
-       -  ``MEDIA_INTF_T_ALSA_PCM_CAPTURE``
-
+    *  -  ``MEDIA_INTF_T_ALSA_PCM_CAPTURE``
        -  Device node interface for ALSA PCM Capture
-
        -  typically, /dev/snd/pcmC?D?c
 
-    -  .. row 13
-
-       ..  _MEDIA-INTF-T-ALSA-PCM-PLAYBACK:
-
-       -  ``MEDIA_INTF_T_ALSA_PCM_PLAYBACK``
-
+    *  -  ``MEDIA_INTF_T_ALSA_PCM_PLAYBACK``
        -  Device node interface for ALSA PCM Playback
-
        -  typically, /dev/snd/pcmC?D?p
 
-    -  .. row 14
-
-       ..  _MEDIA-INTF-T-ALSA-CONTROL:
-
-       -  ``MEDIA_INTF_T_ALSA_CONTROL``
-
+    *  -  ``MEDIA_INTF_T_ALSA_CONTROL``
        -  Device node interface for ALSA Control
-
        -  typically, /dev/snd/controlC?
 
-    -  .. row 15
-
-       ..  _MEDIA-INTF-T-ALSA-COMPRESS:
-
-       -  ``MEDIA_INTF_T_ALSA_COMPRESS``
-
+    *  -  ``MEDIA_INTF_T_ALSA_COMPRESS``
        -  Device node interface for ALSA Compress
-
        -  typically, /dev/snd/compr?
 
-    -  .. row 16
-
-       ..  _MEDIA-INTF-T-ALSA-RAWMIDI:
-
-       -  ``MEDIA_INTF_T_ALSA_RAWMIDI``
-
+    *  -  ``MEDIA_INTF_T_ALSA_RAWMIDI``
        -  Device node interface for ALSA Raw MIDI
-
        -  typically, /dev/snd/midi?
 
-    -  .. row 17
-
-       ..  _MEDIA-INTF-T-ALSA-HWDEP:
-
-       -  ``MEDIA_INTF_T_ALSA_HWDEP``
-
+    *  -  ``MEDIA_INTF_T_ALSA_HWDEP``
        -  Device node interface for ALSA Hardware Dependent
-
        -  typically, /dev/snd/hwC?D?
 
-    -  .. row 18
-
-       ..  _MEDIA-INTF-T-ALSA-SEQUENCER:
-
-       -  ``MEDIA_INTF_T_ALSA_SEQUENCER``
-
+    *  -  ``MEDIA_INTF_T_ALSA_SEQUENCER``
        -  Device node interface for ALSA Sequencer
-
        -  typically, /dev/snd/seq
 
-    -  .. row 19
-
-       ..  _MEDIA-INTF-T-ALSA-TIMER:
-
-       -  ``MEDIA_INTF_T_ALSA_TIMER``
-
+    *  -  ``MEDIA_INTF_T_ALSA_TIMER``
        -  Device node interface for ALSA Timer
-
        -  typically, /dev/snd/timer
 
 
 .. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-pad-flag:
+.. _MEDIA-PAD-FL-SINK:
+.. _MEDIA-PAD-FL-SOURCE:
+.. _MEDIA-PAD-FL-MUST-CONNECT:
 
 .. flat-table:: Media pad flags
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
-
-       ..  _MEDIA-PAD-FL-SINK:
-
-       -  ``MEDIA_PAD_FL_SINK``
-
+    *  -  ``MEDIA_PAD_FL_SINK``
        -  Input pad, relative to the entity. Input pads sink data and are
 	  targets of links.
 
-    -  .. row 2
-
-       ..  _MEDIA-PAD-FL-SOURCE:
-
-       -  ``MEDIA_PAD_FL_SOURCE``
-
+    *  -  ``MEDIA_PAD_FL_SOURCE``
        -  Output pad, relative to the entity. Output pads source data and
 	  are origins of links.
 
-    -  .. row 3
-
-       ..  _MEDIA-PAD-FL-MUST-CONNECT:
-
-       -  ``MEDIA_PAD_FL_MUST_CONNECT``
-
+    *  -  ``MEDIA_PAD_FL_MUST_CONNECT``
        -  If this flag is set and the pad is linked to any other pad, then
 	  at least one of those links must be enabled for the entity to be
 	  able to stream. There could be temporary reasons (e.g. device
@@ -606,46 +362,29 @@ must be set for every pad.
 .. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-link-flag:
+.. _MEDIA-LNK-FL-ENABLED:
+.. _MEDIA-LNK-FL-IMMUTABLE:
+.. _MEDIA-LNK-FL-DYNAMIC:
+.. _MEDIA-LNK-FL-LINK-TYPE:
 
 .. flat-table:: Media link flags
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
-
-       ..  _MEDIA-LNK-FL-ENABLED:
-
-       -  ``MEDIA_LNK_FL_ENABLED``
-
+    *  -  ``MEDIA_LNK_FL_ENABLED``
        -  The link is enabled and can be used to transfer media data. When
 	  two or more links target a sink pad, only one of them can be
 	  enabled at a time.
 
-    -  .. row 2
-
-       ..  _MEDIA-LNK-FL-IMMUTABLE:
-
-       -  ``MEDIA_LNK_FL_IMMUTABLE``
-
+    *  -  ``MEDIA_LNK_FL_IMMUTABLE``
        -  The link enabled state can't be modified at runtime. An immutable
 	  link is always enabled.
 
-    -  .. row 3
-
-       ..  _MEDIA-LNK-FL-DYNAMIC:
-
-       -  ``MEDIA_LNK_FL_DYNAMIC``
-
+    *  -  ``MEDIA_LNK_FL_DYNAMIC``
        -  The link enabled state can be modified during streaming. This flag
 	  is set by drivers and is read-only for applications.
 
-    -  .. row 4
-
-       ..  _MEDIA-LNK-FL-LINK-TYPE:
-
-       -  ``MEDIA_LNK_FL_LINK_TYPE``
-
+    *  -  ``MEDIA_LNK_FL_LINK_TYPE``
        -  This is a bitmask that defines the type of the link. Currently,
 	  two types of links are supported:
 
-- 
2.17.0
