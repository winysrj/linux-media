Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43964 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932184AbeFTToW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 15:44:22 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/2] Memory-to-memory media controller topology
Date: Wed, 20 Jun 2018 16:44:04 -0300
Message-Id: <20180620194406.21753-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed on IRC, memory-to-memory need to be modeled
properly in order to be supported by the media controller
framework, and thus to support the Request API.

The topology looks like this:

Device topology
- entity 1: source (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Source
		<- "proc":0 [ENABLED,IMMUTABLE]

- entity 3: proc (2 pads, 2 links)
            type Node subtype Unknown flags 0
	pad0: Source
		-> "source":0 [ENABLED,IMMUTABLE]
	pad1: Sink
		<- "sink":0 [ENABLED,IMMUTABLE]

- entity 6: sink (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Sink
		-> "proc":1 [ENABLED,IMMUTABLE]

The first commit introduces a register/unregister API,
that creates/destroys all the entities and pads needed,
and links them.

The second commit uses this API to support the vim2m driver.

Ezequiel Garcia (1):
  media: add helpers for memory-to-memory media controller

Hans Verkuil (1):
  vim2m: add media device

 drivers/media/platform/vim2m.c         |  41 +++++-
 drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 176 +++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |   5 +
 include/uapi/linux/media.h             |   3 +
 5 files changed, 229 insertions(+), 9 deletions(-)

-- 
2.17.1
