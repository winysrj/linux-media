Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1152 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1KZKpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 05:45:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
Date: Sat, 26 Nov 2011 11:44:48 +0100
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <201111251622.52582.hverkuil@xs4all.nl> <4ECFB9A0.50001@redhat.com>
In-Reply-To: <4ECFB9A0.50001@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111261144.48443.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 16:52:00 Mauro Carvalho Chehab wrote:
> Em 25-11-2011 13:22, Hans Verkuil escreveu:
> > Using V4L for the video part is easy. But where it becomes a bit more complicated is
> > with the audio device. I assume again that it receives a compressed audio stream
> > (is that correct?), and alsa doesn't handle that yet. I believe Samsung ran into the
> > same issue. For raw audio an alsa output is the logical choice, but for compressed
> > audio it is not so clear.
> 
> Sure that alsa doesn't handle compressed audio? a quick grep for MPEG under drivers/sound 
> shows several things related to MPEG audio support:
> 
> $ git grep -i mpeg sound|wc -l
> 92
> 
> $ git grep -i mpeg sound
> 
> ...
> sound/core/pcm.c: FORMAT(MPEG),
> sound/core/pcm.c: case AFMT_MPEG:
> sound/core/pcm.c:         return "MPEG";
> sound/core/pcm_misc.c:    [SNDRV_PCM_FORMAT_MPEG] = {
> sound/drivers/vx/vx_cmd.h:#define MASK_VALID_PIPE_MPEG_PARAM      0x000040
> sound/drivers/vx/vx_cmd.h:#define MASK_SET_PIPE_MPEG_PARAM        0x000002
> sound/drivers/vx/vx_cmd.h:#define P_PREPARE_FOR_MPEG3_MASK                                0x02
> sound/drivers/vx/vx_core.c:       if (chip->audio_info & VX_AUDIO_INFO_MPEG1)
> sound/drivers/vx/vx_core.c:               snd_iprintf(buffer, " mpeg1");
> sound/drivers/vx/vx_core.c:       if (chip->audio_info & VX_AUDIO_INFO_MPEG2)
> sound/drivers/vx/vx_core.c:               snd_iprintf(buffer, " mpeg2");
> ...
> 
> 
> So, I think that alsa accepts compressed audio.

Nice. I was told once that they didn't support it, but I'm clearly wrong.
Both MPEG and AC3 audio is supported.

Regards,

	Hans
