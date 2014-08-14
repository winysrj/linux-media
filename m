Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3928 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaHNJyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com
Subject: [PATCHv2 00/20] cx23885: convert to the V4L2 core frameworks
Date: Thu, 14 Aug 2014 11:53:45 +0200
Message-Id: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
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
probably try to do the same for those drivers in the near future. And in
fact I have already started on the cx88.

Changes since v1:

- Added patch 20/20 which adds vb2_is_busy checks.
- altera-ci.c still included the videobuf headers for no reason. Fixed in
  patch 15/20.
- In buffer_prepare in cx23885-video.c the buf->bpl field was used before
  it was set. Fixed in patch 15/20.

Regards,

	Hans

