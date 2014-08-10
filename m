Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4492 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHJL6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com
Subject: [PATCH 00/19] cx23885: convert to the V4L2 core frameworks
Date: Sun, 10 Aug 2014 13:57:37 +0200
Message-Id: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the cx23885 driver to the latest V4L2 core
frameworks, removing about 1000 lines in the process.

It now passes the v4l2-compliance tests and, frankly, feels much more
robust.

I have tested this with my HVR-1800 board with video (compressed and
uncompressed), vbi, dvb and alsa.

As usual, the vb2 conversion is a beast of a patch. But the vb2 conversion
affected video, vbi, dvb and alsa, so it's all over the place. And it is
all or nothing. See the commit log of that patch for some more information.

Since the cx23885 code resembles the cx88 and cx25821 code closely, I will
probably try to do the same for those drivers in the near future.

Regards,

	Hans

