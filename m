Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1327 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaIUOsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com
Subject: [RFC PATCH 00/11] Add configuration store support
Date: Sun, 21 Sep 2014 16:48:18 +0200
Message-Id: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for configuration stores to the control framework.
This allows you to store control values for a particular configuration (up to
VIDEO_MAX_FRAME configuration stores are currently supported). When you queue
a new buffer you can supply the store ID and the driver will apply all controls
for that configuration store.

When you set a new value for a configuration store then you can choose whether
this is 'fire and forget', i.e. after the driver applies the control value for that
store it won't be applied again until a new value is set. Or you can set the
value every time that configuration store is applied.

The first 7 patches add support for this in the API and in v4l2-ctrls.c. Patch
8 adds configure store support for the contrast control in the vivid driver.

Patches 9-11 add support for crop/compose controls to v4l2-ctrls and vivid
as a proof-of-concept. This allows you to play around with things like
digital zoom by manipulating crop and compose rectangles for specific buffers.
It's basically a hack just to allow me to test this so don't bother reviewing
these last three patches.

This patch series is available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=confstore

A patched version of qv4l2 and v4l2-ctl that add config store support
is available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=confstore

The easiest way to test this is with vivid. Load vivid, then run the patched
qv4l2. This will associate every queued buffer with a corresponding config
store. There are 4 buffers, so stores 1-4 are available for use.

You can change the contrast value for a buffer as follows:

v4l2-ctl --store=1 -c contrast=90

For a fire-and-forget you add the --ignore-after-use option:

v4l2-ctl --store=1 -c contrast=90 --ignore-after-use

So you can cycle between different contrast values as follows:

v4l2-ctl --store=1 -c contrast=90
v4l2-ctl --store=2 -c contrast=100
v4l2-ctl --store=3 -c contrast=110
v4l2-ctl --store=4 -c contrast=120

This patch series and the API enhancements will be discussed during the
upcoming media workshop.

Regards,

	Hans

