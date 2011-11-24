Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab1KXRhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:37:08 -0500
Message-ID: <4ECE80BE.4090109@redhat.com>
Date: Thu, 24 Nov 2011 15:37:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org>
In-Reply-To: <4ECE79F5.9000402@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 15:08, Andreas Oberritter escreveu:
> Don't break existing Userspace APIs for no reason! It's OK to add the
> new API, but - pretty please - don't just blindly remove audio.h and
> video.h. They are in use since many years by av7110, out-of-tree drivers
> *and more importantly* by applications. Yes, I know, you'd like to see
> those out-of-tree drivers merged, but it isn't possible for many
> reasons. And even if they were merged, you'd say "Port them and your
> apps to V4L". No! That's not an option.

Hi Andreas,

Userspace applications that support av7110 can include the new linux/av7110.h
header. Other applications that support out-of-tree drivers can just have
their own copy of audio.h, osd.h and video.h. So, it won't break or prevent
existing applications to keep working.

The thing is that the media API presents two interfaces to control mpeg decoders.
This is confusing, and, while one of them has active upstream developers working
on it, adding new drivers and new features on it, the other API is not being
updated accordingly, and no new upstream drivers use it.

Worse than that, several ioctl's are there, with not a single in-kernel implementation, 
nor any documentation about how they are supposed to work.

We noticed in Prague that new DVB developers got confused about what should be the
proper implementation for new drivers, so marking it as deprecated is important,
otherwise, we'll end by having different approaches for the same thing.

Just to give you one example, newer DTV standards like ISDB-T and DVB-T2 now uses
H.264 video streams. Support for H.264 were added recently at V4L2 API, but the
dvb video API doesn't support it.

What I'm saying is that this API is legacy, from kernel POV.  So, let's freeze it to DVB v5.4
spec, and remove it from the official Kernel DVB API on future versions (yet, keeping it
as a private API for av7110). It probably makes sense to increase the major version
at DVB API, when this patches got merged, to indicate that DVB v6 and above doesn't
have it anymore, while v5.4 and bellow has it.

> 
> Regards,
> Andreas
> 
> On 24.11.2011 14:39, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  fs/compat_ioctl.c         |   41 +-------
>>  include/linux/dvb/Kbuild  |    3 -
>>  include/linux/dvb/audio.h |  135 ----------------------
>>  include/linux/dvb/osd.h   |  144 -----------------------
>>  include/linux/dvb/video.h |  276 ---------------------------------------------
>>  5 files changed, 1 insertions(+), 598 deletions(-)
>>  delete mode 100644 include/linux/dvb/audio.h
>>  delete mode 100644 include/linux/dvb/osd.h
>>  delete mode 100644 include/linux/dvb/video.h
>>
>> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
>> index 51352de..71adea1 100644
>> --- a/fs/compat_ioctl.c
>> +++ b/fs/compat_ioctl.c
>> @@ -105,10 +105,9 @@
>>  
>>  #include <linux/hiddev.h>
>>  
>> -#include <linux/dvb/audio.h>
>> +#include <linux/av7110.h>
>>  #include <linux/dvb/dmx.h>
>>  #include <linux/dvb/frontend.h>
>> -#include <linux/dvb/video.h>
>>  
>>  #include <linux/sort.h>
>>  
>> @@ -196,32 +195,6 @@ static int do_video_stillpicture(unsigned int fd, unsigned int cmd,
>>  	return err;
>>  }
>>  
>> -struct compat_video_spu_palette {
>> -	int length;
>> -	compat_uptr_t palette;
>> -};
>> -
>> -static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd,
>> -		struct compat_video_spu_palette __user *up)
>> -{
>> -	struct video_spu_palette __user *up_native;
>> -	compat_uptr_t palp;
>> -	int length, err;
>> -
>> -	err  = get_user(palp, &up->palette);
>> -	err |= get_user(length, &up->length);
>> -
>> -	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
>> -	err  = put_user(compat_ptr(palp), &up_native->palette);
>> -	err |= put_user(length, &up_native->length);
>> -	if (err)
>> -		return -EFAULT;
>> -
>> -	err = sys_ioctl(fd, cmd, (unsigned long) up_native);
>> -
>> -	return err;
>> -}
>> -
>>  #ifdef CONFIG_BLOCK
>>  typedef struct sg_io_hdr32 {
>>  	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
>> @@ -1317,9 +1290,6 @@ COMPATIBLE_IOCTL(AUDIO_CLEAR_BUFFER)
>>  COMPATIBLE_IOCTL(AUDIO_SET_ID)
>>  COMPATIBLE_IOCTL(AUDIO_SET_MIXER)
>>  COMPATIBLE_IOCTL(AUDIO_SET_STREAMTYPE)
>> -COMPATIBLE_IOCTL(AUDIO_SET_EXT_ID)
>> -COMPATIBLE_IOCTL(AUDIO_SET_ATTRIBUTES)
>> -COMPATIBLE_IOCTL(AUDIO_SET_KARAOKE)
>>  COMPATIBLE_IOCTL(DMX_START)
>>  COMPATIBLE_IOCTL(DMX_STOP)
>>  COMPATIBLE_IOCTL(DMX_SET_FILTER)
>> @@ -1358,16 +1328,9 @@ COMPATIBLE_IOCTL(VIDEO_FAST_FORWARD)
>>  COMPATIBLE_IOCTL(VIDEO_SLOWMOTION)
>>  COMPATIBLE_IOCTL(VIDEO_GET_CAPABILITIES)
>>  COMPATIBLE_IOCTL(VIDEO_CLEAR_BUFFER)
>> -COMPATIBLE_IOCTL(VIDEO_SET_ID)
>>  COMPATIBLE_IOCTL(VIDEO_SET_STREAMTYPE)
>>  COMPATIBLE_IOCTL(VIDEO_SET_FORMAT)
>> -COMPATIBLE_IOCTL(VIDEO_SET_SYSTEM)
>> -COMPATIBLE_IOCTL(VIDEO_SET_HIGHLIGHT)
>> -COMPATIBLE_IOCTL(VIDEO_SET_SPU)
>> -COMPATIBLE_IOCTL(VIDEO_GET_NAVI)
>> -COMPATIBLE_IOCTL(VIDEO_SET_ATTRIBUTES)
>>  COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
>> -COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)
>>  
>>  /* joystick */
>>  COMPATIBLE_IOCTL(JSIOCGVERSION)
>> @@ -1468,8 +1431,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
>>  		return do_video_get_event(fd, cmd, argp);
>>  	case VIDEO_STILLPICTURE:
>>  		return do_video_stillpicture(fd, cmd, argp);
>> -	case VIDEO_SET_SPU_PALETTE:
>> -		return do_video_set_spu_palette(fd, cmd, argp);
>>  	}
>>  
>>  	/*
>> diff --git a/include/linux/dvb/Kbuild b/include/linux/dvb/Kbuild
>> index f4dba86..f5aa137 100644
>> --- a/include/linux/dvb/Kbuild
>> +++ b/include/linux/dvb/Kbuild
>> @@ -1,8 +1,5 @@
>> -header-y += audio.h
>>  header-y += ca.h
>>  header-y += dmx.h
>>  header-y += frontend.h
>>  header-y += net.h
>> -header-y += osd.h
>>  header-y += version.h
>> -header-y += video.h
>> diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
>> deleted file mode 100644
>> index d47bccd..0000000
>> --- a/include/linux/dvb/audio.h
>> +++ /dev/null
>> @@ -1,135 +0,0 @@
>> -/*
>> - * audio.h
>> - *
>> - * Copyright (C) 2000 Ralph  Metzler <ralph@convergence.de>
>> - *                  & Marcus Metzler <marcus@convergence.de>
>> - *                    for convergence integrated media GmbH
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU General Lesser Public License
>> - * as published by the Free Software Foundation; either version 2.1
>> - * of the License, or (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU Lesser General Public License
>> - * along with this program; if not, write to the Free Software
>> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>> - *
>> - */
>> -
>> -#ifndef _DVBAUDIO_H_
>> -#define _DVBAUDIO_H_
>> -
>> -#include <linux/types.h>
>> -
>> -typedef enum {
>> -	AUDIO_SOURCE_DEMUX, /* Select the demux as the main source */
>> -	AUDIO_SOURCE_MEMORY /* Select internal memory as the main source */
>> -} audio_stream_source_t;
>> -
>> -
>> -typedef enum {
>> -	AUDIO_STOPPED,      /* Device is stopped */
>> -	AUDIO_PLAYING,      /* Device is currently playing */
>> -	AUDIO_PAUSED        /* Device is paused */
>> -} audio_play_state_t;
>> -
>> -
>> -typedef enum {
>> -	AUDIO_STEREO,
>> -	AUDIO_MONO_LEFT,
>> -	AUDIO_MONO_RIGHT,
>> -	AUDIO_MONO,
>> -	AUDIO_STEREO_SWAPPED
>> -} audio_channel_select_t;
>> -
>> -
>> -typedef struct audio_mixer {
>> -	unsigned int volume_left;
>> -	unsigned int volume_right;
>> -  // what else do we need? bass, pass-through, ...
>> -} audio_mixer_t;
>> -
>> -
>> -typedef struct audio_status {
>> -	int                    AV_sync_state;  /* sync audio and video? */
>> -	int                    mute_state;     /* audio is muted */
>> -	audio_play_state_t     play_state;     /* current playback state */
>> -	audio_stream_source_t  stream_source;  /* current stream source */
>> -	audio_channel_select_t channel_select; /* currently selected channel */
>> -	int                    bypass_mode;    /* pass on audio data to */
>> -	audio_mixer_t	       mixer_state;    /* current mixer state */
>> -} audio_status_t;                              /* separate decoder hardware */
>> -
>> -
>> -typedef
>> -struct audio_karaoke {  /* if Vocal1 or Vocal2 are non-zero, they get mixed  */
>> -	int vocal1;    /* into left and right t at 70% each */
>> -	int vocal2;    /* if both, Vocal1 and Vocal2 are non-zero, Vocal1 gets*/
>> -	int melody;    /* mixed into the left channel and */
>> -		       /* Vocal2 into the right channel at 100% each. */
>> -		       /* if Melody is non-zero, the melody channel gets mixed*/
>> -} audio_karaoke_t;     /* into left and right  */
>> -
>> -
>> -typedef __u16 audio_attributes_t;
>> -/*   bits: descr. */
>> -/*   15-13 audio coding mode (0=ac3, 2=mpeg1, 3=mpeg2ext, 4=LPCM, 6=DTS, */
>> -/*   12    multichannel extension */
>> -/*   11-10 audio type (0=not spec, 1=language included) */
>> -/*    9- 8 audio application mode (0=not spec, 1=karaoke, 2=surround) */
>> -/*    7- 6 Quantization / DRC (mpeg audio: 1=DRC exists)(lpcm: 0=16bit,  */
>> -/*    5- 4 Sample frequency fs (0=48kHz, 1=96kHz) */
>> -/*    2- 0 number of audio channels (n+1 channels) */
>> -
>> -
>> -/* for GET_CAPABILITIES and SET_FORMAT, the latter should only set one bit */
>> -#define AUDIO_CAP_DTS    1
>> -#define AUDIO_CAP_LPCM   2
>> -#define AUDIO_CAP_MP1    4
>> -#define AUDIO_CAP_MP2    8
>> -#define AUDIO_CAP_MP3   16
>> -#define AUDIO_CAP_AAC   32
>> -#define AUDIO_CAP_OGG   64
>> -#define AUDIO_CAP_SDDS 128
>> -#define AUDIO_CAP_AC3  256
>> -
>> -#define AUDIO_STOP                 _IO('o', 1)
>> -#define AUDIO_PLAY                 _IO('o', 2)
>> -#define AUDIO_PAUSE                _IO('o', 3)
>> -#define AUDIO_CONTINUE             _IO('o', 4)
>> -#define AUDIO_SELECT_SOURCE        _IO('o', 5)
>> -#define AUDIO_SET_MUTE             _IO('o', 6)
>> -#define AUDIO_SET_AV_SYNC          _IO('o', 7)
>> -#define AUDIO_SET_BYPASS_MODE      _IO('o', 8)
>> -#define AUDIO_CHANNEL_SELECT       _IO('o', 9)
>> -#define AUDIO_GET_STATUS           _IOR('o', 10, audio_status_t)
>> -
>> -#define AUDIO_GET_CAPABILITIES     _IOR('o', 11, unsigned int)
>> -#define AUDIO_CLEAR_BUFFER         _IO('o',  12)
>> -#define AUDIO_SET_ID               _IO('o', 13)
>> -#define AUDIO_SET_MIXER            _IOW('o', 14, audio_mixer_t)
>> -#define AUDIO_SET_STREAMTYPE       _IO('o', 15)
>> -#define AUDIO_SET_EXT_ID           _IO('o', 16)
>> -#define AUDIO_SET_ATTRIBUTES       _IOW('o', 17, audio_attributes_t)
>> -#define AUDIO_SET_KARAOKE          _IOW('o', 18, audio_karaoke_t)
>> -
>> -/**
>> - * AUDIO_GET_PTS
>> - *
>> - * Read the 33 bit presentation time stamp as defined
>> - * in ITU T-REC-H.222.0 / ISO/IEC 13818-1.
>> - *
>> - * The PTS should belong to the currently played
>> - * frame if possible, but may also be a value close to it
>> - * like the PTS of the last decoded frame or the last PTS
>> - * extracted by the PES parser.
>> - */
>> -#define AUDIO_GET_PTS              _IOR('o', 19, __u64)
>> -#define AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
>> -
>> -#endif /* _DVBAUDIO_H_ */
>> diff --git a/include/linux/dvb/osd.h b/include/linux/dvb/osd.h
>> deleted file mode 100644
>> index 880e684..0000000
>> --- a/include/linux/dvb/osd.h
>> +++ /dev/null
>> @@ -1,144 +0,0 @@
>> -/*
>> - * osd.h
>> - *
>> - * Copyright (C) 2001 Ralph  Metzler <ralph@convergence.de>
>> - *                  & Marcus Metzler <marcus@convergence.de>
>> - *                    for convergence integrated media GmbH
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU General Lesser Public License
>> - * as published by the Free Software Foundation; either version 2.1
>> - * of the License, or (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU Lesser General Public License
>> - * along with this program; if not, write to the Free Software
>> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>> - *
>> - */
>> -
>> -#ifndef _DVBOSD_H_
>> -#define _DVBOSD_H_
>> -
>> -#include <linux/compiler.h>
>> -
>> -typedef enum {
>> -  // All functions return -2 on "not open"
>> -  OSD_Close=1,    // ()
>> -  // Disables OSD and releases the buffers
>> -  // returns 0 on success
>> -  OSD_Open,       // (x0,y0,x1,y1,BitPerPixel[2/4/8](color&0x0F),mix[0..15](color&0xF0))
>> -  // Opens OSD with this size and bit depth
>> -  // returns 0 on success, -1 on DRAM allocation error, -2 on "already open"
>> -  OSD_Show,       // ()
>> -  // enables OSD mode
>> -  // returns 0 on success
>> -  OSD_Hide,       // ()
>> -  // disables OSD mode
>> -  // returns 0 on success
>> -  OSD_Clear,      // ()
>> -  // Sets all pixel to color 0
>> -  // returns 0 on success
>> -  OSD_Fill,       // (color)
>> -  // Sets all pixel to color <col>
>> -  // returns 0 on success
>> -  OSD_SetColor,   // (color,R{x0},G{y0},B{x1},opacity{y1})
>> -  // set palette entry <num> to <r,g,b>, <mix> and <trans> apply
>> -  // R,G,B: 0..255
>> -  // R=Red, G=Green, B=Blue
>> -  // opacity=0:      pixel opacity 0% (only video pixel shows)
>> -  // opacity=1..254: pixel opacity as specified in header
>> -  // opacity=255:    pixel opacity 100% (only OSD pixel shows)
>> -  // returns 0 on success, -1 on error
>> -  OSD_SetPalette, // (firstcolor{color},lastcolor{x0},data)
>> -  // Set a number of entries in the palette
>> -  // sets the entries "firstcolor" through "lastcolor" from the array "data"
>> -  // data has 4 byte for each color:
>> -  // R,G,B, and a opacity value: 0->transparent, 1..254->mix, 255->pixel
>> -  OSD_SetTrans,   // (transparency{color})
>> -  // Sets transparency of mixed pixel (0..15)
>> -  // returns 0 on success
>> -  OSD_SetPixel,   // (x0,y0,color)
>> -  // sets pixel <x>,<y> to color number <col>
>> -  // returns 0 on success, -1 on error
>> -  OSD_GetPixel,   // (x0,y0)
>> -  // returns color number of pixel <x>,<y>,  or -1
>> -  OSD_SetRow,     // (x0,y0,x1,data)
>> -  // fills pixels x0,y through  x1,y with the content of data[]
>> -  // returns 0 on success, -1 on clipping all pixel (no pixel drawn)
>> -  OSD_SetBlock,   // (x0,y0,x1,y1,increment{color},data)
>> -  // fills pixels x0,y0 through  x1,y1 with the content of data[]
>> -  // inc contains the width of one line in the data block,
>> -  // inc<=0 uses blockwidth as linewidth
>> -  // returns 0 on success, -1 on clipping all pixel
>> -  OSD_FillRow,    // (x0,y0,x1,color)
>> -  // fills pixels x0,y through  x1,y with the color <col>
>> -  // returns 0 on success, -1 on clipping all pixel
>> -  OSD_FillBlock,  // (x0,y0,x1,y1,color)
>> -  // fills pixels x0,y0 through  x1,y1 with the color <col>
>> -  // returns 0 on success, -1 on clipping all pixel
>> -  OSD_Line,       // (x0,y0,x1,y1,color)
>> -  // draw a line from x0,y0 to x1,y1 with the color <col>
>> -  // returns 0 on success
>> -  OSD_Query,      // (x0,y0,x1,y1,xasp{color}}), yasp=11
>> -  // fills parameters with the picture dimensions and the pixel aspect ratio
>> -  // returns 0 on success
>> -  OSD_Test,       // ()
>> -  // draws a test picture. for debugging purposes only
>> -  // returns 0 on success
>> -// TODO: remove "test" in final version
>> -  OSD_Text,       // (x0,y0,size,color,text)
>> -  OSD_SetWindow, //  (x0) set window with number 0<x0<8 as current
>> -  OSD_MoveWindow, //  move current window to (x0, y0)
>> -  OSD_OpenRaw,	// Open other types of OSD windows
>> -} OSD_Command;
>> -
>> -typedef struct osd_cmd_s {
>> -	OSD_Command cmd;
>> -	int x0;
>> -	int y0;
>> -	int x1;
>> -	int y1;
>> -	int color;
>> -	void __user *data;
>> -} osd_cmd_t;
>> -
>> -/* OSD_OpenRaw: set 'color' to desired window type */
>> -typedef enum {
>> -	OSD_BITMAP1,           /* 1 bit bitmap */
>> -	OSD_BITMAP2,           /* 2 bit bitmap */
>> -	OSD_BITMAP4,           /* 4 bit bitmap */
>> -	OSD_BITMAP8,           /* 8 bit bitmap */
>> -	OSD_BITMAP1HR,         /* 1 Bit bitmap half resolution */
>> -	OSD_BITMAP2HR,         /* 2 bit bitmap half resolution */
>> -	OSD_BITMAP4HR,         /* 4 bit bitmap half resolution */
>> -	OSD_BITMAP8HR,         /* 8 bit bitmap half resolution */
>> -	OSD_YCRCB422,          /* 4:2:2 YCRCB Graphic Display */
>> -	OSD_YCRCB444,          /* 4:4:4 YCRCB Graphic Display */
>> -	OSD_YCRCB444HR,        /* 4:4:4 YCRCB graphic half resolution */
>> -	OSD_VIDEOTSIZE,        /* True Size Normal MPEG Video Display */
>> -	OSD_VIDEOHSIZE,        /* MPEG Video Display Half Resolution */
>> -	OSD_VIDEOQSIZE,        /* MPEG Video Display Quarter Resolution */
>> -	OSD_VIDEODSIZE,        /* MPEG Video Display Double Resolution */
>> -	OSD_VIDEOTHSIZE,       /* True Size MPEG Video Display Half Resolution */
>> -	OSD_VIDEOTQSIZE,       /* True Size MPEG Video Display Quarter Resolution*/
>> -	OSD_VIDEOTDSIZE,       /* True Size MPEG Video Display Double Resolution */
>> -	OSD_VIDEONSIZE,        /* Full Size MPEG Video Display */
>> -	OSD_CURSOR             /* Cursor */
>> -} osd_raw_window_t;
>> -
>> -typedef struct osd_cap_s {
>> -	int  cmd;
>> -#define OSD_CAP_MEMSIZE         1  /* memory size */
>> -	long val;
>> -} osd_cap_t;
>> -
>> -
>> -#define OSD_SEND_CMD            _IOW('o', 160, osd_cmd_t)
>> -#define OSD_GET_CAPABILITY      _IOR('o', 161, osd_cap_t)
>> -
>> -#endif
>> diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
>> deleted file mode 100644
>> index 1d750c0..0000000
>> --- a/include/linux/dvb/video.h
>> +++ /dev/null
>> @@ -1,276 +0,0 @@
>> -/*
>> - * video.h
>> - *
>> - * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
>> - *                  & Ralph  Metzler <ralph@convergence.de>
>> - *                    for convergence integrated media GmbH
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU Lesser General Public License
>> - * as published by the Free Software Foundation; either version 2.1
>> - * of the License, or (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU Lesser General Public License
>> - * along with this program; if not, write to the Free Software
>> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>> - *
>> - */
>> -
>> -#ifndef _DVBVIDEO_H_
>> -#define _DVBVIDEO_H_
>> -
>> -#include <linux/types.h>
>> -#ifdef __KERNEL__
>> -#include <linux/compiler.h>
>> -#else
>> -#include <stdint.h>
>> -#include <time.h>
>> -#endif
>> -
>> -typedef enum {
>> -	VIDEO_FORMAT_4_3,     /* Select 4:3 format */
>> -	VIDEO_FORMAT_16_9,    /* Select 16:9 format. */
>> -	VIDEO_FORMAT_221_1    /* 2.21:1 */
>> -} video_format_t;
>> -
>> -
>> -typedef enum {
>> -	 VIDEO_SYSTEM_PAL,
>> -	 VIDEO_SYSTEM_NTSC,
>> -	 VIDEO_SYSTEM_PALN,
>> -	 VIDEO_SYSTEM_PALNc,
>> -	 VIDEO_SYSTEM_PALM,
>> -	 VIDEO_SYSTEM_NTSC60,
>> -	 VIDEO_SYSTEM_PAL60,
>> -	 VIDEO_SYSTEM_PALM60
>> -} video_system_t;
>> -
>> -
>> -typedef enum {
>> -	VIDEO_PAN_SCAN,       /* use pan and scan format */
>> -	VIDEO_LETTER_BOX,     /* use letterbox format */
>> -	VIDEO_CENTER_CUT_OUT  /* use center cut out format */
>> -} video_displayformat_t;
>> -
>> -typedef struct {
>> -	int w;
>> -	int h;
>> -	video_format_t aspect_ratio;
>> -} video_size_t;
>> -
>> -typedef enum {
>> -	VIDEO_SOURCE_DEMUX, /* Select the demux as the main source */
>> -	VIDEO_SOURCE_MEMORY /* If this source is selected, the stream
>> -			       comes from the user through the write
>> -			       system call */
>> -} video_stream_source_t;
>> -
>> -
>> -typedef enum {
>> -	VIDEO_STOPPED, /* Video is stopped */
>> -	VIDEO_PLAYING, /* Video is currently playing */
>> -	VIDEO_FREEZED  /* Video is freezed */
>> -} video_play_state_t;
>> -
>> -
>> -/* Decoder commands */
>> -#define VIDEO_CMD_PLAY        (0)
>> -#define VIDEO_CMD_STOP        (1)
>> -#define VIDEO_CMD_FREEZE      (2)
>> -#define VIDEO_CMD_CONTINUE    (3)
>> -
>> -/* Flags for VIDEO_CMD_FREEZE */
>> -#define VIDEO_CMD_FREEZE_TO_BLACK     	(1 << 0)
>> -
>> -/* Flags for VIDEO_CMD_STOP */
>> -#define VIDEO_CMD_STOP_TO_BLACK      	(1 << 0)
>> -#define VIDEO_CMD_STOP_IMMEDIATELY     	(1 << 1)
>> -
>> -/* Play input formats: */
>> -/* The decoder has no special format requirements */
>> -#define VIDEO_PLAY_FMT_NONE         (0)
>> -/* The decoder requires full GOPs */
>> -#define VIDEO_PLAY_FMT_GOP          (1)
>> -
>> -/* The structure must be zeroed before use by the application
>> -   This ensures it can be extended safely in the future. */
>> -struct video_command {
>> -	__u32 cmd;
>> -	__u32 flags;
>> -	union {
>> -		struct {
>> -			__u64 pts;
>> -		} stop;
>> -
>> -		struct {
>> -			/* 0 or 1000 specifies normal speed,
>> -			   1 specifies forward single stepping,
>> -			   -1 specifies backward single stepping,
>> -			   >1: playback at speed/1000 of the normal speed,
>> -			   <-1: reverse playback at (-speed/1000) of the normal speed. */
>> -			__s32 speed;
>> -			__u32 format;
>> -		} play;
>> -
>> -		struct {
>> -			__u32 data[16];
>> -		} raw;
>> -	};
>> -};
>> -
>> -/* FIELD_UNKNOWN can be used if the hardware does not know whether
>> -   the Vsync is for an odd, even or progressive (i.e. non-interlaced)
>> -   field. */
>> -#define VIDEO_VSYNC_FIELD_UNKNOWN  	(0)
>> -#define VIDEO_VSYNC_FIELD_ODD 		(1)
>> -#define VIDEO_VSYNC_FIELD_EVEN		(2)
>> -#define VIDEO_VSYNC_FIELD_PROGRESSIVE	(3)
>> -
>> -struct video_event {
>> -	__s32 type;
>> -#define VIDEO_EVENT_SIZE_CHANGED	1
>> -#define VIDEO_EVENT_FRAME_RATE_CHANGED	2
>> -#define VIDEO_EVENT_DECODER_STOPPED 	3
>> -#define VIDEO_EVENT_VSYNC 		4
>> -	__kernel_time_t timestamp;
>> -	union {
>> -		video_size_t size;
>> -		unsigned int frame_rate;	/* in frames per 1000sec */
>> -		unsigned char vsync_field;	/* unknown/odd/even/progressive */
>> -	} u;
>> -};
>> -
>> -
>> -struct video_status {
>> -	int                   video_blank;   /* blank video on freeze? */
>> -	video_play_state_t    play_state;    /* current state of playback */
>> -	video_stream_source_t stream_source; /* current source (demux/memory) */
>> -	video_format_t        video_format;  /* current aspect ratio of stream*/
>> -	video_displayformat_t display_format;/* selected cropping mode */
>> -};
>> -
>> -
>> -struct video_still_picture {
>> -	char __user *iFrame;        /* pointer to a single iframe in memory */
>> -	__s32 size;
>> -};
>> -
>> -
>> -typedef
>> -struct video_highlight {
>> -	int     active;      /*    1=show highlight, 0=hide highlight */
>> -	__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
>> -			     /*    3- 0  Background pixel contrast */
>> -	__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
>> -			     /*    3- 0  Emphasis pixel-1 contrast */
>> -	__u8    color1;      /*    7- 4  Pattern pixel color */
>> -			     /*    3- 0  Background pixel color */
>> -	__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
>> -			     /*    3- 0  Emphasis pixel-1 color */
>> -	__u32    ypos;       /*   23-22  auto action mode */
>> -			     /*   21-12  start y */
>> -			     /*    9- 0  end y */
>> -	__u32    xpos;       /*   23-22  button color number */
>> -			     /*   21-12  start x */
>> -			     /*    9- 0  end x */
>> -} video_highlight_t;
>> -
>> -
>> -typedef struct video_spu {
>> -	int active;
>> -	int stream_id;
>> -} video_spu_t;
>> -
>> -
>> -typedef struct video_spu_palette {      /* SPU Palette information */
>> -	int length;
>> -	__u8 __user *palette;
>> -} video_spu_palette_t;
>> -
>> -
>> -typedef struct video_navi_pack {
>> -	int length;          /* 0 ... 1024 */
>> -	__u8 data[1024];
>> -} video_navi_pack_t;
>> -
>> -
>> -typedef __u16 video_attributes_t;
>> -/*   bits: descr. */
>> -/*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
>> -/*   13-12 TV system (0=525/60, 1=625/50) */
>> -/*   11-10 Aspect ratio (0=4:3, 3=16:9) */
>> -/*    9- 8 permitted display mode on 4:3 monitor (0=both, 1=only pan-sca */
>> -/*    7    line 21-1 data present in GOP (1=yes, 0=no) */
>> -/*    6    line 21-2 data present in GOP (1=yes, 0=no) */
>> -/*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
>> -/*    2    source letterboxed (1=yes, 0=no) */
>> -/*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
>> -
>> -
>> -/* bit definitions for capabilities: */
>> -/* can the hardware decode MPEG1 and/or MPEG2? */
>> -#define VIDEO_CAP_MPEG1   1
>> -#define VIDEO_CAP_MPEG2   2
>> -/* can you send a system and/or program stream to video device?
>> -   (you still have to open the video and the audio device but only
>> -    send the stream to the video device) */
>> -#define VIDEO_CAP_SYS     4
>> -#define VIDEO_CAP_PROG    8
>> -/* can the driver also handle SPU, NAVI and CSS encoded data?
>> -   (CSS API is not present yet) */
>> -#define VIDEO_CAP_SPU    16
>> -#define VIDEO_CAP_NAVI   32
>> -#define VIDEO_CAP_CSS    64
>> -
>> -
>> -#define VIDEO_STOP                 _IO('o', 21)
>> -#define VIDEO_PLAY                 _IO('o', 22)
>> -#define VIDEO_FREEZE               _IO('o', 23)
>> -#define VIDEO_CONTINUE             _IO('o', 24)
>> -#define VIDEO_SELECT_SOURCE        _IO('o', 25)
>> -#define VIDEO_SET_BLANK            _IO('o', 26)
>> -#define VIDEO_GET_STATUS           _IOR('o', 27, struct video_status)
>> -#define VIDEO_GET_EVENT            _IOR('o', 28, struct video_event)
>> -#define VIDEO_SET_DISPLAY_FORMAT   _IO('o', 29)
>> -#define VIDEO_STILLPICTURE         _IOW('o', 30, struct video_still_picture)
>> -#define VIDEO_FAST_FORWARD         _IO('o', 31)
>> -#define VIDEO_SLOWMOTION           _IO('o', 32)
>> -#define VIDEO_GET_CAPABILITIES     _IOR('o', 33, unsigned int)
>> -#define VIDEO_CLEAR_BUFFER         _IO('o',  34)
>> -#define VIDEO_SET_ID               _IO('o', 35)
>> -#define VIDEO_SET_STREAMTYPE       _IO('o', 36)
>> -#define VIDEO_SET_FORMAT           _IO('o', 37)
>> -#define VIDEO_SET_SYSTEM           _IO('o', 38)
>> -#define VIDEO_SET_HIGHLIGHT        _IOW('o', 39, video_highlight_t)
>> -#define VIDEO_SET_SPU              _IOW('o', 50, video_spu_t)
>> -#define VIDEO_SET_SPU_PALETTE      _IOW('o', 51, video_spu_palette_t)
>> -#define VIDEO_GET_NAVI             _IOR('o', 52, video_navi_pack_t)
>> -#define VIDEO_SET_ATTRIBUTES       _IO('o', 53)
>> -#define VIDEO_GET_SIZE             _IOR('o', 55, video_size_t)
>> -#define VIDEO_GET_FRAME_RATE       _IOR('o', 56, unsigned int)
>> -
>> -/**
>> - * VIDEO_GET_PTS
>> - *
>> - * Read the 33 bit presentation time stamp as defined
>> - * in ITU T-REC-H.222.0 / ISO/IEC 13818-1.
>> - *
>> - * The PTS should belong to the currently played
>> - * frame if possible, but may also be a value close to it
>> - * like the PTS of the last decoded frame or the last PTS
>> - * extracted by the PES parser.
>> - */
>> -#define VIDEO_GET_PTS              _IOR('o', 57, __u64)
>> -
>> -/* Read the number of displayed frames since the decoder was started */
>> -#define VIDEO_GET_FRAME_COUNT  	   _IOR('o', 58, __u64)
>> -
>> -#define VIDEO_COMMAND     	   _IOWR('o', 59, struct video_command)
>> -#define VIDEO_TRY_COMMAND 	   _IOWR('o', 60, struct video_command)
>> -
>> -#endif /*_DVBVIDEO_H_*/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

