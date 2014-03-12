Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49490 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaCLR6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 13:58:25 -0400
Message-ID: <04588cf620ba3635c9a59e6eb92d0000.squirrel@www.codeaurora.org>
Date: Wed, 12 Mar 2014 17:58:24 -0000
Subject: Query: Mutiple CAPTURE ports on a single device
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have a v4l2 driver for a hardware which is capable of taking one input
and producing two outputs. Eg: Downscaler which takes one input @ 1080p
and two outputs - one @ 720p and other at VGA. My driver is currently
implemented as having two capabilities -

1. V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
2. V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE

Do you know if I can have two CAPTURE capabilities. In that case how do I
distinguish between QBUF/DQBUF of each capability?

Thanks
Vinay

