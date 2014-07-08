Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53007 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbaGHQbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 12:31:33 -0400
Received: from test-media.192.168.1.1 (test [192.168.1.27])
	by tschai.lan (Postfix) with ESMTPSA id 4D9EA2A1FD0
	for <linux-media@vger.kernel.org>; Tue,  8 Jul 2014 18:31:20 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/8] vivi, the next generation
Date: Tue,  8 Jul 2014 18:31:10 +0200
Message-Id: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series replaces the current vivi driver by an almost completely
rewritten version that provides a huge number of features.

By default the driver has four inputs:

Input 0 emulates a webcam, input 1 emulates a TV capture device, input 2 emulates
an S-Video capture device and input 3 emulates an HDMI capture device.

These inputs act exactly as a real hardware device would behave. This allows
you to use this driver as a test input for application development, since you
can test the various features without requiring special hardware.

A quick overview of the features implemented by this driver:

- A large list of test patterns and variations thereof
- Working brightness, contrast, saturation and hue controls
- Support for the alpha color component
- Full colorspace support, including limited/full RGB range
- All possible control types are present
- Support for various pixel aspect ratios and video aspect ratios
- Error injection to test what happens if errors occur
- Supports crop/compose/scale in any combination
- Can emulate up to 4K resolutions
- All Field settings are supported for testing interlaced capturing
- Supports all standard YUV and RGB formats, including two multiplanar YUV formats
- Overlay support

I demonstrated an earlier version of this driver in San Jose, and as
discussed there this is a replacement for the old vivi driver, not an
incremental patch series.

The first 6 patches are small improvements to the v4l2 core code that
I found while developing this driver. The 7th patch adds the driver
and the last patch the documentation.

There is a final patch that I didn't include here: that only removes
the vivi.c source.

When I do the pull request I will merge that with patch 7, but that
would have made that patch really large. I hope that patch 7 comes
through anyway. If not, then this series can be found here as well:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vivi-ok

For best results try it out with the latest qv4l2 code from v4l-utils!

My goal is to get this in for 3.17: there are still more improvements
to be done (more comments w.r.t. the colorspace handling for one), but it
is vastly superior to the old vivi.

BTW, the test pattern generation code (vivi-colors.[ch] and vivi-tpg.[ch])
has been written in such a way that the code can easily be shared between
other kernel drivers or by v4l-utils.git (make sync-with-kernel).

I'm currently using it in v4l2-ctl, and I plan to use it in qv4l2 as well
for testing video output devices.

Regards,

	Hans

