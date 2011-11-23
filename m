Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2943 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1KWLMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 06:12:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 0/4] Replace VIDEO_COMMAND with VIDIOC_DECODER_CMD
Date: Wed, 23 Nov 2011 12:12:32 +0100
Message-Id: <1322046756-22870-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the 2011 workshop we discussed replacing the decoder commands in
include/linux/dvb/video.h and audio.h by a proper V4L2 API.

This patch series is the first phase of that. It adds new VIDIOC_(TRY_)DECODER_CMD
ioctls to the V4L2 API. These are identical to the VIDEO_(TRY_)COMMAND from
dvb/video.h, but the names of the fields and defines now conform to the V4L2
API conventions.

Documentation has been added and ivtv (the only V4L2 driver that used VIDEO_COMMAND)
has been adapted to support the new V4L2 API.

I do have one question for Mauro: what do you want to do with video.h? Should it be
removed altogether eventually?

Some of the commands defined there aren't used by any driver (e.g. VIDEO_GET_NAVI),
some are specific to the av7110 driver (e.g. VIDEO_STILLPICTURE), some are specific
to ivtv (VIDEO_COMMAND) and some are used by both ivtv and av7110 (e.g. VIDEO_PLAY).

My proposal would be to:

1) remove anything that is not used by any driver from audio.h and video.h
2) move av7110 specific stuff to a new linux/av7110.h header
3) move ivtv specific stuff to the linux/ivtv.h header
4) shared code should be moved to the new linux/av7110.h header and also copied
   to linux/ivtv.h. The ivtv version will rename the names (e.g. VIDEO_ becomes
   IVTV_) but is otherwise unchanged to preserve the ABI. Comments are added
   on how to convert the legacy ioctls to standard V4L2 API in applications.
   Perhaps these legacy ioctls in ivtv can even be removed in a few years time.
5) remove linux/dvb/audio.h and video.h.

What do you think, Mauro?

Regards,

	Hans

