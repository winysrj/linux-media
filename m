Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51207 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756213Ab3HYWzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Aug 2013 18:55:53 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl
Subject: [PATCH v4 0/3] Fix buffer timestamp documentation
Date: Mon, 26 Aug 2013 02:02:00 +0300
Message-Id: <1377471723-22341-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset fixes the documentation related to V4L2 buffer timestamps.
Timestamps in the vast majority of drivers is taken af the end of the frame
rather than at the start of it.

since v3:

Besides the first patch, as suggested, I've added two more to add a new
v4l2_buffer.flags flag (V4L2_BUF_FLAG_TIMESTAMP_SOF) to tell the timestamp
is taken at the start of the frame. What is also changed in the
documentation is that the timestamps are end-of-frame by default and
start-of-frame when the flag is set.

-- 
Kind regards,
Sakari

