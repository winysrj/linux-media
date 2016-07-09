Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:41558 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbcGIPGv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jul 2016 11:06:51 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH RFC] doc-rst: media: reordered top sectioning
Date: Sat,  9 Jul 2016 17:06:26 +0200
Message-Id: <1468076786-8594-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Within the old section hierarchy, all doc parts has been placed under
the introduction, e.g:

* Linux Media Infrastructure API
    + Introduction
        - Video for Linux API
        - Digital TV API
        - ...

With separating the introduction sibling to the other parts
we get a more common section hierarchy:

* Linux Media Infrastructure API
    + Introduction
    + Video for Linux API
    + Digital TV API
    + ...

BTW: compacting the intro text.

This patch is on top of media_tree/docs-next

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/intro.rst      | 46 +++++++++++++++++++++++++++++++++
 Documentation/media/media_uapi.rst | 53 +-------------------------------------
 2 files changed, 47 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/media/intro.rst

diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
new file mode 100644
index 0000000..be90bda
--- /dev/null
+++ b/Documentation/media/intro.rst
@@ -0,0 +1,46 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+============
+Introduction
+============
+
+This document covers the Linux Kernel to Userspace API's used by video
+and radio streaming devices, including video cameras, analog and digital
+TV receiver cards, AM/FM receiver cards, Software Defined Radio (SDR),
+streaming capture and output devices, codec devices and remote controllers.
+
+A typical media device hardware is shown at :ref:`typical_media_device`.
+
+.. _typical_media_device:
+
+.. figure::  media_api_files/typical_media_device.*
+    :alt:    typical_media_device.svg
+    :align:  center
+
+    Typical Media Device
+
+The media infrastructure API was designed to control such devices. It is
+divided into five parts.
+
+1. The :ref:`first part <v4l2spec>` covers radio, video capture and output,
+   cameras, analog TV devices and codecs.
+
+2. The :ref:`second part <dvbapi>` covers the API used for digital TV and
+   Internet reception via one of the several digital tv standards. While it is
+   called as DVB API, in fact it covers several different video standards
+   including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S, DTMB, etc. The
+   complete list of supported standards can be found at
+   :ref:`fe-delivery-system-t`.
+
+3. The :ref:`third part <remote_controllers>` covers the Remote Controller API.
+
+4. The :ref:`fourth part <media_controller>` covers the Media Controller API.
+
+5. The :ref:`fifth part <cec>` covers the CEC (Consumer Electronics Control) API.
+
+It should also be noted that a media device may also have audio components, like
+mixers, PCM capture, PCM playback, etc, which are controlled via ALSA API.  For
+additional information and for the latest development code, see:
+`https://linuxtv.org <https://linuxtv.org>`__.  For discussing improvements,
+reporting troubles, sending new drivers, etc, please mail to: `Linux Media
+Mailing List (LMML) <http://vger.kernel.org/vger-lists.html#linux-media>`__.
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 49f5cb5..527c6de 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -15,61 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
 License".
 
 
-============
-Introduction
-============
-
-This document covers the Linux Kernel to Userspace API's used by video
-and radio streaming devices, including video cameras, analog and digital
-TV receiver cards, AM/FM receiver cards, Software Defined Radio (SDR),
-streaming capture and output devices, codec devices and remote controllers.
-
-A typical media device hardware is shown at
-:ref:`typical_media_device`.
-
-
-.. _typical_media_device:
-
-.. figure::  media_api_files/typical_media_device.*
-    :alt:    typical_media_device.svg
-    :align:  center
-
-    Typical Media Device
-
-The media infrastructure API was designed to control such devices. It is
-divided into five parts.
-
-The :ref:`first part <v4l2spec>` covers radio, video capture and output,
-cameras, analog TV devices and codecs.
-
-The :ref:`second part <dvbapi>` covers the API used for digital TV and
-Internet reception via one of the several digital tv standards. While it
-is called as DVB API, in fact it covers several different video
-standards including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S,
-DTMB, etc. The complete list of supported standards can be found at
-:ref:`fe-delivery-system-t`.
-
-The :ref:`third part <remote_controllers>` covers the Remote Controller API.
-
-The :ref:`fourth part <media_controller>` covers the Media Controller API.
-
-The :ref:`fifth part <cec>` covers the CEC (Consumer Electronics Control) API.
-
-It should also be noted that a media device may also have audio
-components, like mixers, PCM capture, PCM playback, etc, which are
-controlled via ALSA API.
-
-For additional information and for the latest development code, see:
-`https://linuxtv.org <https://linuxtv.org>`__.
-
-For discussing improvements, reporting troubles, sending new drivers,
-etc, please mail to:
-`Linux Media Mailing List (LMML). <http://vger.kernel.org/vger-lists.html#linux-media>`__.
-
-
 .. toctree::
     :maxdepth: 1
 
+    intro
     uapi/v4l/v4l2
     uapi/dvb/dvbapi
     uapi/rc/remote_controllers
-- 
2.7.4

