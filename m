Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33532 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753022AbeE3PHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 11:07:10 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] media: dvb/audio.h: get rid of unused APIs
Date: Wed, 30 May 2018 12:07:04 -0300
Message-Id: <36bfa7287943679617d141bd50431bdde9a2c37d.1527692791.git.mchehab+samsung@kernel.org>
In-Reply-To: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
References: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
In-Reply-To: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
References: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of other ioctls that aren't used anywhere
inside the Kernel tree.

Get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../media/uapi/dvb/audio-get-pts.rst          | 65 ------------------
 .../media/uapi/dvb/audio-set-attributes.rst   | 67 -------------------
 .../media/uapi/dvb/audio-set-ext-id.rst       | 66 ------------------
 .../media/uapi/dvb/audio-set-karaoke.rst      | 66 ------------------
 .../media/uapi/dvb/audio_data_types.rst       | 20 ------
 .../media/uapi/dvb/audio_function_calls.rst   |  4 --
 fs/compat_ioctl.c                             |  3 -
 include/uapi/linux/dvb/audio.h                | 37 ----------
 8 files changed, 328 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/audio-get-pts.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-attributes.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-ext-id.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-karaoke.rst

diff --git a/Documentation/media/uapi/dvb/audio-get-pts.rst b/Documentation/media/uapi/dvb/audio-get-pts.rst
deleted file mode 100644
index 2d1396b003de..000000000000
--- a/Documentation/media/uapi/dvb/audio-get-pts.rst
+++ /dev/null
@@ -1,65 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _AUDIO_GET_PTS:
-
-=============
-AUDIO_GET_PTS
-=============
-
-Name
-----
-
-AUDIO_GET_PTS
-
-.. attention:: This ioctl is deprecated
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, AUDIO_GET_PTS, __u64 *pts)
-    :name: AUDIO_GET_PTS
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -
-
-       -  __u64 \*pts
-
-       -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
-	  ISO/IEC 13818-1.
-
-	  The PTS should belong to the currently played frame if possible,
-	  but may also be a value close to it like the PTS of the last
-	  decoded frame or the last PTS extracted by the PES parser.
-
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. If you need this
-functionality, then please contact the linux-media mailing list
-(`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__).
-
-This ioctl call asks the Audio Device to return the current PTS
-timestamp.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/audio-set-attributes.rst b/Documentation/media/uapi/dvb/audio-set-attributes.rst
deleted file mode 100644
index f0c6153ca80f..000000000000
--- a/Documentation/media/uapi/dvb/audio-set-attributes.rst
+++ /dev/null
@@ -1,67 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _AUDIO_SET_ATTRIBUTES:
-
-====================
-AUDIO_SET_ATTRIBUTES
-====================
-
-Name
-----
-
-AUDIO_SET_ATTRIBUTES
-
-.. attention:: This ioctl is deprecated
-
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, AUDIO_SET_ATTRIBUTES, struct audio_attributes *attr )
-    :name: AUDIO_SET_ATTRIBUTES
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -
-
-       -  audio_attributes_t attr
-
-       -  audio attributes according to section ??
-
-
-Description
------------
-
-This ioctl is intended for DVD playback and allows you to set certain
-information about the audio stream.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  attr is not a valid or supported attribute setting.
diff --git a/Documentation/media/uapi/dvb/audio-set-ext-id.rst b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
deleted file mode 100644
index 8503c47f26bd..000000000000
--- a/Documentation/media/uapi/dvb/audio-set-ext-id.rst
+++ /dev/null
@@ -1,66 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _AUDIO_SET_EXT_ID:
-
-================
-AUDIO_SET_EXT_ID
-================
-
-Name
-----
-
-AUDIO_SET_EXT_ID
-
-.. attention:: This ioctl is deprecated
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(fd, AUDIO_SET_EXT_ID, int id)
-    :name: AUDIO_SET_EXT_ID
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -
-
-       -  int id
-
-       -  audio sub_stream_id
-
-
-Description
------------
-
-This ioctl can be used to set the extension id for MPEG streams in DVD
-playback. Only the first 3 bits are recognized.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  id is not a valid id.
diff --git a/Documentation/media/uapi/dvb/audio-set-karaoke.rst b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
deleted file mode 100644
index c759952d88aa..000000000000
--- a/Documentation/media/uapi/dvb/audio-set-karaoke.rst
+++ /dev/null
@@ -1,66 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _AUDIO_SET_KARAOKE:
-
-=================
-AUDIO_SET_KARAOKE
-=================
-
-Name
-----
-
-AUDIO_SET_KARAOKE
-
-.. attention:: This ioctl is deprecated
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, AUDIO_SET_KARAOKE, struct audio_karaoke *karaoke)
-    :name: AUDIO_SET_KARAOKE
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -
-
-       -  audio_karaoke_t \*karaoke
-
-       -  karaoke settings according to section ??.
-
-
-Description
------------
-
-This ioctl allows one to set the mixer settings for a karaoke DVD.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  karaoke is not a valid or supported karaoke setting.
diff --git a/Documentation/media/uapi/dvb/audio_data_types.rst b/Documentation/media/uapi/dvb/audio_data_types.rst
index 6b93359d64f7..0f7e6a652d92 100644
--- a/Documentation/media/uapi/dvb/audio_data_types.rst
+++ b/Documentation/media/uapi/dvb/audio_data_types.rst
@@ -115,26 +115,6 @@ following bits set according to the hardwares capabilities.
      #define AUDIO_CAP_SDDS 128
      #define AUDIO_CAP_AC3  256
 
-.. c:type:: audio_karaoke
-
-The ioctl AUDIO_SET_KARAOKE uses the following format:
-
-
-.. code-block:: c
-
-    typedef
-    struct audio_karaoke {
-	int vocal1;
-	int vocal2;
-	int melody;
-    } audio_karaoke_t;
-
-If Vocal1 or Vocal2 are non-zero, they get mixed into left and right t
-at 70% each. If both, Vocal1 and Vocal2 are non-zero, Vocal1 gets mixed
-into the left channel and Vocal2 into the right channel at 100% each. Ff
-Melody is non-zero, the melody channel gets mixed into left and right.
-
-
 .. c:type:: audio_attributes
 
 The following attributes can be set by a call to AUDIO_SET_ATTRIBUTES:
diff --git a/Documentation/media/uapi/dvb/audio_function_calls.rst b/Documentation/media/uapi/dvb/audio_function_calls.rst
index 0bb56f0cfed4..7dba16285dab 100644
--- a/Documentation/media/uapi/dvb/audio_function_calls.rst
+++ b/Documentation/media/uapi/dvb/audio_function_calls.rst
@@ -22,13 +22,9 @@ Audio Function Calls
     audio-set-bypass-mode
     audio-channel-select
     audio-bilingual-channel-select
-    audio-get-pts
     audio-get-status
     audio-get-capabilities
     audio-clear-buffer
     audio-set-id
     audio-set-mixer
     audio-set-streamtype
-    audio-set-ext-id
-    audio-set-attributes
-    audio-set-karaoke
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 1aae4551f59f..bc0cdc7f2d6b 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1180,9 +1180,6 @@ COMPATIBLE_IOCTL(AUDIO_CLEAR_BUFFER)
 COMPATIBLE_IOCTL(AUDIO_SET_ID)
 COMPATIBLE_IOCTL(AUDIO_SET_MIXER)
 COMPATIBLE_IOCTL(AUDIO_SET_STREAMTYPE)
-COMPATIBLE_IOCTL(AUDIO_SET_EXT_ID)
-COMPATIBLE_IOCTL(AUDIO_SET_ATTRIBUTES)
-COMPATIBLE_IOCTL(AUDIO_SET_KARAOKE)
 COMPATIBLE_IOCTL(DMX_START)
 COMPATIBLE_IOCTL(DMX_STOP)
 COMPATIBLE_IOCTL(DMX_SET_FILTER)
diff --git a/include/uapi/linux/dvb/audio.h b/include/uapi/linux/dvb/audio.h
index 69f7a85d81b1..afeae063e640 100644
--- a/include/uapi/linux/dvb/audio.h
+++ b/include/uapi/linux/dvb/audio.h
@@ -67,27 +67,6 @@ typedef struct audio_status {
 } audio_status_t;                              /* separate decoder hardware */
 
 
-typedef
-struct audio_karaoke {  /* if Vocal1 or Vocal2 are non-zero, they get mixed  */
-	int vocal1;    /* into left and right t at 70% each */
-	int vocal2;    /* if both, Vocal1 and Vocal2 are non-zero, Vocal1 gets*/
-	int melody;    /* mixed into the left channel and */
-		       /* Vocal2 into the right channel at 100% each. */
-		       /* if Melody is non-zero, the melody channel gets mixed*/
-} audio_karaoke_t;     /* into left and right  */
-
-
-typedef __u16 audio_attributes_t;
-/*   bits: descr. */
-/*   15-13 audio coding mode (0=ac3, 2=mpeg1, 3=mpeg2ext, 4=LPCM, 6=DTS, */
-/*   12    multichannel extension */
-/*   11-10 audio type (0=not spec, 1=language included) */
-/*    9- 8 audio application mode (0=not spec, 1=karaoke, 2=surround) */
-/*    7- 6 Quantization / DRC (mpeg audio: 1=DRC exists)(lpcm: 0=16bit,  */
-/*    5- 4 Sample frequency fs (0=48kHz, 1=96kHz) */
-/*    2- 0 number of audio channels (n+1 channels) */
-
-
 /* for GET_CAPABILITIES and SET_FORMAT, the latter should only set one bit */
 #define AUDIO_CAP_DTS    1
 #define AUDIO_CAP_LPCM   2
@@ -115,22 +94,6 @@ typedef __u16 audio_attributes_t;
 #define AUDIO_SET_ID               _IO('o', 13)
 #define AUDIO_SET_MIXER            _IOW('o', 14, audio_mixer_t)
 #define AUDIO_SET_STREAMTYPE       _IO('o', 15)
-#define AUDIO_SET_EXT_ID           _IO('o', 16)
-#define AUDIO_SET_ATTRIBUTES       _IOW('o', 17, audio_attributes_t)
-#define AUDIO_SET_KARAOKE          _IOW('o', 18, audio_karaoke_t)
-
-/**
- * AUDIO_GET_PTS
- *
- * Read the 33 bit presentation time stamp as defined
- * in ITU T-REC-H.222.0 / ISO/IEC 13818-1.
- *
- * The PTS should belong to the currently played
- * frame if possible, but may also be a value close to it
- * like the PTS of the last decoded frame or the last PTS
- * extracted by the PES parser.
- */
-#define AUDIO_GET_PTS              _IOR('o', 19, __u64)
 #define AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
 
 #endif /* _DVBAUDIO_H_ */
-- 
2.17.0
