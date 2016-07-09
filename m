Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbcGIMuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 08:50:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/3] [media] doc-rst: add media.h header to media contrller
Date: Sat,  9 Jul 2016 09:50:04 -0300
Message-Id: <d2c6815031681fb69fa14c4b17845dccd3210ab1.1468068561.git.mchehab@s-opensource.com>
In-Reply-To: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
References: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
In-Reply-To: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
References: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding the header file is interesting for several reasons:

1) It makes MC documentation consistend with other parts;
2) The header file can be used as a quick index to all API
   elements;
3) The cross-reference check helps to identify symbols that
   aren't documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/Makefile                       |   5 +-
 Documentation/media/media.h.rst.exceptions         |  30 ++++++
 .../media/uapi/mediactl/media-controller.rst       |   2 +-
 Documentation/media/uapi/mediactl/media-header.rst |  10 ++
 .../media/uapi/mediactl/media-ioc-device-info.rst  |   2 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   4 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |   8 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |   2 +-
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |   2 +-
 Documentation/media/uapi/mediactl/media-types.rst  | 117 ++++++++++++++++++++-
 10 files changed, 170 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/media/media.h.rst.exceptions
 create mode 100644 Documentation/media/uapi/mediactl/media-header.rst

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index 0efd91e9998b..cfab8e4f36e1 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -5,7 +5,7 @@ UAPI = $(srctree)/include/uapi/linux
 SRC_DIR=$(srctree)/Documentation/media
 
 FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
-	  videodev2.h.rst
+	  videodev2.h.rst media.h.rst
 
 TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
@@ -46,5 +46,8 @@ $(BUILDDIR)/video.h.rst: ${UAPI}/dvb/video.h ${PARSER} $(SRC_DIR)/video.h.rst.ex
 $(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
 	@$($(quiet)gen_rst)
 
+$(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} $(SRC_DIR)/media.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
 cleandocs:
 	-rm ${TARGETS}
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/media/media.h.rst.exceptions
new file mode 100644
index 000000000000..83d7f7c722fb
--- /dev/null
+++ b/Documentation/media/media.h.rst.exceptions
@@ -0,0 +1,30 @@
+# Ignore header name
+ignore define __LINUX_MEDIA_H
+
+# Ignore macros
+ignore define MEDIA_API_VERSION
+ignore define MEDIA_ENT_F_BASE
+ignore define MEDIA_ENT_F_OLD_BASE
+ignore define MEDIA_ENT_F_OLD_SUBDEV_BASE
+ignore define MEDIA_INTF_T_DVB_BASE
+ignore define MEDIA_INTF_T_V4L_BASE
+ignore define MEDIA_INTF_T_ALSA_BASE
+
+#ignore legacy entity type macros
+ignore define MEDIA_ENT_TYPE_SHIFT
+ignore define MEDIA_ENT_TYPE_MASK
+ignore define MEDIA_ENT_SUBTYPE_MASK
+ignore define MEDIA_ENT_T_DEVNODE_UNKNOWN
+ignore define MEDIA_ENT_T_DEVNODE
+ignore define MEDIA_ENT_T_DEVNODE_V4L
+ignore define MEDIA_ENT_T_DEVNODE_FB
+ignore define MEDIA_ENT_T_DEVNODE_ALSA
+ignore define MEDIA_ENT_T_DEVNODE_DVB
+ignore define MEDIA_ENT_T_UNKNOWN
+ignore define MEDIA_ENT_T_V4L2_VIDEO
+ignore define MEDIA_ENT_T_V4L2_SUBDEV
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_FLASH
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_LENS
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_DECODER
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_TUNER
diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 8758308997a7..0c1296c59571 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -22,7 +22,7 @@ Media Controller
     media-controller-intro
     media-controller-model
     media-types
-
+    media-header
 
 .. _media-user-func:
 
diff --git a/Documentation/media/uapi/mediactl/media-header.rst b/Documentation/media/uapi/mediactl/media-header.rst
new file mode 100644
index 000000000000..96f7b0155e5a
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media-header.rst
@@ -0,0 +1,10 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _media_header:
+
+****************************
+Media Controller Header File
+****************************
+
+.. kernel-include:: $BUILDDIR/media.h.rst
+
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index cee8312bde7d..467d82cbb81e 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _media-ioc-device-info:
+.. _media_ioc_device_info:
 
 ***************************
 ioctl MEDIA_IOC_DEVICE_INFO
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index ae88f46b3a9e..12d4b25d5b94 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _media-ioc-enum-entities:
+.. _media_ioc_enum_entities:
 
 *****************************
 ioctl MEDIA_IOC_ENUM_ENTITIES
@@ -39,6 +39,8 @@ call the MEDIA_IOC_ENUM_ENTITIES ioctl with a pointer to this
 structure. The driver fills the rest of the structure or returns an
 EINVAL error code when the id is invalid.
 
+.. _media-ent-id-flag-next:
+
 Entities can be enumerated by or'ing the id with the
 ``MEDIA_ENT_ID_FLAG_NEXT`` flag. The driver will return information
 about the entity with the smallest id strictly larger than the requested
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index cc3cc3d2400b..87443b1ce42d 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _media-ioc-enum-links:
+.. _media_ioc_enum_links:
 
 **************************
 ioctl MEDIA_IOC_ENUM_LINKS
@@ -44,14 +44,12 @@ MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
 If the ``pads`` field is not NULL, the driver fills the ``pads`` array
 with information about the entity's pads. The array must have enough
 room to store all the entity's pads. The number of pads can be retrieved
-with the :ref:`MEDIA_IOC_ENUM_ENTITIES <media-ioc-enum-entities>`
-ioctl.
+with :ref:`MEDIA_IOC_ENUM_ENTITIES`.
 
 If the ``links`` field is not NULL, the driver fills the ``links`` array
 with information about the entity's outbound links. The array must have
 enough room to store all the entity's outbound links. The number of
-outbound links can be retrieved with the
-:ref:`MEDIA_IOC_ENUM_ENTITIES <media-ioc-enum-entities>` ioctl.
+outbound links can be retrieved with :ref:`MEDIA_IOC_ENUM_ENTITIES`.
 
 Only forward links that originate at one of the entity's source pads are
 returned during the enumeration process.
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 1f2d530aa284..2e382cc7762c 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _media-g-topology:
+.. _media_ioc_g_topology:
 
 **************************
 ioctl MEDIA_IOC_G_TOPOLOGY
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index 57ae5bcc646a..e02fe23de9de 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _media-ioc-setup-link:
+.. _media_ioc_setup_link:
 
 **************************
 ioctl MEDIA_IOC_SETUP_LINK
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index a2932bfef20f..c77717b236ce 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -15,6 +15,9 @@ Types and flags used to represent the media graph elements
 
     -  .. row 1
 
+       ..  _MEDIA-ENT-F-UNKNOWN:
+       .. _MEDIA-ENT-F-V4L2-SUBDEV-UNKNOWN:
+
        -  ``MEDIA_ENT_F_UNKNOWN`` and ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
 
        -  Unknown entity. That generally indicates that a driver didn't
@@ -22,36 +25,48 @@ Types and flags used to represent the media graph elements
 
     -  .. row 2
 
+       ..  _MEDIA-ENT-F-IO-V4L:
+
        -  ``MEDIA_ENT_F_IO_V4L``
 
        -  Data streaming input and/or output entity.
 
     -  .. row 3
 
+       ..  _MEDIA-ENT-F-IO-VBI:
+
        -  ``MEDIA_ENT_F_IO_VBI``
 
        -  V4L VBI streaming input or output entity
 
     -  .. row 4
 
+       ..  _MEDIA-ENT-F-IO-SWRADIO:
+
        -  ``MEDIA_ENT_F_IO_SWRADIO``
 
        -  V4L Software Digital Radio (SDR) streaming input or output entity
 
     -  .. row 5
 
+       ..  _MEDIA-ENT-F-IO-DTV:
+
        -  ``MEDIA_ENT_F_IO_DTV``
 
        -  DVB Digital TV streaming input or output entity
 
     -  .. row 6
 
+       ..  _MEDIA-ENT-F-DTV-DEMOD:
+
        -  ``MEDIA_ENT_F_DTV_DEMOD``
 
        -  Digital TV demodulator entity.
 
     -  .. row 7
 
+       ..  _MEDIA-ENT-F-TS-DEMUX:
+
        -  ``MEDIA_ENT_F_TS_DEMUX``
 
        -  MPEG Transport stream demux entity. Could be implemented on
@@ -59,12 +74,16 @@ Types and flags used to represent the media graph elements
 
     -  .. row 8
 
+       ..  _MEDIA-ENT-F-DTV-CA:
+
        -  ``MEDIA_ENT_F_DTV_CA``
 
        -  Digital TV Conditional Access module (CAM) entity
 
     -  .. row 9
 
+       ..  _MEDIA-ENT-F-DTV-NET-DECAP:
+
        -  ``MEDIA_ENT_F_DTV_NET_DECAP``
 
        -  Digital TV network ULE/MLE desencapsulation entity. Could be
@@ -72,42 +91,56 @@ Types and flags used to represent the media graph elements
 
     -  .. row 10
 
+       ..  _MEDIA-ENT-F-CONN-RF:
+
        -  ``MEDIA_ENT_F_CONN_RF``
 
        -  Connector for a Radio Frequency (RF) signal.
 
     -  .. row 11
 
+       ..  _MEDIA-ENT-F-CONN-SVIDEO:
+
        -  ``MEDIA_ENT_F_CONN_SVIDEO``
 
        -  Connector for a S-Video signal.
 
     -  .. row 12
 
+       ..  _MEDIA-ENT-F-CONN-COMPOSITE:
+
        -  ``MEDIA_ENT_F_CONN_COMPOSITE``
 
        -  Connector for a RGB composite signal.
 
     -  .. row 13
 
+       ..  _MEDIA-ENT-F-CAM-SENSOR:
+
        -  ``MEDIA_ENT_F_CAM_SENSOR``
 
        -  Camera video sensor entity.
 
     -  .. row 14
 
+       ..  _MEDIA-ENT-F-FLASH:
+
        -  ``MEDIA_ENT_F_FLASH``
 
        -  Flash controller entity.
 
     -  .. row 15
 
+       ..  _MEDIA-ENT-F-LENS:
+
        -  ``MEDIA_ENT_F_LENS``
 
        -  Lens controller entity.
 
     -  .. row 16
 
+       ..  _MEDIA-ENT-F-ATV-DECODER:
+
        -  ``MEDIA_ENT_F_ATV_DECODER``
 
        -  Analog video decoder, the basic function of the video decoder is
@@ -119,6 +152,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 17
 
+       ..  _MEDIA-ENT-F-TUNER:
+
        -  ``MEDIA_ENT_F_TUNER``
 
        -  Digital TV, analog TV, radio and/or software radio tuner, with
@@ -129,6 +164,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 18
 
+       ..  _MEDIA-ENT-F-IF-VID-DECODER:
+
        -  ``MEDIA_ENT_F_IF_VID_DECODER``
 
        -  IF-PLL video decoder. It receives the IF from a PLL and decodes
@@ -139,6 +176,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 19
 
+       ..  _MEDIA-ENT-F-IF-AUD-DECODER:
+
        -  ``MEDIA_ENT_F_IF_AUD_DECODER``
 
        -  IF-PLL sound decoder. It receives the IF from a PLL and decodes
@@ -150,24 +189,32 @@ Types and flags used to represent the media graph elements
 
     -  .. row 20
 
+       ..  _MEDIA-ENT-F-AUDIO-CAPTURE:
+
        -  ``MEDIA_ENT_F_AUDIO_CAPTURE``
 
        -  Audio Capture Function Entity.
 
     -  .. row 21
 
+       ..  _MEDIA-ENT-F-AUDIO-PLAYBACK:
+
        -  ``MEDIA_ENT_F_AUDIO_PLAYBACK``
 
        -  Audio Playback Function Entity.
 
     -  .. row 22
 
+       ..  _MEDIA-ENT-F-AUDIO-MIXER:
+
        -  ``MEDIA_ENT_F_AUDIO_MIXER``
 
        -  Audio Mixer Function Entity.
 
     -  .. row 23
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-COMPOSER:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_COMPOSER``
 
        -  Video composer (blender). An entity capable of video
@@ -179,6 +226,8 @@ Types and flags used to represent the media graph elements
 
     -  ..  row 24
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-PIXEL-FORMATTER:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER``
 
        -  Video pixel formatter. An entity capable of pixel formatting
@@ -191,6 +240,8 @@ Types and flags used to represent the media graph elements
 
     -  ..  row 25
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-PIXEL-ENC-CONV:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV``
 
        -  Video pixel encoding converter. An entity capable of pixel
@@ -203,6 +254,8 @@ Types and flags used to represent the media graph elements
 
     -  ..  row 26
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-LUT:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_LUT``
 
        -  Video look-up table. An entity capable of video lookup table
@@ -215,6 +268,8 @@ Types and flags used to represent the media graph elements
 
     -  ..  row 27
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-SCALER:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
 
        -  Video scaler. An entity capable of video scaling must have
@@ -228,6 +283,8 @@ Types and flags used to represent the media graph elements
 
     -  ..  row 28
 
+       ..  _MEDIA-ENT-F-PROC-VIDEO-STATISTICS:
+
        -  ``MEDIA_ENT_F_PROC_VIDEO_STATISTICS``
 
        -  Video statistics computation (histogram, 3A, ...). An entity
@@ -246,6 +303,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 1
 
+       ..  _MEDIA-ENT-FL-DEFAULT:
+
        -  ``MEDIA_ENT_FL_DEFAULT``
 
        -  Default entity for its type. Used to discover the default audio,
@@ -253,6 +312,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 2
 
+       ..  _MEDIA-ENT-FL-CONNECTOR:
+
        -  ``MEDIA_ENT_FL_CONNECTOR``
 
        -  The entity represents a data conector
@@ -268,6 +329,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 1
 
+       ..  _MEDIA-INTF-T-DVB-FE:
+
        -  ``MEDIA_INTF_T_DVB_FE``
 
        -  Device node interface for the Digital TV frontend
@@ -276,6 +339,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 2
 
+       ..  _MEDIA-INTF-T-DVB-DEMUX:
+
        -  ``MEDIA_INTF_T_DVB_DEMUX``
 
        -  Device node interface for the Digital TV demux
@@ -284,6 +349,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 3
 
+       ..  _MEDIA-INTF-T-DVB-DVR:
+
        -  ``MEDIA_INTF_T_DVB_DVR``
 
        -  Device node interface for the Digital TV DVR
@@ -292,6 +359,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 4
 
+       ..  _MEDIA-INTF-T-DVB-CA:
+
        -  ``MEDIA_INTF_T_DVB_CA``
 
        -  Device node interface for the Digital TV Conditional Access
@@ -300,7 +369,9 @@ Types and flags used to represent the media graph elements
 
     -  .. row 5
 
-       -  ``MEDIA_INTF_T_DVB_FE``
+       ..  _MEDIA-INTF-T-DVB-NET:
+
+       -  ``MEDIA_INTF_T_DVB_NET``
 
        -  Device node interface for the Digital TV network control
 
@@ -308,6 +379,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 6
 
+       ..  _MEDIA-INTF-T-V4L-VIDEO:
+
        -  ``MEDIA_INTF_T_V4L_VIDEO``
 
        -  Device node interface for video (V4L)
@@ -316,6 +389,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 7
 
+       ..  _MEDIA-INTF-T-V4L-VBI:
+
        -  ``MEDIA_INTF_T_V4L_VBI``
 
        -  Device node interface for VBI (V4L)
@@ -324,6 +399,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 8
 
+       ..  _MEDIA-INTF-T-V4L-RADIO:
+
        -  ``MEDIA_INTF_T_V4L_RADIO``
 
        -  Device node interface for radio (V4L)
@@ -332,6 +409,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 9
 
+       ..  _MEDIA-INTF-T-V4L-SUBDEV:
+
        -  ``MEDIA_INTF_T_V4L_SUBDEV``
 
        -  Device node interface for a V4L subdevice
@@ -340,6 +419,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 10
 
+       ..  _MEDIA-INTF-T-V4L-SWRADIO:
+
        -  ``MEDIA_INTF_T_V4L_SWRADIO``
 
        -  Device node interface for Software Defined Radio (V4L)
@@ -348,6 +429,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 11
 
+       ..  _MEDIA-INTF-T-ALSA-PCM-CAPTURE:
+
        -  ``MEDIA_INTF_T_ALSA_PCM_CAPTURE``
 
        -  Device node interface for ALSA PCM Capture
@@ -356,6 +439,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 12
 
+       ..  _MEDIA-INTF-T-ALSA-PCM-PLAYBACK:
+
        -  ``MEDIA_INTF_T_ALSA_PCM_PLAYBACK``
 
        -  Device node interface for ALSA PCM Playback
@@ -364,6 +449,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 13
 
+       ..  _MEDIA-INTF-T-ALSA-CONTROL:
+
        -  ``MEDIA_INTF_T_ALSA_CONTROL``
 
        -  Device node interface for ALSA Control
@@ -372,6 +459,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 14
 
+       ..  _MEDIA-INTF-T-ALSA-COMPRESS:
+
        -  ``MEDIA_INTF_T_ALSA_COMPRESS``
 
        -  Device node interface for ALSA Compress
@@ -380,6 +469,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 15
 
+       ..  _MEDIA-INTF-T-ALSA-RAWMIDI:
+
        -  ``MEDIA_INTF_T_ALSA_RAWMIDI``
 
        -  Device node interface for ALSA Raw MIDI
@@ -388,6 +479,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 16
 
+       ..  _MEDIA-INTF-T-ALSA-HWDEP:
+
        -  ``MEDIA_INTF_T_ALSA_HWDEP``
 
        -  Device node interface for ALSA Hardware Dependent
@@ -396,6 +489,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 17
 
+       ..  _MEDIA-INTF-T-ALSA-SEQUENCER:
+
        -  ``MEDIA_INTF_T_ALSA_SEQUENCER``
 
        -  Device node interface for ALSA Sequencer
@@ -404,6 +499,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 18
 
+       ..  _MEDIA-INTF-T-ALSA-TIMER:
+
        -  ``MEDIA_INTF_T_ALSA_TIMER``
 
        -  Device node interface for ALSA Timer
@@ -421,6 +518,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 1
 
+       ..  _MEDIA-PAD-FL-SINK:
+
        -  ``MEDIA_PAD_FL_SINK``
 
        -  Input pad, relative to the entity. Input pads sink data and are
@@ -428,6 +527,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 2
 
+       ..  _MEDIA-PAD-FL-SOURCE:
+
        -  ``MEDIA_PAD_FL_SOURCE``
 
        -  Output pad, relative to the entity. Output pads source data and
@@ -435,6 +536,8 @@ Types and flags used to represent the media graph elements
 
     -  .. row 3
 
+       ..  _MEDIA-PAD-FL-MUST-CONNECT:
+
        -  ``MEDIA_PAD_FL_MUST_CONNECT``
 
        -  If this flag is set and the pad is linked to any other pad, then
@@ -458,6 +561,8 @@ must be set for every pad.
 
     -  .. row 1
 
+       ..  _MEDIA-LNK-FL-ENABLED:
+
        -  ``MEDIA_LNK_FL_ENABLED``
 
        -  The link is enabled and can be used to transfer media data. When
@@ -466,6 +571,8 @@ must be set for every pad.
 
     -  .. row 2
 
+       ..  _MEDIA-LNK-FL-IMMUTABLE:
+
        -  ``MEDIA_LNK_FL_IMMUTABLE``
 
        -  The link enabled state can't be modified at runtime. An immutable
@@ -473,6 +580,8 @@ must be set for every pad.
 
     -  .. row 3
 
+       ..  _MEDIA-LNK-FL-DYNAMIC:
+
        -  ``MEDIA_LNK_FL_DYNAMIC``
 
        -  The link enabled state can be modified during streaming. This flag
@@ -480,12 +589,18 @@ must be set for every pad.
 
     -  .. row 4
 
+       ..  _MEDIA-LNK-FL-LINK-TYPE:
+
        -  ``MEDIA_LNK_FL_LINK_TYPE``
 
        -  This is a bitmask that defines the type of the link. Currently,
 	  two types of links are supported:
 
+	  .. _MEDIA-LNK-FL-DATA-LINK:
+
 	  ``MEDIA_LNK_FL_DATA_LINK`` if the link is between two pads
 
+	  .. _MEDIA-LNK-FL-INTERFACE-LINK:
+
 	  ``MEDIA_LNK_FL_INTERFACE_LINK`` if the link is between an
 	  interface and an entity
-- 
2.7.4

