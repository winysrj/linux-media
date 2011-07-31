Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1GaFIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 01:08:37 -0400
Message-ID: <4E34E34E.9040200@infradead.org>
Date: Sun, 31 Jul 2011 02:08:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: media Documentation Errors
References: <20110730165133.74b91104.rdunlap@xenotime.net>
In-Reply-To: <20110730165133.74b91104.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

Em 30-07-2011 20:51, Randy Dunlap escreveu:
> Hi,
> 
> What do I need to do to eliminate these errors?
> (from 3.0-git12)

Thanks for reporting it.

> Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
> Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
> Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
> Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-type.
> Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
> Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
> Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
> Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
> Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
> Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-type.

This probably means that Samsung guys didn't properly documented those new stuff
into the DocBook, e. g. they're defined at include/linux/videodev2.h, but
either there's no documentation for them, or the links inside the docbook
don't match.

Kamil?

> Error: no ID for constraint linkend: AUDIO_GET_PTS.  
> Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
> Error: no ID for constraint linkend: CA_RESET.
> Error: no ID for constraint linkend: CA_GET_CAP.
> Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
> Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
> Error: no ID for constraint linkend: CA_GET_MSG.
> Error: no ID for constraint linkend: CA_SEND_MSG.
> Error: no ID for constraint linkend: CA_SET_DESCR.
> Error: no ID for constraint linkend: CA_SET_PID.
> Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
> Error: no ID for constraint linkend: DMX_GET_CAPS.
> Error: no ID for constraint linkend: DMX_SET_SOURCE.
> Error: no ID for constraint linkend: DMX_ADD_PID.
> Error: no ID for constraint linkend: DMX_REMOVE_PID.
> Error: no ID for constraint linkend: NET_ADD_IF.
> Error: no ID for constraint linkend: NET_REMOVE_IF.
> Error: no ID for constraint linkend: NET_GET_IF.
> Error: no ID for constraint linkend: VIDEO_GET_SIZE.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
> Error: no ID for constraint linkend: VIDEO_GET_PTS.
> Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
> Error: no ID for constraint linkend: VIDEO_COMMAND.
> Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.

Those are some already known issue: The DVB API spec doesn't match the current
DVB API stack implementation, e. g. those ioctl's are defined at the DVB code,
but the API doesn't specify them.

We need to work to sync the above. Worse than that, several of the above ioctl's
are defined at the code, but are used only on one legacy driver and on some
out-of-tree drivers for years.

This is one of the things I'd like to discuss with the media people during the
KS/2011.

None of the above are fatal errors: they'll just leave a few html links at the the
spec appendices without pointing to the place where they should be defined.

My idea is to have all of them fixed for 3.2.

Thanks,
Mauro
