Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38589 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1FRTNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 15:13:50 -0400
Received: by iwn6 with SMTP id 6so228061iwn.19
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 12:13:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106091445.53598.hansverk@cisco.com>
References: <201106091445.53598.hansverk@cisco.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sat, 18 Jun 2011 19:13:26 +0000
Message-ID: <BANLkTik6+Ez8TOgGP-r0mmcamQVCkhwC2Q@mail.gmail.com>
Subject: Re: RFC: Add V4L2 decoder commands/controls to replace dvb/video.h
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

HI Hans,

looks good... is there any progress?

--
Christian Gmeiner, MSc



2011/6/9 Hans Verkuil <hansverk@cisco.com>:
> RFC: Proposal for a V4L2 decoder API
> ------------------------------------
>
> This RFC is based on this discussion:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg32703.html
>
> The purpose is to remove the dependency of ivtv to the ioctls in dvb/audio.h
> and dvb/video.h.
>
> The summary of the posting referred to above is:
>
> - Add two controls to select the audio output channels.
> - Add two read-only controls for the PTS and frame count.
> - Copy and paste the old VIDEO_(TRY_)COMMAND to VIDIOC_(TRY_)DECODER_CMD.
>
> So, here is the RFC that does that. I'm going through the items from the
> summary in reverse order.
>
>
> 1) Add new VIDIOC_TRY_DECODER_CMD and VIDIOC_DECODER_CMD ioctls.
>
> These are the decoder counterparts of the VIDIOC_(TRY_)ENCODER_CMD ioctls
> that are already in V4L2.
>
> /* Decoder commands */
> #define V4L2_DEC_CMD_PLAY        (0)
> #define V4L2_DEC_CMD_STOP        (1)
> #define V4L2_DEC_CMD_FREEZE      (2)
> #define V4L2_DEC_CMD_CONTINUE    (3)
>
> /* Flags for V4L2_DEC_CMD_FREEZE */
> #define V4L2_DEC_CMD_FREEZE_TO_BLACK            (1 << 0)
>
> /* Flags for V4L2_DEC_CMD_STOP */
> #define V4L2_DEC_CMD_STOP_TO_BLACK              (1 << 0)
> #define V4L2_DEC_CMD_STOP_IMMEDIATELY           (1 << 1)
>
> /* Play format requirements (returned by the driver): */
> /* The decoder has no special format requirements */
> #define V4L2_DEC_PLAY_FMT_NONE         (0)
> /* The decoder requires full GOPs */
> #define V4L2_DEC_PLAY_FMT_GOP          (1)
>
> /* The structure must be zeroed before use by the application
>   This ensures it can be extended safely in the future. */
> struct v4l2_decoder_cmd {
>        __u32 cmd;
>        __u32 flags;
>        union {
>                struct {
>                        /* Stop when this PTS is reached */
>                        __u64 pts;
>                } stop;
>
>                struct {
>                        /* 0 or 1000 specifies normal speed,
>                           1 specifies forward single stepping,
>                           -1 specifies backward single stepping,
>                           >1: playback at speed/1000 of the normal speed,
>                           <-1: reverse playback at (-speed/1000) of the normal speed.
> */
>                        __s32 speed;
>                        __u32 format;
>                } play;
>
>                struct {
>                        __u32 data[16];
>                } raw;
>        };
> };
>
> Other than renaming the #defines and struct there are no changes compared to
> the current video.h API. I see no reason to change this either.
>
>
> 2) Add read-only controls for the PTS and framecount.
>
> V4L2_CID_MPEG_STREAM_DEC_PTS - integer64
>
> Return the PTS (Presentation Time Stamp) of the currently presented frame.
>
> V4L2_CID_MPEG_VIDEO_DEC_FRAME - integer
>
> Return the frame number of the currently presented frame. When the decoder
> starts the frame counter is reset to 0.
>
>
> 3) Add two new audio selection controls.
>
> V4L2_CID_MPEG_AUDIO_DEC_CHANNEL - menu
>
> Select how to playback stereo audio from a normal audio stream:
>
> 0 - Auto (playback native format)
> 1 - Left (left channel only)
> 2 - Right (right channel only)
> 3 - Stereo
> 4 - Swapped Stereo (I'm not sure whether this should be added. Is this ever
> useful?)
>
> This control relates to its encoder counterpart V4L2_CID_MPEG_AUDIO_MODE for
> the non-DUAL modes.
>
> V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_CHANNEL - menu
>
> Select how to playback audio from a multilingual audio stream:
>
> 0 - Auto (either always Left or can be based on some preferred language)
> 1 - Left (left channel only)
> 2 - Right (right channel only)
> 3 - Stereo
> 4 - Swapped Stereo (I'm not sure whether this should be added. Is this ever
> useful?)
>
> This control relates to its encoder counterpart V4L2_CID_MPEG_AUDIO_MODE for
> the DUAL mode.
>
> Note that these two controls are specific to the audio layer I/II/III audio
> mode setting. They do not support any e.g. AAC decoding. More research will
> need to be done to know whether that makes sense or not.
>
> Regards,
>
>        Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
