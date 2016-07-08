Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbcGHND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/54] doc-rst: linux_tv: dvb: put return value at the end
Date: Fri,  8 Jul 2016 10:02:56 -0300
Message-Id: <fc833980e3b07015d4fbd3a9d7d16c3d9dc5dc73.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some syscall descriptions, the tables are described after
the return value. Do that inside descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/audio-set-attributes.rst       |  2 --
 Documentation/linux_tv/media/dvb/audio-set-ext-id.rst |  2 --
 .../linux_tv/media/dvb/audio-set-karaoke.rst          |  2 --
 .../linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst | 19 ++++++++++---------
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst       | 17 +++++++----------
 Documentation/linux_tv/media/dvb/fe-get-info.rst      | 19 ++++++++++---------
 Documentation/linux_tv/media/dvb/fe-read-ber.rst      |  2 --
 Documentation/linux_tv/media/dvb/fe-read-status.rst   | 15 +++++++--------
 Documentation/linux_tv/media/dvb/fe-set-frontend.rst  |  2 --
 Documentation/linux_tv/media/dvb/fe-set-tone.rst      | 17 +++++++----------
 Documentation/linux_tv/media/dvb/video-get-event.rst  |  2 --
 11 files changed, 41 insertions(+), 58 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
index ea08cea6aa78..820c8b2e2298 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
@@ -58,8 +58,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
index 456b05267f29..38a255289e8c 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
@@ -58,8 +58,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
index 07453ceae40f..28138222582a 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
@@ -57,8 +57,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
index 60241c6e68a8..7ddbce6bcd7e 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
@@ -36,17 +36,11 @@ DESCRIPTION
 
 Receives reply from a DiSEqC 2.0 command.
 
-
-RETURN VALUE
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _dvb-diseqc-slave-reply:
 
+struct dvb_diseqc_slave_reply
+-----------------------------
+
 .. flat-table:: struct dvb_diseqc_slave_reply
     :header-rows:  0
     :stub-columns: 0
@@ -78,3 +72,10 @@ appropriately. The generic error codes are described at the
 
        -  Return from ioctl after timeout ms with errorcode when no message
 	  was received
+
+RETURN VALUE
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index dea9cdff0469..806ee5a9df68 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -40,21 +40,11 @@ read/write permissions.
 It provides support for what's specified at
 `Digital Satellite Equipment Control (DiSEqC) - Simple "ToneBurst" Detection Circuit specification. <http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf>`__
 
-
-RETURN VALUE
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _fe-sec-mini-cmd-t:
 
 enum fe_sec_mini_cmd
 ====================
 
-
 .. _fe-sec-mini-cmd:
 
 .. flat-table:: enum fe_sec_mini_cmd
@@ -83,3 +73,10 @@ enum fe_sec_mini_cmd
 	  ``SEC_MINI_B``
 
        -  Sends a mini-DiSEqC 22kHz '1' Data Burst to select satellite-B
+
+RETURN VALUE
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index d97218805851..1efb242d7f4a 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -41,17 +41,11 @@ takes a pointer to dvb_frontend_info which is filled by the driver.
 When the driver is not compatible with this specification the ioctl
 returns an error.
 
-
-RETURN VALUE
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _dvb-frontend-info:
 
+struct dvb_frontend_info
+========================
+
 .. flat-table:: struct dvb_frontend_info
     :header-rows:  0
     :stub-columns: 0
@@ -423,3 +417,10 @@ supported only on some specific frontend types.
 	  ``FE_CAN_MUTE_TS``
 
        -  The frontend can stop spurious TS data output
+
+RETURN VALUE
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/fe-read-ber.rst b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
index f0b364baba96..39cf656a4ca0 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-ber.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
@@ -20,8 +20,6 @@ SYNOPSIS
 Arguments
 ----------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index ac6f23869530..697598d30976 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -44,14 +44,6 @@ varies according with the architecture. This needs to be fixed in the
 future.
 
 
-RETURN VALUE
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _fe-status-t:
 
 int fe_status
@@ -132,3 +124,10 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  The frontend was reinitialized, application is recommended to
 	  reset DiSEqC, tone and parameters
+
+RETURN VALUE
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
index 0cce39666773..06edd97e7e53 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
@@ -66,8 +66,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index afe8b750fca6..18677f205954 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -46,21 +46,11 @@ a tone may interfere on other devices, as they may lose the capability
 of selecting the band. So, it is recommended that applications would
 change to SEC_TONE_OFF when the device is not used.
 
-
-RETURN VALUE
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _fe-sec-tone-mode-t:
 
 enum fe_sec_tone_mode
 =====================
 
-
 .. _fe-sec-tone-mode:
 
 .. flat-table:: enum fe_sec_tone_mode
@@ -90,3 +80,10 @@ enum fe_sec_tone_mode
 
        -  Don't send a 22kHz tone to the antenna (except if the
 	  FE_DISEQC_* ioctls are called)
+
+RETURN VALUE
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/linux_tv/media/dvb/video-get-event.rst
index 3240cd6da6f6..b08ca148ecdc 100644
--- a/Documentation/linux_tv/media/dvb/video-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-event.rst
@@ -69,8 +69,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4

