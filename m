Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3882 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaB1Rmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 12:42:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [REVIEWv3 PATCH 00/17] vb2: fixes, balancing callbacks (PART 1)
Date: Fri, 28 Feb 2014 18:41:58 +0100
Message-Id: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This third version incorporates the comments I received, and I also made
some additional changes.

Changes since REVIEWv2:

- the patches regarding the buf_finish changes were reorganized. Laurent
  pointed out a bug in patch 07/15 that is fixed here by adding the
  buf_finish call to __queue_cancel instead of messing around with __dqbuf.
  Basically the original patches 5-7 have been replaced by new ones that
  do things in a much more understandable order.

- patch 12/15 was partially wrong. The __reqbufs change was correct,
  but calling the finish memop wasn't. That is something that will be
  necessary later when we add dmabuf support for vb2-dma-sg, but for
  now it is simply wrong. It had crept in inadvertently so I just dropped
  that part of the patch.

- I've added patch 15/17: while it doesn't seem to lead to a real bug,
  it is fishy nevertheless. Just don't call buf_finish until the buffer
  is in the right state.

- I've also added patch 17/17 because without it the v4l2-compliance
  tool bails out early and never gets to the streaming tests.

Ignore patches 1-3: the first is already merged in 3.14, and 2 and 3
are about to be merged in 3.14. But you need them for some follow-up
patches.

Regards,

        Hans



