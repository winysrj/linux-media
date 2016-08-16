Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 4/9] [media] docs-rst: better use the .. note:: tag
Date: Tue, 16 Aug 2016 13:47:32 -0300
Message-Id: <4324c535445061d813c2b6643ff90a7d20ea740b.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change multi-line note tags to be more symetric, e. g. not starting
the text together witht the tag.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst          |  4 +++-
 Documentation/media/uapi/cec/cec-func-ioctl.rst          |  4 +++-
 Documentation/media/uapi/cec/cec-func-open.rst           |  4 +++-
 Documentation/media/uapi/cec/cec-func-poll.rst           |  4 +++-
 Documentation/media/uapi/cec/cec-intro.rst               |  4 +++-
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst     |  4 +++-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst          |  4 +++-
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst          |  4 +++-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst         |  4 +++-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst          |  4 +++-
 Documentation/media/uapi/cec/cec-ioc-receive.rst         |  4 +++-
 Documentation/media/uapi/dvb/dvb-fe-read-status.rst      |  4 +++-
 Documentation/media/uapi/dvb/dvbapi.rst                  |  4 +++-
 Documentation/media/uapi/dvb/dvbproperty.rst             |  4 +++-
 Documentation/media/uapi/dvb/examples.rst                |  4 +++-
 Documentation/media/uapi/dvb/fe-get-info.rst             |  4 +++-
 Documentation/media/uapi/dvb/fe-read-status.rst          |  4 +++-
 Documentation/media/uapi/dvb/frontend.rst                |  4 +++-
 .../media/uapi/rc/lirc-set-wideband-receiver.rst         |  4 +++-
 Documentation/media/uapi/v4l/audio.rst                   |  4 +++-
 Documentation/media/uapi/v4l/buffer.rst                  | 13 ++++++++++---
 Documentation/media/uapi/v4l/crop.rst                    | 12 +++++++++---
 Documentation/media/uapi/v4l/dev-codec.rst               |  4 +++-
 Documentation/media/uapi/v4l/dev-osd.rst                 |  4 +++-
 Documentation/media/uapi/v4l/dev-overlay.rst             |  8 ++++++--
 Documentation/media/uapi/v4l/dev-rds.rst                 |  4 +++-
 Documentation/media/uapi/v4l/extended-controls.rst       |  4 +++-
 Documentation/media/uapi/v4l/func-mmap.rst               |  4 +++-
 Documentation/media/uapi/v4l/pixfmt-006.rst              |  4 +++-
 Documentation/media/uapi/v4l/pixfmt-007.rst              | 12 +++++++++---
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst          |  4 +++-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst           |  4 +++-
 Documentation/media/uapi/v4l/pixfmt-y16.rst              |  4 +++-
 Documentation/media/uapi/v4l/standard.rst                |  4 +++-
 Documentation/media/uapi/v4l/tuner.rst                   |  4 +++-
 Documentation/media/uapi/v4l/userp.rst                   |  4 +++-
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst   |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst  |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst         |  9 ++++++---
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst        |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst  |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst  |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enumaudioout.rst     |  4 +++-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst       |  4 +++-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst           |  4 +++-
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst      |  8 ++++++--
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst      |  4 +++-
 Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst |  4 +++-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst          |  8 ++++++--
 Documentation/media/uapi/v4l/vidioc-qbuf.rst             |  4 +++-
 Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst |  4 +++-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst        | 16 ++++++++++++----
 Documentation/media/uapi/v4l/vidioc-querystd.rst         |  4 +++-
 Documentation/media/uapi/v4l/vidioc-streamon.rst         |  4 +++-
 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst  |  4 +++-
 Documentation/media/v4l-drivers/bttv.rst                 |  1 +
 56 files changed, 206 insertions(+), 69 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index bb94e4358910..bdbb9e545ae4 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -32,7 +32,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 Closes the cec device. Resources associated with the file descriptor are
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index d0279e6d2734..170bdd56211e 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -38,7 +38,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 The :c:func:`ioctl()` function manipulates cec device parameters. The
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 38fd7e0cfccd..c83989acfc83 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -45,7 +45,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 To open a cec device applications call :c:func:`open()` with the
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index fcab65f6d6b8..5d1e0525056e 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -29,7 +29,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 With the :c:func:`poll()` function applications can wait for CEC
diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/media/uapi/cec/cec-intro.rst
index afa76f26fdde..4a19ea5323a9 100644
--- a/Documentation/media/uapi/cec/cec-intro.rst
+++ b/Documentation/media/uapi/cec/cec-intro.rst
@@ -3,7 +3,9 @@
 Introduction
 ============
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 HDMI connectors provide a single pin for use by the Consumer Electronics
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index eaedc63186e6..2516d4c3a4c8 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -31,7 +31,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 All cec devices must support :ref:`ioctl CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`. To query
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 04ee90099676..359f7b3aa91a 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -35,7 +35,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 To query the current CEC logical addresses, applications call
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index b955d044b334..c50aa3ee1e0d 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -34,7 +34,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 To query the current physical address applications call
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 7a6d6d00ce19..36eb4f907d30 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -32,7 +32,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 CEC devices can send asynchronous events. These can be retrieved by
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index f0084d892db6..c0e851f357d0 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -30,7 +30,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 By default any filehandle can use :ref:`CEC_TRANSMIT`, but in order to prevent
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index ae5a39ade45f..7167a90209df 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -33,7 +33,9 @@ Arguments
 Description
 ===========
 
-.. note:: This documents the proposed CEC API. This API is not yet finalized
+.. note::
+
+   This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
 To receive a CEC message the application has to fill in the
diff --git a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
index fcffaa7e1463..76c20612b274 100644
--- a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
@@ -17,7 +17,9 @@ using :ref:`FE_READ_STATUS`.
 Signal statistics are provided via
 :ref:`FE_GET_PROPERTY`.
 
-.. note:: Most statistics require the demodulator to be fully locked
+.. note::
+
+   Most statistics require the demodulator to be fully locked
    (e. g. with FE_HAS_LOCK bit set). See
    :ref:`Frontend statistics indicators <frontend-stat-properties>` for
    more details.
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 48e61aba741e..37680137e3f2 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -8,7 +8,9 @@
 Part II - Digital TV API
 ########################
 
-.. note:: This API is also known as **DVB API**, although it is generic
+.. note::
+
+   This API is also known as **DVB API**, although it is generic
    enough to support all digital TV standards.
 
 **Version 5.10**
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index cd0511b06c2c..a5a859a45381 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -20,7 +20,9 @@ Also, the union didn't have any space left to be expanded without
 breaking userspace. So, the decision was to deprecate the legacy
 union/struct based approach, in favor of a properties set approach.
 
-.. note:: On Linux DVB API version 3, setting a frontend were done via
+.. note::
+
+   On Linux DVB API version 3, setting a frontend were done via
    :ref:`struct dvb_frontend_parameters <dvb-frontend-parameters>`.
    This got replaced on version 5 (also called "S2API", as this API were
    added originally_enabled to provide support for DVB-S2), because the
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index bf0a8617de92..9a4ae4b0f3d7 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -9,7 +9,9 @@ Examples
 In this section we would like to present some examples for using the DVB
 API.
 
-..note:: This section is out of date, and the code below won't even
+..note::
+
+   This section is out of date, and the code below won't even
    compile. Please refer to the
    `libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__ for
    updated/recommended examples.
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index bb6c32e47ce8..dfc7644f9dac 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -144,7 +144,9 @@ struct dvb_frontend_info
        -  Capabilities supported by the frontend
 
 
-.. note:: The frequencies are specified in Hz for Terrestrial and Cable
+.. note::
+
+   The frequencies are specified in Hz for Terrestrial and Cable
    systems. They're specified in kHz for Satellite systems
 
 
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 624ed9d06488..defe30d036ec 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -40,7 +40,9 @@ used to check about the locking status of the frontend after being
 tuned. The ioctl takes a pointer to an integer where the status will be
 written.
 
-.. note:: The size of status is actually sizeof(enum fe_status), with
+.. note::
+
+   The size of status is actually sizeof(enum fe_status), with
    varies according with the architecture. This needs to be fixed in the
    future.
 
diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 48c5cd487ce7..e051a9012540 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -29,7 +29,9 @@ The frontend can be accessed through ``/dev/dvb/adapter?/frontend?``.
 Data types and ioctl definitions can be accessed by including
 ``linux/dvb/frontend.h`` in your application.
 
-.. note:: Transmission via the internet (DVB-IP) is not yet handled by this
+.. note::
+
+   Transmission via the internet (DVB-IP) is not yet handled by this
    API but a future extension is possible.
 
 On Satellite systems, the API support for the Satellite Equipment
diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
index cffb01fd1042..b9d582fd7df1 100644
--- a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
+++ b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
@@ -42,7 +42,9 @@ that prevents them to be used with some remotes. Wide band receiver might
 also be more precise. On the other hand its disadvantage it usually
 reduced range of reception.
 
-.. note:: Wide band receiver might be implictly enabled if you enable
+.. note::
+
+    Wide band receiver might be implictly enabled if you enable
     carrier reports. In that case it will be disabled as soon as you disable
     carrier reports. Trying to disable wide band receiver while carrier
     reports are active will do nothing.
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index 4dd11345866c..b8059fb05372 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -37,7 +37,9 @@ The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDOUT>` ioctls report the current
 audio input and output, respectively.
 
-.. note:: Note that, unlike :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+.. note::
+
+   Note that, unlike :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
    :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
    structure as :ref:`VIDIOC_ENUMAUDIO` and
    :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` do, not just an index.
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 5deb4a46f992..f75f959b960b 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -166,12 +166,15 @@ struct v4l2_buffer
 	  output device because the application did not pass new data in
 	  time.
 
-	  .. note:: This may count the frames received e.g. over USB, without
+	  .. note::
+
+	     This may count the frames received e.g. over USB, without
 	     taking into account the frames dropped by the remote hardware due
 	     to limited compression throughput or bus bandwidth. These devices
 	     identify by not enumerating any video standards, see
 	     :ref:`standard`.
 
+
     -  .. row 10
 
        -  __u32
@@ -299,7 +302,9 @@ struct v4l2_plane
 	  ``bytesused`` will be set to the size of the plane (see the
 	  ``length`` field of this struct) by the driver.
 
-	  .. note:: Note that the actual image data starts at ``data_offset``
+	  .. note::
+
+	     Note that the actual image data starts at ``data_offset``
 	     which may not be 0.
 
     -  .. row 2
@@ -371,7 +376,9 @@ struct v4l2_plane
 	  field when ``type`` refers to a capture stream, applications when
 	  it refers to an output stream.
 
-	  .. note:: That data_offset is included  in ``bytesused``. So the
+	  .. note::
+
+	     That data_offset is included  in ``bytesused``. So the
 	     size of the image in the plane is ``bytesused``-``data_offset``
 	     at offset ``data_offset`` from the start of the plane.
 
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 0913822347af..4622884b06ea 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -15,7 +15,9 @@ offset into a video signal.
 Applications can use the following API to select an area in the video
 signal, query the default area and the hardware limits.
 
-.. note:: Despite their name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
+.. note::
+
+   Despite their name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
    :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP
    <VIDIOC_G_CROP>` ioctls apply to input as well as output devices.
 
@@ -38,7 +40,9 @@ support scaling or the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls. Their size (and position
 where applicable) will be fixed in this case.
 
-.. note:: All capture and output devices must support the
+.. note::
+
+   All capture and output devices must support the
    :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications
    can determine if scaling takes place.
 
@@ -144,7 +148,9 @@ reopening a device, such that piping data into or out of a device will
 work without special preparations. More advanced applications should
 ensure the parameters are suitable before starting I/O.
 
-.. note:: On the next two examples, a video capture device is assumed;
+.. note::
+
+   On the next two examples, a video capture device is assumed;
    change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
 Example: Resetting the cropping parameters
diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
index dfb20328e34d..d9f218449ddd 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-codec.rst
@@ -21,7 +21,9 @@ for both capture and output to start the codec.
 Video compression codecs use the MPEG controls to setup their codec
 parameters
 
-.. note:: The MPEG controls actually support many more codecs than
+.. note::
+
+   The MPEG controls actually support many more codecs than
    just MPEG. See :ref:`mpeg-controls`.
 
 Memory-to-memory devices can often be used as a shared resource: you can
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index fadda131f020..4e1ee79ec334 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -16,7 +16,9 @@ this interface, which borrows structures and ioctls of the
 The OSD function is accessible through the same character special file
 as the :ref:`Video Output <capture>` function.
 
-.. note:: The default function of such a ``/dev/video`` device is video
+.. note::
+
+   The default function of such a ``/dev/video`` device is video
    capturing or output. The OSD function is only available after calling
    the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index 92b4471b0c6e..d47a6bbc2e98 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -19,7 +19,9 @@ video into a window.
 Video overlay devices are accessed through the same character special
 files as :ref:`video capture <capture>` devices.
 
-.. note:: The default function of a ``/dev/video`` device is video
+.. note::
+
+   The default function of a ``/dev/video`` device is video
    capturing. The overlay function is only available after calling
    the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
@@ -236,7 +238,9 @@ exceeded are undefined. [#f3]_
     :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`,
     :ref:`framebuffer-flags`).
 
-    .. note:: This field was added in Linux 2.6.23, extending the
+    .. note::
+
+       This field was added in Linux 2.6.23, extending the
        structure. However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
        ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
        parent structure with padding bytes at the end, are not affected.
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
index cd6ad63cb90b..fa32538d4c1f 100644
--- a/Documentation/media/uapi/v4l/dev-rds.rst
+++ b/Documentation/media/uapi/v4l/dev-rds.rst
@@ -14,7 +14,9 @@ at devices capable of receiving and/or transmitting RDS information.
 For more information see the core RDS standard :ref:`iec62106` and the
 RBDS standard :ref:`nrsc4`.
 
-.. note:: Note that the RBDS standard as is used in the USA is almost
+.. note::
+
+   Note that the RBDS standard as is used in the USA is almost
    identical to the RDS standard. Any RDS decoder/encoder can also handle
    RBDS. Only some of the fields have slightly different meanings. See the
    RBDS standard for more information.
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 71071d73747d..782f7f3c2209 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -184,7 +184,9 @@ Codec Control Reference
 Below all controls within the Codec control class are described. First
 the generic controls, then controls specific for certain hardware.
 
-.. note:: These controls are applicable to all codecs and not just MPEG. The
+.. note::
+
+   These controls are applicable to all codecs and not just MPEG. The
    defines are prefixed with V4L2_CID_MPEG/V4L2_MPEG as the controls
    were originally made for MPEG codecs and later extended to cover all
    encoding formats.
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index c156fb7b7422..639fef5b4f78 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -78,7 +78,9 @@ Arguments
     ``MAP_SHARED`` allows applications to share the mapped memory with
     other (e. g. child-) processes.
 
-    .. note:: The Linux ``videobuf`` module  which is used by some
+    .. note::
+
+       The Linux ``videobuf`` module  which is used by some
        drivers supports only ``MAP_SHARED``. ``MAP_PRIVATE`` requests
        copy-on-write semantics. V4L2 applications should not set the
        ``MAP_PRIVATE``, ``MAP_DENYWRITE``, ``MAP_EXECUTABLE`` or ``MAP_ANON``
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 987b9a8a9eb4..1c8321f9b1fb 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -19,7 +19,9 @@ colorspace field of struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 or struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>`
 needs to be filled in.
 
-.. note:: The default R'G'B' quantization is full range for all
+.. note::
+
+   The default R'G'B' quantization is full range for all
    colorspaces except for BT.2020 which uses limited range R'G'B'
    quantization.
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 8c946b0c63a0..39753f6f7b83 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -538,7 +538,9 @@ projectors that use the DCI-P3 colorspace. The default transfer function
 is ``V4L2_XFER_FUNC_DCI_P3``. The default Y'CbCr encoding is
 ``V4L2_YCBCR_ENC_709``.
 
-.. note:: Note that this colorspace does not specify a
+.. note::
+
+   Note that this colorspace does not specify a
    Y'CbCr encoding since it is not meant to be encoded to Y'CbCr. So this
    default Y'CbCr encoding was picked because it is the HDTV encoding. The
    default Y'CbCr quantization is limited range. The chromaticities of the
@@ -754,7 +756,9 @@ reference are:
        -  0.316
 
 
-.. note:: This colorspace uses Illuminant C instead of D65 as the white
+.. note::
+
+   This colorspace uses Illuminant C instead of D65 as the white
    reference. To correctly convert an image in this colorspace to another
    that uses D65 you need to apply a chromatic adaptation algorithm such as
    the Bradford method.
@@ -888,7 +892,9 @@ reference are identical to sRGB. The transfer function use is
 with full range quantization where Y' is scaled to [0…255] and Cb/Cr are
 scaled to [-128…128] and then clipped to [-128…127].
 
-.. note:: The JPEG standard does not actually store colorspace
+.. note::
+
+   The JPEG standard does not actually store colorspace
    information. So if something other than sRGB is used, then the driver
    will have to set that information explicitly. Effectively
    ``V4L2_COLORSPACE_JPEG`` can be considered to be an abbreviation for
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index 14446ed7f650..7f295b48748c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -19,7 +19,9 @@ This format is similar to
 has a depth of 16 bits. The least significant byte is stored at lower
 memory addresses (little-endian).
 
-..note:: The actual sampling precision may be lower than 16 bits,
+..note::
+
+    The actual sampling precision may be lower than 16 bits,
     for example 10 bits per pixel with values in tange 0 to 1023.
 
 **Byte Order.**
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
index 37fa099c16a6..b16874951f0f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
@@ -17,7 +17,9 @@ Description
 This is a grey-scale image with a depth of 16 bits per pixel. The most
 significant byte is stored at lower memory addresses (big-endian).
 
-.. note:: Tthe actual sampling precision may be lower than 16 bits, for
+.. note::
+
+   The actual sampling precision may be lower than 16 bits, for
    example 10 bits per pixel with values in range 0 to 1023.
 
 **Byte Order.**
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
index 4c41c042188b..10e2824da147 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16.rst
@@ -17,7 +17,9 @@ Description
 This is a grey-scale image with a depth of 16 bits per pixel. The least
 significant byte is stored at lower memory addresses (little-endian).
 
-.. note:: The actual sampling precision may be lower than 16 bits, for
+.. note::
+
+   The actual sampling precision may be lower than 16 bits, for
    example 10 bits per pixel with values in range 0 to 1023.
 
 **Byte Order.**
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index c4f678f545ec..5dd341f18839 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -41,7 +41,9 @@ output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
 *received* standard can be sensed with the
 :ref:`VIDIOC_QUERYSTD` ioctl.
 
-..note:: The parameter of all these ioctls is a pointer to a
+..note::
+
+   The parameter of all these ioctls is a pointer to a
    :ref:`v4l2_std_id <v4l2-std-id>` type (a standard set), *not* an
    index into the standard enumeration. Drivers must implement all video
    standard ioctls when the device has one or more video inputs or outputs.
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index 37eb4b9b95fb..c3df65c2e320 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -28,7 +28,9 @@ struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER <VIDIOC_G
 also contains signal status information applicable when the tuner of the
 current video or radio input is queried.
 
-.. note:: :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` does not switch the
+.. note::
+
+   :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` does not switch the
    current tuner, when there is more than one at all. The tuner is solely
    determined by the current video input. Drivers must support both ioctls
    and set the ``V4L2_CAP_TUNER`` flag in the struct :ref:`v4l2_capability
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 1d8b14bd4cdc..0371e068c50b 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -88,7 +88,9 @@ To start and stop capturing or output applications call the
 :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl.
 
-.. note:: ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
+.. note::
+
+   ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
    both queues and unlocks all buffers as a side effect. Since there is no
    notion of doing anything "now" on a multitasking system, if an
    application needs to synchronize with another event it should examine
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 6e05957013bb..c390412d5aa9 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -39,7 +39,9 @@ initialize the ``pad`` field to 0, zero the reserved array of struct
 ``VIDIOC_DV_TIMINGS_CAP`` ioctl on a video node and the driver will fill
 in the structure.
 
-.. note:: Drivers may return different values after
+.. note::
+
+   Drivers may return different values after
    switching the video input or output.
 
 When implemented by the driver DV capabilities of subdevices can be
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 3ba75d3fb93c..764d6cea601c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -49,7 +49,9 @@ error code when the index is out of bounds. To enumerate all supported
 DV timings, applications shall begin at index zero, incrementing by one
 until the driver returns ``EINVAL``.
 
-.. note:: Drivers may enumerate a different set of DV timings after
+.. note::
+
+   Drivers may enumerate a different set of DV timings after
    switching the video input or output.
 
 When implemented by the driver DV timings of subdevices can be queried
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 90996f69d6ae..4715261631ab 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -40,7 +40,9 @@ fill the rest of the structure or return an ``EINVAL`` error code. All
 formats are enumerable by beginning at index zero and incrementing by
 one until ``EINVAL`` is returned.
 
-.. note:: After switching input or output the list of enumerated image
+.. note::
+
+   After switching input or output the list of enumerated image
    formats may be different.
 
 
@@ -51,7 +53,6 @@ one until ``EINVAL`` is returned.
     :stub-columns: 0
     :widths:       1 1 2
 
-
     -  .. row 1
 
        -  __u32
@@ -113,7 +114,9 @@ one until ``EINVAL`` is returned.
 	  Several image formats are already defined by this specification in
 	  :ref:`pixfmt`.
 
-	  .. attention:: These codes are not the same as those used
+	  .. attention::
+
+	     These codes are not the same as those used
 	     in the Windows world.
 
     -  .. row 7
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index ceae6003039e..9c22a3a6938f 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -73,7 +73,9 @@ the device supports. Only for the ``V4L2_FRMIVAL_TYPE_DISCRETE`` type
 does it make sense to increase the index value to receive more frame
 intervals.
 
-.. note:: The order in which the frame intervals are returned has no
+.. note::
+
+   The order in which the frame intervals are returned has no
    special meaning. In particular does it not say anything about potential
    default frame intervals.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 8b268354d442..6e2adf6c23a3 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -72,7 +72,9 @@ the ``type`` field to determine the type of frame size enumeration the
 device supports. Only for the ``V4L2_FRMSIZE_TYPE_DISCRETE`` type does
 it make sense to increase the index value to receive more frame sizes.
 
-.. note:: The order in which the frame sizes are returned has no special
+.. note::
+
+   The order in which the frame sizes are returned has no special
    meaning. In particular does it not say anything about potential default
    format sizes.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 00ab5e19cc1d..ccf308bd9423 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -129,7 +129,9 @@ of the corresponding tuner/modulator is set.
        -  :cspan:`2` The supported modulation systems of this frequency
 	  band. See :ref:`band-modulation`.
 
-	  .. note:: Currently only one modulation system per frequency band
+	  .. note::
+
+	     Currently only one modulation system per frequency band
 	     is supported. More work will need to be done if multiple
 	     modulation systems are possible. Contact the linux-media
 	     mailing list
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index cde1db55834f..3112b43242f2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -41,7 +41,9 @@ structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio outputs applications shall begin at index
 zero, incrementing by one until the driver returns ``EINVAL``.
 
-.. note:: Connectors on a TV card to loop back the received audio signal
+.. note::
+
+    Connectors on a TV card to loop back the received audio signal
     to a sound card are not audio outputs in this sense.
 
 See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDOUT>` for a description of struct
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index b1c1bfeb251e..c9e9a550e86d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -51,7 +51,9 @@ return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
 as ``VIDIOC_G_AUDOUT`` does.
 
-.. note:: Connectors on a TV card to loop back the received audio signal
+.. note::
+
+   Connectors on a TV card to loop back the received audio signal
    to a sound card are not audio outputs in this sense.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index 1a982b68a72f..b881098b8964 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -67,7 +67,9 @@ total number of available EDID blocks and it will return 0 without
 copying any data. This is an easy way to discover how many EDID blocks
 there are.
 
-.. note:: If there are no EDID blocks available at all, then
+.. note::
+
+   If there are no EDID blocks available at all, then
    the driver will set ``blocks`` to 0 and it returns 0.
 
 To set the EDID blocks of a receiver the application has to fill in the
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 39e24ad4b825..c91039b16d49 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -127,7 +127,9 @@ still cause this situation.
 	  to a value large enough to store the payload result and ``ENOSPC`` is
 	  returned.
 
-	  .. note:: For string controls, this ``size`` field should
+	  .. note::
+
+	     For string controls, this ``size`` field should
 	     not be confused with the length of the string. This field refers
 	     to the size of the memory that contains the string. The actual
 	     *length* of the string may well be much smaller.
@@ -265,7 +267,9 @@ still cause this situation.
 	  control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
 	  value of the control.
 
-	  .. note:: You can only get the default value of the control,
+	  .. note::
+
+	     You can only get the default value of the control,
 	     you cannot set or try it.
 
 	  For backwards compatibility you can also use a control class here
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index a2e8c73f0678..fcb2e4896d4d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -130,7 +130,9 @@ To change the radio frequency the
 	  shall be modulated. It contains a set of flags as defined in
 	  :ref:`modulator-txsubchans`.
 
-	  .. note:: The tuner ``rxsubchans`` flags  are reused, but the
+	  .. note::
+
+	     The tuner ``rxsubchans`` flags  are reused, but the
 	     semantics are different. Video output devices
 	     are assumed to have an analog or PCM audio input with 1-3
 	     channels. The ``txsubchans`` flags select one or more channels
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index f1f661d0200c..f3db6f677650 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -40,7 +40,9 @@ output device, applications initialize the ``type`` field of a struct
 driver fills in the remaining fields or returns an ``EINVAL`` error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
 
-.. note:: The ``type`` field was added, and the ioctl changed from read-only
+.. note::
+
+   The ``type`` field was added, and the ioctl changed from read-only
    to write-read, in Linux 2.6.19.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 614db06b8b4b..d209736d6a53 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -391,7 +391,9 @@ To change the radio frequency the
 	  carrier for a monaural secondary language. Only
 	  ``V4L2_TUNER_ANALOG_TV`` tuners can have this capability.
 
-	  .. note:: The ``V4L2_TUNER_CAP_LANG2`` and ``V4L2_TUNER_CAP_SAP``
+	  .. note::
+
+	     The ``V4L2_TUNER_CAP_LANG2`` and ``V4L2_TUNER_CAP_SAP``
 	     flags are synonyms. ``V4L2_TUNER_CAP_SAP`` applies when the tuner
 	     supports the ``V4L2_STD_NTSC_M`` video standard.
 
@@ -502,7 +504,9 @@ To change the radio frequency the
 
        -  The tuner receives a Second Audio Program.
 
-	  .. note:: The ``V4L2_TUNER_SUB_LANG2`` and ``V4L2_TUNER_SUB_SAP``
+	  .. note::
+
+	     The ``V4L2_TUNER_SUB_LANG2`` and ``V4L2_TUNER_SUB_SAP``
 	     flags are synonyms. The ``V4L2_TUNER_SUB_SAP`` flag applies
 	     when the current video standard is ``V4L2_STD_NTSC_M``.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 3b927f36fb5b..31c360d7d1a6 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -137,7 +137,9 @@ EIO
     ``VIDIOC_DQBUF`` failed due to an internal error. Can also indicate
     temporary problems like signal loss.
 
-    .. note:: The driver might dequeue an (empty) buffer despite returning
+    .. note::
+
+       The driver might dequeue an (empty) buffer despite returning
        an error, or even stop capturing. Reusing such buffer may be unsafe
        though and its details (e.g. ``index``) may not be returned either.
        It is recommended that drivers indicate recoverable errors by setting
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 416d8d604af4..6a87f44cdf3f 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -39,7 +39,9 @@ similar to sensing the video standard. To do so, applications call
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. Once the hardware detects
 the timings, it will fill in the timings structure.
 
-.. note:: Drivers shall *not* switch timings automatically if new
+.. note::
+
+   Drivers shall *not* switch timings automatically if new
    timings are detected. Instead, drivers should send the
    ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support this) and expect
    that userspace will take action by calling :ref:`VIDIOC_QUERY_DV_TIMINGS`.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 8d6e61a7284d..937ce9e32a79 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -84,7 +84,9 @@ fills the rest of the structure or returns an ``EINVAL`` error code when the
 :ref:`v4l2_queryctrl <v4l2-queryctrl>` ``minimum`` to ``maximum``,
 inclusive.
 
-.. note:: It is possible for ``VIDIOC_QUERYMENU`` to return
+.. note::
+
+   It is possible for ``VIDIOC_QUERYMENU`` to return
    an ``EINVAL`` error code for some indices between ``minimum`` and
    ``maximum``. In that case that particular menu item is not supported by
    this driver. Also note that the ``minimum`` value is not necessarily 0.
@@ -188,7 +190,9 @@ See also the examples in :ref:`control`.
 	  ``_BITMASK``, ``_MENU`` or ``_INTEGER_MENU`` control. Not valid
 	  for other types of controls.
 
-	  .. note:: Drivers reset controls to their default value only when
+	  .. note::
+
+	     Drivers reset controls to their default value only when
 	     the driver is first loaded, never afterwards.
 
     -  .. row 8
@@ -306,7 +310,9 @@ See also the examples in :ref:`control`.
 	  ``_BOOLEAN``, ``_BITMASK``, ``_MENU``, ``_INTEGER_MENU``, ``_U8``
 	  or ``_U16`` control. Not valid for other types of controls.
 
-	  .. note:: Drivers reset controls to their default value only when
+	  .. note::
+
+	     Drivers reset controls to their default value only when
 	     the driver is first loaded, never afterwards.
 
     -  .. row 8
@@ -728,7 +734,9 @@ See also the examples in :ref:`control`.
 	  case the hardware calculates the gain value based on the lighting
 	  conditions which can change over time.
 
-	  .. note:: Setting a new value for a volatile control will have no
+	  .. note::
+
+	     Setting a new value for a volatile control will have no
 	     effect and no ``V4L2_EVENT_CTRL_CH_VALUE`` will be sent, unless
 	     the ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is
 	     also set. Otherwise the new value will just be ignored.
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index b4a4e222c7b0..cb03d249417c 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -43,7 +43,9 @@ will return V4L2_STD_UNKNOWN. When detection is not possible or fails,
 the set must contain all standards supported by the current video input
 or output.
 
-.. note:: Drivers shall *not* switch the video standard
+.. note::
+
+   Drivers shall *not* switch the video standard
    automatically if a new video standard is detected. Instead, drivers
    should send the ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support
    this) and expect that userspace will take action by calling
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index bb23745ebcaf..7fa4362f9a81 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -76,7 +76,9 @@ then 0 is returned. Nothing happens in the case of ``VIDIOC_STREAMON``,
 but ``VIDIOC_STREAMOFF`` will return queued buffers to their starting
 state as mentioned above.
 
-.. note:: Applications can be preempted for unknown periods right before
+.. note::
+
+   Applications can be preempted for unknown periods right before
    or after the ``VIDIOC_STREAMON`` or ``VIDIOC_STREAMOFF`` calls, there is
    no notion of starting or stopping "now". Buffer timestamps can be used
    to synchronize with other events.
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 3f28e8c47960..86b16faa41bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -54,7 +54,9 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
        -  Type of the event, see :ref:`event-type`.
 
-	  .. note:: ``V4L2_EVENT_ALL`` can be used with
+	  .. note::
+
+	     ``V4L2_EVENT_ALL`` can be used with
 	     :ref:`VIDIOC_UNSUBSCRIBE_EVENT <VIDIOC_SUBSCRIBE_EVENT>` for
 	     unsubscribing all events at once.
 
diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index f78c135b40e7..7abc1c9a261b 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -586,6 +586,7 @@ Cards
 -----
 
 .. note::
+
    For a more updated list, please check
    https://linuxtv.org/wiki/index.php/Hardware_Device_Information
 
-- 
2.7.4


