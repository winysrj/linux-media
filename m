Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:37311 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1GZStj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 14:49:39 -0400
Message-ID: <4E2F0C53.10907@iki.fi>
Date: Tue, 26 Jul 2011 21:49:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/3] Frame synchronisation events and support for them in
 the OMAP 3 ISP driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The OMAP 3 ISP driver implements an HS_VS event which is triggered when
the reception of a frame begins. This functionality is very, very likely
not specific to OMAP 3 ISP so it should be standardised.

I have a few patches to do that. Additionally the next expected buffer
sequence number is provided with the event, unlike earlier.

The questions I had over the RFC (under otherwise same subject field on
this list) have been resolved:

1) Other frame synchronisation events, if they ever are needed, can be
implemented by using the id field as the line number the event should be
triggered on, as proposed by Sylwester and Hans. Currently, the id field
is not separately mentioned in the documentation, meaning that
FRAME_SYNC events have id field set to 0 meaning frame start.

2) It was also concluded that the buffer sequence number is specific to
FRAME_SYNC event and deserves its own struct: struct v4l2_event_frame_sync.

Changes to the RFC:

- Renamed V4L2_EVENT_FRAME_START to V4L2_EVENT_FRAME_SYNC.
- Removed extra reference to V4L2_EVENT_FRAME_START in documentation; it
is mentioned in the same page struct v4l2_event_frame_sync is related to it.
- The OMAP 3 ISP driver check that the id field is zero in anticipation
of such events.

-- 
Sakari Ailus
sakari.ailus@iki.fi
