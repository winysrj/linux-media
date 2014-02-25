Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2223 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaBYKdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:33:12 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1PAX99l070227
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 11:33:11 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from test-media.192.168.1.1 (test [192.168.1.27])
	by tschai.lan (Postfix) with ESMTPSA id F12812A0232
	for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 11:33:06 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/2] Add viloop and vioverlay drivers
Date: Tue, 25 Feb 2014 11:33:03 +0100
Message-Id: <1393324385-44355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I wanted to share these two drivers, even though they need more work,
particular w.r.t. code quality.

They assume that PART 1 and PART 2 of the vb2 patch series are applied.

The viloop driver loops video from one device to another. It will create
pairs of video devices, the first an output device, the second a capture
device, and just copy the video data from one device to the other.

It can be loaded in multiplanar mode with the multiplanar=1 option.
It's a clean implementation using all the latest frameworks, in particular
all streaming memory models are supported as well as EXPBUF.

I did look at first at the out-of-tree v4l2-loopback driver, but it was
quicker to just write my own.

The vioverlay driver is a driver to test overlay support, both capture and
output overlays. Few drivers support this, so it is very hard to have
applications test their support for overlays, or to test drivers with overlay
support.

Overlay may be less and less important, but it is part of the API and you
need a way to test it.

The vioverlay driver creates a framebuffer, an output video node and a capture
video node. The output video node is used to pass video to the driver which
will be used as the video for the video output overlay feature. The capture
node is used to capture the result of the framebuffer contents mixed in with
the video output overlay.

Currently clipping and bitmap support is in, but not yet alpha blending and
chromakeying.

Feedback and ideas are welcome.

Again, I am well aware that these drivers need some more code cleanup work,
so don't bother commenting on that :-) They've been written in just the past
3-4 days so they are freshly baked...

Regards,

	Hans

