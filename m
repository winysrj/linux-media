Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48375
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752416AbdIATiB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 06/14] media: dvb uAPI docs: Prefer use "Digital TV instead of "DVB"
Date: Fri,  1 Sep 2017 16:37:42 -0300
Message-Id: <6ea7f8ba3dcd52ad8c83adae4c32ccb21a070031.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of the term "DVB" at the dvb API docs is confusing,
as, right now, it can refer to either the European digital TV
standard or to the subsystem.

So, prefer calling it as "Digital TV" on most places, to avoid
ambiguity.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/dvb/audio-channel-select.rst        |  2 +-
 Documentation/media/uapi/dvb/audio-fclose.rst      |  8 +++----
 Documentation/media/uapi/dvb/audio-fopen.rst       |  8 +++----
 Documentation/media/uapi/dvb/audio-fwrite.rst      |  8 +++----
 Documentation/media/uapi/dvb/audio-set-av-sync.rst |  2 +-
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |  6 +++---
 Documentation/media/uapi/dvb/audio-set-mute.rst    |  2 +-
 Documentation/media/uapi/dvb/audio.rst             | 13 +++++------
 Documentation/media/uapi/dvb/ca-fclose.rst         |  8 +++----
 Documentation/media/uapi/dvb/ca-fopen.rst          | 10 ++++-----
 Documentation/media/uapi/dvb/ca.rst                | 11 +++++-----
 Documentation/media/uapi/dvb/demux.rst             | 13 +++++++----
 Documentation/media/uapi/dvb/dmx-fclose.rst        |  8 +++----
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 10 ++++-----
 Documentation/media/uapi/dvb/dmx-fread.rst         |  8 +++----
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |  8 +++----
 Documentation/media/uapi/dvb/dvbapi.rst            | 25 ++++++++++++++++------
 Documentation/media/uapi/dvb/dvbproperty.rst       |  4 ++--
 Documentation/media/uapi/dvb/examples.rst          |  4 ++--
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |  2 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  5 +++--
 Documentation/media/uapi/dvb/fe-get-property.rst   |  2 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |  2 +-
 .../media/uapi/dvb/fe_property_parameters.rst      |  4 ++--
 .../dvb/frontend-property-terrestrial-systems.rst  |  2 +-
 Documentation/media/uapi/dvb/frontend.rst          | 10 ++++-----
 Documentation/media/uapi/dvb/frontend_f_close.rst  |  6 +++---
 Documentation/media/uapi/dvb/frontend_f_open.rst   |  6 +++---
 .../media/uapi/dvb/frontend_legacy_dvbv3_api.rst   |  6 +++---
 Documentation/media/uapi/dvb/intro.rst             | 18 ++++++++--------
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst   |  6 +++---
 Documentation/media/uapi/dvb/net-add-if.rst        |  2 +-
 Documentation/media/uapi/dvb/net.rst               | 13 +++++------
 .../media/uapi/dvb/query-dvb-frontend-info.rst     |  4 ++--
 Documentation/media/uapi/dvb/video-continue.rst    |  2 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |  4 ++--
 Documentation/media/uapi/dvb/video-get-event.rst   |  2 +-
 Documentation/media/uapi/dvb/video-play.rst        |  2 +-
 .../media/uapi/dvb/video-select-source.rst         |  2 +-
 Documentation/media/uapi/dvb/video-stop.rst        |  2 +-
 Documentation/media/uapi/dvb/video.rst             | 15 +++++++------
 41 files changed, 149 insertions(+), 126 deletions(-)

diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
index 2ceb4efebdf0..8cab3d7abff5 100644
--- a/Documentation/media/uapi/dvb/audio-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-channel-select.rst
@@ -44,7 +44,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
 
 This ioctl call asks the Audio Device to select the requested channel if
diff --git a/Documentation/media/uapi/dvb/audio-fclose.rst b/Documentation/media/uapi/dvb/audio-fclose.rst
index 4df24c8d74ed..58d351a3af4b 100644
--- a/Documentation/media/uapi/dvb/audio-fclose.rst
+++ b/Documentation/media/uapi/dvb/audio-fclose.rst
@@ -2,14 +2,14 @@
 
 .. _audio_fclose:
 
-=================
-DVB audio close()
-=================
+========================
+Digital TV audio close()
+========================
 
 Name
 ----
 
-DVB audio close()
+Digital TV audio close()
 
 .. attention:: This ioctl is deprecated
 
diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
index a802c2e0dc6a..4a174640bf11 100644
--- a/Documentation/media/uapi/dvb/audio-fopen.rst
+++ b/Documentation/media/uapi/dvb/audio-fopen.rst
@@ -2,14 +2,14 @@
 
 .. _audio_fopen:
 
-================
-DVB audio open()
-================
+=======================
+Digital TV audio open()
+=======================
 
 Name
 ----
 
-DVB audio open()
+Digital TV audio open()
 
 .. attention:: This ioctl is deprecated
 
diff --git a/Documentation/media/uapi/dvb/audio-fwrite.rst b/Documentation/media/uapi/dvb/audio-fwrite.rst
index 8882cad7d165..4980ae7953ef 100644
--- a/Documentation/media/uapi/dvb/audio-fwrite.rst
+++ b/Documentation/media/uapi/dvb/audio-fwrite.rst
@@ -2,14 +2,14 @@
 
 .. _audio_fwrite:
 
-=================
-DVB audio write()
-=================
+=========================
+Digital TV audio write()
+=========================
 
 Name
 ----
 
-DVB audio write()
+Digital TV audio write()
 
 .. attention:: This ioctl is deprecated
 
diff --git a/Documentation/media/uapi/dvb/audio-set-av-sync.rst b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
index 0cef4917d2cf..cf621f3a3037 100644
--- a/Documentation/media/uapi/dvb/audio-set-av-sync.rst
+++ b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
@@ -38,7 +38,7 @@ Arguments
 
        -  boolean state
 
-       -  Tells the DVB subsystem if A/V synchronization shall be ON or OFF.
+       -  Tells the Digital TV subsystem if A/V synchronization shall be ON or OFF.
 
           TRUE: AV-sync ON
 
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
index b063c496c2eb..f0db1fbdb066 100644
--- a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
@@ -38,7 +38,7 @@ Arguments
        -  boolean mode
 
        -  Enables or disables the decoding of the current Audio stream in
-	  the DVB subsystem.
+	  the Digital TV subsystem.
 
           TRUE: Bypass is disabled
 
@@ -50,8 +50,8 @@ Description
 
 This ioctl call asks the Audio Device to bypass the Audio decoder and
 forward the stream without decoding. This mode shall be used if streams
-that can’t be handled by the DVB system shall be decoded. Dolby
-DigitalTM streams are automatically forwarded by the DVB subsystem if
+that can’t be handled by the Digial TV system shall be decoded. Dolby
+DigitalTM streams are automatically forwarded by the Digital TV subsystem if
 the hardware can handle it.
 
 
diff --git a/Documentation/media/uapi/dvb/audio-set-mute.rst b/Documentation/media/uapi/dvb/audio-set-mute.rst
index 897e7228f4d8..0af105a8ddcc 100644
--- a/Documentation/media/uapi/dvb/audio-set-mute.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mute.rst
@@ -48,7 +48,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` with the
 ``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
 
diff --git a/Documentation/media/uapi/dvb/audio.rst b/Documentation/media/uapi/dvb/audio.rst
index 155622185ea4..e9f9e589c486 100644
--- a/Documentation/media/uapi/dvb/audio.rst
+++ b/Documentation/media/uapi/dvb/audio.rst
@@ -2,15 +2,16 @@
 
 .. _dvb_audio:
 
-################
-DVB Audio Device
-################
-The DVB audio device controls the MPEG2 audio decoder of the DVB
-hardware. It can be accessed through ``/dev/dvb/adapter?/audio?``. Data
+#######################
+Digital TV Audio Device
+#######################
+
+The Digital TV audio device controls the MPEG2 audio decoder of the Digital
+TV hardware. It can be accessed through ``/dev/dvb/adapter?/audio?``. Data
 types and and ioctl definitions can be accessed by including
 ``linux/dvb/audio.h`` in your application.
 
-Please note that some DVB cards don’t have their own MPEG decoder, which
+Please note that some Digital TV cards don’t have their own MPEG decoder, which
 results in the omission of the audio and video device.
 
 These ioctls were also used by V4L2 to control MPEG decoders implemented
diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
index d97c1957aad5..e84bbfcfa184 100644
--- a/Documentation/media/uapi/dvb/ca-fclose.rst
+++ b/Documentation/media/uapi/dvb/ca-fclose.rst
@@ -2,14 +2,14 @@
 
 .. _ca_fclose:
 
-==============
-DVB CA close()
-==============
+=====================
+Digital TV CA close()
+=====================
 
 Name
 ----
 
-DVB CA close()
+Digital TV CA close()
 
 
 Synopsis
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index 51ac27dfec75..a03a01abf3da 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -2,14 +2,14 @@
 
 .. _ca_fopen:
 
-=============
-DVB CA open()
-=============
+====================
+Digital TV CA open()
+====================
 
 Name
 ----
 
-DVB CA open()
+Digital TV CA open()
 
 
 Synopsis
@@ -23,7 +23,7 @@ Arguments
 ---------
 
 ``name``
-  Name of specific DVB CA device.
+  Name of specific Digital TV CA device.
 
 ``flags``
   A bit-wise OR of the following flags:
diff --git a/Documentation/media/uapi/dvb/ca.rst b/Documentation/media/uapi/dvb/ca.rst
index e3de778a5678..deac72d89e93 100644
--- a/Documentation/media/uapi/dvb/ca.rst
+++ b/Documentation/media/uapi/dvb/ca.rst
@@ -2,11 +2,12 @@
 
 .. _dvb_ca:
 
-#############
-DVB CA Device
-#############
-The DVB CA device controls the conditional access hardware. It can be
-accessed through ``/dev/dvb/adapter?/ca?``. Data types and and ioctl
+####################
+Digital TV CA Device
+####################
+
+The Digital TV CA device controls the conditional access hardware. It
+can be accessed through ``/dev/dvb/adapter?/ca?``. Data types and and ioctl
 definitions can be accessed by including ``linux/dvb/ca.h`` in your
 application.
 
diff --git a/Documentation/media/uapi/dvb/demux.rst b/Documentation/media/uapi/dvb/demux.rst
index b12b5a2dac94..45c3d6405c46 100644
--- a/Documentation/media/uapi/dvb/demux.rst
+++ b/Documentation/media/uapi/dvb/demux.rst
@@ -2,10 +2,15 @@
 
 .. _dvb_demux:
 
-################
-DVB Demux Device
-################
-The DVB demux device controls the filters of the DVB hardware/software.
+#######################
+Digital TV Demux Device
+#######################
+
+The Digital TV demux device controls the MPEG-TS filters for the
+digital TV. If the driver and hardware supports, those filters are
+implemented at the hardware. Otherwise, the Kernel provides a software
+emulation.
+
 It can be accessed through ``/dev/adapter?/demux?``. Data types and and
 ioctl definitions can be accessed by including ``linux/dvb/dmx.h`` in
 your application.
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index b4401379e294..8693501dbd4d 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -2,14 +2,14 @@
 
 .. _dmx_fclose:
 
-=================
-DVB demux close()
-=================
+========================
+Digital TV demux close()
+========================
 
 Name
 ----
 
-DVB demux close()
+Digital TV demux close()
 
 
 Synopsis
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index 7ed2fda9a7c7..3dee019522db 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -2,14 +2,14 @@
 
 .. _dmx_fopen:
 
-================
-DVB demux open()
-================
+=======================
+Digital TV demux open()
+=======================
 
 Name
 ----
 
-DVB demux open()
+Digital TV demux open()
 
 
 Synopsis
@@ -22,7 +22,7 @@ Arguments
 ---------
 
 ``name``
-  Name of specific DVB demux device.
+  Name of specific Digital TV demux device.
 
 ``flags``
   A bit-wise OR of the following flags:
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index 8d2fe9839dd3..cb6cedbb47f6 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -2,14 +2,14 @@
 
 .. _dmx_fread:
 
-================
-DVB demux read()
-================
+=======================
+Digital TV demux read()
+=======================
 
 Name
 ----
 
-DVB demux read()
+Digital TV demux read()
 
 
 Synopsis
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 5e82a9ee418f..77f138f6234f 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -2,14 +2,14 @@
 
 .. _dmx_fwrite:
 
-=================
-DVB demux write()
-=================
+========================
+Digital TV demux write()
+========================
 
 Name
 ----
 
-DVB demux write()
+Digital TV demux write()
 
 
 Synopsis
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 9ca3dd24bd7d..268bf69db281 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -10,8 +10,21 @@ Part II - Digital TV API
 
 .. note::
 
-   This API is also known as **DVB API**, although it is generic
-   enough to support all digital TV standards.
+   This API is also known as Linux **DVB API**.
+
+   It it was originally written to support the European digital TV
+   standard (DVB), and later extended to support all digital TV standards.
+
+   In order to avoid confusion, within this document, it was opted to refer to
+   it, and to associated hardware as **Digital TV**.
+
+   The word **DVB** is reserved to be used for:
+
+     - the Digital TV API version
+       (e. g. DVB API version 3 or DVB API version 5);
+     - digital TV data types (enums, structs, defines, etc);
+     - digital TV device nodes (``/dev/dvb/...``);
+     - the European DVB standard.
 
 **Version 5.10**
 
@@ -41,11 +54,11 @@ Authors:
 
 - J. K. Metzler, Ralph <rjkm@metzlerbros.de>
 
- - Original author of the DVB API documentation.
+ - Original author of the Digital TV API documentation.
 
 - O. C. Metzler, Marcus <rjkm@metzlerbros.de>
 
- - Original author of the DVB API documentation.
+ - Original author of the Digital TV API documentation.
 
 - Carvalho Chehab, Mauro <m.chehab@kernel.org>
 
@@ -63,11 +76,11 @@ Revision History
 
 DocBook improvements and cleanups, in order to document the system calls
 on a more standard way and provide more description about the current
-DVB API.
+Digital TV API.
 
 :revision: 2.0.4 / 2011-05-06 (*mcc*)
 
-Add more information about DVB APIv5, better describing the frontend
+Add more information about DVBv5 API, better describing the frontend
 GET/SET props ioctl's.
 
 
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index c40943be5925..1a56c1724e59 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -13,7 +13,7 @@ antenna subsystem via Satellite Equipment Control - SEC (on satellite
 systems). The actual parameters are specific to each particular digital
 TV standards, and may change as the digital TV specs evolves.
 
-In the past (up to DVB API version 3), the strategy used was to have a
+In the past (up to DVB API version 3 - DVBv3), the strategy used was to have a
 union with the parameters needed to tune for DVB-S, DVB-C, DVB-T and
 ATSC delivery systems grouped there. The problem is that, as the second
 generation standards appeared, the size of such union was not big
@@ -41,7 +41,7 @@ with supports all digital TV delivery systems.
       support to new standards and/or new hardware.
 
    3. Nowadays, most frontends support multiple delivery systems.
-      Only with DVB v5 calls it is possible to switch between
+      Only with DVB API version 5 calls it is possible to switch between
       the multiple delivery systems supported by a frontend.
 
    4. DVB API version 5 is also called *S2API*, as the first
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index 1a94966312c0..e0f627ca2e4d 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -6,8 +6,8 @@
 Examples
 ********
 
-In this section we would like to present some examples for using the DVB
-API.
+In this section we would like to present some examples for using the Digital
+TV API.
 
 .. note::
 
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
index e1243097c09e..78476c1c7bf5 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
@@ -31,7 +31,7 @@ Description
 If the bus has been automatically powered off due to power overload,
 this ioctl call restores the power to the bus. The call requires
 read/write access to the device. This call has no effect if the device
-is manually powered off. Not all DVB adapters support this ioctl.
+is manually powered off. Not all Digital TV adapters support this ioctl.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 17e9d9aa5b22..9e5a7a27e158 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -9,7 +9,8 @@ ioctl FE_GET_INFO
 Name
 ====
 
-FE_GET_INFO - Query DVB frontend capabilities and returns information about the - front-end. This call only requires read-only access to the device
+FE_GET_INFO - Query Digital TV frontend capabilities and returns information
+about the - front-end. This call only requires read-only access to the device.
 
 
 Synopsis
@@ -33,7 +34,7 @@ Arguments
 Description
 ===========
 
-All DVB frontend devices support the ``FE_GET_INFO`` ioctl. It is used
+All Digital TV frontend devices support the ``FE_GET_INFO`` ioctl. It is used
 to identify kernel devices compatible with this specification and to
 obtain information about driver and hardware capabilities. The ioctl
 takes a pointer to dvb_frontend_info which is filled by the driver.
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index fffa78d17f61..948d2ba84f2c 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -35,7 +35,7 @@ Arguments
 Description
 ===========
 
-All DVB frontend devices support the ``FE_SET_PROPERTY`` and
+All Digital TV frontend devices support the ``FE_SET_PROPERTY`` and
 ``FE_GET_PROPERTY`` ioctls. The supported properties and statistics
 depends on the delivery system and on the device:
 
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index a84b045e8148..4adb52f084ff 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -33,7 +33,7 @@ Arguments
 Description
 ===========
 
-All DVB frontend devices support the ``FE_READ_STATUS`` ioctl. It is
+All Digital TV frontend devices support the ``FE_READ_STATUS`` ioctl. It is
 used to check about the locking status of the frontend after being
 tuned. The ioctl takes a pointer to an integer where the status will be
 written.
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 49470f7dda02..6eef507fea50 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -819,7 +819,7 @@ Possible values are the same as documented on enum
 DTV_API_VERSION
 ===============
 
-Returns the major/minor version of the DVB API
+Returns the major/minor version of the Digital TV API
 
 
 .. _DTV-CODE-RATE-HP:
@@ -919,7 +919,7 @@ DTV_STREAM_ID
 Used on DVB-S2, DVB-T2 and ISDB-S.
 
 DVB-S2, DVB-T2 and ISDB-S support the transmission of several streams on
-a single transport stream. This property enables the DVB driver to
+a single transport stream. This property enables the digital TV driver to
 handle substream filtering, when supported by the hardware. By default,
 substream filtering is disabled.
 
diff --git a/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst b/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
index dbc717cad9ee..0beb5cb3d729 100644
--- a/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
@@ -100,7 +100,7 @@ to tune any ISDB-T/ISDB-Tsb hardware. Of course it is possible that some
 very sophisticated devices won't need certain parameters to tune.
 
 The information given here should help application writers to know how
-to handle ISDB-T and ISDB-Tsb hardware using the Linux DVB-API.
+to handle ISDB-T and ISDB-Tsb hardware using the Linux Digital TV API.
 
 The details given here about ISDB-T and ISDB-Tsb are just enough to
 basically show the dependencies between the needed parameter values, but
diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 40adcd0da2dc..b9cfcad39823 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -2,11 +2,11 @@
 
 .. _dvb_frontend:
 
-################
-DVB Frontend API
-################
+#######################
+Digital TV Frontend API
+#######################
 
-The DVB frontend API was designed to support three groups of delivery
+The Digital TV frontend API was designed to support three groups of delivery
 systems: Terrestrial, cable and Satellite. Currently, the following
 delivery systems are supported:
 
@@ -17,7 +17,7 @@ delivery systems are supported:
 
 -  Satellite systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS
 
-The DVB frontend controls several sub-devices including:
+The Digital TV frontend controls several sub-devices including:
 
 -  Tuner
 
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
index 791434bd9548..67958d73cf34 100644
--- a/Documentation/media/uapi/dvb/frontend_f_close.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_close.rst
@@ -2,9 +2,9 @@
 
 .. _frontend_f_close:
 
-********************
-DVB frontend close()
-********************
+***************************
+Digital TV frontend close()
+***************************
 
 Name
 ====
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
index 4c25ece73da1..8e8cb466c24b 100644
--- a/Documentation/media/uapi/dvb/frontend_f_open.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_open.rst
@@ -2,9 +2,9 @@
 
 .. _frontend_f_open:
 
-*******************
-DVB frontend open()
-*******************
+***************************
+Digital TV frontend open()
+***************************
 
 Name
 ====
diff --git a/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst b/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
index 7d4a091b7d7f..a4d5319cb76b 100644
--- a/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
+++ b/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
@@ -2,9 +2,9 @@
 
 .. _frontend_legacy_dvbv3_api:
 
-****************************************
-DVB Frontend legacy API (a. k. a. DVBv3)
-****************************************
+***********************************************
+Digital TV Frontend legacy API (a. k. a. DVBv3)
+***********************************************
 
 The usage of this API is deprecated, as it doesn't support all digital
 TV standards, doesn't provide good statistics measurements and provides
diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
index aeafc9ab96c1..fbae687414ce 100644
--- a/Documentation/media/uapi/dvb/intro.rst
+++ b/Documentation/media/uapi/dvb/intro.rst
@@ -33,19 +33,19 @@ use ioctl calls. This also includes the knowledge of C or C++.
 History
 =======
 
-The first API for DVB cards we used at Convergence in late 1999 was an
+The first API for Digital TV cards we used at Convergence in late 1999 was an
 extension of the Video4Linux API which was primarily developed for frame
-grabber cards. As such it was not really well suited to be used for DVB
-cards and their new features like recording MPEG streams and filtering
+grabber cards. As such it was not really well suited to be used for Digital
+TV cards and their new features like recording MPEG streams and filtering
 several section and PES data streams at the same time.
 
 In early 2000, Convergence was approached by Nokia with a proposal for a new
-standard Linux DVB API. As a commitment to the development of terminals
+standard Linux Digital TV API. As a commitment to the development of terminals
 based on open standards, Nokia and Convergence made it available to all
 Linux developers and published it on https://linuxtv.org in September
 2000. With the Linux driver for the Siemens/Hauppauge DVB PCI card,
-Convergence provided a first implementation of the Linux DVB API.
-Convergence was the maintainer of the Linux DVB API in the early
+Convergence provided a first implementation of the Linux Digital TV API.
+Convergence was the maintainer of the Linux Digital TV API in the early
 days.
 
 Now, the API is maintained by the LinuxTV community (i.e. you, the reader
@@ -88,7 +88,7 @@ Conditional Access (CA) hardware like CI adapters and smartcard slots
 
       Not every digital TV hardware provides conditional access hardware.
 
-Demultiplexer which filters the incoming DVB stream
+Demultiplexer which filters the incoming Digital TV MPEG-TS stream
    The demultiplexer splits the TS into its components like audio and
    video streams. Besides usually several of such audio and video
    streams it also contains data streams with information about the
@@ -124,8 +124,8 @@ The Linux Digital TV API lets you control these hardware components through
 currently six Unix-style character devices for video, audio, frontend,
 demux, CA and IP-over-DVB networking. The video and audio devices
 control the MPEG2 decoder hardware, the frontend device the tuner and
-the DVB demodulator. The demux device gives you control over the PES and
-section filters of the hardware. If the hardware does not support
+the Digital TV demodulator. The demux device gives you control over the PES
+and section filters of the hardware. If the hardware does not support
 filtering these filters can be implemented in software. Finally, the CA
 device controls all the conditional access capabilities of the hardware.
 It can depend on the individual security requirements of the platform,
diff --git a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
index dac349a1bb27..7eb14d6f729f 100644
--- a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
+++ b/Documentation/media/uapi/dvb/legacy_dvb_apis.rst
@@ -2,9 +2,9 @@
 
 .. _legacy_dvb_apis:
 
-*******************
-DVB Deprecated APIs
-*******************
+***************************
+Digital TV Deprecated APIs
+***************************
 
 The APIs described here are kept only for historical reasons. There's
 just one driver for a very legacy hardware that uses this API. No modern
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index 5896bf1b339b..1087efb9baa0 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -64,7 +64,7 @@ filled with the number of the created interface.
 
        -  ifnum
 
-       -  number of the DVB interface.
+       -  number of the Digital TV interface.
 
     -  .. row 4
 
diff --git a/Documentation/media/uapi/dvb/net.rst b/Documentation/media/uapi/dvb/net.rst
index 00ae5df0c321..fdb5301a4b1f 100644
--- a/Documentation/media/uapi/dvb/net.rst
+++ b/Documentation/media/uapi/dvb/net.rst
@@ -2,10 +2,11 @@
 
 .. _net:
 
-###############
-DVB Network API
-###############
-The DVB net device controls the mapping of data packages that are part
+######################
+Digital TV Network API
+######################
+
+The Digital TV net device controls the mapping of data packages that are part
 of a transport stream to be mapped into a virtual network interface,
 visible through the standard Linux network protocol stack.
 
@@ -28,8 +29,8 @@ header.
 
 .. _net_fcalls:
 
-DVB net Function Calls
-######################
+Digital TV net Function Calls
+#############################
 
 .. toctree::
     :maxdepth: 1
diff --git a/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst b/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
index 81cd9b92a36c..51ec0b04b496 100644
--- a/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
+++ b/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
@@ -9,5 +9,5 @@ Querying frontend information
 Usually, the first thing to do when the frontend is opened is to check
 the frontend capabilities. This is done using
 :ref:`FE_GET_INFO`. This ioctl will enumerate the
-DVB API version and other characteristics about the frontend, and can be
-opened either in read only or read/write mode.
+Digital TV API version and other characteristics about the frontend, and can
+be opened either in read only or read/write mode.
diff --git a/Documentation/media/uapi/dvb/video-continue.rst b/Documentation/media/uapi/dvb/video-continue.rst
index 030c2ec98869..e65e600be632 100644
--- a/Documentation/media/uapi/dvb/video-continue.rst
+++ b/Documentation/media/uapi/dvb/video-continue.rst
@@ -44,7 +44,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call restarts decoding and playing processes of the video
diff --git a/Documentation/media/uapi/dvb/video-freeze.rst b/Documentation/media/uapi/dvb/video-freeze.rst
index 9cef65a02e8d..5a28bdc8badd 100644
--- a/Documentation/media/uapi/dvb/video-freeze.rst
+++ b/Documentation/media/uapi/dvb/video-freeze.rst
@@ -44,14 +44,14 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call suspends the live video stream being played. Decoding
 and playing are frozen. It is then possible to restart the decoding and
 playing process of the video stream using the VIDEO_CONTINUE command.
 If VIDEO_SOURCE_MEMORY is selected in the ioctl call
-VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
+VIDEO_SELECT_SOURCE, the Digital TV subsystem will not decode any more data
 until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
 
 
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
index 6ad14cdb894a..b4f53616db9a 100644
--- a/Documentation/media/uapi/dvb/video-get-event.rst
+++ b/Documentation/media/uapi/dvb/video-get-event.rst
@@ -50,7 +50,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To get events from a V4L2 decoder
+This ioctl is for Digital TV devices only. To get events from a V4L2 decoder
 use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
 
 This ioctl call returns an event of type video_event if available. If
diff --git a/Documentation/media/uapi/dvb/video-play.rst b/Documentation/media/uapi/dvb/video-play.rst
index 3f66ae3b7e35..2124120aec22 100644
--- a/Documentation/media/uapi/dvb/video-play.rst
+++ b/Documentation/media/uapi/dvb/video-play.rst
@@ -44,7 +44,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call asks the Video Device to start playing a video stream
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
index 2f4fbf4b490c..cde6542723ca 100644
--- a/Documentation/media/uapi/dvb/video-select-source.rst
+++ b/Documentation/media/uapi/dvb/video-select-source.rst
@@ -50,7 +50,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. This ioctl was also supported by the
+This ioctl is for Digital TV devices only. This ioctl was also supported by the
 V4L2 ivtv driver, but that has been replaced by the ivtv-specific
 ``IVTV_IOC_PASSTHROUGH_MODE`` ioctl.
 
diff --git a/Documentation/media/uapi/dvb/video-stop.rst b/Documentation/media/uapi/dvb/video-stop.rst
index fb827effb276..474309ad31c2 100644
--- a/Documentation/media/uapi/dvb/video-stop.rst
+++ b/Documentation/media/uapi/dvb/video-stop.rst
@@ -60,7 +60,7 @@ Arguments
 Description
 -----------
 
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
+This ioctl is for Digital TV devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call asks the Video Device to stop playing the current
diff --git a/Documentation/media/uapi/dvb/video.rst b/Documentation/media/uapi/dvb/video.rst
index 60d43fb7ce22..e7d68cd0cf23 100644
--- a/Documentation/media/uapi/dvb/video.rst
+++ b/Documentation/media/uapi/dvb/video.rst
@@ -2,20 +2,21 @@
 
 .. _dvb_video:
 
-################
-DVB Video Device
-################
-The DVB video device controls the MPEG2 video decoder of the DVB
-hardware. It can be accessed through **/dev/dvb/adapter0/video0**. Data
+#######################
+Digital TV Video Device
+#######################
+
+The Digital TV video device controls the MPEG2 video decoder of the Digital
+TV hardware. It can be accessed through **/dev/dvb/adapter0/video0**. Data
 types and and ioctl definitions can be accessed by including
 **linux/dvb/video.h** in your application.
 
-Note that the DVB video device only controls decoding of the MPEG video
+Note that the Digital TV video device only controls decoding of the MPEG video
 stream, not its presentation on the TV or computer screen. On PCs this
 is typically handled by an associated video4linux device, e.g.
 **/dev/video**, which allows scaling and defining output windows.
 
-Some DVB cards don’t have their own MPEG decoder, which results in the
+Some Digital TV cards don’t have their own MPEG decoder, which results in the
 omission of the audio and video device as well as the video4linux
 device.
 
-- 
2.13.5
