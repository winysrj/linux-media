Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/41] Documentation: audio_function_calls: improve man-like format
Date: Mon,  4 Jul 2016 22:30:41 -0300
Message-Id: <341fc7296a5844fcd1a116145054c78820187302.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing this file were causing lots of warnings with sphinx,
due to the c function prototypes.

Fix that by prepending them with .. cpp:function::

While here, use the same way we document man-like pages,
at the V4L side of the book and add escapes to asterisks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/audio_function_calls.rst    | 356 +++++++++++++--------
 1 file changed, 220 insertions(+), 136 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index b3408b7c4e91..118444e05a21 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -9,10 +9,11 @@ Audio Function Calls
 
 .. _audio_fopen:
 
-open()
-======
+DVB audio open()
+================
 
-DESCRIPTION
+Description
+-----------
 
 This system call opens a named audio device (e.g.
 /dev/dvb/adapter0/audio0) for subsequent use. When an open() call has
@@ -28,11 +29,13 @@ fail, and an error code will be returned. If the Audio Device is opened
 in O_RDONLY mode, the only ioctl call that can be used is
 AUDIO_GET_STATUS. All other call will return with an error code.
 
-SYNOPSIS
+Synopsis
+--------
 
-int open(const char *deviceName, int flags);
+.. c:function:: int  open(const char *deviceName, int flags)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -43,7 +46,7 @@ PARAMETERS
 
     -  .. row 1
 
-       -  const char *deviceName
+       -  const char \*deviceName
 
        -  Name of specific audio device.
 
@@ -74,7 +77,8 @@ PARAMETERS
        -  (blocking mode is the default)
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -105,18 +109,21 @@ RETURN VALUE
 
 .. _audio_fclose:
 
-close()
-=======
+DVB audio close()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call closes a previously opened audio device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int close(int fd);
+.. c:function:: int  close(int fd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -132,7 +139,8 @@ PARAMETERS
        -  File descriptor returned by a previous call to open().
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -151,10 +159,11 @@ RETURN VALUE
 
 .. _audio_fwrite:
 
-write()
-=======
+DVB audio write()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call can only be used if AUDIO_SOURCE_MEMORY is selected
 in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in
@@ -162,11 +171,13 @@ PES format. If O_NONBLOCK is not specified the function will block
 until buffer space is available. The amount of data to be transferred is
 implied by count.
 
-SYNOPSIS
+Synopsis
+--------
 
-size_t write(int fd, const void *buf, size_t count);
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -183,7 +194,7 @@ PARAMETERS
 
     -  .. row 2
 
-       -  void *buf
+       -  void \*buf
 
        -  Pointer to the buffer containing the PES data.
 
@@ -194,7 +205,8 @@ PARAMETERS
        -  Size of buf.
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -228,16 +240,19 @@ RETURN VALUE
 AUDIO_STOP
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to stop playing the current
 stream.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_STOP);
+.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -259,7 +274,8 @@ PARAMETERS
        -  Equals AUDIO_STOP for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -271,16 +287,19 @@ appropriately. The generic error codes are described at the
 AUDIO_PLAY
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to start playing an audio stream
 from the selected source.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_PLAY);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -302,7 +321,8 @@ PARAMETERS
        -  Equals AUDIO_PLAY for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -314,17 +334,20 @@ appropriately. The generic error codes are described at the
 AUDIO_PAUSE
 ===========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call suspends the audio stream being played. Decoding and
 playing are paused. It is then possible to restart again decoding and
 playing process of the audio stream using AUDIO_CONTINUE command.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_PAUSE);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -346,7 +369,8 @@ PARAMETERS
        -  Equals AUDIO_PAUSE for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -358,16 +382,19 @@ appropriately. The generic error codes are described at the
 AUDIO_CONTINUE
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl restarts the decoding and playing process previously paused
 with AUDIO_PAUSE command.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_CONTINUE);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -389,7 +416,8 @@ PARAMETERS
        -  Equals AUDIO_CONTINUE for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -401,19 +429,21 @@ appropriately. The generic error codes are described at the
 AUDIO_SELECT_SOURCE
 ===================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call informs the audio device which source shall be used for
 the input data. The possible sources are demux or memory. If
 AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
 through the write command.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SELECT_SOURCE,
-audio_stream_source_t source);
+.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -441,7 +471,8 @@ PARAMETERS
        -  Indicates the source that shall be used for the Audio stream.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -453,7 +484,8 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_MUTE
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` with the
@@ -462,11 +494,13 @@ V4L2 :ref:`VIDIOC_DECODER_CMD` with the
 This ioctl call asks the audio device to mute the stream that is
 currently being played.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -504,7 +538,8 @@ PARAMETERS
        -  FALSE Audio Un-mute
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -516,16 +551,19 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_AV_SYNC
 =================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to turn ON or OFF A/V
 synchronization.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -563,7 +601,8 @@ PARAMETERS
        -  FALSE AV-sync OFF
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -575,7 +614,8 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_BYPASS_MODE
 =====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to bypass the Audio decoder and
 forward the stream without decoding. This mode shall be used if streams
@@ -583,11 +623,13 @@ that can’t be handled by the DVB system shall be decoded. Dolby
 DigitalTM streams are automatically forwarded by the DVB subsystem if
 the hardware can handle it.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode);
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -626,7 +668,8 @@ PARAMETERS
        -  FALSE Bypass is enabled
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -638,7 +681,8 @@ appropriately. The generic error codes are described at the
 AUDIO_CHANNEL_SELECT
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
@@ -646,12 +690,13 @@ V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
 This ioctl call asks the Audio Device to select the requested channel if
 possible.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT,
-audio_channel_select_t);
+.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -679,7 +724,8 @@ PARAMETERS
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -691,7 +737,8 @@ appropriately. The generic error codes are described at the
 AUDIO_BILINGUAL_CHANNEL_SELECT
 ==============================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. It has been replaced
 by the V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK`` control
@@ -700,12 +747,13 @@ for MPEG decoders controlled through V4L2.
 This ioctl call asks the Audio Device to select the requested channel
 for bilingual streams if possible.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT,
-audio_channel_select_t);
+.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -733,7 +781,8 @@ PARAMETERS
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -745,7 +794,8 @@ appropriately. The generic error codes are described at the
 AUDIO_GET_PTS
 =============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. If you need this
 functionality, then please contact the linux-media mailing list
@@ -754,11 +804,13 @@ functionality, then please contact the linux-media mailing list
 This ioctl call asks the Audio Device to return the current PTS
 timestamp.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts);
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -781,7 +833,7 @@ PARAMETERS
 
     -  .. row 3
 
-       -  __u64 *pts
+       -  __u64 \*pts
 
        -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
           ISO/IEC 13818-1.
@@ -791,7 +843,8 @@ PARAMETERS
           decoded frame or the last PTS extracted by the PES parser.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -803,17 +856,19 @@ appropriately. The generic error codes are described at the
 AUDIO_GET_STATUS
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to return the current state of the
 Audio Device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status
-*status);
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -836,12 +891,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct audio_status *status
+       -  struct audio_status \*status
 
        -  Returns the current state of Audio Device.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -853,17 +909,19 @@ appropriately. The generic error codes are described at the
 AUDIO_GET_CAPABILITIES
 ======================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to tell us about the decoding
 capabilities of the audio hardware.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int
-*cap);
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -886,12 +944,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  unsigned int *cap
+       -  unsigned int \*cap
 
        -  Returns a bit array of supported sound formats.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -903,16 +962,19 @@ appropriately. The generic error codes are described at the
 AUDIO_CLEAR_BUFFER
 ==================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Audio Device to clear all software and hardware
 buffers of the audio decoder device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_CLEAR_BUFFER);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -934,7 +996,8 @@ PARAMETERS
        -  Equals AUDIO_CLEAR_BUFFER for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -946,7 +1009,8 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_ID
 ============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl selects which sub-stream is to be decoded if a program or
 system stream is sent to the video device. If no audio stream type is
@@ -956,11 +1020,13 @@ other stream types. If the stream type is set the id just specifies the
 substream id of the audio stream and only the first 5 bits are
 recognized.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SET_ID, int id);
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -988,7 +1054,8 @@ PARAMETERS
        -  audio sub-stream id
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1000,16 +1067,18 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_MIXER
 ===============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl lets you adjust the mixer settings of the audio decoder.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t
-*mix);
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1032,12 +1101,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  audio_mixer_t *mix
+       -  audio_mixer_t \*mix
 
        -  mixer settings.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1049,17 +1119,20 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_STREAMTYPE
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl tells the driver which kind of audio stream to expect. This
 is useful if the stream offers several audio sub-streams like LPCM and
 AC3.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type);
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1087,7 +1160,8 @@ PARAMETERS
        -  stream type
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1113,16 +1187,19 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_EXT_ID
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl can be used to set the extension id for MPEG streams in DVD
 playback. Only the first 3 bits are recognized.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = AUDIO_SET_EXT_ID, int id);
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1150,7 +1227,8 @@ PARAMETERS
        -  audio sub_stream_id
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1176,17 +1254,19 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_ATTRIBUTES
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is intended for DVD playback and allows you to set certain
 information about the audio stream.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t
-attr );
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1214,7 +1294,8 @@ PARAMETERS
        -  audio attributes according to section ??
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1240,16 +1321,18 @@ appropriately. The generic error codes are described at the
 AUDIO_SET_KARAOKE
 =================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl allows one to set the mixer settings for a karaoke DVD.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t
-*karaoke);
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1272,12 +1355,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  audio_karaoke_t *karaoke
+       -  audio_karaoke_t \*karaoke
 
        -  karaoke settings according to section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

