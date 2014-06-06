Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41856 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaFFNwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 09:52:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 0/2] vb2: Report POLLERR for fatal errors only
Date: Fri,  6 Jun 2014 15:53:08 +0200
Message-Id: <1402062790-17690-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set modifies the vb2 implementation of the poll() operation to set
the POLLERR flag for fatal errors only. The rationale and implementation
details are explained in the individual commit messages.

Changes since v2:

- Return POLLERR when not streaming only when no buffers are queued
- Tested with vivi and VB2_READ

Changes since v1:

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

