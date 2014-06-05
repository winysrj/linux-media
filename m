Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34480 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFEMXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 08:23:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH/RFC v2 0/2]  vb2: Report POLLERR for fatal errors only
Date: Thu,  5 Jun 2014 14:23:09 +0200
Message-Id: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set modifies the vb2 implementation of the poll() operation to set
the POLLERR flag for fatal errors only. The rationale and implementation
details are explained in the individual commit messages.

Changes since to v1:

- Rebased on top of the latest media tree master branch
- Fixed typos

Laurent Pinchart (2):
  v4l: vb2: Don't return POLLERR during transient buffer underruns
  v4l: vb2: Add fatal error condition flag

 drivers/media/v4l2-core/videobuf2-core.c | 40 +++++++++++++++++++++++++++++---
 include/media/videobuf2-core.h           |  3 +++
 2 files changed, 40 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

