Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:41180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3IMVyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 17:54:16 -0400
Received: from www.codeaurora.org (pdx-caf-fw-vip.codeaurora.org [198.145.11.226])
	by smtp.codeaurora.org (Postfix) with ESMTP id E351D13EED3
	for <linux-media@vger.kernel.org>; Fri, 13 Sep 2013 21:54:15 +0000 (UTC)
Message-ID: <79eef80b5fa29d83a7ae9a3f7d83cea8.squirrel@www.codeaurora.org>
Date: Fri, 13 Sep 2013 21:54:15 -0000
Subject: User data propagation for video codecs
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

For video decoder, our video driver, which is V4l2 based, exposes two
capabilities:

1. V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE for transaction of compressed buffers.
2. V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE for transaction of
decoded/uncompressed buffers.

We have a requirement to propagate "user specific data" from compressed
buffer to uncompressed buffer. We are not able to find any field in
"struct v4l2_buffer" which can be used for this purpose. Please suggest if
this can be achieved with current V4L2 framework.


Thanks
Vinay

