Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3537 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab1KXNjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: =?UTF-8?q?=5BRFCv2=20PATCH=2010/12=5D=20av7110=3A=20replace=20audio=2Eh=2C=20video=2Eh=20and=20osd=2Eh=20by=20av7110=2Eh=2E?=
Date: Thu, 24 Nov 2011 14:39:07 +0100
Message-Id: <5276295e57ca56ed2a27148d918b63b00dd05b34.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
References: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Create a new public header, av7110.h, that contains all the av7110
specific audio, video and osd APIs that used to be defined in dvb/audio.h,
dvb/video.h and dvb/osd.h. These APIs are no longer part of DVBv5 but are
now av7110-specific.

This decision was taken during the 2011 Prague V4L-DVB workshop.

Ideally av7110 would be converted to use the replacement V4L2 MPEG
decoder API, but that's a huge job for such an old driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/ttpci/av7110.h |    4 +-
 include/linux/Kbuild             |    1 +
 include/linux/av7110.h           |  609 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 611 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/av7110.h

diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/dvb/ttpci/av7110.h
index d85b851..e36d6bd 100644
--- a/drivers/media/dvb/ttpci/av7110.h
+++ b/drivers/media/dvb/ttpci/av7110.h
@@ -7,11 +7,9 @@
 #include <linux/i2c.h>
 #include <linux/input.h>
 
-#include <linux/dvb/video.h>
-#include <linux/dvb/audio.h>
+#include <linux/av7110.h>
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/ca.h>
-#include <linux/dvb/osd.h>
 #include <linux/dvb/net.h>
 #include <linux/mutex.h>
 
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 619b565..51bd25f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -68,6 +68,7 @@ header-y += audit.h
 header-y += auto_fs.h
 header-y += auto_fs4.h
 header-y += auxvec.h
+header-y += av7110.h
 header-y += ax25.h
 header-y += b1lli.h
 header-y += baycom.h
diff --git a/include/linux/av7110.h b/include/linux/av7110.h
new file mode 100644
index 0000000..a192480
--- /dev/null
+++ b/include/linux/av7110.h
@@ -0,0 +1,609 @@
+/*
+ * av7110.h
+ *
+ * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
+ *                  & Ralph  Metzler <ralph@convergence.de>
+ *                    for convergence integrated media GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ */
+
+#ifndef _AV7110_API_H_
+#define _AV7110_API_H_
+
+#include <linux/types.h>
+#ifdef __KERNEL__
+#include <linux/compiler.h>
+#else
+#include <stdint.h>
+#include <time.h>
+#endif
+
+
+/* av7110 video ioctls
+ *
+ * The DVB video device controls the MPEG2 video decoder of the av7110 DVB
+ * hardware. It can be accessed through /dev/dvb/adapter0/video0.
+ *
+ * Note that the DVB video device only controls decoding of the MPEG video
+ * stream, not its presentation on the TV or computer screen. On PCs this
+ * is typically handled by an associated video4linux device, e.g. /dev/video,
+ * which allows scaling and defining output windows.
+ *
+ * Only one user can open the Video Device in O_RDWR mode. All other attempts
+ * to open the device in this mode will fail and an error code will be returned.
+ * If the Video Device is opened in O_RDONLY mode, the only ioctl call that can
+ * be used is VIDEO_GET_STATUS. All other calls will return with an error code.
+ *
+ * The write() system call can only be used if VIDEO_SOURCE_MEMORY is selected
+ * in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in PES
+ * format. If O_NONBLOCK is not specified the function will block until buffer
+ * space is available. The amount of data to be transferred is implied by count.
+ */
+
+/** video_format_t
+ * Used in the VIDEO_SET_FORMAT ioctl to tell the driver which aspect ratio
+ * the output hardware (e.g. TV) has. It is also used in the data structures
+ * video_status returned by VIDEO_GET_STATUS and video_event returned by
+ * VIDEO_GET_EVENT which report about the display format of the current video
+ * stream.
+ */
+typedef enum {
+	VIDEO_FORMAT_4_3,     /* Select 4:3 format */
+	VIDEO_FORMAT_16_9,    /* Select 16:9 format. */
+	VIDEO_FORMAT_221_1    /* 2.21:1 */
+} video_format_t;
+
+
+/** video_displayformat_t
+ * In case the display format of the video stream and of the display hardware
+ * differ the application has to specify how to handle the cropping of the
+ * picture. This can be done using the VIDEO_SET_DISPLAY_FORMAT call.
+ */
+typedef enum {
+	VIDEO_PAN_SCAN,       /* use pan and scan format */
+	VIDEO_LETTER_BOX,     /* use letterbox format */
+	VIDEO_CENTER_CUT_OUT  /* use center cut out format */
+} video_displayformat_t;
+
+typedef struct {
+	int w;
+	int h;
+	video_format_t aspect_ratio;
+} video_size_t;
+
+/** video_stream_source_t
+ * The video stream source is set through the VIDEO_SELECT_SOURCE call and
+ * can take the following values, depending on whether we are replaying from
+ * an internal (demuxer) or external (user write) source.
+ *
+ * VIDEO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend
+ * or the DVR device) as the source of the video stream. If VIDEO_SOURCE_MEMORY
+ * is selected the stream comes from the application through the write() system call.
+ */
+typedef enum {
+	VIDEO_SOURCE_DEMUX, /* Select the demux as the main source */
+	VIDEO_SOURCE_MEMORY /* If this source is selected, the stream
+			       comes from the user through the write
+			       system call */
+} video_stream_source_t;
+
+
+/** video_play_state_t
+ * The following values can be returned by the VIDEO_GET_STATUS call
+ * representing the state of video playback.
+ */
+typedef enum {
+	VIDEO_STOPPED, /* Video is stopped */
+	VIDEO_PLAYING, /* Video is currently playing */
+	VIDEO_FREEZED  /* Video is freezed */
+} video_play_state_t;
+
+
+/* Decoder commands */
+#define VIDEO_CMD_PLAY        (0)
+#define VIDEO_CMD_STOP        (1)
+#define VIDEO_CMD_FREEZE      (2)
+#define VIDEO_CMD_CONTINUE    (3)
+
+struct video_event {
+	__s32 type;
+#define VIDEO_EVENT_SIZE_CHANGED	1
+	__kernel_time_t timestamp;
+	union {
+		video_size_t size;
+	} u;
+};
+
+
+/** struct video_status
+ * The VIDEO_GET_STATUS call returns this structure informing about various
+ * states of the playback operation.
+ *
+ * @video_blank: if set video will be blanked out if the channel is changed
+ * or if playback is stopped. Otherwise, the last picture will be displayed.
+ * @play_state: indicates if the video is currently frozen, stopped, or being
+ * played back.
+ * @stream_source: corresponds to the selected source for the
+ * video stream. It can come either from the demultiplexer or from memory.
+ * @video_format: indicates the aspect ratio (one of 4:3 or 16:9) of the
+ * currently played video stream.
+ * @display_format: corresponds to the selected cropping mode in case the
+ * source video format is not the same as the format of the output device.
+ */
+struct video_status {
+	int                   video_blank;   /* blank video on freeze? */
+	video_play_state_t    play_state;    /* current state of playback */
+	video_stream_source_t stream_source; /* current source (demux/memory) */
+	video_format_t        video_format;  /* current aspect ratio of stream*/
+	video_displayformat_t display_format;/* selected cropping mode */
+};
+
+
+/** struct video_still_picture
+ * An I-frame displayed via the VIDEO_STILLPICTURE call is passed on within the
+ * following structure.
+ */
+struct video_still_picture {
+	char __user *iFrame;        /* pointer to a single iframe in memory */
+	__s32 size;
+};
+
+typedef __u16 video_attributes_t;
+/*   bits: descr. */
+/*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
+/*   13-12 TV system (0=525/60, 1=625/50) */
+/*   11-10 Aspect ratio (0=4:3, 3=16:9) */
+/*    9- 8 permitted display mode on 4:3 monitor (0=both, 1=only pan-sca */
+/*    7    line 21-1 data present in GOP (1=yes, 0=no) */
+/*    6    line 21-2 data present in GOP (1=yes, 0=no) */
+/*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
+/*    2    source letterboxed (1=yes, 0=no) */
+/*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
+
+
+/* bit definitions for capabilities: */
+/* can the hardware decode MPEG1 and/or MPEG2? */
+#define VIDEO_CAP_MPEG1   1
+#define VIDEO_CAP_MPEG2   2
+/* can you send a system and/or program stream to video device?
+   (you still have to open the video and the audio device but only
+    send the stream to the video device) */
+#define VIDEO_CAP_SYS     4
+#define VIDEO_CAP_PROG    8
+/* can the driver also handle SPU, NAVI and CSS encoded data?
+   (CSS API is not present yet) */
+#define VIDEO_CAP_SPU    16
+#define VIDEO_CAP_NAVI   32
+#define VIDEO_CAP_CSS    64
+
+/** VIDEO_STOP - Stop playing the current stream.
+ */
+#define VIDEO_STOP                 _IO('o', 21)
+
+/** VIDEO_PLAY - Start playing a video stream from the selected source.
+ * Depending on the input parameter, the screen can be blanked out (1)
+ * or displaying the last decoded frame (0).
+ */
+#define VIDEO_PLAY                 _IO('o', 22)
+
+/** VIDEO_FREEZE
+ * This ioctl call suspends the live video stream being played. Decoding and
+ * playing are frozen. It is then possible to restart the decoding and playing
+ * process of the video stream using the VIDEO_CONTINUE command. If
+ * VIDEO_SOURCE_MEMORY is selected in the ioctl call VIDEO_SELECT_SOURCE, the
+ * DVB subsystem will not decode any more data until the ioctl call
+ * VIDEO_CONTINUE or VIDEO_PLAY is performed.
+ */
+#define VIDEO_FREEZE               _IO('o', 23)
+
+/** VIDEO_CONTINUE
+ * Restarts decoding and playing processes of the video stream which was played
+ * before a call to VIDEO_FREEZE was made.
+ */
+#define VIDEO_CONTINUE             _IO('o', 24)
+
+/** VIDEO_SELECT_SOURCE
+ * This ioctl call informs the video device which source shall be used for the
+ * input data. The possible sources are demux or memory. If memory is selected,
+ * the data is fed to the video device through the write command.
+ */
+#define VIDEO_SELECT_SOURCE        _IO('o', 25)
+
+/** VIDEO_SET_BLANK
+ * Blank out the picture (1) or show last decoded frame (0).
+ */
+#define VIDEO_SET_BLANK            _IO('o', 26)
+
+/** VIDEO_GET_STATUS - Return the current status of the device.
+ */
+#define VIDEO_GET_STATUS           _IOR('o', 27, struct video_status)
+
+/** VIDEO_GET_EVENT
+ * This ioctl call returns an event of type video_event if available. If an
+ * event is not available, the behavior depends on whether the device is in
+ * blocking or non-blocking mode. In the latter case, the call fails immediately
+ * with errno set to EWOULDBLOCK. In the former case, the call blocks until an
+ * event becomes available. The standard Linux poll() and/or select() system
+ * calls can be used with the device file descriptor to watch for new events.
+ * For select(), the file descriptor should be included in the exceptfds
+ * argument, and for poll(), POLLPRI should be specified as the wake-up
+ * condition. Read-only permissions are sufficient for this ioctl call.
+ */
+#define VIDEO_GET_EVENT            _IOR('o', 28, struct video_event)
+
+/** VIDEO_SET_DISPLAY_FORMAT - Select the video format to be applied by the MPEG chip on the video.
+ */
+#define VIDEO_SET_DISPLAY_FORMAT   _IO('o', 29)
+
+/** VIDEO_STILLPICTURE
+ * This ioctl call asks the Video Device to display a still picture (I-frame).
+ * The input data shall contain an I-frame. If the pointer is NULL, then the
+ * current displayed still picture is blanked.
+ */
+#define VIDEO_STILLPICTURE         _IOW('o', 30, struct video_still_picture)
+
+/** VIDEO_FAST_FORWARD
+ * This ioctl call asks the Video Device to skip decoding of N number of
+ * I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is selected.
+ */
+#define VIDEO_FAST_FORWARD         _IO('o', 31)
+
+/** VIDEO_SLOWMOTION
+ * This ioctl call asks the video device to repeat decoding frames N number
+ * of times. This call can only be used if VIDEO_SOURCE_MEMORY is selected.
+ */
+#define VIDEO_SLOWMOTION           _IO('o', 32)
+
+/** VIDEO_GET_CAPABILITIES
+ * This ioctl call asks the video device about its decoding capabilities.
+ * On success it returns an integer which has bits set according to the
+ * video capability defines.
+ */
+#define VIDEO_GET_CAPABILITIES     _IOR('o', 33, unsigned int)
+
+/** VIDEO_CLEAR_BUFFER - Clear all video buffers in the driver and in the decoder hardware.
+ */
+#define VIDEO_CLEAR_BUFFER         _IO('o',  34)
+
+/** VIDEO_SET_STREAMTYPE
+ * This ioctl tells the driver which kind of stream to expect being written
+ * to it. If this call is not used the default of video PES is used.
+ * Note: this call doesn't do anything in the av7110 driver and just returns 0.
+ */
+#define VIDEO_SET_STREAMTYPE       _IO('o', 36)
+
+/** VIDEO_SET_FORMAT
+ * This ioctl sets the screen format (aspect ratio) of the connected output
+ * device (TV) so that the output of the decoder can be adjusted accordingly.
+ */
+#define VIDEO_SET_FORMAT           _IO('o', 37)
+
+/** VIDEO_GET_SIZE
+ */
+#define VIDEO_GET_SIZE             _IOR('o', 55, video_size_t)
+
+
+
+/* av7110 audio ioctls
+ *
+ * The DVB audio device controls the MPEG2 audio decoder of the av7110 DVB
+ * hardware. It can be accessed through /dev/dvb/adapter0/audio0.
+ *
+ * Only one user can open the Audio Device in O_RDWR mode. All other attempts
+ * to open the device in this mode will fail and an error code will be returned.
+ * If the Audio Device is opened in O_RDONLY mode, the only ioctl call that can
+ * be used is AUDIO_GET_STATUS. All other calls will return with an error code.
+ *
+ * The write() system call can only be used if AUDIO_SOURCE_MEMORY is selected
+ * in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in PES
+ * format. If O_NONBLOCK is not specified the function will block until buffer
+ * space is available. The amount of data to be transferred is implied by count.
+ */
+
+/** audio_stream_source_t
+ *
+ * The audio stream source is set through the AUDIO_SELECT_SOURCE call and can take
+ * the following values, depending on whether we are replaying from an internal (demux) or
+ * external (user write) source.
+ *
+ * AUDIO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
+ * DVR device) as the source of the video stream. If AUDIO_SOURCE_MEMORY
+ * is selected the stream comes from the application through the write() system
+ * call.
+ */
+typedef enum {
+	AUDIO_SOURCE_DEMUX, /* Select the demux as the main source */
+	AUDIO_SOURCE_MEMORY /* Select internal memory as the main source */
+} audio_stream_source_t;
+
+
+/** audio_play_state_t
+ *
+ * The following values can be returned by the AUDIO_GET_STATUS call representing the
+ * state of audio playback.
+ */
+typedef enum {
+	AUDIO_STOPPED,      /* Device is stopped */
+	AUDIO_PLAYING,      /* Device is currently playing */
+	AUDIO_PAUSED        /* Device is paused */
+} audio_play_state_t;
+
+
+/** audio_channel_select_t
+ *
+ * The audio channel selected via AUDIO_CHANNEL_SELECT is determined by the
+ * following values.
+ */
+typedef enum {
+	AUDIO_STEREO,
+	AUDIO_MONO_LEFT,
+	AUDIO_MONO_RIGHT,
+	AUDIO_MONO,
+	AUDIO_STEREO_SWAPPED
+} audio_channel_select_t;
+
+
+/** struct audio_mixer
+ *
+ * The following structure is used by the AUDIO_SET_MIXER call to set the audio
+ * volume.
+ */
+typedef struct audio_mixer {
+	unsigned int volume_left;
+	unsigned int volume_right;
+  // what else do we need? bass, pass-through, ...
+} audio_mixer_t;
+
+
+/** struct audio_status
+ *
+ * The AUDIO_GET_STATUS call returns the following structure informing about various
+ * states of the playback operation.
+ */
+typedef struct audio_status {
+	int                    AV_sync_state;  /* sync audio and video? */
+	int                    mute_state;     /* audio is muted */
+	audio_play_state_t     play_state;     /* current playback state */
+	audio_stream_source_t  stream_source;  /* current stream source */
+	audio_channel_select_t channel_select; /* currently selected channel */
+	int                    bypass_mode;    /* pass on audio data to */
+	audio_mixer_t	       mixer_state;    /* current mixer state */
+} audio_status_t;                              /* separate decoder hardware */
+
+/** audio encodings
+ *
+ * A call to AUDIO_GET_CAPABILITIES returns an unsigned integer with the following
+ * bits set according to the hardware's capabilities.
+ */
+#define AUDIO_CAP_DTS    1
+#define AUDIO_CAP_LPCM   2
+#define AUDIO_CAP_MP1    4
+#define AUDIO_CAP_MP2    8
+#define AUDIO_CAP_MP3   16
+#define AUDIO_CAP_AAC   32
+#define AUDIO_CAP_OGG   64
+#define AUDIO_CAP_SDDS 128
+#define AUDIO_CAP_AC3  256
+
+/** AUDIO_STOP - Stop playing the current stream.
+ */
+#define AUDIO_STOP                 _IO('o', 1)
+
+/** AUDIO_PLAY - Start playing an audio stream from the selected source.
+ */
+#define AUDIO_PLAY                 _IO('o', 2)
+
+/** AUDIO_PAUSE
+ * Suspends the audio stream being played. Decoding and playing are paused.
+ * It is then possible to restart again decoding and playing process of the
+ * audio stream using AUDIO_CONTINUE command.
+ *
+ * If AUDIO_SOURCE_MEMORY is selected in the ioctl call AUDIO_SELECT_SOURCE,
+ * the DVB-subsystem will not decode (consume) any more data until the ioctl
+ * call AUDIO_CONTINUE or AUDIO_PLAY is performed.
+ */
+#define AUDIO_PAUSE                _IO('o', 3)
+
+/** AUDIO_CONTINUE - Restarts the decoding and playing process previously paused with AUDIO_PAUSE command.
+ *
+ * It only works if the stream were previously stopped with AUDIO_PAUSE.
+ */
+#define AUDIO_CONTINUE             _IO('o', 4)
+
+/** AUDIO_SELECT_SOURCE
+ * This ioctl call informs the audio device which source shall be used for
+ * the input data. The possible sources are demux or memory. If
+ * AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
+ * through the write command.
+ */
+#define AUDIO_SELECT_SOURCE        _IO('o', 5)
+
+/** AUDIO_SET_MUTE - Mute the stream that is currently being played.
+ */
+#define AUDIO_SET_MUTE             _IO('o', 6)
+
+/** AUDIO_SET_AV_SYNC - Turn ON or OFF A/V synchronization.
+ */
+#define AUDIO_SET_AV_SYNC          _IO('o', 7)
+
+/** AUDIO_SET_BYPASS_MODE
+ * This ioctl call asks the Audio Device to bypass the Audio decoder and forward
+ * the stream without decoding. This mode shall be used if streams that can’t be
+ * handled by the DVB system shall be decoded. Dolby DigitalTM streams are
+ * automatically forwarded by the DVB subsystem if the hardware can handle it.
+ */
+#define AUDIO_SET_BYPASS_MODE      _IO('o', 8)
+
+/** AUDIO_CHANNEL_SELECT - Select the requested channel if possible.
+ */
+#define AUDIO_CHANNEL_SELECT       _IO('o', 9)
+
+/** AUDIO_GET_STATUS - Return the current state of the Audio Device.
+ */
+#define AUDIO_GET_STATUS           _IOR('o', 10, audio_status_t)
+
+/** AUDIO_GET_CAPABILITIES - Return the decoding capabilities of the audio hardware.
+ * Returns a bit array of supported sound formats.
+ */
+#define AUDIO_GET_CAPABILITIES     _IOR('o', 11, unsigned int)
+
+/** AUDIO_CLEAR_BUFFER - Clear all software and hardware buffers of the audio decoder device.
+ */
+#define AUDIO_CLEAR_BUFFER         _IO('o',  12)
+
+/** AUDIO_SET_ID
+ * This ioctl selects which sub-stream is to be decoded if a program or system
+ * stream is sent to the video device. If no audio stream type is set the id
+ * has to be in [0xC0,0xDF] for MPEG sound, in [0x80,0x87] for AC3 and in
+ * [0xA0,0xA7] for LPCM. More specifications may follow for other stream types.
+ * If the stream type is set the id just specifies the substream id of the
+ * audio stream and only the first 5 bits are recognized.
+ * Note: this call doesn't do anything in the av7110 driver and just returns 0.
+ */
+#define AUDIO_SET_ID               _IO('o', 13)
+
+/** AUDIO_SET_MIXER - Adjusts the mixer settings of the audio decoder.
+ */
+#define AUDIO_SET_MIXER            _IOW('o', 14, audio_mixer_t)
+
+/** AUDIO_SET_STREAMTYPE
+ * This ioctl tells the driver which kind of audio stream to expect. This is
+ * useful if the stream offers several audio sub-streams like LPCM and AC3.
+ * Note: this call doesn't do anything in the av7110 driver and just returns 0.
+ */
+#define AUDIO_SET_STREAMTYPE       _IO('o', 15)
+
+
+/* av7110 OSD ioctls */
+
+typedef enum {
+  // All functions return -2 on "not open"
+  OSD_Close=1,    // ()
+  // Disables OSD and releases the buffers
+  // returns 0 on success
+  OSD_Open,       // (x0,y0,x1,y1,BitPerPixel[2/4/8](color&0x0F),mix[0..15](color&0xF0))
+  // Opens OSD with this size and bit depth
+  // returns 0 on success, -1 on DRAM allocation error, -2 on "already open"
+  OSD_Show,       // ()
+  // enables OSD mode
+  // returns 0 on success
+  OSD_Hide,       // ()
+  // disables OSD mode
+  // returns 0 on success
+  OSD_Clear,      // ()
+  // Sets all pixel to color 0
+  // returns 0 on success
+  OSD_Fill,       // (color)
+  // Sets all pixel to color <col>
+  // returns 0 on success
+  OSD_SetColor,   // (color,R{x0},G{y0},B{x1},opacity{y1})
+  // set palette entry <num> to <r,g,b>, <mix> and <trans> apply
+  // R,G,B: 0..255
+  // R=Red, G=Green, B=Blue
+  // opacity=0:      pixel opacity 0% (only video pixel shows)
+  // opacity=1..254: pixel opacity as specified in header
+  // opacity=255:    pixel opacity 100% (only OSD pixel shows)
+  // returns 0 on success, -1 on error
+  OSD_SetPalette, // (firstcolor{color},lastcolor{x0},data)
+  // Set a number of entries in the palette
+  // sets the entries "firstcolor" through "lastcolor" from the array "data"
+  // data has 4 byte for each color:
+  // R,G,B, and a opacity value: 0->transparent, 1..254->mix, 255->pixel
+  OSD_SetTrans,   // (transparency{color})
+  // Sets transparency of mixed pixel (0..15)
+  // returns 0 on success
+  OSD_SetPixel,   // (x0,y0,color)
+  // sets pixel <x>,<y> to color number <col>
+  // returns 0 on success, -1 on error
+  OSD_GetPixel,   // (x0,y0)
+  // returns color number of pixel <x>,<y>,  or -1
+  OSD_SetRow,     // (x0,y0,x1,data)
+  // fills pixels x0,y through  x1,y with the content of data[]
+  // returns 0 on success, -1 on clipping all pixel (no pixel drawn)
+  OSD_SetBlock,   // (x0,y0,x1,y1,increment{color},data)
+  // fills pixels x0,y0 through  x1,y1 with the content of data[]
+  // inc contains the width of one line in the data block,
+  // inc<=0 uses blockwidth as linewidth
+  // returns 0 on success, -1 on clipping all pixel
+  OSD_FillRow,    // (x0,y0,x1,color)
+  // fills pixels x0,y through  x1,y with the color <col>
+  // returns 0 on success, -1 on clipping all pixel
+  OSD_FillBlock,  // (x0,y0,x1,y1,color)
+  // fills pixels x0,y0 through  x1,y1 with the color <col>
+  // returns 0 on success, -1 on clipping all pixel
+  OSD_Line,       // (x0,y0,x1,y1,color)
+  // draw a line from x0,y0 to x1,y1 with the color <col>
+  // returns 0 on success
+  OSD_Query,      // (x0,y0,x1,y1,xasp{color}}), yasp=11
+  // fills parameters with the picture dimensions and the pixel aspect ratio
+  // returns 0 on success
+  OSD_Test,       // ()
+  // draws a test picture. for debugging purposes only
+  // returns 0 on success
+// TODO: remove "test" in final version
+  OSD_Text,       // (x0,y0,size,color,text)
+  OSD_SetWindow, //  (x0) set window with number 0<x0<8 as current
+  OSD_MoveWindow, //  move current window to (x0, y0)
+  OSD_OpenRaw,	// Open other types of OSD windows
+} OSD_Command;
+
+typedef struct osd_cmd_s {
+	OSD_Command cmd;
+	int x0;
+	int y0;
+	int x1;
+	int y1;
+	int color;
+	void __user *data;
+} osd_cmd_t;
+
+/* OSD_OpenRaw: set 'color' to desired window type */
+typedef enum {
+	OSD_BITMAP1,           /* 1 bit bitmap */
+	OSD_BITMAP2,           /* 2 bit bitmap */
+	OSD_BITMAP4,           /* 4 bit bitmap */
+	OSD_BITMAP8,           /* 8 bit bitmap */
+	OSD_BITMAP1HR,         /* 1 Bit bitmap half resolution */
+	OSD_BITMAP2HR,         /* 2 bit bitmap half resolution */
+	OSD_BITMAP4HR,         /* 4 bit bitmap half resolution */
+	OSD_BITMAP8HR,         /* 8 bit bitmap half resolution */
+	OSD_YCRCB422,          /* 4:2:2 YCRCB Graphic Display */
+	OSD_YCRCB444,          /* 4:4:4 YCRCB Graphic Display */
+	OSD_YCRCB444HR,        /* 4:4:4 YCRCB graphic half resolution */
+	OSD_VIDEOTSIZE,        /* True Size Normal MPEG Video Display */
+	OSD_VIDEOHSIZE,        /* MPEG Video Display Half Resolution */
+	OSD_VIDEOQSIZE,        /* MPEG Video Display Quarter Resolution */
+	OSD_VIDEODSIZE,        /* MPEG Video Display Double Resolution */
+	OSD_VIDEOTHSIZE,       /* True Size MPEG Video Display Half Resolution */
+	OSD_VIDEOTQSIZE,       /* True Size MPEG Video Display Quarter Resolution*/
+	OSD_VIDEOTDSIZE,       /* True Size MPEG Video Display Double Resolution */
+	OSD_VIDEONSIZE,        /* Full Size MPEG Video Display */
+	OSD_CURSOR             /* Cursor */
+} osd_raw_window_t;
+
+typedef struct osd_cap_s {
+	int  cmd;
+#define OSD_CAP_MEMSIZE         1  /* memory size */
+	long val;
+} osd_cap_t;
+
+
+#define OSD_SEND_CMD            _IOW('o', 160, osd_cmd_t)
+#define OSD_GET_CAPABILITY      _IOR('o', 161, osd_cap_t)
+
+#endif
+
-- 
1.7.7.3

