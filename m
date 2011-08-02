Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:36143 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1HBKkC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2011 06:40:02 -0400
Message-ID: <4E37D415.8060000@iki.fi>
Date: Tue, 02 Aug 2011 13:40:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 0/2] Frame synchronisation events and support for them
 in the OMAP 3 ISP driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second version of the frame synchronisation patchset which
contains fixes based on the comments from Laurent. The patches are on
top of this tree which contains acked patches:

http://linuxtv.org/git/sailus/media_tree.git media-for-3.1-misc-1

Shortlog is available here:

<URL:http://git.linuxtv.org/sailus/media_tree.git/shortlog/refs/heads/media-for-3.1-misc-1>

Changes since the first one:

- Fixed the description of the second patch.
- Clarified the documentation.
- v4l2_event_frame_sync.buffer_sequence renamed to frame_sequence

Changes to the RFC:

- Renamed V4L2_EVENT_FRAME_START to V4L2_EVENT_FRAME_SYNC.
- Removed extra reference to V4L2_EVENT_FRAME_START in documentation; it
is mentioned in the same page struct v4l2_event_frame_sync is related to it.
- The OMAP 3 ISP driver check that the id field is zero in anticipation
of such events.

-- 
Sakari Ailus
sakari.ailus@iki.fi
