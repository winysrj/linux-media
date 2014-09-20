Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1066 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaITTQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 15:16:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com
Subject: [PATCHv2 0/3] vb2: fix VBI/poll regression
Date: Sat, 20 Sep 2014 21:16:34 +0200
Message-Id: <1411240597-2105-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, so v1 wasn't the final patch series :-) Let's see if this is.

Changes since v1:

- Also initialize waiting_for_buffers in STREAMOFF and when CREATE_BUFS is
  called and no buffers have been allocated yet.
- Improve some of the wording in patch 2 based on suggestions from Laurent.

This patch series resolves the vb2 VBI poll regression where alevt and mtt
fail on drivers using vb2.

These applications call REQBUFS, queue the buffers and then poll() without
calling STREAMON first. They rely on poll() to return POLLERR in that case
and they do the STREAMON at that time. This is correct according to the spec,
but this was never implemented in vb2.

This is fixed together with an other vb2 regression: calling REQBUFS, then
STREAMON, then poll() without doing a QBUF first should return POLLERR as
well according to the spec. This has been fixed as well and the spec has
been clarified that this is only done for capture queues. Output queues in
the same situation will return as well, but with POLLOUT|POLLWRNORM set
instead of POLLERR.

The final patch adds missing documentation to poll() regarding event handling
and improves the documentation regarding stream I/O and output queues.

Regards,

	Hans

