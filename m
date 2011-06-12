Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1068 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1FLLAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 07:00:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>
Subject: tuner-core: fix g_freq/s_std and g/s_tuner
Date: Sun, 12 Jun 2011 12:59:41 +0200
Message-Id: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK, this is the fourth version of this patch series.

The first five patches are the same as before. But for fixing the g_frequency
and g/s_tuner subdev ops I've decided to follow Mauro's lead and let the core
fill in the tuner type for those ioctls. Trying to do this in the drivers is
a tricky business, but doing this in video_ioctl2 is dead easy.

The only driver not using video_ioctl2 and that has tuner support as well is
pvrusb2, so I did that manually. Mike, can you review that single patch? All
it does is fill in v4l2_tuner's type based on whether the radio or TV is
active.

The last patch fixes a typo in the bttv radio s_tuner implementation making
VIDIOC_S_TUNER work again.

This patch series has been tested with bttv, cx18, ivtv and pvrusb2.

