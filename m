Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3780 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZFSP3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 11:29:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW] refactoring video_register_device
Date: Fri, 19 Jun 2009 17:29:08 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191729.09255.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Based on your earlier comments I refactored the video_register_device 
function.

My code is here http://www.linuxtv.org/hg/~hverkuil/v4l-dvb and it contains 
the following four patches:

- v4l: remove video_register_device_index

This implements the RFC I posted earlier: video_register_device_index is not 
actually used in any of the drivers so we can remove it and instead 
automatically determine the index for each device. This simplifies the 
video_register_device function in preparation for the next patch.

- v4l: refactor video_register_device

This does the main refactoring. The term 'kernel number' is now replaced 
with 'device node number', which is hopefully more understandable. The code 
to find the device node number and minor number has been split off and 
exists in two variants, depending on CONFIG_VIDEO_FIXED_MINOR_RANGES.

I also found and fixed a potential race condition.

- ivtv/cx18: replace 'kernel number' with 'device node number'.

Minor changes to ivtv/cx18 to conform to the new terminology.

- v4l: warn when desired devnodenr is in use & add _no_warn function

Added the warning when the desired device node number was already in use and 
add a video_register_device_no_warn variant for use with ivtv and cx18 
where that warning is not appropriate.

Hopefully this makes this function easier to understand, but I'm too closely 
familiar with the code to tell whether I've succeeded. So this needs to be 
reviewed first.

Thanks,

        Hans

diffstat:
 Documentation/video4linux/v4l2-framework.txt |   43 ++--
 drivers/media/video/cx18/cx18-driver.c       |    2
 drivers/media/video/cx18/cx18-streams.c      |    4
 drivers/media/video/ivtv/ivtv-driver.c       |    2
 drivers/media/video/ivtv/ivtv-streams.c      |    4
 drivers/media/video/v4l2-dev.c               |  270 
+++++++++++++++------------
 include/media/v4l2-dev.h                     |    6
 7 files changed, 192 insertions(+), 139 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
