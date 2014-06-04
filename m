Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55953 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaFDOFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:05:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH/RFC 0/2] vb2: Report POLLERR for fatal errors only
Date: Wed,  4 Jun 2014 16:05:42 +0200
Message-Id: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set modifies the vb2 implementation of the poll() operation to set
the POLLERR flag for fatal errors only. The rationale and implementation
details are explained in the individual commit messages.

Laurent Pinchart (2):
  v4l: vb2: Don't return POLLERR during transient buffer underruns
  v4l: vb2: Add fatal error condition flag

 drivers/media/video/videobuf2-core.c | 41 +++++++++++++++++++++++++++++++++---
 include/media/videobuf2-core.h       |  3 +++
 2 files changed, 41 insertions(+), 3 deletions(-)

-- 
Regards,

Laurent Pinchart

